

import 'dart:developer';

import 'package:clone/smart_giving/providers/auth_provider.dart';
import 'package:clone/smart_giving/providers/bussiness_provider.dart';
import 'package:clone/smart_giving/utlis/common/card.dart';
import 'package:clone/smart_giving/utlis/common/loading_screen.dart';
import 'package:clone/smart_giving/utlis/common/spacers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show Provider;

class ViewFundRequest extends StatefulWidget {
  const ViewFundRequest({super.key});

  @override
  State<ViewFundRequest> createState() => _ViewFundRequestState();
}

class _ViewFundRequestState extends State<ViewFundRequest> {
  String? userId;
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final businessProvider = Provider.of<BusinessProvider>(
        context,
        listen: false,
      );

      userId = authProvider.userData?["id"];
      if (userId != null) {
        await businessProvider.fetchBusinessRecords(userId!);
      }

      setState(() {
        isLoading = false; // Stop loading after fetching data
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final businessProvider = Provider.of<BusinessProvider>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Smart Giving App",
              style: TextStyle(
                color: Colors.green,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Welcome, ${authProvider.userData?["name"] ?? ''}",
              style: TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            vSpace18,
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "  View My Fund Request ",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            vSpace18,

            isLoading
                ? Padding(
                  padding: const EdgeInsets.only(top: 250),
                  child: LoadingScreen(),
                )
                : businessProvider.businessRecords.isEmpty
                ? const Center(
                  child: Text("No records found"),
                ) // No data found UI
                : isLoading
                ? const Padding(
                  padding: EdgeInsets.only(top: 250),
                  child: LoadingScreen(),
                )
                : businessProvider.businessRecords.isEmpty
                ? const Center(
                  child: Text("No records found"),
                ) // No data found UI
                : LayoutBuilder(
                  builder: (context, constraints) {
                    log("Parent Height: ${constraints.maxHeight}");
                    return SizedBox(
                      height: 480, // Ensure a definite height
                      child: ListView.builder(
                        itemCount: businessProvider.businessRecords.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final record =
                              businessProvider.businessRecords[index];
                          return SizedBox(
                            width: 320,
                            child: FundRequestCard(record: record),
                          );
                        },
                      ),
                    );
                  },
                ),
            // SizedBox(
            //   height: 480,
            //   child: ListView.builder(
            //     itemCount: businessProvider.businessRecords.length,
            //     scrollDirection: Axis.horizontal,
            //     itemBuilder: (context, index) {
            //       final record = businessProvider.businessRecords[index];
            //       return SizedBox(
            //         width: 320,
            //         child: FundRequestCard(record: record),
            //       );
            //     },
            //   ),
            // ),

            // : SizedBox(
            //   height: 450,
            //   child: ListView.builder(
            //     itemCount: businessProvider.businessRecords.length,
            //     scrollDirection: Axis.horizontal,
            //     itemBuilder: (context, index) {
            //       final record = businessProvider.businessRecords[index];
            //       return Expanded(child: FundRequestCard(record: record));
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
