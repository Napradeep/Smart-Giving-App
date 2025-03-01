import 'package:clone/smart_giving/screens/custom_appbar.dart';
import 'package:clone/smart_giving/screens/toggle.dart';
import 'package:clone/smart_giving/utlis/common/images.dart';
import 'package:clone/smart_giving/utlis/common/spacers.dart';
import 'package:flutter/material.dart';

class ViewPanelDeatils extends StatefulWidget {
  const ViewPanelDeatils({super.key});

  @override
  State<ViewPanelDeatils> createState() => _ViewPanelDeatilsState();
}

class _ViewPanelDeatilsState extends State<ViewPanelDeatils> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Smart Giving App", image: adminImage),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "My Activity Overview",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            vSpace36,

            Center(child: ApprovalToggle()),
          ],
        ),
      ),
    );
  }
}
