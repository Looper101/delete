import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_keeper_001/constants/constants.dart';

import '../models/shopping_list.dart';
import '../utils/dbhelper.dart';

var priorities = [
  'Select priority',
  'High',
  'Medium',
  'Low',
];

class ShoppingListAlertDialog extends StatefulWidget {
  ShoppingListAlertDialog({this.isNew, this.list});
  final bool isNew;
  final ShoppingList list;

  final txtPriority = TextEditingController();
  @override
  _ShoppingListAlertDialogState createState() =>
      _ShoppingListAlertDialogState();
}

class _ShoppingListAlertDialogState extends State<ShoppingListAlertDialog> {
  DbHelper helper = DbHelper();

  @override
  void initState() {
    super.initState();
    controllerCheck(widget.isNew);
  }

  void controllerCheck(bool isNew) {
    switch (isNew) {
      case false:
        txtName.text = widget.list.name;
        widget.txtPriority.text = widget.list.priority.toString();
        break;
      case true:
        txtName.text = '';
        widget.txtPriority.text = '';
        break;
      default:
    }
  }

  updatePriorityAsInt(String value) {
    switch (value) {
      case 'Select priority':
        return null;
        break;

      case 'High':
        return widget.list.priority = 1;
        break;
      case 'Medium':
        return widget.list.priority = 2;
        break;
      case 'Low':
        return widget.list.priority = 3;
        break;
      default:
    }
  }

  indexToPriority(int value) {
    switch (value) {
      case 0:
        return widget.list.priority = 3;
        break;
      case 1:
        return widget.list.priority = 2;
        break;
      case 2:
        return widget.list.priority = 1;
        break;
      default:
    }
  }

  String getPriorityAsString(int value) {
    String prt;
    switch (value) {
      case 1:
        prt = priorities[0];
        break;
      case 2:
        prt = priorities[1];
        break;
      case 3:
        prt = priorities[2];
        break;
    }
    return prt;
  }

  String stringToIntPriority(int value) {
    String newPrirority;
    switch (value) {
      case 1:
        newPrirority = 'High';
        break;
      case 2:
        newPrirority = 'Medium';
        break;
      case 3:
        newPrirority = 'Low';
        break;
      case 0:
        newPrirority = 'Select priority';
        break;
    }
    return newPrirority;
  }

  priorityToString(int priority) {
    switch (priority) {
      case 1:
        return 'High';
        break;
      case 2:
        return 'Medium';
        break;
      case 3:
        return 'Low';
        break;
    }
  }

  List<String> buttonTitle = [
    'Low',
    'Medium',
    'High',
  ];

