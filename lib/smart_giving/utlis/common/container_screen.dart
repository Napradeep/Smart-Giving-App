import 'package:flutter/material.dart';

class ReusableContainer extends StatelessWidget {
  final String title;
  final String subtitle;
  final String contion;
  final VoidCallback onTap;

  const ReusableContainer({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.contion,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 1, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),

        border: Border.all(color: Colors.black12, width: 2.0),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.black54)),
          Divider(color: Colors.black),
          InkWell(
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(contion),

                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.arrow_forward_ios_outlined),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
