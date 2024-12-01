import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_resto_agent/Helpers/localization.dart';
import 'package:mobile_resto_agent/bloc/ImageLoaderBloc.dart';
import 'package:mobile_resto_agent/model/CartItem.dart';
import 'package:mobile_resto_agent/bloc/CategoryBloc.dart' as c;
import 'package:mobile_resto_agent/bloc/FichBloc.dart' as f;
import 'package:mobile_resto_agent/bloc/MaterialBloc.dart';
import 'package:mobile_resto_agent/model/tbl_mg_materials.dart';
import 'package:mobile_resto_agent/screens/resourceDetailScreen.dart';
import 'package:mobile_resto_agent/widgets/counterWidget.dart';
import 'package:mobile_resto_agent/widgets/customEmpty.dart';
import 'package:mobile_resto_agent/widgets/customLoading.dart';
import 'package:mobile_resto_agent/widgets/infoItem.dart';

class ResourcesPage extends StatefulWidget {
  final int catId;
  final int fichId;

  const ResourcesPage({Key? key, required this.catId, required this.fichId}) : super(key: key);

  @override
  _ResourcesPageState createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  @override
  Widget build(BuildContext context) {
    final trs = AppLocalizations.of(context);
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final int crossAxisCount = width < 350
        ? 1
        : width <= 650
            ? 2
            : width <= 1050
                ? 3
                : width <= 1300
                    ? 4
                    : 5;
    Widget emptyWidget = SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: CustomEmpty(
        height: height * 0.75,
        width: width,
      ),
    );

    Widget resourceWidgetBuild(
      List<TblMgMaterials> materials,
      List<CartItem> cartItems,
    ) {
      if (materials.isEmpty) {
        return emptyWidget;
      }
      return GridView.builder(
        scrollDirection: Axis.vertical,
        itemCount: materials.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 2.6 / 2,
          crossAxisCount: crossAxisCount,
        ),
        itemBuilder: (context, index) {
          double count = 0;
          if (cartItems.any((element) => element.material.id == materials[index].id)) {
            count = cartItems.firstWhere((element) => element.material.id == materials[index].id).count;
          }
          return BlocProvider(
            create: (context) => ImageLoaderBloc()..add(LoadImageEvent(materials[index].id, 0)),
            child: Builder(
              builder: (context) => TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 500),
                      reverseTransitionDuration: Duration(milliseconds: 500),
                      pageBuilder: (_, animation, secondaryAnimation) => FadeTransition(
                        opacity: animation,
                        child: ResourceDetailScreen(
                          material: materials[index],
                          materials: materials,
                          cartItems: cartItems,
                          controller: PageController(initialPage: index),
                        ),
                      ),
                    ),
                  );
                },
                style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
                child: InfoItem(
                  height: 75,
                  image: BlocBuilder<ImageLoaderBloc, ImageLoaderState>(
                    builder: (context, state) {
                      if (state is LoadingImageState) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).cardColor,
                          ),
                        );
                      } else if (state is ImageLoadedState) {
                        return Image.memory(
                          state.imageBytes,
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object object, StackTrace? trace) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SvgPicture.asset(
                                'assets/images/NoImage.svg',
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 50),
                          child: SvgPicture.asset(
                            'assets/images/NoImage.svg',
                            fit: BoxFit.contain,
                          ),
                        );
                      }
                    },
                  ),
                  widget: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 3,
                            child: materials[index].name(trs).length < 60
                                ? FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      materials[index].name(trs),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  )
                                : Text(
                                    materials[index].name(trs),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 8,
                                      color: Colors.black,
                                    ),
                                  ),
                          ),
                          Flexible(
                            flex: 1,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                materials[index].salePrice.toStringAsFixed(2),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (materials[index].aStatusId==1)
                        Counter(
                        count: count,
                        add: () {
                          TblMgMaterials _mat = materials[index];
                          if (_mat.matAutoPrice > 0) {
                            double sum = 0;
                            for (CartItem ci in cartItems) {
                              sum = sum + ci.material.salePrice * ci.count;
                            }
                            _mat = _mat.copyWith(salePrice: sum / 100 * _mat.matAutoPrice);
                          }
                          BlocProvider.of<MaterialBloc>(context).add(PlusCount(
                            material: _mat,
                          ));
                        },
                        remove: () {
                          BlocProvider.of<MaterialBloc>(context).add(MinusCount(
                            material: materials[index],
                          ));
                        },
                        newValue: (double number) {
                          TblMgMaterials _mat = materials[index];
                          if (_mat.matAutoPrice > 0) {
                            double sum = 0;
                            for (CartItem ci in cartItems) {
                              sum = sum + ci.material.salePrice * ci.count;
                            }
                            _mat = _mat.copyWith(salePrice: sum / 100 * _mat.matAutoPrice);
                          }
                          BlocProvider.of<MaterialBloc>(context).add(NewValue(
                            material: _mat,
                            matAttributes: [],
                            count: number,
                          ));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    return Container(
      child: RefreshIndicator(
        onRefresh: () async {
          BlocProvider.of<MaterialBloc>(context).add(GetMaterialEvent());
          BlocProvider.of<c.CategoryBloc>(context).add(c.LoadEvent());
          BlocProvider.of<f.FichBloc>(context).add(f.LoadEvent(widget.fichId));
        },
        child: BlocBuilder<MaterialBloc, MaterialBlocState>(
          builder: (context, state) {
            if (state is LoadingState) {
              return SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: CustomLoading(
                  height: height * 0.75,
                  width: width,
                ),
              );
            } else if (state is LoadedState) {
              List<TblMgMaterials> materials = state.materials.where((material) => material.catId == widget.catId || widget.catId == 0).toList();
              List<CartItem> cartItems = state.cartItems;
              return resourceWidgetBuild(materials, cartItems);
            } else if (state is LoadedWithMessageState) {
              List<TblMgMaterials> materials = state.materials.where((material) => material.catId == widget.catId || widget.catId == 0).toList();
              List<CartItem> cartItems = state.cartItems;
              return resourceWidgetBuild(materials, cartItems);
            }
            return emptyWidget;
          },
        ),
      ),
    );
  }
}
