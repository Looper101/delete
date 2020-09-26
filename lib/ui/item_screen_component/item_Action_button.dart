import 'package:flutter/material.dart';

class ItemActionButtion extends StatelessWidget {
  const ItemActionButtion({
    this.size,
    this.icon,
    this.label,
    this.iconColor,
    this.onPress,
  });

  final Size size;
  final IconData icon;
  final String label;
  final Color iconColor;
  final Function onPress;
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPress,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      color: Colors.black,
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(icon, color: iconColor),
          SizedBox(width: size.width * 0.025),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
