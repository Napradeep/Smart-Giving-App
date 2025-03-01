import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DonorProvider extends ChangeNotifier {
  List<Map<String, dynamic>> fundRecords = [];
  bool isLoading = false;
  Future<void> fetchAllBusinessRecords() async {
    isLoading = true; // Start loading
    notifyListeners();

    List<Map<String, dynamic>> allRecords = [];

    try {
      // Get all users
      QuerySnapshot usersSnapshot =
          await FirebaseFirestore.instance.collection("users").get();

      for (var userDoc in usersSnapshot.docs) {
        String userId = userDoc.id; // Get user ID

        try {
          // Fetch records where status is "waiting" or "process"
          QuerySnapshot recSnapshot =
              await FirebaseFirestore.instance
                  .collection("users")
                  .doc(userId)
                  .collection("rec")
                  .where("status", whereIn: ["process"])
                  .orderBy("timestamp", descending: true)
                  .get();

          // Add each record along with user ID
          for (var doc in recSnapshot.docs) {
            Map<String, dynamic> record = doc.data() as Map<String, dynamic>;
            record['userId'] = userId;
            allRecords.add(record);
          }
        } catch (recError) {
          log("Error fetching 'rec' data for user: $userId - $recError");
        }
      }

      fundRecords = allRecords;
      log("--${fundRecords.toString()}");
    } catch (e) {
      log("Error fetching business records: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<Map<String, dynamic>> businessRecords = [];

  Future<void> fetchDonorPayments(String donorUID) async {
    isLoading = true; // Start loading
    notifyListeners();

    List<Map<String, dynamic>> allRecords = [];

    try {
      // Get all users
      QuerySnapshot usersSnapshot =
          await FirebaseFirestore.instance.collection("users").get();

      for (var userDoc in usersSnapshot.docs) {
        String userId = userDoc.id; // Get user ID

        // Fetch the "rec" sub-collection for each user
        QuerySnapshot recSnapshot =
            await FirebaseFirestore.instance
                .collection("users")
                .doc(userId)
                .collection("rec")
                .where("status", whereIn: ["completed"])
                .where("donorUID", isEqualTo: donorUID)
                // .orderBy("timestamp", descending: true)
                .get();

        // Add each record along with user ID
        for (var doc in recSnapshot.docs) {
          Map<String, dynamic> record = doc.data() as Map<String, dynamic>;
          record['userId'] = userId;
          allRecords.add(record);
        }
      }

      businessRecords = allRecords;
      log("--${businessRecords.toString()}");
    } catch (e) {
      log("Error fetching donor payments: $e");
    } finally {
      isLoading = false; // Stop loading
      notifyListeners();
    }
  }

  Future storePaymentData(
    Map<String, dynamic> paymentData,
    String conntainerId,
    String adminId,
    String donorId,
  ) async {
    try {
      log("Fetching records for admin: $conntainerId");

      // Query to find a request with status "waiting"
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance
              .collection("users")
              .doc(conntainerId)
              .collection("rec")
              .where("status", isEqualTo: "process")
              .limit(1)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        String requestId = querySnapshot.docs.first.id;
        log("Found matching request: $requestId");

        // Update the document with payment details
        await FirebaseFirestore.instance
            .collection("users")
            .doc(conntainerId)
            .collection("rec")
            .doc(requestId)
            .update({
              "status": "completed",
              "paymentData": paymentData,
              "DnorId": donorId,
              "donorUID": adminId,
            });

        log("Payment data updated successfully for request: $requestId");
      } else {
        log("No matching request found for admin: $adminId");
      }
    } catch (e) {
      log("Error updating payment data: $e");
    }
  }

  // Future<void>  storePaymentData(
  //   Map<String, dynamic> paymentData,
  //   String adminId,
  // ) async {
  //   try {
  //     // String donorId = paymentData["DnorId"];
  //     // String donorUID = paymentData["adminId"];
  //     // String donorMobile = paymentData["mobileno"];

  //     // print("Fetching records for admin: $adminId");

  //     QuerySnapshot querySnapshot =

  //         await FirebaseFirestore.instance
  //             .collection("users")
  //             .doc(adminId)
  //             .collection("rec")
  //             .where("status", isEqualTo: "waiting")
  //             .limit(1)
  //             .get();

  //     if (querySnapshot.docs.isNotEmpty) {
  //       String requestId = querySnapshot.docs.first.id;
  //       log(" Found matching request: $requestId");

  //       log("Payment data updated successfully for request: $requestId");
  //     } else {
  //       log("No matching request found for admin: $adminId");
  //     }
  //   } catch (e) {
  //     log("Error updating payment data: $e");
  //   }
  // }
}


// import 'dart:developer';

// import 'package:clone/smart_giving/donor/Provider/donor_provider.dart';
// import 'package:clone/smart_giving/donor/view/request_container.dart';
// import 'package:clone/smart_giving/providers/auth_provider.dart' show AuthProvider;
// import 'package:clone/smart_giving/screens/custom_appbar.dart';
// import 'package:clone/smart_giving/utlis/common/images.dart';
// import 'package:clone/smart_giving/utlis/common/loading_screen.dart';
// import 'package:clone/smart_giving/utlis/razorpay/order_req_model.dart';
// import 'package:clone/smart_giving/utlis/razorpay/payment_option_model.dart';
// import 'package:clone/smart_giving/utlis/razorpay/razorpay_utils.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

// class FundRequestScreen extends StatefulWidget {
//   const FundRequestScreen({super.key});

//   @override
//   State<FundRequestScreen> createState() => _FundRequestScreenState();
// }

// class _FundRequestScreenState extends State<FundRequestScreen> {
//   String? userId;
//   String? donorId;
//   bool isLoading = true;
//   bool isProcessingPayment = false;

//   @override
//   void initState() {
//     super.initState();
//     _fetchData();
//   }

//   Future<void> _fetchData() async {
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     final donorProvider = Provider.of<DonorProvider>(context, listen: false);

//     setState(() {
//       isLoading = true;
//     });

//     userId = authProvider.userData?["id"];
//     donorId = authProvider.userData?["donorId"];

//     await donorProvider.fetchAllBusinessRecords();

//     setState(() {
//       isLoading = false;
//     });
//   }

//   Future<void> _handlePaymentSuccess(
//       PaymentSuccessResponse response, Map<String, dynamic> fundRequest) async {
//     setState(() {
//       isProcessingPayment = true;
//     });

//     final donorProvider = Provider.of<DonorProvider>(context, listen: false);

//     int amountInPaisa = int.parse(
//           fundRequest["amount"].toString().replaceAll(RegExp(r'[^0-9]'), ''),
//         ) *
//         100;

//     Map<String, dynamic> paymentData = {
//       "payment_id": response.paymentId,
//       "order_id": response.orderId,
//       "signature": response.signature,
//       "name": fundRequest["name"],
//       "mobileno": fundRequest["mobile"],
//       "status": "success",
//       "description": "Monthly Subscription",
//       "amount": (amountInPaisa / 100).toString(),
//       "currency": "INR",
//       "transaction_mode": "UPI",
//       "payment_gateway": "Razorpay",
//       "date": DateFormat('dd-MM-yyyy').format(DateTime.now()),
//       "paidTime": DateFormat('hh.mm a').format(DateTime.now()),
//       "timestamp": DateTime.now().toIso8601String(),
//       "DnorId": donorId,
//       "expiryDate": DateTime.now().add(Duration(days: 30)).toIso8601String(),
//       "payment_verified": false,
//       "adminId": userId,
//     };

//     await donorProvider.storePaymentData(paymentData, fundRequest["adminId"]);

//     // Refresh Data after Payment
//     await _fetchData();

//     setState(() {
//       isProcessingPayment = false;
//     });
//   }

//   void _handlePaymentError(PaymentFailureResponse response) {
//     log("Payment failed: ${response.code} - ${response.message}");
//   }

//   void _handleExternalWallet(ExternalWalletResponse response) {
//     log("External Wallet: $response");
//   }

//   void _startPaymentProcess(Map<String, dynamic> fundRequest) async {
//     var razorPayUtils = RazorPayUtils();
//     int amountInPaisa = int.parse(
//           fundRequest["amount"].toString().replaceAll(RegExp(r'[^0-9]'), ''),
//         ) *
//         100;

//     final order = await razorPayUtils.createOrder(
//       OrderRequest(
//         amountInPaisa: amountInPaisa,
//         currency: "INR",
//       ),
//     );

//     final checkoutOptions = RazorPayOptions(
//       amountInPaisa: amountInPaisa,
//       name: fundRequest["name"],
//       orderId: order.id,
//       description: "Monthly Subscription",
//       prefill: Prefill(
//         contact: fundRequest["mobile"],
//         email: "test@gmail.com",
//       ),
//       method: {'upi': true, 'card': false, 'netbanking': false},
//       subscriptionId: '',
//     );

//     razorPayUtils.razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
//         (PaymentSuccessResponse response) {
//       _handlePaymentSuccess(response, fundRequest);
//     });

//     razorPayUtils.razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     razorPayUtils.razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

//     razorPayUtils.razorpay.open(checkoutOptions.toJson());
//   }

//   @override
//   Widget build(BuildContext context) {
//     final donorProvider = Provider.of<DonorProvider>(context);

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: CustomAppBar(title: "Smart Giving App", image: donorImage),
//       body: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Fund Request",
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//             const SizedBox(height: 10),
//             if (isProcessingPayment)
             
//             Expanded(
//               child: Consumer<DonorProvider>(
//                 builder: (context, donorProvider, child) {
//                   if (isLoading) {
//                     return LoadingScreen();
//                   }

//                   if (donorProvider.fundRecords.isEmpty) {
//                     return Center(
//                       child: Text(
//                         "No Records Found",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     );
//                   }

//                   return ListView.builder(
//                     itemCount: donorProvider.fundRecords.length,
//                     itemBuilder: (context, index) {
//                       final fundRequest = donorProvider.fundRecords[index];

//                       return RequestContainer(
//                         studentName: fundRequest["name"] ?? "Unknown",
//                         reason: fundRequest["userType"] ?? "Not Provided",
//                         feesAmout: fundRequest["amount"]?.toString() ?? "0",
//                         onTap: () => _startPaymentProcess(fundRequest),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
