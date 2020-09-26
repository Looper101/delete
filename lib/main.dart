import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:note_keeper_001/components/app_bar.dart';
import 'package:note_keeper_001/constants/constants.dart';
import 'package:note_keeper_001/constants/constants.dart';

import 'package:note_keeper_001/models/shopping_list.dart';
import 'package:note_keeper_001/ui/items_screen.dart';
import 'package:note_keeper_001/ui/shopping_list_dialog.dart';

import './utils/dbhelper.dart';
import 'constants/constants.dart';
import 'constants/constants.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:firebase_admob/firebase_admob.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.indigo,
            cursorColor: Colors.teal.shade600,
            textSelectionHandleColor: Colors.teal.shade500),
        home: ShList());
  }
}

class ShList extends StatefulWidget {
  @override
  _ShListState createState() => _ShListState();
}

class _ShListState extends State<ShList> {
//   MobileAdTargetingInfo targetingInfo;
//   BannerAd myBanner;
  DbHelper helper = DbHelper();
  List<ShoppingList> shoppingList = [];
  var colorResult;

  ShoppingListAlertDialog shoppingListDialog;

  @override
  void initState() {
    super.initState();

    // targetingInfo = MobileAdTargetingInfo(
    //   keywords: <String>['flutterio', 'beautiful apps'],
    //   contentUrl: 'https://flutter.io',
    //   // birthday: DateTime.now(),
    //   childDirected: false,
    //   // designedForFamilies: false,

    //   // gender: MobileAdGender
    //   //     .male, // or MobileAdGender.female, MobileAdGender.unknown
    //   testDevices: <String>[], // Android emulators are considered test devices
    // );

    // myBanner = BannerAd(
    //   // Replace the testAdUnitId with an ad unit id from the AdMob dash.
    //   // https://developers.google.com/admob/android/test-ads
    //   // https://developers.google.com/admob/ios/test-ads
    //   adUnitId: BannerAd.testAdUnitId,
    //   size: AdSize.smartBanner,
    //   targetingInfo: targetingInfo,
    //   listener: (MobileAdEvent event) {
    //     print("BannerAd event is $event");
    //   },
    // );

    shoppingListDialog = ShoppingListAlertDialog();
    broadCastDb();
  }

  Future broadCastDb() async {
    await helper.openDb();
    var result = await helper.getLists();

    setState(() {
      shoppingList = result;
    });
  }

  List<Color> cardColor = [
    Color(0XFFCC0202),
    Color(0XFFFDA381),
    Color(0xFF86ABB0),
    Color(0xFFF56237)
  ];

  // showBanner() {
  //   myBanner
  //     // typically this happens well before the ad is shown
  //     ..load()
  //     ..show(
  //       // Positions the banner ad 60 pixels from the bottom of the screen
  //       anchorOffset: 0.0,
  //       // Positions the banner ad 10 pixels from the center of the screen to the right

  //       // Banner Position
  //       anchorType: AnchorType.bottom,
  //     );
  // }

  // var counter = '';
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final height = MediaQuery.of(context).size.height;

