// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:clone/smart_giving/admin/provider/view_fund_service.dart';
import 'package:clone/smart_giving/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FundTable extends StatefulWidget {
  const FundTable({super.key});

  @override
  State<FundTable> createState() => _FundTableState();
}

class _FundTableState extends State<FundTable> {
  String? AdminID;
  // bool isloading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final businessProvider = Provider.of<ViewFundService>(
        context,
        listen: false,
      );

      AdminID = authProvider.userData?["id"];
      print(AdminID);
      //if (userId != null) {
      await businessProvider.fetchAllBusinessRecords();
      // setState(() {
      //   isloading = false;
      // });
      // }
    });
  }

  Future<void> _updateStatus(
    BuildContext context,
    String userId,
    String docId,
    String newStatus,
    String AdminID,
  ) async {
    final businessProvider = Provider.of<ViewFundService>(
      context,
      listen: false,
    );

    try {
      setState(() {
        // isloading = true;
      });
      await businessProvider.updateFundStatus(
        userId,
        docId,
        newStatus,
        AdminID,
      );
      await businessProvider.fetchAllBusinessRecords();
    } catch (e) {
      setState(() {
        // isloading = false;
      });
      log("Error updating status: $e");
    }
  }

  void _showConfirmationDialog(
    BuildContext context,
    String userId,
    String docId,
    String newStatus,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Confirm Update"),
            content: Text("Are you sure you want to accept this fund request?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context); 
                  await _updateStatus(
                    context,
                    userId,
                    docId,
                    newStatus,
                    AdminID!,
                  );
                },

                child: Text("Confirm"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final businessProvider = Provider.of<ViewFundService>(context);
    print(AdminID);

    return 
    // isloading
    //     ? LoadingScreen()
        businessProvider.businessRecords.isEmpty
        ? Center(child: Text("No records found"))
        : SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 20,
              headingRowColor: WidgetStateColor.resolveWith(
                (states) => Colors.blue.shade100,
              ),
              border: TableBorder.all(color: Colors.black45),
              columns: const [
                DataColumn(label: Center(child: Text("S.No"))),
                DataColumn(label: Center(child: Text("Name"))),
                DataColumn(label: Center(child: Text("Amount"))),
                DataColumn(label: Center(child: Text("Status"))),
                DataColumn(label: Center(child: Text("Date"))),
                DataColumn(label: Center(child: Text("Action"))),
              ],
              rows: List.generate(businessProvider.businessRecords.length, (
                index,
              ) {
                final data = businessProvider.businessRecords[index];
                final userId = data["userId"];
                final docId = data["docId"];

                return DataRow(
                  color: WidgetStateColor.resolveWith(
                    (states) =>
                        index.isEven ? Colors.grey.shade200 : Colors.white,
                  ),
                  cells: [
                    DataCell(Center(child: Text("${index + 1}"))),
                    DataCell(Center(child: Text("${data["name"]}"))),
                    DataCell(Center(child: Text("₹${data["amount"]}"))),
                    DataCell(
                      Center(
                        child: Text(
                          data["status"],
                          style: TextStyle(
                            color:
                                data["status"] == "Paid"
                                    ? Colors.green
                                    : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Center(
                        child: Text(
                          DateFormat('MMMM d, yyyy').format(
                            DateTime.fromMillisecondsSinceEpoch(
                              data["timestamp"].seconds * 1000,
                            ),
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Row(
                        children: [
                          IconButton.filled(
                            onPressed:
                                () => _showConfirmationDialog(
                                  context,
                                  userId,
                                  docId,
                                  "process",
                                ),
                            icon: Icon(Icons.check, color: Colors.white),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                          ),
                          IconButton.filled(
                            onPressed:
                                () => _showConfirmationDialog(
                                  context,
                                  userId,
                                  docId,
                                  "cancel",
                                ),
                            icon: Icon(Icons.cancel, color: Colors.white),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        );
  }
}
