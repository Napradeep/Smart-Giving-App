// import 'package:flutter/material.dart';

// class ApprovalToggle extends StatefulWidget {
//   const ApprovalToggle({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _ApprovalToggleState createState() => _ApprovalToggleState();
// }

// class _ApprovalToggleState extends State<ApprovalToggle> {
//   bool isApproved = true;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 40,
//       width: 250,
//       decoration: BoxDecoration(
//         color: Colors.blue.shade200,
//         borderRadius: BorderRadius.circular(25),
//       ),
//       child: Stack(
//         children: [
//           AnimatedAlign(
//             duration: Duration(milliseconds: 300),
//             curve: Curves.easeInOut,
//             alignment:
//                 isApproved ? Alignment.centerLeft : Alignment.centerRight,
//             child: Container(
//               width: 120,
//               height: 40,
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.green),
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(25),
//               ),
//             ),
//           ),

//           // Row for text buttons
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _buildOption("Approved", true),
//               _buildOption("Rejected", false),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildOption(String title, bool isActive) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: () {
//           setState(() {
//             isApproved = isActive;
//           });
//         },
//         child: Center(
//           child: Text(
//             title,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight:
//                   isApproved == isActive ? FontWeight.bold : FontWeight.normal,
//               color:
//                   isApproved == isActive
//                       ? Colors.green.shade700
//                       : Colors.black54,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:clone/smart_giving/providers/auth_provider.dart';
import 'package:clone/smart_giving/utlis/common/loading_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

class ApprovalToggle extends StatefulWidget {
  const ApprovalToggle({super.key});

  @override
  _ApprovalToggleState createState() => _ApprovalToggleState();
}

class _ApprovalToggleState extends State<ApprovalToggle> {
  bool isApproved = true;
  List<Map<String, dynamic>> filteredData = [];
  bool isLoading = true;
  String? adminId;

  @override
  void initState() {
    super.initState();
    _fetchFilteredData();
  }

  Future<void> _fetchFilteredData() async {
    setState(() => isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    adminId = authProvider.userData?["id"];
    print("🔹 Admin ID: $adminId");

    try {
      QuerySnapshot usersSnapshot =
          await FirebaseFirestore.instance.collection("users").get();

      List<Map<String, dynamic>> allRecords = [];

      for (var userDoc in usersSnapshot.docs) {
        String userId = userDoc.id;
        QuerySnapshot recSnapshot =
            await FirebaseFirestore.instance
                .collection("users")
                .doc(userId)
                .collection("rec")
                .get();

        for (var doc in recSnapshot.docs) {
          Map<String, dynamic> record = doc.data() as Map<String, dynamic>;
          record['userId'] = userId;

          if (record["acptAdminId"] == adminId &&
              (isApproved
                  ? ["process", "completed"].contains(record["status"])
                  : ["cancel"].contains(record["status"]))) {
            allRecords.add(record);
          }
        }
      }

      setState(() {
        filteredData = allRecords;
        isLoading = false;
      });
    } catch (e) {
      print("❌ Error fetching data: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleButton(),
          const SizedBox(height: 20),
          Expanded(
            child:
                isLoading
                    ? LoadingScreen()
                    : filteredData.isEmpty
                    ? const Center(child: Text("No records found"))
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredData.length,
                      itemBuilder: (context, index) {
                        return SingleChildScrollView(
                          child: _buildRecordCard(filteredData[index]),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton() {
    return Container(
      height: 45,
      width: 260,
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment:
                isApproved ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: 125,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildToggleOption("Approved", true),
              _buildToggleOption("Rejected", false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToggleOption(String title, bool isActive) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            isApproved = isActive;
            _fetchFilteredData();
          });
        },
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight:
                  isApproved == isActive ? FontWeight.bold : FontWeight.normal,
              color: isApproved == isActive ? Colors.green : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecordCard(Map<String, dynamic> record) {
    Color cardColor;
    switch (record["status"]) {
      case "process":
        cardColor = Colors.blue.shade50;
        break;
      case "completed":
        cardColor = Colors.green.shade50;
        break;
      case "cancel":
        cardColor = Colors.red.shade50;
        break;
      default:
        cardColor = Colors.grey.shade200;
    }

    return Animate(
      effects: [FadeEffect(duration: 500.ms), SlideEffect(duration: 400.ms)],
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 6,
        color: cardColor,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (record.containsKey("name"))
                _buildInfoRow(Icons.person, record['name']),
              if (record.containsKey("mobile"))
                _buildInfoRow(Icons.phone, record['mobile']),
              if (record.containsKey("amount"))
                _buildInfoRow(
                  Icons.attach_money,
                  "₹${record['amount']}",
                  color: Colors.green.shade700,
                ),
              if (record.containsKey("projectType"))
                _buildInfoRow(
                  Icons.work,
                  record['projectType'],
                  color: Colors.red,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color ?? Colors.black87),
          SizedBox(width: 8),

          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: color ?? Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
