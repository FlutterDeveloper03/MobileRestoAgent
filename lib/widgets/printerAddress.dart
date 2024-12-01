import 'package:flutter/material.dart';
import 'package:mobile_resto_agent/model/printerAddress.dart';

class CustomPrinterAddress extends StatelessWidget {
  final PrinterAddress address;
  final Function delete;
  const CustomPrinterAddress({
    Key? key,
    required this.address,
    required this.delete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.0),
              margin: EdgeInsets.only(left: 8.0),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                address.ip + ':' + address.port,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          Container(
            height: 50,
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1.5,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () {
                delete();
              },
              child: Icon(Icons.delete),
            ),
          ),
        ],
      ),
    );
  }
}
