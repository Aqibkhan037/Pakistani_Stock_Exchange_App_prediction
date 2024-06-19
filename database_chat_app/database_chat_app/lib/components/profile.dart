import 'package:database_chat_app/components/myStyle.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  final String username;
  final String email;
  final String currentBalance;
  final String totalInvestent;

  const Profile({
    required this.username,
    required this.email,
    required this.currentBalance,
    required this.totalInvestent,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.symmetric(horizontal: 35.0),
      padding: EdgeInsets.only(top: 170),
      width: double.infinity,
      height: 400,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(80.0),
        ),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 20.0,
            backgroundColor: Colors.blue,
            child: Icon(
              Icons.person,
              size: 20.0,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            username,
            style: heading4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.email,
                size: 16.0,
                color: Colors.grey,
              ),
              Text(
                email,
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    currentBalance,
                    style: countText,
                  ),
                  Text(
                    'Current Balance',
                    style: followText,
                  )
                ],
              ),
              SizedBox(
                width: 24.0,
              ),
              Column(
                children: [
                  Text(
                    totalInvestent,
                    style: countText,
                  ),
                  Text(
                    'Total Investment',
                    style: followText,
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
