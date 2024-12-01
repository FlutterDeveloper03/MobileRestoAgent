import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_resto_agent/Helpers/SharedPrefKeys.dart';
import 'package:mobile_resto_agent/data/local/FromHiveBox.dart';
import 'package:mobile_resto_agent/data/remote/QueryFromApi.dart';
import 'package:mobile_resto_agent/model/imageModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
//region Events

class ImageLoaderEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadImageEvent extends ImageLoaderEvent {
  final int materialId;
  final int catId;

  LoadImageEvent(this.materialId, this.catId);

  @override
  List<Object> get props => [materialId, catId];
}

//endregion Events

//region States
class ImageLoaderState extends Equatable {
  @override
  List<Object> get props => [];
}

class ImageLoaderInitialState extends ImageLoaderState {}

class LoadingImageState extends ImageLoaderState {}

class ImageEmptyState extends ImageLoaderState {}

class ImageLoadedState extends ImageLoaderState {
  final int materialId;
  final int catId;
  final Uint8List imageBytes;

  ImageLoadedState(this.imageBytes, this.catId, this.materialId);

  @override
  List<Object> get props => [imageBytes, materialId, catId];

  @override
  String toString() {
    return "ImageLoadedState";
  }
}

class ImageLoadErrorState extends ImageLoaderState {}

//endregion States

//region Bloc

class ImageLoaderBloc extends Bloc<ImageLoaderEvent, ImageLoaderState> {
  ImageLoaderBloc() : super(ImageLoaderInitialState());
  FromHive hive = FromHive();

  @override
  void onTransition(Transition<ImageLoaderEvent, ImageLoaderState> transition) {
    super.onTransition(transition);
    print(transition);
  }

  @override
  Stream<ImageLoaderState> mapEventToState(ImageLoaderEvent event) async* {
    if (event is LoadImageEvent) {
      yield* onLoadImageEvent(event);
    }
  }

  Stream<ImageLoaderState> onLoadImageEvent(LoadImageEvent event) async* {
    yield LoadingImageState();
    String serverAddress = "";
    String serverPort = "";
    String dbUName = "";
    String dbUPass = "";
    String dbName = "";
    final _sharedPref = await SharedPreferences.getInstance();
    int selectedDbConnectionType = _sharedPref.getInt(SharedPrefKeys.selectedDbConnectionType) ?? 0;
    if (selectedDbConnectionType == 0) {
      serverAddress = _sharedPref.getString(SharedPrefKeys.baseUrl)?.split(":")[0] ?? SharedPrefKeys.defaultUrl.split(":")[0];
      serverPort = _sharedPref.getString(SharedPrefKeys.baseUrl)?.split(":")[1] ?? SharedPrefKeys.defaultUrl.split(":")[1];
      dbUName = _sharedPref.getString(SharedPrefKeys.DbUName) ?? SharedPrefKeys.defaultDbUName;
      dbUPass = _sharedPref.getString(SharedPrefKeys.DbUPass) ?? '';
      dbName = _sharedPref.getString(SharedPrefKeys.DbName) ?? SharedPrefKeys.defaultDbName;
    }
    String baseUrl = _sharedPref.getString(SharedPrefKeys.baseUrl) ?? SharedPrefKeys.defaultUrl;
    QueryFromApi _queryFromApi = QueryFromApi(baseUrl, selectedDbConnectionType,
        serverAddress: serverAddress, serverPort: serverPort, dbName: dbName, dbUName: dbUName, dbUPass: dbUPass);
    try {
      ImageModel? _imgModel;
      if (event.catId>0){
        ImageModel? _imageModel = hive.getImage(catId: event.catId);
        if (_imageModel!=null && _imageModel.image.length>0){
          _imgModel = _imageModel;
        } else {
          _imgModel = await _queryFromApi.getCatImage(event.catId,'');
          if (_imgModel!=null){
            hive.putImage(_imgModel);
          }
        }
        if (_imgModel!=null) {
          yield ImageLoadedState(_imgModel.image,event.catId,event.materialId);
        } else {
          yield ImageEmptyState();
        }
        _imgModel=null;
        _imgModel = await _queryFromApi.getMatImage(event.materialId,'');
        if (_imgModel!=null){
          _imageModel?.delete();
          hive.putImage(_imgModel);
          yield ImageLoadedState(_imgModel.image,event.catId,event.materialId);
        }
      } else if (event.materialId>0){
        ImageModel? _imageModel = hive.getImage(matId: event.materialId);
        if (_imageModel!=null && _imageModel.image.length>0){
          _imgModel = _imageModel;
        } else {
          _imgModel = await _queryFromApi.getMatImage(event.materialId,'');
          if (_imgModel!=null){
            hive.putImage(_imgModel);
          }
        }
        if (_imgModel!=null) {
          yield ImageLoadedState(_imgModel.image,event.catId,event.materialId);
          String _imgGuid = _imgModel.guid;
          _imgModel=null;
          _imgModel = await _queryFromApi.getMatImage(event.materialId,_imgGuid);
          if (_imgModel!=null){
            if (_imageModel?.box!=null){
              _imageModel?.delete();
            }
            hive.putImage(_imgModel);
            yield ImageLoadedState(_imgModel.image,event.catId,event.materialId);
          }
        } else {
          yield ImageEmptyState();
        }

      }
    } catch (e) {
      print('Print error load image: ${e.toString()}');
      yield ImageLoadErrorState();
    }
  }
}

//endregion Bloc
