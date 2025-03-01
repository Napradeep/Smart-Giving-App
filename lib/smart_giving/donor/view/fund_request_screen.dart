import 'dart:developer';

import 'package:clone/smart_giving/donor/Provider/donor_provider.dart';
import 'package:clone/smart_giving/donor/view/request_container.dart';
import 'package:clone/smart_giving/providers/auth_provider.dart'
    show AuthProvider;
import 'package:clone/smart_giving/screens/custom_appbar.dart';
import 'package:clone/smart_giving/utlis/common/images.dart';
import 'package:clone/smart_giving/utlis/common/loading_screen.dart';
import 'package:clone/smart_giving/utlis/razorpay/order_req_model.dart';
import 'package:clone/smart_giving/utlis/razorpay/payment_option_model.dart';
import 'package:clone/smart_giving/utlis/razorpay/razorpay_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class FundRequestScreen extends StatefulWidget {
  const FundRequestScreen({super.key});

  @override
  State<FundRequestScreen> createState() => _FundRequestScreenState();
}

class _FundRequestScreenState extends State<FundRequestScreen> {
  String? userId;
  String? donorId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final businessProvider = Provider.of<DonorProvider>(
        context,
        listen: false,
      );

      userId = authProvider.userData?["id"];
      donorId = authProvider.userData?["donorId"];

      await businessProvider.fetchAllBusinessRecords();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Smart Giving App", image: donorImage),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Fund Request",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),

            // Listening to DonorProvider
            Consumer<DonorProvider>(
              builder: (context, businessProvider, child) {
                if (businessProvider.fundRecords.length == 0 &&
                    businessProvider.fundRecords.isEmpty) {
                      return Padding
                      (padding: EdgeInsets.only(top: 220),
                        child: Center(child: Text("No Records found")));
                  
                } else if (
                    businessProvider.fundRecords.isEmpty) {
                  return LoadingScreen();
                }

                return Expanded(
                  child: ListView.builder(
                    itemCount: businessProvider.fundRecords.length,
                    itemBuilder: (context, index) {
                      final fundRequest = businessProvider.fundRecords[index];

                      return RequestContainer(
                        studentName: fundRequest["name"] ?? "Unknown",
                        reason: fundRequest["userType"] ?? "Not Provided",
                        feesAmout: fundRequest["amount"]?.toString() ?? "0",
                        onTap: () async {
                          var razorPayUtils = RazorPayUtils();
                          print("Original Amount: ${fundRequest["amount"]}");
                          print(fundRequest["userId"]);
                          // log(fundRequest["adminId"]);

                          int amountInPaisa =
                              int.parse(
                                fundRequest["amount"].toString().replaceAll(
                                  RegExp(r'[^0-9]'),
                                  '',
                                ),
                              ) *
                              100; // Convert INR to paisa

                          final order = await razorPayUtils.createOrder(
                            OrderRequest(
                              amountInPaisa: amountInPaisa,
                              currency: "INR",
                            ),
                          );

                          // ✅ Use only the Order ID, NOT Subscription ID
                          final checkoutOptions = RazorPayOptions(
                            amountInPaisa: amountInPaisa,
                            name: fundRequest["name"],
                            orderId: order.id,
                            description: "Monthly Subscription",
                            prefill: Prefill(
                              contact: fundRequest["mobile"],
                              email: "test@gmail.com",
                            ),
                            method: {
                              'upi': true,
                              'card': false,
                              'netbanking': false,
                            },
                            subscriptionId: '',
                          );

                          razorPayUtils.razorpay.on(
                            Razorpay.EVENT_PAYMENT_SUCCESS,
                            (PaymentSuccessResponse response) async {
                              log("Payment Success: ${response.paymentId}");
                              log("successssss ${response.data}");
                              Map<String, dynamic> paymentData = {
                                "payment_id": response.paymentId,
                                "order_id": response.orderId,
                                "signature": response.signature,
                                "name": fundRequest["name"],
                                "mobileno": fundRequest["mobile"],
                                "status": "success",
                                "description": "Monthly Subscription",
                                // "amount": amountInPaisa.toString(),
                                "amount": (amountInPaisa / 100).toString(),
                                "currency": "INR",
                                "transaction_mode": "UPI",
                                "payment_gateway": "Razorpay",
                                "date": DateFormat(
                                  'dd-MM-yyyy',
                                ).format(DateTime.now()),
                                "paidTime": DateFormat(
                                  'hh.mm a',
                                ).format(DateTime.now()),
                                "timestamp": DateTime.now().toIso8601String(),
                                "DnorId": donorId,
                                "expiryDate":
                                    DateTime.now()
                                        .add(Duration(days: 30))
                                        .toIso8601String(),
                                "payment_verified": false,
                                "adminId": userId,
                              };
                              print(paymentData);
                              print(fundRequest["adminId"]);
                              log(fundRequest["adminId"]);
                              businessProvider.storePaymentData(
                                paymentData,
                                fundRequest['adminId'],
                                userId ?? "",
                                donorId ?? "",
                              );
                              businessProvider.fetchAllBusinessRecords();
                            },
                          );

                          razorPayUtils.razorpay.on(
                            Razorpay.EVENT_PAYMENT_ERROR,
                            (response) {
                              log("errrr $response");
                              print(
                                "Payment failed: ${response.code} - ${response.message}",
                              );
                            },
                          );

                          razorPayUtils.razorpay.on(
                            Razorpay.EVENT_EXTERNAL_WALLET,
                            (response) {
                              log("ext wallet $response");
                            },
                          );

                          // ✅ Open Razorpay with the updated options
                          razorPayUtils.razorpay.open(checkoutOptions.toJson());
                          //  MyRouter.push(screen: PaymentScreen());
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
