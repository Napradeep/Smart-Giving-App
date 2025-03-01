import 'package:clone/smart_giving/providers/bussiness_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class DonationTable extends StatefulWidget {
  const DonationTable({super.key});

  @override
  DonationTableState createState() => DonationTableState();
}

class DonationTableState extends State<DonationTable> {
  String? userId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final businessProvider = Provider.of<BusinessProvider>(
        context,
        listen: false,
      );

      userId = authProvider.userData?["id"];
      if (userId != null) {
        await businessProvider.fetchBusinessRecords(userId!);
        print("ennter...");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BusinessProvider>(
      builder: (context, businessProvider, child) {
        if (businessProvider.businessRecords.isEmpty) {
          return const Center(child: Text("No records found"));
        }
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 20,
              dataRowColor: WidgetStateColor.resolveWith((
                Set<WidgetState> states,
              ) {
                return states.contains(WidgetState.selected)
                    ? Colors.blue.withOpacity(0.2)
                    : Colors.transparent;
              }),
              headingRowColor: WidgetStateColor.resolveWith(
                (states) => Colors.blue.shade100,
              ),
              border: TableBorder.all(color: Colors.black45),
              columns: [
                DataColumn(label: Center(child: Text("S.No"))),
                DataColumn(label: Center(child: Text("Name"))),
                DataColumn(label: Center(child: Text("Amount"))),
                DataColumn(label: Center(child: Text("Status"))),
                DataColumn(label: Center(child: Text("Date"))),
              ],

              rows: List.generate(businessProvider.businessRecords.length, (
                index,
              ) {
                final data = businessProvider.businessRecords[index];
                return DataRow(
                  color: WidgetStateColor.resolveWith(
                    (states) =>
                        index.isEven ? Colors.grey.shade200 : Colors.white,
                  ), // Alternating row colors
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
                  ],
                );
              }),
            ),

            //  DataTable(
            //   columns: const [
            //     DataColumn(label: Center(child: Text("S.No"))),
            //     DataColumn(label: Center(child: Text("Amount"))),
            //     DataColumn(label: Center(child: Text("Status"))),
            //     DataColumn(label: Center(child: Text("Date"))),
            //   ],
            //   rows: List.generate(businessProvider.businessRecords.length, (
            //     index,
            //   ) {
            //     final data = businessProvider.businessRecords[index];
            //     return DataRow(
            //       cells: [
            //         DataCell(Center(child: Text("${index + 1}"))),
            //         DataCell(Center(child: Text("₹${data["amount"]}"))),
            //         DataCell(
            //           Center(
            //             child: Text(
            //               data["status"],
            //               style: TextStyle(
            //                 color:
            //                     data["status"] == "Paid"
            //                         ? Colors.green
            //                         : Colors.red,
            //                 fontWeight: FontWeight.bold,
            //               ),
            //             ),
            //           ),
            //         ),
            //         DataCell(
            //           Center(
            //             child: Text(
            //               DateFormat('MMMM d, yyyy').format(
            //                 DateTime.fromMillisecondsSinceEpoch(
            //                   data["timestamp"].seconds * 1000,
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
            //       ],
            //     );
            //   }),
            // ),
          ),
        );
      },
    );
  }
}
