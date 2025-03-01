import 'package:clone/smart_giving/screens/custom_appbar.dart';
import 'package:clone/smart_giving/screens/expantile.dart';
import 'package:clone/smart_giving/utlis/common/images.dart';
import 'package:clone/smart_giving/utlis/common/loading_screen.dart';
import 'package:clone/smart_giving/utlis/common/spacers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DonorDetails extends StatefulWidget {
  const DonorDetails({super.key});

  @override
  State<DonorDetails> createState() => _DonorDetailsState();
}

class _DonorDetailsState extends State<DonorDetails> {
  List<Map<String, dynamic>> donors = [];

  @override
  void initState() {
    super.initState();
    fetchDonors();
  }

  Future<void> fetchDonors() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance
            .collection("users")
            .where("userType", isEqualTo: "DONOR")
            .get();

    setState(() {
      donors =
          snapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Smart Giving App', image: adminImage),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              "Check Donor Detail's",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            vSpace36,

            // Display donors
            Expanded(
              child:
                  donors.isEmpty
                      ? LoadingScreen()
                      : ListView.builder(
                        itemCount: donors.length,
                        itemBuilder: (context, index) {
                          final donor = donors[index];
                          return DonorTile(
                            donorImage: donorImage,
                            profileName: donor['name'] ?? "Unknown",
                            donorId: donor['donorId'] ?? "D000",
                            donorDetails:
                                "${donor['name']} has been a donor since 2020, contributing to multiple charities",

                            onViewDetails: () {
                              // Navigate to a detailed screen if needed
                            },
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