  int valueEnter;
  String initialValue;
  String userTyped;
  final txtName = TextEditingController();
  final formKey2 = GlobalKey<FormState>();
  String currentButton;
  @override
  Widget build(BuildContext context) {
    helper.openDb();
    currentButton = priorityToString(widget.list.priority);
    // initialValue = updatePriorityAsInt(widget.list.priority);

    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      actionsPadding: EdgeInsets.only(right: size.width * 0.035),
      backgroundColor: Colors.black.withAlpha(200),
      elevation: 0,
      title: Text(
        widget.isNew ? 'New Shopping List' : 'Edit Shopping List',
        style: kTextFieldTextStyle.copyWith(color: Colors.white),
      ),
      content: SingleChildScrollView(
        child: Container(
          width: size.width - 100,
          child: Column(
            children: <Widget>[
              Form(
                key: formKey2,
                child: TextFormField(
                  validator: (valuetyped) {
                    if (valuetyped.isEmpty) {
                      return '*Item is required';
                    }
                    return null;
                  },
                  maxLength: 15,
                  autofocus: true,
                  style: kItemNote.copyWith(color: Colors.black),
                  controller: txtName,
                  decoration: InputDecoration(
                    errorStyle: TextStyle(
                        color: Colors.white, fontSize: 15, letterSpacing: 0.5),
                    hintText: 'Add Category title',
                    hintStyle: kItemNote.copyWith(color: kSeaBlue),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        borderSide: BorderSide.none),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.00005,
              ),
              // CupertinoSegmentedControl(
              //   padding: EdgeInsets.all(1),
              //   selectedColor: Colors.black,
              //   pressedColor: Colors.red,
              //   unselectedColor:
              //       currentButton == initialValue ? kThemeColor : Colors.white,
              //   borderColor: Colors.black38,
              //   children: {
              //     'Low': Container(
              //       margin: EdgeInsets.symmetric(vertical: 6, horizontal: 25),
              //       child: Text(
              //         'Low',
              //         style: TextStyle(fontSize: 20, color: Colors.white),
              //       ),
              //     ),
              //     'Medium': Container(
              //       margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              //       child: Text(
              //         'Medium',
              //         style: TextStyle(fontSize: 20, color: Colors.white),
              //       ),
              //     ),
              //     'Three': Container(
              //       margin: EdgeInsets.symmetric(vertical: 6, horizontal: 25),
              //       child: Text(
              //         'High',
              //         style: TextStyle(fontSize: 20, color: Colors.white),
              //       ),
              //     ),
              //   },
              //   onValueChanged: (value) {
              //     print(value);

              //     setState(() {
              //       initialValue = value;

              //       currentButton = value;
              //       valueEnter = updatePriorityAsInt(value);
              //       print(currentButton);
              //     });
              //   },
              // ),
              // ListView.builder(
              //     itemCount: 10,
              //     itemBuilder: (context) => Container(child: Text('Mandaee'))),

              Container(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
                height: size.height * 0.048,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white70.withOpacity(0.045),
                    borderRadius: BorderRadius.circular(5)),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: buttonTitle.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          valueEnter = index;
                          indexToPriority(valueEnter);
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(
                            horizontal: size.width * 0.0029, vertical: 3),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: valueEnter == index
                                  ? Colors.black
                                  : Colors.white),
                          color: (valueEnter == index)
                              ? Colors.amber
                              : Colors.black,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          buttonTitle[index],
                          style: TextStyle(
                              fontSize: valueEnter == index ? 20 : 15,
                              color: valueEnter == index
                                  ? Colors.black
                                  : Colors.grey),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          color: Colors.amber,
          onPressed: () async {
            if (formKey2.currentState.validate() == true) {
              widget.list.name = txtName.text;
              await helper.insertList(widget.list);
              Navigator.pop(context);
            }
          },
          child: Text(
            'Save',
            style: TextStyle(color: Colors.black),
          ),
        )
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}

// ListTile(
//                   leading: DropdownButton(
//                     style: kItemNote.copyWith(
//                         fontSize: 10, fontWeight: FontWeight.w500),
//                     iconDisabledColor: kOrangeOnion,
//                     icon: RotatedBox(
//                       quarterTurns: 3,
//                       child: Icon(
//                         CupertinoIcons.back,
//                         color: Colors.grey,
//                       ),
//                     ),
//                     dropdownColor: Color(0xFF451386),
//                     iconEnabledColor: Colors.black,
//                     underline: Divider(
//                       color: Colors.transparent,
//                       height: 10,
//                     ),
//                     value: initialValue,
//                     onChanged: (valueSelected) {
//                       setState(() {
//                         initialValue = valueSelected;
//                         valueEnter = updatePriorityAsInt(valueSelected);
//                       });
//                     },
//                     items: List.generate(
//                       priorities.length,
//                       (index) {
//                         return DropdownMenuItem(
//                           child: Text(
//                             priorities[index],
//                             style: kTextFieldTextStyle.copyWith(
//                               color: Colors.white,
//                             ),
//                           ),
//                           value: priorities[index],
//                         );
//                       },
//                     ),
//                   ),
//                   title: CupertinoSegmentedControl(
//                     children: {
//                       'Low': Text('Low'),
//                       'Medium': Text('Medium'),
//                       'High': Text('High'),
//                     },
//                     onValueChanged: (value) {},
//                   ),
//                 ),