    broadCastDb();
    helper.openDb();
    // showBanner();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: BuildDrawer(helper: helper, size: size),
      backgroundColor: Color(0xD5FFFFFF),
      body: SafeArea(
        child: shoppingList.length == 0
            ? Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Expanded(
                        child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: size.width * 0.015,
                                vertical: size.height * 0.005),
                            padding: EdgeInsets.all(size.aspectRatio * 15),
                            child: CustomAppBar(
                              size: size,
                              list: shoppingList,
                              onPress: () {
                                _scaffoldKey.currentState.openDrawer();
                              },
                            ))),
                    Expanded(
                      flex: 7,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: EdgeInsets.only(
                                top: size.height * 0.2,
                                right: size.width * 0.045,
                                left: size.width * 0.045,
                              ),
                              // height: size.height * 0.45,
                              // width: size.width * 0.02,
                              child: Image(
                                image: AssetImage('images/cart_item.png'),
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  vertical: size.height * 0.05),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    'Your List is empty',
                                    style: kItemNote.copyWith(
                                        fontFamily: 'openSansM',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepOrange),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    'Create list and add them to your trolley',
                                    style: kItemNote.copyWith(color: kSeaBlue),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(2),
                    topRight: Radius.circular(2),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: size.width * 0.015,
                            vertical: size.height * 0.005),
                        padding: EdgeInsets.all(size.aspectRatio * 15),
                        child: CustomAppBar(
                          size: size,
                          list: shoppingList,
                          onPress: () {},
                        ),
                      ),
                    ),
                    // Expanded(
                    //   flex: 7,
                    //  hild: Container(
                    //     child: ListView.builder(
                    //       itemCount: shoppingList.length == null
                    //           ? 0
                    //           : shoppingList.length,
                    //       itemBuilder: (BuildContext context, index) {
                    //         return Dismissible(
                    //           background: Container(
                    //             color: Colors.red,
                    //           ),
                    //           onDismissed: (direction) {
                    //             helper.deleteList(shoppingList[index]);

                    //             setState(() {
                    //               shoppingList.removeAt(index);
                    //             });
                    //             Scaffold.of(context).showSnackBar(
                    //               SnackBar(
                    //                 content: Text(
                    //                   'Category deleted',
                    //                   style: TextStyle(
                    //                       color: Colors.black,
                    //                       fontWeight: FontWeight.bold),
                    //                 ),
                    //                 backgroundColor: Colors.teal.shade500,
                    //               ),
                    //             );
                    //           },
                    //           key: Key(shoppingList[index].name),
                    //           child: Container(
                    //             padding: EdgeInsets.symmetric(vertical: 20),
                    //             margin: EdgeInsets.symmetric(
                    //                 vertical: size.height * 0.01,
                    //                 horizontal: size.width * 0.02),
                    //             decoration: BoxDecoration(
                    //               color: Colors.teal.shade400,
                    //               borderRadius: BorderRadius.circular(10),
                    //             ),
                    //             child: ListTile(
                    //               leading: CircleAvatar(
                    //                 backgroundColor: getPriorityForNumber(
                    //                     shoppingList[index].priority),
                    //                 child: Text(
                    //                   shoppingList[index].priority.toString(),
                    //                 ),
                    //               ),
                    //               title: Text(
                    //                 shoppingList[index].name,
                    //                 style: TextStyle(
                    //                     fontSize: 25,
                    //                     fontWeight: FontWeight.bold),
                    //               ),
                    //               trailing: IconButton(
                    //                 tooltip: 'Edit',
                    //                 icon: Icon(Icons.edit),
                    //                 color: Colors.black,
                    //                 onPressed: () {
                    //                   showDialog(
                    //                     context: context,
                    //                     builder: (BuildContext context) =>
                    //                         ShoppingListAlertDialog(
                    //                             list: shoppingList[index],
                    //                             isNew: false),
                    //                   );
                    //                 },
                    //               ),
                    //               onTap: () {
                    //                 Navigator.push(
                    //                   context,
                    //                   MaterialPageRoute(
                    //                     builder: (context) =>
                    //                         ItemScreen(shoppingList[index]),
                    //                   ),
                    //                 );
                    //               },
                    //               onLongPress: () {
                    //                 showDialog(
                    //                   context: context,
                    //                   builder: (context) {
                    //                     return ShoppingListAlertDialog(
                    //                         list: shoppingList[index],
                    //                         isNew: false);
                    //                   },
                    //                 );
                    //               },
                    //             ),
                    //           ),
                    //         );
                    //       },
                    //     ),
                    //   ),
                    // ),

                    Expanded(
                      flex: 7,
                      child: ListView.builder(
                        itemCount: shoppingList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Dismissible(
                            key: Key(shoppingList[index].name),
                            onDismissed: (direction) {
                              try {
                                helper.deleteList(shoppingList[index]);

                                setState(() {
                                  shoppingList.removeAt(index);
                                });

                                Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    duration: Duration(milliseconds: 100),
                                    content: Text(
                                      'Category deleted',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    backgroundColor: Colors.black,
                                  ),
                                );
                              } catch (e) {}
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: size.height * 0.002),
                              child: Stack(
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ItemScreen(shoppingList[index]),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: shuffleColorById(
                                            shoppingList[index].id),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      margin: EdgeInsets.symmetric(
                                        horizontal: size.width * 0.03,
                                        vertical: size.height * 0.009,
                                        // left: size.width * 0.04,
                                        // right: size.width * 0.04,
                                        // top: size.height * 0.03,
                                      ),
                                      padding: EdgeInsets.only(
                                          left: size.width * 0.03,
                                          right: size.width * 0.03),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          top: height * 0.03,
                                          bottom: height * 0.03,
                                          left: size.width * 0.002,
                                          right: size.width * 0.002,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              textBaseline:
                                                  TextBaseline.alphabetic,
                                              children: <Widget>[
                                                AutoSizeText(
                                                  shoppingList[index].name,
                                                  maxLines: 2,
                                                  maxFontSize: 20,
                                                  minFontSize: 19,
                                                  style:
                                                      kNameTextStyle.copyWith(
                                                          fontSize: 30,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                ),
                                                SizedBox(
                                                  height: size.height * 0.02,
                                                ),
                                                Container(
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 10),
                                                  child: priorityChecker(
                                                    size.width * 0.04,
                                                    size.height * 0.015,
                                                    shoppingList[index]
                                                        .priority,
                                                    index,
                                                    shuffleColorById(
                                                        shoppingList[index].id),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    child: FractionalTranslation(
                                      translation: Offset(
                                        size.width * 0.02135,
                                        1.342,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ItemScreen(
                                                shoppingList[index],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: shuffleColorById(
                                                  shoppingList[index].id),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              boxShadow: [
                                                BoxShadow(
                                                  offset: Offset(0.2, 1.5),
                                                  blurRadius: 10,
                                                  spreadRadius: 0.03,
                                                  color: shuffleColorForShadow(
                                                      shoppingList[index].id),
                                                )
                                              ]),
                                          child: CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            foregroundColor: Colors.white,
                                            child:
                                                Icon(Icons.arrow_forward_ios),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        elevation: 0,
        backgroundColor: Colors.orange.shade900,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        tooltip: 'add List',
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return ShoppingListAlertDialog(
                  list: ShoppingList(0, '', 0), isNew: true);
            },
          );
        },
      ),
    );
  }

  Color getPriorityForCard(int priority) {
    switch (priority) {
      case 1:
        return Colors.black87;
        break;
      case 2:
        return Colors.black54;
      case 3:
        return Colors.black54;
      default:
        return Colors.grey;
    }
  }

//TODO: fix the method below, to return cshowolored container based on the piority selected

  Widget getWidgetFromPriority(int priority, double height, double width) {
    const trialColorBlack = Colors.black;
    const trialColorGrey = Colors.grey;
    switch (priority) {
      case 3:
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(2),
              height: height,
              width: width,
              decoration:
                  BoxDecoration(color: trialColorBlack, shape: BoxShape.circle),
            ),
            Container(
              margin: EdgeInsets.all(2),
              height: height,
              width: width,
              decoration:
                  BoxDecoration(color: trialColorGrey, shape: BoxShape.circle),
            ),
            Container(
              margin: EdgeInsets.all(2),
              height: height,
              width: width,
              decoration:
                  BoxDecoration(color: trialColorGrey, shape: BoxShape.circle),
            ),
          ],
        );
        break;
      case 2:
        return Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(2),
              height: height,
              width: width,
              decoration:
                  BoxDecoration(color: trialColorBlack, shape: BoxShape.circle),
            ),
            Container(
              margin: EdgeInsets.all(2),
              height: height,
              width: width,
              decoration:
                  BoxDecoration(color: trialColorBlack, shape: BoxShape.circle),
            ),
            Container(
              margin: EdgeInsets.all(2),
              height: height,
              width: width,
              decoration:
                  BoxDecoration(color: trialColorGrey, shape: BoxShape.circle),
            ),
          ],
        );
        break;
      case 1:
        return Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(2),
              height: height,
              width: width,
              decoration:
                  BoxDecoration(color: trialColorBlack, shape: BoxShape.circle),
            ),
            Container(
              margin: EdgeInsets.all(2),
              height: height,
              width: width,
              decoration:
                  BoxDecoration(color: trialColorBlack, shape: BoxShape.circle),
            ),
            Container(
              margin: EdgeInsets.all(2),
              height: height,
              width: width,
              decoration:
                  BoxDecoration(color: trialColorBlack, shape: BoxShape.circle),
            ),
          ],
        );
        break;
      default:
        return Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(2),
              height: height,
              width: width,
              decoration:
                  BoxDecoration(color: trialColorBlack, shape: BoxShape.circle),
            ),
            Container(
              margin: EdgeInsets.all(2),
              height: height,
              width: width,
              decoration:
                  BoxDecoration(color: trialColorBlack, shape: BoxShape.circle),
            ),
            Container(
              margin: EdgeInsets.all(2),
              height: height,
              width: width,
              decoration:
                  BoxDecoration(color: trialColorBlack, shape: BoxShape.circle),
            ),
          ],
        );
        break;
    }
  }

  shuffleColorById(int id) {
    if (id.isEven) {
      return Color(0xF5000000);
    } else if (id.isOdd) {
      return Color(0xFF085477);
    }
  }

  shuffleColorForShadow(int id) {
    if (id.isEven) {
      return Color(0x112B2EC7);
    } else if (id.isOdd) {
      return Color(0x0A756F77);
    }
  }

  Color getPriorityForNumber(int priority) {
    switch (priority) {
      case 1:
        return Colors.black.withRed(100);
        break;
      case 2:
        return Colors.black;
      case 3:
        return Colors.indigo.withRed(10);
      default:
        return Colors.black;
    }
  }
}

