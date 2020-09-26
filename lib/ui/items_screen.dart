import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_keeper_001/constants/constants.dart';
import 'package:note_keeper_001/models/list_item.dart';
import 'package:note_keeper_001/ui/item_screen_component/title_edit_dialog.dart';
import 'package:note_keeper_001/ui/list_item_dialog.dart';
import 'package:note_keeper_001/utils/dbhelper.dart';

import '../models/shopping_list.dart';
import 'item_screen_component/item_card.dart';

class ItemScreen extends StatefulWidget {
  ItemScreen(this.shoppingList);

  final ShoppingList shoppingList;

  @override
  _ItemScreenState createState() => _ItemScreenState(this.shoppingList);
}

class _ItemScreenState extends State<ItemScreen> with TickerProviderStateMixin {
  DbHelper helper;

  List<ListItem> items = [];
  int xresult;

  final ShoppingList shoppingList;
  _ItemScreenState(this.shoppingList);

  Future showData(int idList) async {
    await helper.openDb();
    items = await helper.getItems(idList);

    try {
      setState(() {
        items = items;
        xresult = items.length;
      });
    } catch (e) {}
  }

  bool doneBuying = false;
  ListItem listItem;

  @override
  void dispose() {
    super.dispose();
  }

  getColorForCard(int value) {
    if (value.isOdd) {
      return kButtonColor;
    } else if (value.isEven) {
      return kSeaBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    helper = DbHelper();
    helper.openDb();
    showData(this.shoppingList.id);

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: items.length == 0
            ? EmptyItem(
                size: size,
                shoppingList: shoppingList,
                widget: widget,
                data: items.length,
                style: kItemNameTextStyle.copyWith(
                    fontSize: shoppingList.name.length > 10 ? 20 : 25,
                    color: Colors.black),
                editOnpress: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return ItemTitleDialog(widget.shoppingList);
                    },
                  );
                },
                onPress: () {
                  Navigator.pop(context, xresult);
                },
                visible: false)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: size.width * 0.01),
                      padding: EdgeInsets.all(size.aspectRatio * 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          CustomItemAppBar(
                            list: shoppingList.name,
                            size: size,
                            style: kItemNameTextStyle.copyWith(
                                fontSize:
                                    shoppingList.name.length > 10 ? 20 : 25,
                                color: Colors.black),
                            onPress: () {
                              Navigator.pop(context, xresult);
                            },
                            editOnpress: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return ItemTitleDialog(widget.shoppingList);
                                },
                              );
                            },
                          ),
                          Container(
                            margin: EdgeInsets.only(right: size.width * 0.02),
                            child: DeletAll(
                              size: size,
                              shoppingList: widget.shoppingList,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: ListView.builder(
                      itemCount: items.length != null ? items.length : 0,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: Key(items[index].name),
                          onDismissed: (direction) {
                            helper.deleteItem(items[index]);
                            setState(() {
                              items.removeAt(index);
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: size.width * 0.035,
                              vertical: size.height * 0.02,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(110),
                            ),
                            child: CardItem(
                              cardColor: items[index].doneDoneBuying
                                  ? Color(0xFFB5C5A3)
                                  : Color(0xFF085477),
                              itemName: Text(
                                items[index].name,
                                style: kItemNameTextStyle.copyWith(
                                    fontSize: 20, fontWeight: FontWeight.w700),
                              ),
                              itemNote: Text(
                                  items[index].note.length <= 0
                                      ? 'Empty note !'
                                      : "Note: ${items[index].note}",
                                  style: items[index].note.length <= 0
                                      ? TextStyle(color: Colors.white)
                                      : kItemNote.copyWith(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w300)),
                              itemQuantity: Text(
                                items[index].quantity,
                                style: kItemQuantityTextStyle.copyWith(
                                    fontSize: 21, fontWeight: FontWeight.w300),
                              ),
                              size: size,
                              boughtVisible: items[index].doneDoneBuying,
                              editPress: () {
//show dialog

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ItemDialog(items[index], false);
                                  },
                                );
                              },
                              donePress: () {
                                setState(
                                  () {
                                    doneBuying = !doneBuying;

                                    items[index].isDone =
                                        decisionHelper(doneBuying);
                                    helper.insertItem(items[index]);
                                  },
                                );
                              },
                              disCardPress: () {
                                helper.deleteItem(items[index]);
                                setState(() {
                                  items.removeAt(index);
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),                                                                    
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.black,
        tooltip: 'Add Item',
        label: Row(
          children: <Widget>[
            Icon(
              Icons.add,
              color: Colors.white,
            ),
            SizedBox(width: size.width * 0.01),
            Text('Item'),
          ],
        ),
        onPressed: () async {
          showDialog(
            context: context,
            builder: (context) {
              return ItemDialog(
                  ListItem(
                    0,
                    widget.shoppingList.id,
                    '',
                    '',
                    '',
                    decisionHelper(doneBuying),
                  ),
                  true);
            },
          );
        },
      ),
    );
  }

  ListTile gonnapuffyou(int index, Size size, BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
          backgroundColor: Colors.teal,
          child: Text(
            items[index].id.toString(),
          )),
      title: Text(
        items[index].name,
        style: TextStyle(
            fontSize: 25,
            color: Colors.white,
            decoration: items[index].doneDoneBuying == true
                ? TextDecoration.lineThrough
                : TextDecoration.none),
      ),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
            child: RichText(
              text: TextSpan(
                text: '',
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: 'Quantity :',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.teal,
                    ),
                  ),
                  TextSpan(
                    text: ' ${items[index].quantity}',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        decoration: items[index].doneDoneBuying == true
                            ? TextDecoration.lineThrough
                            : TextDecoration.none),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            height: size.height * 0.01,
            color: Colors.white,
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: size.height * 0.002),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    text: '',
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Note',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.teal),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: size.height * 0.01,
                  color: Colors.white,
                  endIndent: size.width * 0.5,
                ),
                SizedBox(height: size.height * 0.01),
                Text(
                  '${items[index].note}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      decoration: items[index].doneDoneBuying == true
                          ? TextDecoration.lineThrough
                          : TextDecoration.none),
                ),
              ],
            ),
          ),
        ],
      ),
      trailing: IconButton(
        alignment: Alignment.center,
        icon: Icon(
          Icons.edit,
          color: Colors.white,
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ItemDialog(items[index], false);
            },
          );
        },
      ),
    );
  }

  bool selector;

  String decisionHelper(bool value) {
    String output;
    switch (value) {
      case true:
        output = 'true';
        break;
      case false:
        output = 'false';
        break;
    }
    return output;
  }

  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.teal;
        break;
      case 2:
        return Colors.amber;
      case 3:
        return Colors.teal;
      default:
        return Colors.teal;
    }
  }

  stringLength(String value) {
    var finalLength;

    if (value.length >= 10) {
      finalLength = (value.length / 2).round();
    } else if (value.length >= 20) {
      finalLength = (value.length / 3).round();
    } else if (value.length >= 30) {
      finalLength = (value.length / 5).round();
    }
    return finalLength;
  }
}

