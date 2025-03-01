// import 'dart:developer';
// import 'dart:io';

// import 'package:flutter/material.dart';

// class FCMService {
//   static final FCMService _instance = FCMService._internal();

//   factory FCMService() {
//     return _instance;
//   }

//   FCMService._internal();

//   String? _token;
//   String? _accessToken;
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   Future<String> getAccessToken() async {
//     String? token = await _firebaseMessaging.getToken();
//     return token ?? ""; // Provide a default empty string if the token is null
//   }

//   // Usage example
//   Future<void> getAndPrintToken() async {
//     String token = await getAccessToken();
//     log("FCM Token: $token");
//   }

//   Future<void> requestPermissions() async {
//     NotificationSettings settings = await _firebaseMessaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       log("User granted permission for notifications.");
//     } else {
//       log("User denied permission for notifications.");
//     }
//   }

//   // Method to get FCM token for Android and iOS
//   Future<void> getToken() async {
//     FirebaseMessaging messaging = FirebaseMessaging.instance;

//     try {
//       String? token = await messaging.getToken();
//       _token = token;
//       log('FCM Token: $token');

//       if (Platform.isIOS) {
//         // iOS-specific: request permissions
//         await FirebaseMessaging.instance.requestPermission(
//           alert: true,
//           badge: true,
//           sound: true,
//         );
//         log('iOS notification permissions granted');
//       }
//     } catch (e) {
//       log('Error getting FCM token: $e');
//     }
//   }

//   // Method to obtain access token for sending messages
//   Future<void> obtainAccessToken() async {
//     try {
//       final accountCredentials = ServiceAccountCredentials.fromJson(r'''
// {
//   "type": "service_account",
//   "project_id": "donor-proj",
//   "private_key_id": "96d2f814fb8c31b3f1e7dbc37232ae5cfec89219",
//   "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC9qR20pAd1Bh5X\nUxi2hhKE18Aa2Oni0K2Tf/9G4qf+TLyO67830fN+YSoZh5h0lkUwBZZChCaV3pey\n/lQLfVILZeOOwcCbSPHfkotVWhwFJ+ggLk8R+rZcGz0v/JVCmcPtrDs0UBI+NIUW\nnRQx7us4B8de9R7mFTl2NF1PehXZHaqlQYcJlEymO7lrPO/JZjbaFYrOV8u8Ra0X\n1dwu4Zjh+L0oCKpijMke9EMrqRf1b5DTmgB2TF7w2JKF4crOMQ57KOJE2NwTNc2G\n784c4+is/8FocGFjQ0bzcTeof1lYLaSoecLLYIGi/O0n4sNkqIOnXLd1aGVOgYUk\n9IqQEBtVAgMBAAECggEAJHwWPBQK4DL1XsCcQi5//QChErkUIx8YKQYINltvTD74\nTfkhX4xarj7kUaVxSUpIFIEaowCXiKCZp6P/yHcK86jd0e5JTkYFy4e+GIT9W2uO\nHrSx3shPUOAnkOXi071PQNcvS3S00bUaPhupESMAKlbqvkRitYmzNF9F7P5UGiAi\nyaB5PEd7cpBOONtBBl0NzFUEdWBiOGQCFsfJAQ6s6N5fMEqTdEk8B4tI/Y+jH/g7\nyjI8Qn88HSgR/25piYGPH3mzZDsHv5JBTYfm2nYP5a2xEZNHC0bvvZjRHLbAOtSA\nI4T3Zt0sQdLqBQUBo3Tnq6akwSsh4F8rZ9PEdmf+SQKBgQD2+CXPIHlUDDZgYr1p\nMAwx0oExflUlvlCr1dBLZTxlS8x8dyLriCxqD/o/EHbD6MOPcVWNC5VYolBWE+vr\nJtDeOxtTaFlcuF3D9ur5bggG1cVwi0WuDezchwI6oEK0eBWQyuGn/h26UYJxnqxV\nqjN5xdWmtMczPSgkw61l09ykWQKBgQDEmIIBp/CQHgnw9S183sPtHJmGqZ4sZ9Y9\n+Ky8vNbA26syu4hEmY58AkYoLCOg1Bui3z5tDnIS+YX77wU9nYkfTzWwpsp06Rnc\nb/T8BzyHyOkRRBHHIBNugmnTlRc3cNlo1vzRX932iMsA0w8iPL+RgIp0Dn1IrZx9\n2Uv4a1q/XQKBgAb9iRxuv+BoJBXgVZonmQDEA5IiEEjsNR5YA/hOWkJHvfb77Eoc\nZZ1u7FdioOn0qaxiudgvLr/+gCWflLroM1tG8wQOXREpysWkNIxw19tRq6/+0S8X\nB9BKJf8A0EKJb5rUk0SNBcxjSDztD9Ww5poYxm5ciZLitUMtIrhSIdmpAoGASY6q\nbgYxGysyGwcRWvxaoHgn9Vu3g/PiFFPcBc4+J/DJEHVcWhZ+WmXbbCJ/vig+ouUW\njWVvRyw3dnkLI++yo5VWiF8Pt0iUVYdKSZZHjqKcmco3QKL+wkVnZTQOeL7viauO\n8qQE/75U/lz595x1LPLEWwIk3DGhMPFB3JQGYz0CgYEA1EorfjQ+cjaUN0ANak+w\n9i437brhItECDPboD6DvvBwfP/nC+iM3dkIuN7n35OshBx+I8DQ2tVAqq5jgtoVX\njA37lX2LA1M7EWXnEakj7xFnTr2pAwJE/i6LfNPQhLcgVuegPBwiTlEXjjEmP1H5\njJU8N9gCIWUp9UnEM/EjdNM=\n-----END PRIVATE KEY-----\n",
//   "client_email": "firebase-adminsdk-fbsvc@donor-proj.iam.gserviceaccount.com",
//   "client_id": "107963945795366057079",
//   "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//   "token_uri": "https://oauth2.googleapis.com/token",
//   "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
//   "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40donor-proj.iam.gserviceaccount.com",
//   "universe_domain": "googleapis.com"
// }
//       ''');

//       final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
//       final authClient = await clientViaServiceAccount(
//         accountCredentials,
//         scopes,
//       );

//       _accessToken = authClient.credentials.accessToken.data;
//       log('Access Token: $_accessToken');
//     } catch (e) {
//       log('Error obtaining access token: $e');
//     }
//   }

//   String? get token => _token;
//   String? get accessToken => _accessToken;
// }
