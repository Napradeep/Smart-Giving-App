import 'package:clone/smart_giving/models/user_model/user_model.dart';
import 'package:clone/smart_giving/notification.dart';
import 'package:clone/smart_giving/utlis/common/button.dart';
import 'package:clone/smart_giving/utlis/common/spacers.dart';
import 'package:clone/smart_giving/utlis/common/textfields.dart';
import 'package:clone/smart_giving/utlis/scaffold/scaffolds.dart';
import 'package:clone/smart_giving/utlis/validator/validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Signupscreen extends StatefulWidget {
  final VoidCallback onToggle;
  final String role;
  const Signupscreen({super.key, required this.onToggle, required this.role});

  @override
  State<Signupscreen> createState() => _SignupscreenState();
}

class _SignupscreenState extends State<Signupscreen> {
  final mobileCTRL = TextEditingController();
  final passwordCTRL = TextEditingController();
  final nameCTRL = TextEditingController();
  final addressCTRL = TextEditingController();
  String? deviceToken;
  bool isPasswordVisible = false;
  String? selectedUserType;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          MyTextfomrfiledbox(
            icon: Icon(Icons.person),
            hinttext: "Name",
            controller: nameCTRL,
          ),
          vSpace18,
          MyTextfomrfiledbox(
            icon: Icon(Icons.phone),
            hinttext: "Mobile Number",
            controller: mobileCTRL,
            keyboardType: TextInputType.phone,
          ),
          vSpace18,
          MyTextfomrfiledbox(
            icon: Icon(Icons.lock),
            hinttext: "Password",
            controller: passwordCTRL,
            suffixIcon: IconButton(
              icon: Icon(
                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              },
            ),
            obscureText: !isPasswordVisible,
          ),
          vSpace18,
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.person_outline),
              border: OutlineInputBorder(),
              hintText: "Select User Type",
            ),
            value: selectedUserType,
            items:
                ["USER", "ADMIN", "DONOR"].map((String userType) {
                  return DropdownMenuItem<String>(
                    value: userType,
                    child: Text(userType),
                  );
                }).toList(),
            onChanged: (value) {
              setState(() {
                selectedUserType = value;
              });
            },
          ),
          vSpace18,
          Button(
            color: Colors.blue.shade200,
            onpressed: () async {
              if (selectedUserType == null) {
                Messenger.alertError("Please select a user type");
                return;
              }
              String? mobileError = InputValidator.validateMobile(
                mobileCTRL.text,
              );
              if (mobileError != null) {
                Messenger.alertError(mobileError);
                return;
              }

              String? passwordError = InputValidator.validatePassword(
                passwordCTRL.text,
              );
              if (passwordError != null) {
                Messenger.alertError(passwordError);
                return;
              }

              try {
                String userId =
                    FirebaseFirestore.instance.collection("users").doc().id;
                final FCMService fcmService = FCMService();
                await fcmService.getToken();
                deviceToken = fcmService.token;
                UserModel user = UserModel(
                  id: userId, 
                  name: nameCTRL.text.trim(),
                  contact: mobileCTRL.text.trim(),
                  monbileno: mobileCTRL.text.trim(),
                  userType: selectedUserType!,
                  password: passwordCTRL.text,
                );

                await FirebaseFirestore.instance
                    .collection("users")
                    .doc(userId)
                    .set(user.toMap());

                Messenger.alertSuccess("Signup Successful!");
                setState(() {
                  widget.onToggle();
                });
              } catch (e) {
                Messenger.alertError("Error: ${e.toString()}");
              }
            },
            texxt: "Signup",
            width: 350,
            height: 40,
            txtcolor: Colors.black,
          ),
          vSpace18,
          GestureDetector(
            onTap: widget.onToggle,
            child: Text(
              "Already Have an Account? Login",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
