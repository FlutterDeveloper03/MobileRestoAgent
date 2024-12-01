import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_resto_agent/Helpers/localization.dart';
import 'package:mobile_resto_agent/bloc/FichBloc.dart';
import 'package:mobile_resto_agent/bloc/ImageLoaderBloc.dart';
import 'package:mobile_resto_agent/bloc/MaterialBloc.dart';
import 'package:mobile_resto_agent/bloc/SalesmansBloc.dart';
import 'package:mobile_resto_agent/model/tbl_mg_category.dart';
import 'package:mobile_resto_agent/model/tbl_mg_salesman.dart';
import 'package:mobile_resto_agent/pages/resourcePage.dart';
import 'package:mobile_resto_agent/widgets/cBackButton.dart';
import 'package:mobile_resto_agent/widgets/customEmpty.dart';
import 'package:mobile_resto_agent/widgets/customLoading.dart';
import 'package:mobile_resto_agent/widgets/customSlidingPanel.dart';
import 'package:mobile_resto_agent/widgets/navItem.dart';
import 'package:mobile_resto_agent/bloc/CategoryBloc.dart' as c;
import 'package:mobile_resto_agent/bloc/TableBloc.dart' as tableBloc;
import 'package:mobile_resto_agent/model/table.dart' as tm;
class TableScreen extends StatefulWidget {
  final tm.Table table;

  TableScreen({required this.table});

  @override
  _TableScreenState createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  final BorderRadius borderRadius = BorderRadius.circular(10.0);
  ScrollController scrollController = ScrollController();
  PageController controller = PageController(initialPage: 0);
  String title = '';
  int itemCount = 1;
  int _index = 0;
  int _selectedCatId = 0;
  List<TblMgCategory> _cats=[];