class EmptyItem extends StatelessWidget {
  const EmptyItem(
      {Key key,
      @required this.size,
      @required this.shoppingList,
      @required this.widget,
      this.data,
      this.visible,
      this.onPress,
      this.editOnpress,
      this.style})
      : super(key: key);

  final Size size;
  final ShoppingList shoppingList;
  final ItemScreen widget;
  final bool visible;
  final int data;
  final Function onPress;
  final Function editOnpress;
  final TextStyle style;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            margin: EdgeInsets.only(right: size.width * 0.01),
            padding: EdgeInsets.all(size.aspectRatio * 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CustomItemAppBar(
                  list: shoppingList.name,
                  size: size,
                  onPress: onPress,
                  style: style,
                  editOnpress: editOnpress,
                ),
                Visibility(
                  visible: visible,
                  child: DeletAll(
                    size: size,
                    shoppingList: widget.shoppingList,
                  ),
                )
              ],
            ),
          ),
        ),
        Expanded(
          flex: 7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.only(
                    top: size.height * 0.2,
                    right: size.width * 0.045,
                    left: size.width * 0.045,
                  ),
                  // height: size.height * 0.45,
                  // width: size.width * 0.02,
                  child: Image(
                    height: size.height * 0.45,
                    width: size.width * 0.02,
                    image: AssetImage('images/cart_item.png'),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.05),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Item List is empty',
                        style: kItemNote.copyWith(
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Add item to your trolley',
                        style: kItemNote.copyWith(color: Colors.blueGrey),
                      )
                    ],
                  ),
                ),
              ),
              // Expanded(
              //   child: Container(
              //     margin: EdgeInsets.symmetric(
              //         vertical: 10, horizontal: size.width * 0.1),
              //     child: FlatButton(
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(20),
              //       ),
              //       color: Colors.deepOrangeAccent,
              //       onPressed: () {},
              //       child: Text(
              //         'Add List',
              //         style: TextStyle(
              //             color: Colors.white, fontSize: 25),
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ],
    );
  }
}

class DeletAll extends StatefulWidget {
  DeletAll({this.size, this.shoppingList}) : assert(size != null);
  final Size size;
  final ShoppingList shoppingList;

  @override
  _DeletAllState createState() => _DeletAllState();
}

