import 'dart:io';

import 'package:clone/smart_giving/admin/common/fund_table.dart';
import 'package:clone/smart_giving/admin/provider/view_fund_service.dart';
import 'package:clone/smart_giving/providers/auth_provider.dart';
import 'package:clone/smart_giving/screens/custom_appbar.dart';
import 'package:clone/smart_giving/utlis/common/button.dart';
import 'package:clone/smart_giving/utlis/common/images.dart';
import 'package:clone/smart_giving/utlis/common/spacers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';

class AdminViewFunds extends StatefulWidget {
  const AdminViewFunds({super.key});

  @override
  State<AdminViewFunds> createState() => _AdminViewFundsState();
}

class _AdminViewFundsState extends State<AdminViewFunds> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final businessProvider = Provider.of<ViewFundService>(
        context,
        listen: false,
      );

      await businessProvider.fetchAllBusinessRecords();
    });
  }

  Future<void> generatePdf() async {
    final pdf = pw.Document();
    final businessProvider = Provider.of<ViewFundService>(
      context,
      listen: false,
    );

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "Fund Details",
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              // ignore: deprecated_member_use
              pw.Table.fromTextArray(
                headers: ["S.No", "Name", "Amount", "Status", "Date", "Action"],
                data: List.generate(businessProvider.businessRecords.length, (
                  index,
                ) {
                  final data = businessProvider.businessRecords[index];
                  return [
                    index + 1,
                    data["name"],
                    "${data["amount"]}",
                    data["status"],
                    DateFormat('MMMM d, yyyy').format(
                      DateTime.fromMillisecondsSinceEpoch(
                        data["timestamp"].seconds * 1000,
                      ),
                    ),
                  ];
                }),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                border: pw.TableBorder.all(color: PdfColors.black),
                cellAlignment: pw.Alignment.center,
              ),
            ],
          );
        },
      ),
    );

    // Save PDF to device storage
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/Fund_details.pdf");
    await file.writeAsBytes(await pdf.save());

    // Open the saved PDF
    OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    final businessProvider = Provider.of<ViewFundService>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Smart giving App', image: adminImage),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            vSpace18,
            Text(
              "Check View Fund Requests",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            vSpace8,

            Expanded(child: FundTable()),
          ],
        ),
      ),

      bottomSheet:
          businessProvider.businessRecords.length == 0
              ? voidBox
              : Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 20,
                ),
                child: Button(
                  color: Colors.blue,
                  onpressed: generatePdf,
                  texxt: "Download",

                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  txtcolor: Colors.black,
                ),
              ),
    );
  }
}
