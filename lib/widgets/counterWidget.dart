import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Counter extends StatelessWidget {
  final double count;
  final Function add;
  final Function remove;
  final Function(double number) newValue;
  const Counter(
      {Key? key,
      required this.count,
      required this.add,
      required this.remove,
      required this.newValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = BorderRadius.circular(15);
    return Container(
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {
                remove();
              },
              icon: Icon(Icons.remove, color: Colors.white),
              iconSize: 15,
              padding: EdgeInsets.all(0),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    blurRadius: 3.0,
                    color: Colors.grey.withOpacity(0.7),
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () async {
                  double number = await (showDialog(
                        context: context,
                        builder: (context) {
                          TextEditingController controller =
                              TextEditingController(
                                  text: count.toString() != '0'
                                      ? (count % 1 == 0) ? count.toStringAsFixed(0) : count.toStringAsFixed(3)
                                      : '');
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: borderRadius,
                            ),
                            insetPadding: EdgeInsets.all(20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                                borderRadius: borderRadius,
                              ),
                              padding: EdgeInsets.all(8.0),
                              height: 115,
                              width: 200,
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: borderRadius,
                                      color: Colors.white,
                                    ),
                                    width: 190,
                                    child: TextField(
                                      autofocus: true,
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.phone,
                                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,3}'))],
                                      controller: controller,
                                      onSubmitted: (String text) {
                                        Navigator.pop(context, text);
                                      },
                                      decoration: InputDecoration(
                                        hintStyle: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                          fontSize: 16,
                                        ),
                                        contentPadding: EdgeInsets.all(8.0),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColorLight),
                                          borderRadius: borderRadius,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColorLight),
                                          borderRadius: borderRadius,
                                        ),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      side: BorderSide(
                                        style: BorderStyle.solid,
                                        color:
                                            Theme.of(context).primaryColorLight,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(
                                        context,
                                        double.parse(
                                          controller.text.isNotEmpty
                                              ? controller.text
                                              : '0',
                                        ),
                                      );
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )) ??
                      count;
                  newValue(number);
                },
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text((count % 1 == 0) ? count.toStringAsFixed(0) : count.toStringAsFixed(3)),
                ),
              ),
            ),
          ),
          Container(
            height: 40,
            width: 40,
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {
                add();
              },
              icon: Icon(Icons.add, color: Colors.white),
              iconSize: 15,
              padding: EdgeInsets.all(0),
            ),
          ),
        ],
      ),
    );
  }
}
