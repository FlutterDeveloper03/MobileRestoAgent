import 'package:flutter/material.dart';
import 'package:mobile_resto_agent/Helpers/localization.dart';
import 'package:mobile_resto_agent/screens/SettingsScreen.dart';

class AppBarActions extends StatelessWidget {
  final double width;
  final Function handleSearch;
  const AppBarActions({
    Key? key,
    required this.width,
    required this.handleSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final trs = AppLocalizations.of(context);
    final BorderRadius borderRadius = BorderRadius.circular(10.0);
    return Container(
      alignment: Alignment.centerRight,
      width: width,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              child: TextField(
                onSubmitted: (String input) {
                  handleSearch(input);
                },
                cursorColor: Theme.of(context).primaryColorLight,
                style: TextStyle(
                  color: Theme.of(context).primaryColorLight,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: trs.translate('search_text_hint'),
                  hintStyle: TextStyle(
                    color: Theme.of(context).primaryColorLight,
                    fontSize: 16,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).primaryColorLight,
                  ),
                  contentPadding: EdgeInsets.all(8.0),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColorLight),
                    borderRadius: borderRadius,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColorLight),
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
                color: Theme.of(context).primaryColorDark,
              ),
            ),
            Container(
              height: 40,
              width: 40,
              margin: EdgeInsets.only(right: 8.0),
              child: TextButton(
                style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsScreen(),
                    ),
                  );
                },
                child: Container(
                  child: Icon(
                    Icons.settings,
                    color: Theme.of(context).primaryColorLight,
                  ),
                  padding: EdgeInsets.all(8.0),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
