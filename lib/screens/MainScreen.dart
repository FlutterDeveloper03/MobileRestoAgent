import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_resto_agent/Helpers/localization.dart';
import 'package:mobile_resto_agent/bloc/FichBloc.dart' as f;
import 'package:mobile_resto_agent/bloc/MaterialBloc.dart' as m;
import 'package:mobile_resto_agent/bloc/TableBloc.dart';
import 'package:mobile_resto_agent/bloc/TableCategoryBloc.dart';
import 'package:mobile_resto_agent/model/tbl_dk_table_category.dart';
import 'package:mobile_resto_agent/screens/SettingsScreen.dart';
import 'package:mobile_resto_agent/screens/TableScreen.dart';
import 'package:mobile_resto_agent/widgets/customEmpty.dart';
import 'package:mobile_resto_agent/widgets/customLoading.dart';
import 'package:mobile_resto_agent/widgets/infoItem.dart';

class MainScreen extends StatefulWidget {
  final String name;

  MainScreen({required this.name});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final AppLocalizations trs = AppLocalizations.of(context);
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
    final double spacing = (((width) / 500).ceil() - (width) / 500) * (crossAxisCount - 1);

    Future<bool> askToConfirmDialog(String text) async {
      return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(
            trs.translate(text) ?? text,
            style: Theme.of(context).textTheme.headlineSmall,
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
      );
    }

