import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key key,
    @required this.size,
    @required this.list,
    this.onPress,
  }) : super(key: key);

  final Size size;
  final List list;
  final Function onPress;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.menu),
          onPressed: onPress,
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            'Shop Rush',
            style: TextStyle(
                fontSize: 25,
                fontFamily: 'openSansM',
                fontWeight: FontWeight.w900),
          ),
        ),
        CircleAvatar(
          backgroundColor: Colors.black,
          foregroundColor: Color(0XFFCCB3D2),
          radius: 14,
          child: Text(
            list.length.toString(),
            overflow: TextOverflow.ellipsis,
            style:
                TextStyle(fontFamily: 'openSansM', fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
