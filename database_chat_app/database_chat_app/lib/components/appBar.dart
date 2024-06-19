import "package:database_chat_app/components/myStyle.dart";
import "package:flutter/material.dart";

class MyAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20.0),
      height: 120,
      decoration: const BoxDecoration(
        color: Color(0xfff4f5fa),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(80.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Profile',
            style: titleText,
          ),
          Container(
            padding: const EdgeInsets.only(right: 20.0),
            child: Icon(
              Icons.settings,
              color: Color.fromARGB(255, 39, 7, 66),
              size: 30.0,
            ),
          )
        ],
      ),
    ); // AppBar
  }
}
