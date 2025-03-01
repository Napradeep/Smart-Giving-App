// import 'dart:convert';
// import 'dart:developer';
// import 'dart:typed_data';

// import 'package:clone/smart_giving/providers/auth_provider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';

// class FirestoreImageUpload extends StatefulWidget {
//   const FirestoreImageUpload({super.key});

//   @override
//   FirestoreImageUploadState createState() => FirestoreImageUploadState();
// }

// class FirestoreImageUploadState extends State<FirestoreImageUpload> {
//   String? base64Image;
//   String? userId;
//   Future<void> pickAndUploadImage() async {
    
//     final ImagePicker picker = ImagePicker();
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     final XFile? image = await picker.pickImage(source: ImageSource.gallery);
//     userId = authProvider.userData?["id"];
//     if (image == null) return;

//     // Convert Image to Bytes
//     Uint8List imageBytes = await image.readAsBytes();

//     // Convert Bytes to Base64 String
//     String base64String = base64Encode(imageBytes);
//     log(base64String);

//     // Store in Firestore
//     await FirebaseFirestore.instance.collection('users').add({
//       'imageData': base64String,
//       'userId': userId,
//       'timestamp': DateTime.now().toIso8601String(),
//     });

//     setState(() {
//       base64Image = base64String;
//     });

//     log("✅ Image uploaded successfully!");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         base64Image != null
//             ? Image.memory(base64Decode(base64Image!))
//             : Text("No Image Selected"),
//         ElevatedButton(
//           onPressed: pickAndUploadImage,
//           child: Text("Upload Image"),
//         ),
//       ],
//     );
//   }
// }
