import 'dart:developer' show log;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewFundService extends ChangeNotifier {
  final TextEditingController nameCTRL = TextEditingController();
  final TextEditingController mobileCTRL = TextEditingController();
  final TextEditingController amountCTRL = TextEditingController();
  final TextEditingController upiCTRL = TextEditingController();
  List<Map<String, dynamic>> businessRecords = [];

  Future<void> fetchAllBusinessRecords() async {
    List<Map<String, dynamic>> allRecords = [];
    QuerySnapshot usersSnapshot =
        await FirebaseFirestore.instance.collection("users").get();

    for (var userDoc in usersSnapshot.docs) {
      String userId = userDoc.id;

      QuerySnapshot recSnapshot =
          await FirebaseFirestore.instance
              .collection("users")
              .doc(userId)
              .collection("rec")
              .where("status", whereIn: ["waiting"])
              .get();

      for (var doc in recSnapshot.docs) {
        Map<String, dynamic> record = doc.data() as Map<String, dynamic>;
        record['userId'] = userId;
        record['docId'] = doc.id;
        allRecords.add(record);
      }
    }

    businessRecords = allRecords;
    log("--$businessRecords.toString()");
    notifyListeners();
  }

  Future<void> updateFundStatus(
    String userId,
    String docId,
    String newStatus,
    String AdminId,
  ) async {
    try {
      print("AdminId : $AdminId");
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("rec")
          .doc(docId)
          .update({"status": newStatus, "acptAdminId": AdminId});

      fetchAllBusinessRecords();
    } catch (e) {
      log("Error updating status: $e");
    }
  }

  @override
  void dispose() {
    nameCTRL.dispose();
    mobileCTRL.dispose();
    amountCTRL.dispose();
    upiCTRL.dispose();
    super.dispose();
  }
}