    return WillPopScope(
      onWillPop: () async {
        bool result = await askToConfirmDialog('would_you_like_out');
        return result;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.name,
          ),
          leadingWidth: 80,
          leading: TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.all(0),
            ),
            onPressed: () async {
              bool result = await askToConfirmDialog('would_you_like_out');
              if (result) {
                Navigator.pop(context);
              }
            },
            child: Container(
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.only(left: 8.0),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Icon(
                      Icons.arrow_back,
                      color: Theme.of(context).primaryColorLight,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        trs.translate('back') ?? 'back',
                        style: TextStyle(color: Theme.of(context).primaryColorLight),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(),
                  ),
                );
              },
              child: Container(
                alignment: Alignment.center,
                child: Icon(
                  Icons.settings,
                  color: Theme.of(context).primaryColorLight,
                ),
                padding: EdgeInsets.all(8.0),
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ],
        ),
        body: Row(
          children: [
            Expanded(
              flex: 7,
              child: RefreshIndicator(
                onRefresh: () async {
                  BlocProvider.of<TableBloc>(context).add(LoadEvent());
                },
                child: BlocBuilder<TableBloc, TableState>(builder: (tablesBlocContext, state) {
                  if (state is LoadedState) {
                    return GridView.builder(
                      itemCount: state.tables.length,
                      itemBuilder: (context, index) => BlocProvider(
                        create: (_) => f.FichBloc(),
                        child: Builder(builder: (context) {
                          return TextButton(
                            style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
                            onPressed: () {
                              BlocProvider.of<m.MaterialBloc>(context).add(m.CleanCart());
                              BlocProvider.of<f.FichBloc>(context).add(f.LoadEvent(state.tables[index].fichId));
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: BlocProvider.of<f.FichBloc>(context),
                                    child: TableScreen(
                                      table: state.tables[index],
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: InfoItem(
                              image: Stack(
                                children: [
                                  Image.asset(
                                    'assets/images/table.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                  (state.tables[index].invDesc.length > 0 ||
                                          state.tables[index].speCode.length > 0 ||
                                          state.tables[index].securityCode.length > 0)
                                      ? Container(
                                          color: Colors.white,
                                          width: 100,
                                          child: ListView(
                                            children: [
                                              (state.tables[index].securityCode.length > 0)
                                                  ? SingleChildScrollView(
                                                      scrollDirection: Axis.horizontal,
                                                      child: Row(
                                                        children: [
                                                          Icon(Icons.info_outline),
                                                          Text(state.tables[index].securityCode),
                                                        ],
                                                      ),
                                                    )
                                                  : SizedBox.shrink(),
                                              (state.tables[index].speCode.length > 0)
                                                  ? SingleChildScrollView(
                                                      scrollDirection: Axis.horizontal,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Icon(Icons.phone_android_outlined),
                                                          Text(state.tables[index].speCode),
                                                        ],
                                                      ),
                                                    )
                                                  : SizedBox.shrink(),
                                              (state.tables[index].groupCode.length > 0)
                                                  ? SingleChildScrollView(
                                                      scrollDirection: Axis.horizontal,
                                                      child: Row(
                                                        children: [
                                                          Icon(Icons.room_service),
                                                          Text(state.tables[index].groupCode),
                                                        ],
                                                      ),
                                                    )
                                                  : SizedBox.shrink(),
                                              SizedBox(height: 20,),
                                            ],
                                          ),
                                        )
                                      : Column(
                                          children: [
                                            (state.tables[index].invDesc.length > 0)
                                                ? SingleChildScrollView(
                                                    child: Row(
                                                      children: [
                                                        Icon(Icons.info_outline),
                                                        Text(state.tables[index].invDesc),
                                                      ],
                                                    ),
                                                  )
                                                : SizedBox.shrink(),
                                            (state.tables[index].speCode.length > 0)
                                                ? Row(
                                                    children: [
                                                      Icon(Icons.phone_android_outlined),
                                                      Text(state.tables[index].speCode),
                                                    ],
                                                  )
                                                : SizedBox.shrink(),
                                            (state.tables[index].securityCode.length > 0)
                                                ? Row(
                                                    children: [
                                                      Icon(Icons.room_service),
                                                      Text(state.tables[index].securityCode),
                                                    ],
                                                  )
                                                : SizedBox.shrink(),
                                            SizedBox(height: 20,),
                                          ],
                                        ),
                                ],
                              ),
                              widget: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 2,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        state.tables[index].tableName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 3,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        state.tables[index].fichTotal.toStringAsFixed(2),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).colorScheme.secondary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: spacing,
                        childAspectRatio: 2.6 / 2,
                        crossAxisCount: crossAxisCount,
                      ),
                    );
                  } else if (state is LoadingState) {
                    return CustomLoading(
                      height: height * 0.8,
                      width: width,
                    );
                  }
                  return CustomEmpty(
                    height: height * 0.8,
                    width: width,
                  );
                }),
              ),
            ),
            Expanded(
              flex: 2,
              child: RefreshIndicator(
                onRefresh: () async {
                  BlocProvider.of<TableCategoryBloc>(context).add(LoadTableCategoriesEvent());
                },
                child: BlocBuilder<TableCategoryBloc, TableCategoryState>(builder: (tableCategoryBlocContext, state) {
                  if (state is TableCategoriesLoadedState) {
                    List<TblDkTableCategory> _tableCategories = [];
                    _tableCategories.addAll(state.tableCategories);
                    return GridView.builder(
                      itemCount: _tableCategories.length,
                      itemBuilder: (context, index) => Builder(builder: (context) {
                        return (index == 0) ? TextButton(
                          style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
                          onPressed: () {
                            BlocProvider.of<TableBloc>(context).add(LoadEvent(
                                tableCategory: ('')));
                          },
                          child: InfoItem(
                            image: Image.asset(
                              'assets/images/tablesCategory.jpg',
                              fit: BoxFit.cover,
                            ),
                            widget: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                trs.translate('all') ?? 'All',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        )
                        :TextButton(
                          style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
                          onPressed: () {
                            BlocProvider.of<TableBloc>(context).add(LoadEvent(
                                tableCategory: (_tableCategories[index].tableCatName == (trs.translate('all') ?? 'All'))
                                    ? ''
                                    : _tableCategories[index].tableCatName));
                          },
                          child: InfoItem(
                            image: Image.asset(
                              'assets/images/tablesCategory.jpg',
                              fit: BoxFit.cover,
                            ),
                            widget: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                _tableCategories[index].tableCatName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: spacing,
                        crossAxisCount: 1,
                      ),
                    );
                  } else if (state is LoadingTableCategoriesState) {
                    return CustomLoading(
                      height: height * 0.8,
                      width: width,
                    );
                  }
                  return CustomEmpty(
                    height: height * 0.8,
                    width: width,
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