  @override
  Widget build(BuildContext context) {
    title=widget.table.tableName;
    final trs = AppLocalizations.of(context);
    final double width = MediaQuery
        .of(context)
        .size
        .width;
    final double bodyWidth = width < 700 ? width : width - 350;
    // final double height = MediaQuery.of(context).size.height;
    final double headerHeight = width < 700 ? 56 : 100;
    changePage(int index,int catId) {
      setState(() {
        _selectedCatId=catId;
        if (_index == index) {
          controller.jumpToPage(index);
        } else if (1 >= (_index - index).abs()) {
          controller.animateToPage(
            index,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOutCubic,
          );
        } else {
          controller.jumpToPage(index);
        }
        _index = index;
        print('Print _index:$_index');
      });
    }

    void search(String search) {
      BlocProvider.of<MaterialBloc>(context).add(SearchEvent(
        search: search,
        locale: trs,
      ));
    }

    Future<bool> askToConfirmDialog(String text) async {
      return (await showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              content: Text(
                trs.translate(text) ?? text,
                style: Theme
                    .of(context)
                    .textTheme
                    .headlineSmall,
              ),
              actions: [
                TextButton(
                  child: Text(
                    trs.translate('no') ?? 'no',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
                TextButton(
                  child: Text(
                    trs.translate('yes') ?? 'yes',
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                )
              ],
            ),
      )) ??
          false;
    }

    showTablesDialog(BuildContext context, AppLocalizations trs) {
      showDialog(
        context: context,
        builder: (context1) {
          BorderRadius borderRadius = BorderRadius.circular(15);
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius,
            ),
            insetPadding: EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                color: Theme
                    .of(context)
                    .colorScheme
                    .secondary,
                borderRadius: borderRadius,
              ),
              padding: EdgeInsets.all(8.0),
              height: MediaQuery
                  .of(context)
                  .size
                  .height / 1.3,
              width: MediaQuery
                  .of(context)
                  .size
                  .width / 1.2,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: BlocBuilder<tableBloc.TableBloc, tableBloc.TableState>(
                        builder: (context, state) {
                          if (state is tableBloc.LoadingState) {
                            return Center(
                                child: CustomLoading(
                                  height: MediaQuery
                                      .of(context)
                                      .size
                                      .height / 1.3 * 0.8,
                                  width: width,
                                ));
                          } else if (state is tableBloc.EmptyState) {
                            return CustomEmpty(
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .height / 1.3 * 0.8,
                              width: width,
                            );
                          } else if (state is tableBloc.LoadedState) {
                            return ListView.builder(
                              itemCount: state.tables.length,
                              itemBuilder: (context, index) {
                                tm.Table table = state.tables[index];
                                return StatefulBuilder(
                                  builder: (context, setState) =>
                                      Column(
                                        children: [
                                          ListTile(
                                            leading: (table.fichNetTotal > 0) ? Icon(Icons.airline_seat_recline_normal) : Icon(Icons.deck),
                                            title: Text(table.tableName),
                                            subtitle: Column(
                                              children: [
                                                (table.invDesc.length > 0)
                                                    ? Row(
                                                  children: [
                                                    Icon(Icons.info_outline),
                                                    Text(table.invDesc),
                                                  ],
                                                )
                                                    : SizedBox.shrink(),
                                                (table.speCode.length > 0)
                                                    ? Row(
                                                  children: [
                                                    Icon(Icons.phone_android_outlined),
                                                    Text(table.speCode),
                                                  ],
                                                )
                                                    : SizedBox.shrink(),
                                                (table.groupCode.length > 0)
                                                    ? Row(
                                                  children: [
                                                    Icon(Icons.phone),
                                                    Text(table.groupCode),
                                                  ],
                                                )
                                                    : SizedBox.shrink(),
                                                (table.securityCode.length > 0)
                                                    ? Row(
                                                  children: [
                                                    Icon(Icons.room_service),
                                                    Text(table.securityCode),
                                                  ],
                                                )
                                                    : SizedBox.shrink(),
                                              ],
                                            ),
                                            trailing: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [Icon(Icons.functions), Text(table.fichNetTotal.toStringAsFixed(2))],
                                            ),
                                            onTap: () async {
                                              if (table.fichId > 0) {
                                                bool result = await askToConfirmDialog(trs.translate('doYouWantToMergeTables') ??
                                                    'The table is not empty. Are you sure you want to move the current table to the unselected?');
                                                if (result) {
                                                  BlocProvider.of<tableBloc.TableBloc>(context).add(
                                                      tableBloc.MoveTableEvent(widget.table, table));
                                                }
                                              } else {
                                                // bool result = await askToConfirmDialog(trs.translate('doYouWantToMoveTable') ??
                                                //     'Are you sure you want to move the current table to the unselected one?');
                                                // if (result) {
                                                //   BlocProvider.of<tableBloc.TableBloc>(context).add(
                                                //       tableBloc.MoveTableEvent(widget.table, table));
                                                // }
                                              }
                                              // Navigator.of(context).pop();
                                            },
                                          ),
                                          Divider(
                                            thickness: 1,
                                            height: 1,
                                            color: Colors.orange,
                                          )
                                        ],
                                      ),
                                );
                              },
                            );
                          } else
                            return SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      side: BorderSide(
                        style: BorderStyle.solid,
                        color: Theme
                            .of(context)
                            .primaryColorLight,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                      child: Text(trs.translate('ok') ?? 'ok'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    showSalesmansDialog(BuildContext context, int fichId, AppLocalizations trs) {
      showDialog(
        context: context,
        builder: (context1) {
          BorderRadius borderRadius = BorderRadius.circular(15);
          return BlocProvider.value(
            value: BlocProvider.of<FichBloc>(context),
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius,
              ),
              insetPadding: EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme
                      .of(context)
                      .colorScheme
                      .secondary,
                  borderRadius: borderRadius,
                ),
                padding: EdgeInsets.all(8.0),
                height: MediaQuery
                    .of(context)
                    .size
                    .height / 1.3,
                width: MediaQuery
                    .of(context)
                    .size
                    .width / 1.2,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(15))),
                        child: BlocBuilder<SalesmansBloc, SalesmansState>(
                          builder: (context, state) {
                            if (state is LoadingSalesmansState) {
                              return Center(
                                  child: CustomLoading(
                                    height: MediaQuery
                                        .of(context)
                                        .size
                                        .height / 1.3 * 0.8,
                                    width: width,
                                  ));
                            } else if (state is SalesmansEmptyState) {
                              return CustomEmpty(
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height / 1.3 * 0.8,
                                width: width,
                              );
                            } else if (state is SalesmansLoadedState) {
                              return ListView.builder(
                                itemCount: state.salesmans.length,
                                itemBuilder: (context, index) {
                                  TblMgSalesman salesman = state.salesmans[index];
                                  return Column(
                                    children: [
                                      ListTile(
                                        leading: (salesman.salesmanStatusId ==2) ? Icon(Icons.engineering) : Icon(Icons.person),
                                        title: Text(salesman.salesmanName),
                                        onTap: () async {
                                          bool result = await askToConfirmDialog(trs.translate('doYouWantToChangeSalesman') ??
                                              'Are you sure you want to change waiter of the table to the selected one?');
                                          if (result) {
                                            BlocProvider.of<FichBloc>(context).add(
                                                ChangeSalesmanEvent(fichId, salesman.salesmanId));
                                          }
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      Divider(
                                        thickness: 1,
                                        height: 1,
                                        color: Colors.orange,
                                      )
                                    ],
                                  );
                                },
                              );
                            } else
                              return SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        side: BorderSide(
                          style: BorderStyle.solid,
                          color: Theme
                              .of(context)
                              .primaryColorLight,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                        child: Text(trs.translate('ok') ?? 'ok'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<tableBloc.TableBloc>(context).add(tableBloc.LoadEvent());
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: CBackButton(),
          leadingWidth: 70,
          actions: [
            Container(
              alignment: Alignment.centerRight,
              width: width,
              // width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(width: 60, child: FittedBox(fit: BoxFit.scaleDown, child: Text(title))),
                    Container(
                      child: TextField(
                        onSubmitted: (String input) {
                          search(input);
                        },
                        cursorColor: Theme
                            .of(context)
                            .primaryColorLight,
                        style: TextStyle(
                          color: Theme
                              .of(context)
                              .primaryColorLight,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          hintText: trs.translate('search_text_hint'),
                          hintStyle: TextStyle(
                            color: Theme
                                .of(context)
                                .primaryColorLight,
                            fontSize: 16,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Theme
                                .of(context)
                                .primaryColorLight,
                          ),
                          contentPadding: EdgeInsets.all(8.0),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme
                                .of(context)
                                .primaryColorLight),
                            borderRadius: borderRadius,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme
                                .of(context)
                                .primaryColorLight),
                            borderRadius: borderRadius,
                          ),
                        ),
                      ),
                      width: 150,
                      height: 40,
                      margin: EdgeInsets.all(8.0),
                      // padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: borderRadius,
                        color: Theme
                            .of(context)
                            .primaryColorDark,
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      margin: EdgeInsets.only(right: 8.0),
                      child: TextButton(
                        style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
                        onPressed: () {
                          showTablesDialog(context, trs);
                        },
                        child: Container(
                          child: Icon(
                            Icons.move_up,
                            color: Theme
                                .of(context)
                                .primaryColorLight,
                          ),
                          padding: EdgeInsets.all(8.0),
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: borderRadius,
                            color: Theme
                                .of(context)
                                .colorScheme
                                .secondary,
                          ),
                        ),
                      ),
                    ),

                    BlocBuilder<FichBloc,FichState>(
                      builder: (context, state) {
                         return Container(
                            height: 40,
                            width: 40,
                            margin: EdgeInsets.only(right: 8.0),
                            child: TextButton(
                              style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
                              onPressed: () {
                                showSalesmansDialog(context,widget.table.fichId, trs);
                              },
                              child: Container(
                                child: Icon(
                                  Icons.supervised_user_circle_outlined,
                                  color: Theme
                                      .of(context)
                                      .primaryColorLight,
                                ),
                                padding: EdgeInsets.all(8.0),
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  borderRadius: borderRadius,
                                  color: Theme
                                      .of(context)
                                      .colorScheme
                                      .secondary,
                                ),
                              ),
                            ),
                          );
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        body: CustomSlidingPanel(
          table: widget.table,
          headerHeight: headerHeight,
          child: Column(
            children: [
              Container(
                  height: 100,
                  width: double.infinity,
                  child: BlocBuilder<c.CategoryBloc, c.CategoryState>(
                    builder: (context, state) {
                      _cats = [
                        TblMgCategory(catId: 0,
                            catName: trs.translate('all') ?? 'All',
                            catNameTm: 'Hemmesi',
                            catNameRu: 'Все',
                            catNameEn: 'All',
                            catOrder: 0,
                            catImage: Uint8List.fromList([]))
                      ];
                      if (state is c.LoadingState) {
                        return Container(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 80,
                            height: 80,
                            child: CircularProgressIndicator(
                              color: Theme.of(context).cardColor,
                            ),
                          ),
                        );
                      } else if (state is c.LoadedState) {
                        _cats.addAll(state.categories);
                        itemCount = state.categories.length + 1;
                        return ListView.builder(
                            controller: scrollController,
                            scrollDirection: Axis.horizontal,
                            itemCount: state.categories.length,
                            itemBuilder: (context, index) =>
                                BlocProvider(
                                  create: (context) => ImageLoaderBloc()..add(LoadImageEvent(0, _cats[index].catId)),
                                  child: Builder(
                                      builder: (context) {
                                        return TextButton(
                                          key: Key('CatIndex' + index.toString()),
                                          style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
                                          onPressed: () {
                                            changePage(index,_cats[index].catId);
                                          },
                                          child: BlocBuilder<ImageLoaderBloc, ImageLoaderState>(
                                            builder: (context, state) {
                                              if (state is ImageLoadedState) {
                                                return NavItem(
                                                  isActive: _index == index,
                                                  label: _cats[index].name(trs),
                                                  image: state.imageBytes.isNotEmpty
                                                      ? DecorationImage(
                                                    image: MemoryImage(state.imageBytes),
                                                    fit: BoxFit.cover,
                                                  )
                                                      : DecorationImage(
                                                    image: AssetImage('assets/images/no-image.jpg'),
                                                    fit: BoxFit.cover,
                                                  ),
                                                );
                                              } else {
                                                return NavItem(
                                                  isActive: _index == index,
                                                  label: _cats[index].name(trs),
                                                  image: DecorationImage(
                                                    image: AssetImage('assets/images/no-image.jpg'),
                                                    fit: BoxFit.cover,
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        );
                                      }
                                  ),
                                )
                        );
                      }
                      return TextButton(
                        key: Key('CatIndex' + 0.toString()),
                        style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
                        onPressed: () {
                          changePage(0,0);
                        },
                        child: NavItem(
                          isActive: _index == 0,
                          label: trs.translate('all') ?? 'all',
                          image: DecorationImage(
                            image: AssetImage('assets/images/no-image.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  )
              ),
              Expanded(
                child: PageView.builder(
                  onPageChanged: (index) {
                    changePage(index,_cats[index].catId);
                    setState(() {
                      scrollController.animateTo(
                        (index * 100) - (bodyWidth / 2) + 50,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      );
                      _index = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    if (index > 0) {
                      return ResourcesPage(
                        catId: _selectedCatId,
                        fichId: widget.table.fichId,
                      );
                    } else {
                      return ResourcesPage(catId: 0, fichId: widget.table.fichId);
                    }
                  },
                  controller: controller,
                  itemCount: itemCount,
                ),
              ),
              Container(
                height: headerHeight + 80,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
