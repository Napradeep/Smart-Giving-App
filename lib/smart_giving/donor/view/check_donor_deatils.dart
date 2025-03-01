import 'package:clone/smart_giving/donor/Provider/donor_provider.dart';
import 'package:clone/smart_giving/providers/auth_provider.dart';
import 'package:clone/smart_giving/screens/custom_appbar.dart';
import 'package:clone/smart_giving/utlis/common/images.dart';
import 'package:clone/smart_giving/utlis/common/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart' show Provider;

class CheckDonorDeatils extends StatefulWidget {
  const CheckDonorDeatils({super.key});

  @override
  State<CheckDonorDeatils> createState() => _CheckDonorDeatilsState();
}

class _CheckDonorDeatilsState extends State<CheckDonorDeatils> {
  String? userId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final businessProvider = Provider.of<DonorProvider>(
        context,
        listen: false,
      );

      businessProvider.businessRecords.clear();

      userId = authProvider.userData?["id"];
      if (userId != null) {
        print(userId);
        await businessProvider.fetchDonorPayments(userId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final businessProvider = Provider.of<DonorProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(title: "Smart Giving App", image: donorImage),
      body:
          businessProvider.isLoading
              ? LoadingScreen()
              : businessProvider.businessRecords.isEmpty
              ? const Center(child: Text("No records found"))
              : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: EdgeInsets.only(top: 60),
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
                      rows: List.generate(
                        businessProvider.businessRecords.length,
                        (index) {
                          final data = businessProvider.businessRecords[index];
                          return DataRow(
                            color: WidgetStateColor.resolveWith(
                              (states) =>
                                  index.isEven
                                      ? Colors.grey.shade200
                                      : Colors.white,
                            ),
                            cells: [
                              DataCell(Center(child: Text("${index + 1}"))),
                              DataCell(Center(child: Text("${data["name"]}"))),
                              DataCell(
                                Center(child: Text("₹${data["amount"]}")),
                              ),
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
                        },
                      ),
                    ),
                  ),
                ),
              ),
    );
  }
}
