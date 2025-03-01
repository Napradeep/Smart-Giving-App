// ignore_for_file: use_build_context_synchronously

import 'package:clone/smart_giving/providers/auth_provider.dart';
import 'package:clone/smart_giving/screens/home_lobby.dart';
import 'package:clone/smart_giving/utlis/common/button.dart';
import 'package:clone/smart_giving/utlis/common/spacers.dart';
import 'package:clone/smart_giving/utlis/common/textfields.dart';
import 'package:clone/smart_giving/utlis/navigator/router.dart';
import 'package:clone/smart_giving/utlis/scaffold/scaffolds.dart';
import 'package:clone/smart_giving/utlis/validator/validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  final VoidCallback onToggle;
  final String role;
  const Login({super.key, required this.role, required this.onToggle});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final mobileCTRL = TextEditingController();
  final passwordCTRL = TextEditingController();
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          MyTextfomrfiledbox(
            icon: Icon(Icons.phone),
            hinttext: "Mobile Number",
            controller: mobileCTRL,
            length: 10,
            keyboardType: TextInputType.phone,
            onChanged: (value) {
              passwordCTRL.clear();
            },
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

          vSpace36,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Button(
                color: Colors.blue.shade200,
                onpressed: () async {
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

                  bool loginSuccess = await authProvider.loginUser(
                    mobileCTRL.text,
                    passwordCTRL.text,
                    widget.role,
                  );

                  if (loginSuccess) {
                    Messenger.alertSuccess("Login Successful!");
                    // widget.role == "ADMIN"
                    //     ?
                    MyRouter.pushRemoveUntil(
                      screen: AdminPanel(role: widget.role),
                    );
                    // : MyRouter.pushRemoveUntil(screen: AdminPanel());
                    print(authProvider.userData);
                  } else {
                    Messenger.alertError("Invalid Mobile Number or Password");
                  }
                },
                texxt: "Login",
                width: 150,
                height: 40,
                txtcolor: Colors.black,
              ),

              Button(
                color: Colors.blue.shade200,
                onpressed: widget.onToggle,
                texxt: "Signup",
                width: 150,
                height: 40,
                txtcolor: Colors.black,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
