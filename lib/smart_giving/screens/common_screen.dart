import 'dart:developer';

import 'package:clone/smart_giving/screens/auth_screen.dart';
import 'package:clone/smart_giving/utlis/common/appbar.dart';
import 'package:clone/smart_giving/utlis/common/prfoile_container.dart';
import 'package:clone/smart_giving/utlis/common/spacers.dart';
import 'package:clone/smart_giving/utlis/navigator/router.dart';
import 'package:flutter/material.dart';

class CommonScreen extends StatefulWidget {
  const CommonScreen({super.key});

  @override
  State<CommonScreen> createState() => _CommonScreenState();
}

class _CommonScreenState extends State<CommonScreen> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    final double screenWidth = screenSize.width;

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: buildAppBar(),
      body: Column(
        children: [
          vSpace36,
          vSpace36,
          //Admin
          ProfileAvatar(
            name: 'ADMIN',
            imagePath: 'assets/adminface.jpg',
            onTap: () {
              log("ADMIN");
              MyRouter.push(
                  screen: AuthScreen(
                role: 'ADMIN',
              ));
            },
          ),
          vSpace8,
          // user
          ProfileAvatar(
            name: 'USER',
            imagePath: 'assets/studnet.jpg',
            onTap: () {
              log("USER");
              MyRouter.push(
                  screen: AuthScreen(
                role: 'USER',
              ));
            },
          ),
          vSpace8,

          //donor
          ProfileAvatar(
            name: 'DONOR',
            imagePath: 'assets/heping.jpg',
            onTap: () {
              log("DONOR");
              MyRouter.push(
                  screen: AuthScreen(
                role: 'DONOR',
              ));
            },
          ),
          Expanded(
            flex: 2,
            child: Image.asset(
              "assets/handimages.png",
              width: screenWidth,
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }
}
