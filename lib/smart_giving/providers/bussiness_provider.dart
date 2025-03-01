import 'dart:developer';

import 'package:clone/smart_giving/screens/home_lobby.dart';
import 'package:clone/smart_giving/utlis/navigator/router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BusinessProvider extends ChangeNotifier {
  final TextEditingController nameCTRL = TextEditingController();
  final TextEditingController mobileCTRL = TextEditingController();
  final TextEditingController amountCTRL = TextEditingController();
  final TextEditingController upiCTRL = TextEditingController();
   List<Map<String, dynamic>> businessRecords = [];

  String? selectedUserType;
  String? selectedProjectType;

  Future<void> addBusinessProfile(String userId, String name) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("rec")
          .add({
            "name": name,
            "mobile": mobileCTRL.text.trim(),
            "amount": amountCTRL.text.trim(),
            "upi": upiCTRL.text.trim(),
            "userType": selectedUserType,
            "projectType": selectedProjectType,
            "adminId": userId,
            'status': "waiting",
            "timestamp": FieldValue.serverTimestamp(),
          });

      notifyListeners();
      MyRouter.pushRemoveUntil(screen: AdminPanel());
    } catch (e) {
      log("Error: $e");
    }
  }

 

  Future<void> fetchBusinessRecords(String userId) async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance
            .collection("users")
            .doc(userId)
            .collection("rec")
            .orderBy("timestamp", descending: true)
            .get();

    businessRecords =
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
        log(businessRecords.toString());

    notifyListeners();
  }

  void clearFields() {
    mobileCTRL.clear();
    upiCTRL.clear();
    amountCTRL.clear();
    selectedUserType = null;
    selectedProjectType = null;
    notifyListeners();
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
