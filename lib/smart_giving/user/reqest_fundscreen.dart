import 'dart:developer';

import 'package:clone/smart_giving/providers/auth_provider.dart';
import 'package:clone/smart_giving/providers/bussiness_provider.dart';
import 'package:clone/smart_giving/utlis/common/button.dart';
import 'package:clone/smart_giving/utlis/common/spacers.dart';
import 'package:clone/smart_giving/utlis/common/textfields.dart';
import 'package:clone/smart_giving/utlis/scaffold/scaffolds.dart';
import 'package:clone/smart_giving/utlis/validator/validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReqestFundscreen extends StatefulWidget {
  const ReqestFundscreen({super.key});

  @override
  State<ReqestFundscreen> createState() => _ReqestFundscreenState();
}

class _ReqestFundscreenState extends State<ReqestFundscreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final businessProvider = Provider.of<BusinessProvider>(
        context,
        listen: false,
      );
      businessProvider.clearFields();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final businessProvider = Provider.of<BusinessProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Smart Giving App",
              style: TextStyle(
                color: Colors.green,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Welcome,${authProvider.userData!["name"]}",
              style: TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              children: [
                // FirestoreImageUpload(),
                // vSpace36,
                // title
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Request Fund",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
                vSpace18,
                //name
                MyTextfomrfiledbox(
                  controller: businessProvider.mobileCTRL,
                  hinttext: "Mobile number",
                  keyboardType: TextInputType.number,
                  length: 10,
                ),
                vSpace18,
                //dropdown service type
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                    hintText: "Select User Type",
                  ),
                  value: businessProvider.selectedUserType,
                  items:
                      [
                        "Tution fees",
                        "Collage Fees",
                        "Book fees",
                        "School fees",
                      ].map((String userType) {
                        return DropdownMenuItem<String>(
                          value: userType,
                          child: Text(userType),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      businessProvider.selectedUserType = value;
                    });
                  },
                ),
                vSpace18,
                // amount
                MyTextfomrfiledbox(
                  controller: businessProvider.amountCTRL,
                  hinttext: "Amount",
                  keyboardType: TextInputType.number,
                ),

                vSpace18,

                // proof type
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                    hintText: "Proof Type",
                  ),
                  value: businessProvider.selectedProjectType,

                  items:
                      ["Adhar Card", "Collage certificate"].map((
                        String proofType,
                      ) {
                        return DropdownMenuItem<String>(
                          value: proofType,
                          child: Text(proofType),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      businessProvider.selectedProjectType = value;
                    });
                  },
                ),
                vSpace18,

                //image
                

                //upi
                MyTextfomrfiledbox(
                  controller: businessProvider.upiCTRL,
                  hinttext: "Enter UPI ID",
                ),
                vSpace36,

                //submit
                Button(
                  color: Colors.blue,
                  onpressed: () async {
                    if (businessProvider.selectedProjectType == null &&
                        businessProvider.selectedUserType == null) {
                      Messenger.alertError("Fill the Empty fields");
                      return;
                    }
                    String? mobileError = InputValidator.validateMobile(
                      businessProvider.mobileCTRL.text,
                    );

                    if (mobileError != null) {
                      Messenger.alertError(mobileError);
                      return;
                    }

                    if (businessProvider.amountCTRL.text.isEmpty) {
                      Messenger.alertError("Enter validate Amount");
                      return;
                    }

                    if (businessProvider.upiCTRL.text.isEmpty) {
                      Messenger.alertError("Enter validate UPI ID");
                      return;
                    }

                    try {
                      String userId = authProvider.userData!["id"];
                      String username = authProvider.userData!["name"];
                      log(userId);

                      businessProvider.addBusinessProfile(userId, username);
                      Messenger.alertSuccess("Requested Successful!");
                    } catch (e) {
                      Messenger.alertError("Error: ${e.toString()}");
                    }
                  },
                  texxt: 'Submit',
                  width: 120,
                  height: 40,
                  txtcolor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
