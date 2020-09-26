// import 'package:flutter/material.dart';
// import 'package:note_keeper_001/constants/constants.dart';

// import '../models/list_item.dart';
// import '../utils/dbhelper.dart';

// class ItemDialog extends StatefulWidget {
//   ItemDialog(this.item, this.isNew);

//   final ListItem item;
//   final bool isNew;

//   @override
//   _ItemDialogState createState() => _ItemDialogState();
// }

// class _ItemDialogState extends State<ItemDialog> {
//   final _formKey = GlobalKey<FormState>();

//   DbHelper helper = DbHelper();

//   final txtName = TextEditingController();
//   final txtNote = TextEditingController();
//   final txtQuantity = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     controllerCheck(widget.isNew);
//   }

//   void controllerCheck(bool isNew) {
//     switch (isNew) {
//       case true:
//         txtName.text = '';
//         txtQuantity.text = '';
//         txtNote.text = '';
//         break;
//       case false:
//         txtName.text = widget.item.name;
//         txtQuantity.text = widget.item.quantity;
//         txtNote.text = widget.item.note;
//         break;
//       default:
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: Colors.black26,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Container(
//             alignment: Alignment.center,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 TextFormField(
//                   style: kItemNote.copyWith(color: Colors.black),
//                   validator: (value) {
//                     if (value.isEmpty) {
//                       return ' item Name is required';
//                     }
//                     return null;
//                   },
//                   autofocus: true,
//                   // style:
//                   //     TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//                   controller: txtName,
//                   maxLength: 10,
//                   decoration: InputDecoration(
//                     errorStyle: TextStyle(
//                       color: Colors.amber,
//                     ),
//                     counterText: '',
//                     counterStyle: TextStyle(color: Colors.white),
//                     filled: true,
//                     fillColor: Colors.white,
//                     hintText: 'i.e chocolate',
//                     hintStyle: kItemNote.copyWith(color: Colors.grey),
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide.none,
//                       borderRadius: BorderRadius.circular(3),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 TextFormField(
//                   style: kItemNote.copyWith(color: Colors.black),
//                   controller: txtQuantity,
//                   maxLength: 15,
//                   decoration: InputDecoration(
//                     errorStyle: TextStyle(
//                         color: Colors.white, fontSize: 15, letterSpacing: 0.5),
//                     counterText: '',
//                     hintText: 'Item Quantity',
//                     hintStyle: kItemNote.copyWith(color: Colors.grey),
//                     filled: true,
//                     fillColor: Colors.white,
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide.none,
//                       borderRadius: BorderRadius.circular(3),
//                     ),
//                   ),
//                 ),
//                 FlatButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: Text('Pop'),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:note_keeper_001/constants/constants.dart';

import '../models/list_item.dart';
import '../utils/dbhelper.dart';

class ItemDialog extends StatefulWidget {
  ItemDialog(this.item, this.isNew);

  final ListItem item;
  final bool isNew;

  @override
  _ItemDialogState createState() => _ItemDialogState();
}

class _ItemDialogState extends State<ItemDialog> {
  final _formKey = GlobalKey<FormState>();

  DbHelper helper = DbHelper();

  final txtName = TextEditingController();
  final txtNote = TextEditingController();
  final txtQuantity = TextEditingController();

  @override
  void initState() {
    super.initState();
    controllerCheck(widget.isNew);
  }

  void controllerCheck(bool isNew) {
    switch (isNew) {
      case true:
        txtName.text = '';
        txtQuantity.text = '';
        txtNote.text = '';
        break;
      case false:
        txtName.text = widget.item.name;
        txtQuantity.text = widget.item.quantity;
        txtNote.text = widget.item.note;
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      actionsPadding: EdgeInsets.only(right: size.width * 0.035),
      backgroundColor: Colors.black,
      title: Text(
        widget.isNew ? 'Add New Item' : 'Edit Item',
        style: TextStyle(color: Colors.white),
      ),
      content: Container(
        width: size.width * 0.03,
        height: size.height * 0.25,
        // color: Colors.red,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  style: kItemNote.copyWith(color: Colors.black),
                  validator: (value) {
                    if (value.isEmpty) {
                      return ' item Name is required';
                    }
                    return null;
                  },
                  autofocus: true,
                  // style:
                  //     TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  controller: txtName,
                  maxLength: 15,
                  decoration: InputDecoration(
                    errorStyle: TextStyle(
                      color: Colors.amber,
                    ),
                    counterText: '',
                    counterStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'i.e chocolate',
                    hintStyle: kItemNote.copyWith(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  style: kItemNote.copyWith(color: Colors.black),
                  controller: txtQuantity,
                  maxLength: 15,
                  decoration: InputDecoration(
                    errorStyle: TextStyle(
                        color: Colors.white, fontSize: 15, letterSpacing: 0.5),
                    counterText: '',
                    hintText: 'Item Quantity',
                    hintStyle: kItemNote.copyWith(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  style: kItemNote.copyWith(color: Colors.black),
                  controller: txtNote,
                  maxLines: 2,
                  maxLength: 50,
                  decoration: InputDecoration(
                    counterText: '',
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Item Note',
                    hintStyle: kItemNote.copyWith(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.025,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          color: Colors.amber,
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              widget.item.name = txtName.text;
              widget.item.quantity = txtQuantity.text;
              widget.item.note = txtNote.text;

              await helper.insertItem(widget.item);
              Navigator.pop(context);
            }
          },
          child: Text(
            'Save',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