priorityChecker(double width, double height, int priority, int index,
    var cuurentColorIndex) {
  const trialColorGrey = Colors.blue;
  if (index.isOdd) {
    if (priority == 3) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(2),
            height: height,
            width: width,
            decoration:
                BoxDecoration(color: trialColorGrey, shape: BoxShape.circle),
          ),
          // Container(
          //   margin: EdgeInsets.all(2),
          //   height: height,
          //   width: width,
          //   decoration:
          //       BoxDecoration(color: trialColorGrey, shape: BoxShape.circle),
          // ),
          // Container(
          //   margin: EdgeInsets.all(2),
          //   height: height,
          //   width: width,
          //   decoration:
          //       BoxDecoration(color: trialColorGrey, shape: BoxShape.circle),
          // ),
        ],
      );
    } else if (priority == 2) {
      return Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(2),
            height: height,
            width: width,
            decoration:
                BoxDecoration(color: trialColorGrey, shape: BoxShape.circle),
          ),
          Container(
            margin: EdgeInsets.all(2),
            height: height,
            width: width,
            decoration:
                BoxDecoration(color: trialColorGrey, shape: BoxShape.circle),
          ),
          // Container(
          //   margin: EdgeInsets.all(2),
          //   height: height,
          //   width: width,
          //   decoration:
          //       BoxDecoration(color: trialColorGrey, shape: BoxShape.circle),
          // ),
        ],
      );
    } else if (priority == 1) {
      return Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(2),
            height: height,
            width: width,
            decoration:
                BoxDecoration(color: trialColorGrey, shape: BoxShape.circle),
          ),
          Container(
            margin: EdgeInsets.all(2),
            height: height,
            width: width,
            decoration:
                BoxDecoration(color: trialColorGrey, shape: BoxShape.circle),
          ),
          Container(
            margin: EdgeInsets.all(2),
            height: height,
            width: width,
            decoration:
                BoxDecoration(color: trialColorGrey, shape: BoxShape.circle),
          ),
        ],
      );
    } else {
      return Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(2),
            height: height,
            width: width,
            decoration:
                BoxDecoration(color: cuurentColorIndex, shape: BoxShape.circle),
          ),
          Container(
            margin: EdgeInsets.all(2),
            height: height,
            width: width,
            decoration:
                BoxDecoration(color: cuurentColorIndex, shape: BoxShape.circle),
          ),
          Container(
            margin: EdgeInsets.all(2),
            height: height,
            width: width,
            decoration:
                BoxDecoration(color: cuurentColorIndex, shape: BoxShape.circle),
          ),
        ],
      );
    }
  } else if (index.isEven) {
    if (priority == 3) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(2),
            height: height,
            width: width,
            decoration: BoxDecoration(color: kRedish, shape: BoxShape.circle),
          ),
          // Container(
          //   margin: EdgeInsets.all(2),
          //   height: height,
          //   width: width,
          //   decoration:
          //       BoxDecoration(color: trialColorGrey, shape: BoxShape.circle),
          // ),
          // Container(
          //   margin: EdgeInsets.all(2),
          //   height: height,
          //   width: width,
          //   decoration:
          //       BoxDecoration(color: trialColorGrey, shape: BoxShape.circle),
          // ),
        ],
      );
    } else if (priority == 2) {
      return Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(2),
            height: height,
            width: width,
            decoration: BoxDecoration(color: kRedish, shape: BoxShape.circle),
          ),
          Container(
            margin: EdgeInsets.all(2),
            height: height,
            width: width,
            decoration: BoxDecoration(color: kRedish, shape: BoxShape.circle),
          ),
          // Container(
          //   margin: EdgeInsets.all(2),
          //   height: height,
          //   width: width,
          //   decoration:
          //       BoxDecoration(color: trialColorGrey, shape: BoxShape.circle),
          // ),
        ],
      );
    } else if (priority == 1) {
      return Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(2),
            height: height,
            width: width,
            decoration: BoxDecoration(color: kRedish, shape: BoxShape.circle),
          ),
          Container(
            margin: EdgeInsets.all(2),
            height: height,
            width: width,
            decoration: BoxDecoration(color: kRedish, shape: BoxShape.circle),
          ),
          Container(
            margin: EdgeInsets.all(2),
            height: height,
            width: width,
            decoration: BoxDecoration(color: kRedish, shape: BoxShape.circle),
          ),
        ],
      );
    } else {
      return Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(2),
            height: height,
            width: width,
            decoration:
                BoxDecoration(color: cuurentColorIndex, shape: BoxShape.circle),
          ),
          Container(
            margin: EdgeInsets.all(2),
            height: height,
            width: width,
            decoration:
                BoxDecoration(color: cuurentColorIndex, shape: BoxShape.circle),
          ),
          Container(
            margin: EdgeInsets.all(2),
            height: height,
            width: width,
            decoration:
                BoxDecoration(color: cuurentColorIndex, shape: BoxShape.circle),
          ),
        ],
      );
    }
  }
}

class BuildDrawer extends StatefulWidget {
  const BuildDrawer({
    Key key,
    @required this.helper,
    @required this.size,
  }) : super(key: key);

  final DbHelper helper;
  final Size size;

  @override
  _BuildDrawerState createState() => _BuildDrawerState();
}

class _BuildDrawerState extends State<BuildDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ListTile(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          var size = MediaQuery.of(context).size;
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            title: Text('Developer Details'),
                            backgroundColor: kButtonColor.withOpacity(0.9),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              textBaseline: TextBaseline.alphabetic,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Opeyemi Noah',
                                    style: TextStyle(fontSize: 25),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    FlatButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      color: Colors.black,
                                      onPressed: () {
                                        launch('https://www.google.com',
                                            forceWebView: false);
                                      },
                                      child: Text(
                                        'E-mail',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    FlatButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      color: Colors.black,
                                      onPressed: () {
                                        launch('https://www.instagram.com',
                                            forceWebView: false);
                                      },
                                      child: Text(
                                        'Instagram',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                    leading: Icon(
                      Icons.contact_phone,
                      size: 27,
                    ),
                    title: Text(
                      'Developer Contact',
                      style: TextStyle(fontSize: 21),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
