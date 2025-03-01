// import 'package:clone/smart_giving/screens/custom_appbar.dart';
// import 'package:clone/smart_giving/utlis/common/images.dart';
// import 'package:clone/smart_giving/utlis/common/spacers.dart';
// import 'package:clone/smart_giving/utlis/common/textfields.dart';
// import 'package:flutter/material.dart';

// class PaymentScreen extends StatefulWidget {
//   const PaymentScreen({super.key});

//   @override
//   State<PaymentScreen> createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentScreen> {
//   final payAmountCTRL = TextEditingController();
//   final paymentmodeCTRL = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: CustomAppBar(title: "Smart giving App", image: donorImage),
//       body: Column(
//         children: [
//           Text(
//             "Donate To Fund",
//             style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//           ),
//           vSpace36,
//           MyTextfomrfiledbox(
//             controller: payAmountCTRL,
//             hinttext: "Please Enter Ammount",
//           ),
//           vSpace18,
//           MyTextfomrfiledbox(
//             controller: paymentmodeCTRL,
//             hinttext: "Please payment mode",
//           ),
//         ],
//       ),
//     );
//   }
// }
