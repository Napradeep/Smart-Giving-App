import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageFirestoreExample extends StatefulWidget {
  const ImageFirestoreExample({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ImageFirestoreExampleState createState() => _ImageFirestoreExampleState();
}

class _ImageFirestoreExampleState extends State<ImageFirestoreExample> {
  Uint8List? _imageBytes;

  // Firestore Collection Reference
  final CollectionReference imageCollection =
      FirebaseFirestore.instance.collection("images");

  // Pick Image and Convert to Bytes
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      Uint8List bytes = await File(image.path).readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });

      // Store Image Bytes in Firestore
      await imageCollection.add({"imageBytes": bytes});
    }
  }

  // Fetch Image from Firestore
  Future<void> _fetchImage() async {
    QuerySnapshot snapshot = await imageCollection.get();
    if (snapshot.docs.isNotEmpty) {
      var data = snapshot.docs.first.data() as Map<String, dynamic>;
      setState(() {
        _imageBytes = data["imageBytes"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _imageBytes != null
              ? Image.memory(
                  _imageBytes!,
                  height: 90,
                )
              : Text("No image selected"),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _pickImage,
            child: Text("Pick & Store Image"),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _fetchImage,
            child: Text("Fetch Image from Firestore"),
          ),
        ],
      ),
    );
  }
}
