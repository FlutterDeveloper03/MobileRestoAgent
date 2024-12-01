import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_resto_agent/Helpers/localization.dart';
import 'package:mobile_resto_agent/bloc/MaterialBloc.dart';
import 'package:mobile_resto_agent/model/CartItem.dart';
import 'package:mobile_resto_agent/model/tbl_mg_materials.dart';
import 'package:mobile_resto_agent/pages/resourceDetailPage.dart';
import 'package:mobile_resto_agent/widgets/cBackButton.dart';

class ResourceDetailScreen extends StatefulWidget {
  final TblMgMaterials material;
  final List<CartItem> cartItems;
  final List<TblMgMaterials> materials;

  final PageController controller;

  const ResourceDetailScreen({
    Key? key,
    required this.material,
    required this.materials,
    required this.cartItems,
    required this.controller,
  }) : super(key: key);

  @override
  _ResourceDetailScreenState createState() => _ResourceDetailScreenState();
}

class _ResourceDetailScreenState extends State<ResourceDetailScreen> {
  final BorderRadius borderRadius = BorderRadius.circular(10.0);
  Widget? title;

  @override
  Widget build(BuildContext context) {
    final trs = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: CBackButton(),
        leadingWidth: 80,
        title: title ?? Text(widget.material.name(trs)),
        centerTitle: true,
      ),
      body: PageView.builder(
        onPageChanged: (int index) {
          setState(() {
            title = Text(widget.materials[index].name(trs));
          });
        },
        itemBuilder: (context, index) {
          double count = 0;
          if (widget.cartItems.any((element) => element.material.id == widget.materials[index].id)) {
            count = widget.cartItems.firstWhere((element) => element.material.id == widget.materials[index].id).count;
          }
          return ResourceDetailPage(
            material: widget.materials[index],
            count: count,
            cartItems: widget.cartItems,
            changeState: () {
              setState(() {});
            },
          );
        },
        controller: widget.controller,
        itemCount: widget.materials.length,
      ),
    );
  }
}
