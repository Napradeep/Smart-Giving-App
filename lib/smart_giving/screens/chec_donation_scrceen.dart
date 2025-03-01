// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:clone/smart_giving/providers/auth_provider.dart';
import 'package:clone/smart_giving/providers/bussiness_provider.dart';
import 'package:clone/smart_giving/screens/Donation_table.dart';
import 'package:clone/smart_giving/utlis/common/button.dart';
import 'package:clone/smart_giving/utlis/common/spacers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';

class ChecDonationScrceen extends StatefulWidget {
  const ChecDonationScrceen({super.key});

  @override
  State<ChecDonationScrceen> createState() => _ChecDonationScrceenState();
}

class _ChecDonationScrceenState extends State<ChecDonationScrceen> {
  Future<void> generatePdf() async {
    final pdf = pw.Document();
    final businessProvider = Provider.of<BusinessProvider>(
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
                "Donation Details",
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                headers: ["S.No", "Amount", "Status", "Date"],
                data: List.generate(businessProvider.businessRecords.length, (
                  index,
                ) {
                  final data = businessProvider.businessRecords[index];
                  return [
                    index + 1,
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
    final file = File("${dir.path}/donation_details.pdf");
    await file.writeAsBytes(await pdf.save());

    // Open the saved PDF
    OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
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
              "Welcome, ${authProvider.userData!["name"]}",
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
        actions: [
          CircleAvatar(
            maxRadius: 31,
            backgroundColor: Colors.green,
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              maxRadius: 25,
              backgroundImage: AssetImage("assets/studnet.jpg"),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Check Donation Details",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            vSpace18,
            Expanded(child: DonationTable()),
          ],
        ),
      ),
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
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
