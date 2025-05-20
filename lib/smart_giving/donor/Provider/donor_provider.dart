import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DonorProvider extends ChangeNotifier {
  List<Map<String, dynamic>> fundRecords = [];
  bool isLoading = false;
  Future<void> fetchAllBusinessRecords() async {
    isLoading = true; // Start loading
    notifyListeners();

    List<Map<String, dynamic>> allRecords = [];

    try {
      // Get all users
      QuerySnapshot usersSnapshot =
          await FirebaseFirestore.instance.collection("users").get();

      for (var userDoc in usersSnapshot.docs) {
        String userId = userDoc.id; // Get user ID

        try {
          // Fetch records where status is "waiting" or "process"
          QuerySnapshot recSnapshot =
              await FirebaseFirestore.instance
                  .collection("users")
                  .doc(userId)
                  .collection("rec")
                  .where("status", whereIn: ["process"])
                  .orderBy("timestamp", descending: true)
                  .get();

          // Add each record along with user ID
          for (var doc in recSnapshot.docs) {
            Map<String, dynamic> record = doc.data() as Map<String, dynamic>;
            record['userId'] = userId;
            allRecords.add(record);
          }
        } catch (recError) {
          log("Error fetching 'rec' data for user: $userId - $recError");
        }
      }

      fundRecords = allRecords;
      log("--${fundRecords.toString()}");
    } catch (e) {
      log("Error fetching business records: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<Map<String, dynamic>> businessRecords = [];

  Future<void> fetchDonorPayments(String donorUID) async {
    isLoading = true; // Start loading
    notifyListeners();

    List<Map<String, dynamic>> allRecords = [];

    try {
      // Get all users
      QuerySnapshot usersSnapshot =
          await FirebaseFirestore.instance.collection("users").get();

      for (var userDoc in usersSnapshot.docs) {
        String userId = userDoc.id; // Get user ID

        // Fetch the "rec" sub-collection for each user
        QuerySnapshot recSnapshot =
            await FirebaseFirestore.instance
                .collection("users")
                .doc(userId)
                .collection("rec")
                .where("status", whereIn: ["completed"])
                .where("donorUID", isEqualTo: donorUID)
                // .orderBy("timestamp", descending: true)
                .get();

        // Add each record along with user ID
        for (var doc in recSnapshot.docs) {
          Map<String, dynamic> record = doc.data() as Map<String, dynamic>;
          record['userId'] = userId;
          allRecords.add(record);
        }
      }

      businessRecords = allRecords;
      log("--${businessRecords.toString()}");
    } catch (e) {
      log("Error fetching donor payments: $e");
    } finally {
      isLoading = false; // Stop loading
      notifyListeners();
    }
  }

  Future storePaymentData(
    Map<String, dynamic> paymentData,
    String conntainerId,
    String adminId,
    String donorId,
  ) async {
    try {
      log("Fetching records for admin: $conntainerId");

      // Query to find a request with status "waiting"
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance
              .collection("users")
              .doc(conntainerId)
              .collection("rec")
              .where("status", isEqualTo: "process")
              .limit(1)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        String requestId = querySnapshot.docs.first.id;
        log("Found matching request: $requestId");

        // Update the document with payment details
        await FirebaseFirestore.instance
            .collection("users")
            .doc(conntainerId)
            .collection("rec")
            .doc(requestId)
            .update({
              "status": "completed",
              "paymentData": paymentData,
              "DnorId": donorId,
              "donorUID": adminId,
            });

        log("Payment data updated successfully for request: $requestId");
      } else {
        log("No matching request found for admin: $adminId");
      }
    } catch (e) {
      log("Error updating payment data: $e");
    }
  }

  
}