class _DeletAllState extends State<DeletAll> {
  DbHelper helper = DbHelper();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: kSeaBlue,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: Text(
                'Do you want to delete all records ?',
                style: kItemNote.copyWith(
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.info,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: Text(
                        'You can always swipe to delete an item',
                        style: kItemNote.copyWith(
                            color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ],
              content: SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    RaisedButton(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      color: Colors.black,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'No',
                        style: kItemNote.copyWith(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    RaisedButton(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      color: kRedish,
                      onPressed: () {
                        helper.deleteAllItem(this.widget.shoppingList.id);
                        setState(() {});
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Yes',
                        style: kItemNote.copyWith(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Icon(Icons.settings_backup_restore, color: Colors.black),
    );
  }
}

class CustomItemAppBar extends StatelessWidget {
  const CustomItemAppBar({
    Key key,
    @required this.size,
    @required this.list,
    this.style,
    this.onPress,
    this.editOnpress,
  }) : super(key: key);

  final Size size;
  final String list;
  final Function onPress;
  final TextStyle style;
  final Function editOnpress;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      textBaseline: TextBaseline.alphabetic,
      children: <Widget>[
        IconButton(icon: Icon(CupertinoIcons.back), onPressed: onPress),
        SizedBox(
          width: size.width * 0.01,
        ),
        Text(
          list,
          style: style,
        ),
        SizedBox(
          width: size.width * 0.04,
        ),
        FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(50),
              bottom: Radius.circular(50),
            ),
          ),
          onPressed: editOnpress,
          child: Icon(Icons.mode_edit),
        ),
      ],
    );
  }
}

//Previous item Card load it to LitView.builder and it will work viola!!

// Dismissible(
//                           key: Key(items[index].name),
//                           onDismissed: (direction) {
//                             String strName = items[index].name;
//                             helper.deleteItem(items[index]);
//                             setState(() {
//                               items.removeAt(index);
//                             });
//                           },
//                           background: Container(
//                             color: kSeaBlue.withRed(250),
//                           ),
//                           child: GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   doneBuying = !doneBuying;

//                                   items[index].isDone =
//                                       decisionHelper(doneBuying);
//                                   helper.insertItem(items[index]);
//                                 });
//                               },
//                               child: Stack(
//                                 children: <Widget>[
//                                   Container(
//                                     margin: EdgeInsets.only(
//                                       right: size.width * 0.05,
//                                       left: size.width * 0.05,
//                                       top: size.height * 0.025,
//                                     ),
//                                     decoration: BoxDecoration(
//                                         color: items[index].doneDoneBuying
//                                             ? kSeaBlue.withOpacity(0.6)
//                                             : kButtonColor,
//                                         borderRadius: BorderRadius.circular(7)),
//                                     padding:
//                                         EdgeInsets.all(size.aspectRatio * 15),
//                                     // padding:
//                                     //     EdgeInsets.all(size.aspectRatio * 15),
//                                     child: Row(
//                                       children: <Widget>[
//                                         Expanded(
//                                             child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           textBaseline: TextBaseline.alphabetic,
//                                           children: <Widget>[
//                                             Text(
//                                               items[index].name,
//                                               style: TextStyle(
//                                                   color: Colors.white,
//                                                   fontFamily: 'ProductSansL',
//                                                   fontSize: 20,
//                                                   decoration: items[index]
//                                                               .doneDoneBuying ==
//                                                           true
//                                                       ? TextDecoration
//                                                           .lineThrough
//                                                       : TextDecoration.none),
//                                             ),
//                                             SizedBox(
//                                                 height: size.height * 0.01),
//                                             Text(items[index].quantity,
//                                                 style: TextStyle(
//                                                     color: Colors.white54,
//                                                     // fontFamily: 'ProductSansM',
//                                                     fontSize: 20,
//                                                     decoration: items[index]
//                                                                 .doneDoneBuying ==
//                                                             true
//                                                         ? TextDecoration
//                                                             .lineThrough
//                                                         : TextDecoration.none)),
//                                             Divider(
//                                               color: Colors.grey.shade500,
//                                             ),
//                                             SizedBox(
//                                                 height: size.height * 0.01),
//                                             Text(
//                                               items[index].note,
//                                               style: TextStyle(
//                                                   color: Colors.white,
//                                                   fontFamily: 'ProductSansM',
//                                                   fontSize: 20,
//                                                   decoration: items[index]
//                                                               .doneDoneBuying ==
//                                                           true
//                                                       ? TextDecoration
//                                                           .lineThrough
//                                                       : TextDecoration.none),
//                                             )
//                                           ],
//                                         )),
//                                       ],
//                                     ),
//                                   ),
//                                   Positioned(
//                                     child: FractionalTranslation(
//                                       translation: Offset(
//                                         size.width / 60,
//                                         size.height / 720,
//                                       ),
//                                       child: GestureDetector(
//                                         onTap: () {
//                                           print(
//                                             showDialog(
//                                               context: context,
//                                               builder: (BuildContext context) {
//                                                 return ItemDialog(
//                                                     items[index], false);
//                                               },
//                                             ),
//                                           );
//                                         },
//                                         child: CircleAvatar(
//                                           radius: 25,
//                                           backgroundColor: Color(0xC59B0606),
//                                           child: Text('Edit'),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               )),
//                         );
