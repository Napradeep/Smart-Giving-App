import 'package:clone/smart_giving/utlis/common/spacers.dart';
import 'package:flutter/material.dart';

class AdminContainer extends StatelessWidget {
  final String image;
  final String viewTText;
  final String content;
  final VoidCallback onTap;
  const AdminContainer({
    super.key,
    required this.image,
    required this.viewTText,
    required this.content,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(vertical: 1, horizontal: 1),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),

        border: Border.all(color: Colors.black12, width: 2.0),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2)),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              maxRadius: 30,
              backgroundColor: Colors.green,
              child: CircleAvatar(
                maxRadius: 25,
                backgroundImage: AssetImage(image),
              ),
            ),
            title: Text(
              viewTText,
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: IconButton(
              onPressed: onTap,
              icon: Icon(Icons.arrow_forward_ios_sharp),
            ),
          ),

          vSpace18,
          Text(content, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
