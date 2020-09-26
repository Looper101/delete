import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_keeper_001/constants/constants.dart';

import 'item_Action_button.dart';

class CardItem extends StatefulWidget {
  CardItem(
      {this.size,
      this.disCardPress,
      this.donePress,
      this.editPress,
      this.itemName,
      this.itemNote,
      this.itemQuantity,
      this.cardColor,
      this.boughtVisible});

  final Size size;

  final Function disCardPress;
  final Function editPress;
  final Function donePress;
  final Widget itemName;
  final Widget itemQuantity;
  final Widget itemNote;
  final Color cardColor;
  final bool boughtVisible;
  @override
  _CardItemState createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          visible = !visible;
        });
      },
      child: Stack(
        children: [
          Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: widget.size.width * 0.05,
                    vertical: widget.size.height * 0.02),
                decoration: BoxDecoration(
                    color: widget.cardColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        widget.itemName,
                        widget.itemQuantity,
                      ],
                    ),
                    SizedBox(height: 30),
                    Visibility(
                      replacement: Row(
                        children: <Widget>[
                          Transform.rotate(
                            angle: pi / -10.0,
                            child: Icon(
                              CupertinoIcons.down_arrow,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Read note',
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      ),
                      visible: visible,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: widget.itemNote,
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: visible,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ItemActionButtion(
                      size: widget.size,
                      icon: CupertinoIcons.clear_circled_solid,
                      label: 'Discard',
                      iconColor: Colors.red,
                      onPress: widget.disCardPress,
                    ),
                    ItemActionButtion(
                      size: widget.size,
                      icon: Icons.edit,
                      label: 'Edit',
                      iconColor: Colors.white,
                      onPress: widget.editPress,
                    ),
                    ItemActionButtion(
                      size: widget.size,
                      icon: Icons.done,
                      label: 'Bought',
                      iconColor: Colors.green,
                      onPress: widget.donePress,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Visibility(
            visible: widget.boughtVisible,
            child: Positioned(
              top: widget.size.height * 0.069,
              right: widget.size.width * 0.16,
              child: FractionalTranslation(
                translation: Offset(0, 0),
                child: Transform.rotate(
                  angle: pi / 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: widget.size.height * 0.005,
                        horizontal: widget.size.width * 0.04),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      'Bought !',
                      style: kItemNote,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
