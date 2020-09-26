import 'package:flutter/material.dart';
import 'package:note_keeper_001/constants/constants.dart';
import 'package:note_keeper_001/models/shopping_list.dart';
import 'package:note_keeper_001/utils/dbhelper.dart';

class ItemTitleDialog extends StatefulWidget {
  ItemTitleDialog(this.list);
  final ShoppingList list;
  @override
  _ItemTitleDialogState createState() => _ItemTitleDialogState();
}

class _ItemTitleDialogState extends State<ItemTitleDialog> {
  DbHelper helper = DbHelper();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    txtName.text = widget.list.name;
  }

  final txtName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      backgroundColor: kMilkBrown,
      title: Text('Edit Title'),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Form(
              key: formKey,
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
                  hintText: 'edit Category title',
                  hintStyle: kItemNote.copyWith(color: kSeaBlue),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            RaisedButton(
              color: Colors.black,
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                if (formKey.currentState.validate()) {
                  widget.list.name = txtName.text;
                  await helper.insertList(widget.list);
                  Navigator.pop(context);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
