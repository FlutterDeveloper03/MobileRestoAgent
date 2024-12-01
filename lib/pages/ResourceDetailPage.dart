import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_resto_agent/Helpers/localization.dart';
import 'package:mobile_resto_agent/bloc/MaterialBloc.dart';
import 'package:mobile_resto_agent/model/CartItem.dart';
import 'package:mobile_resto_agent/model/tbl_mg_materials.dart';
import 'package:mobile_resto_agent/widgets/counterWidget.dart';

class ResourceDetailPage extends StatelessWidget {
  final TblMgMaterials material;
  final double count;
  final Function changeState;
  final List<CartItem> cartItems;
  const ResourceDetailPage({
    Key? key,
    required this.material,
    required this.cartItems,
    required this.count,
    required this.changeState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final trs = AppLocalizations.of(context);
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Container(
      child: Stack(
        children: [
          Container(
            height: height,
            width: width,
            child: Hero(
              tag: material.materialName,
              child: material.imagePict.isNotEmpty
                  ? Image.memory(
                material.imagePict,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object object,
                    StackTrace? trace) {
                  return Image.asset(
                    'assets/images/no-image.jpg',
                    fit: BoxFit.cover,
                  );
                },
              )
                  : Image.asset(
                'assets/images/no-image.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: width <= 300
                ? width
                : width <= 600
                ? width / 2
                : width <= 1200
                ? width / 3
                : width / 4,
            color: Colors.black54,
            child: ListView(
              children: [
                Padding(
                  padding:
                  EdgeInsets.fromLTRB(0, height * 0.15, 0, height * 0.10),
                  child: Text(
                    material.name(trs),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 26,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    material.desc(trs),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: (material.aStatusId==1) ? Counter(
                    count: count,
                    add: () {
                      TblMgMaterials _mat = material;
                      if (_mat.matAutoPrice>0){
                        double sum=0;
                        for (CartItem ci in cartItems){
                          sum=sum+ci.material.salePrice*ci.count;
                        }
                        _mat=_mat.copyWith(salePrice: sum/100*_mat.matAutoPrice);
                      }
                      BlocProvider.of<MaterialBloc>(context).add(PlusCount(
                        material: _mat,
                      ));
                      changeState();
                    },
                    remove: () {
                      BlocProvider.of<MaterialBloc>(context).add(MinusCount(
                        material: material,
                      ));
                      changeState();
                    },
                    newValue: (double number) {
                      TblMgMaterials _mat = material;
                      if (_mat.matAutoPrice>0){
                        double sum=0;
                        for (CartItem ci in cartItems){
                          sum=sum+ci.material.salePrice*ci.count;
                        }
                        _mat=_mat.copyWith(salePrice: sum/100*_mat.matAutoPrice);
                      }
                      BlocProvider.of<MaterialBloc>(context).add(NewValue(
                        material: _mat,
                        matAttributes: [],
                        count: number,
                      ));
                    },
                  ) : SizedBox.shrink(),
                ),
                Padding(
                  padding:
                  EdgeInsets.fromLTRB(0, height * 0.15, 0, height * 0.1),
                  child: Text(
                    material.salePrice.toString() + ' TMT',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 36,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
