import 'dart:developer';

import 'package:clone/smart_giving/notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  Map<String, dynamic>? _userData;

  Map<String, dynamic>? get userData => _userData;

  Future<bool> loginUser(String mobile, String password, String role) async {
    try {
      var userDoc =
          await FirebaseFirestore.instance
              .collection("users")
              .where("mobileno", isEqualTo: mobile.trim())
              .where("password", isEqualTo: password.trim())
              .where("userType", isEqualTo: role)
              .get();

      if (userDoc.docs.isNotEmpty) {
        _userData = userDoc.docs.first.data();
        String userId = userDoc.docs.first.id;

        notifyListeners();
        await saveUserToken(userId);

        return true;
      }
      return false;
    } catch (e) {
      log("Login Error: $e");
      return false;
    }
  }

  Future<void> saveUserToken(String userId) async {
    final FCMService fcmService = FCMService();
    await fcmService.getToken();
    String? deviceToken = fcmService.token;

    if (deviceToken != null) {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'deviceToken': deviceToken,
      });
    }
  }

  void logout() {
    _userData = null;
    notifyListeners();
  }
}
