import 'package:clone/smart_giving/utlis/common/button.dart';
import 'package:clone/smart_giving/utlis/common/images.dart';
import 'package:flutter/material.dart';

class RequestContainer extends StatelessWidget {
  final String studentName;
  final String reason;
  final String feesAmout;
  final VoidCallback onTap;

  const RequestContainer({
    super.key,
    required this.studentName,
    required this.reason,
    required this.feesAmout, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              maxRadius: 30,
              backgroundColor: Colors.green.shade700,
              child: CircleAvatar(
                maxRadius: 27,
                backgroundImage: AssetImage(userIMage),
              ),
            ),
            title: Text(
              studentName,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Text(
              "Need for $reason",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Amount: ₹$feesAmout",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Button(
                borderRadius: BorderRadius.circular(8),
                color: Colors.blue,
                onpressed: onTap,
                texxt: "Donate",
                width: 80,
                height: 35,
                txtcolor: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
