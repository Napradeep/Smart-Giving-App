import 'dart:developer';

import 'package:clone/smart_giving/utlis/sesion/sharedpref.dart';
import 'package:flutter/material.dart';


// Storing user session

class SesionHandle extends ChangeNotifier {
  Future<void> saveUserSession(Map<String, dynamic> userData) async {
    await LocalStorageUtils.instance.write('userId', userData['id']);
    await LocalStorageUtils.instance.write('userType', userData['userType']);
    await LocalStorageUtils.instance.write('mobileNo', userData['mobileno']);
    await LocalStorageUtils.instance.write('userName', userData['name']);
  }

  Future<void> getUserSession() async {
    String? userId = await LocalStorageUtils.instance.read<String>('userId');
    String? userType =
        await LocalStorageUtils.instance.read<String>('userType');
    String? mobileNo =
        await LocalStorageUtils.instance.read<String>('mobileNo');
    String? userName =
        await LocalStorageUtils.instance.read<String>('userName');

    log("User ID: $userId");
    log("User Type: $userType");
    log("Mobile No: $mobileNo");
    log("User Name: $userName");
  }
}
