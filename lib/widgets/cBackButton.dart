import 'package:flutter/material.dart';
import 'package:mobile_resto_agent/Helpers/localization.dart';

class CBackButton extends StatelessWidget {
  const CBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final trs = AppLocalizations.of(context);
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.all(0),
      ),
      onPressed: () {
        Navigator.pop(context);
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
    );
  }
}
