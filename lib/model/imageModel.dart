import 'dart:convert';
import 'dart:typed_data';
import 'package:hive/hive.dart';
part 'imageModelAdapter.dart';

@HiveType(typeId: 1)
class ImageModel extends HiveObject{
  @HiveField(0, defaultValue: 0)
  int imageId;

  @HiveField(1)
  int matId;

  @HiveField(2)
  int catId;

  @HiveField(3)
  String guid;

  @HiveField(4)
  Uint8List image;

  ImageModel({required this.imageId,required this.matId,required this.catId,required this.guid,required this.image});

  factory ImageModel.fromMap(Map<String,dynamic> map){
    return ImageModel(
      imageId:map['image_id'] ?? map['cat_id'] ?? 0,
      matId:map['material_id'] ?? 0,
      catId:map['cat_id'] ?? 0,
      guid:map['cat_id_guid'] ?? map['image_id_guid'] ?? '',
      image: base64Decode(map['image_pict'] ?? map['cat_image'] ?? '')
    );
  }
}
