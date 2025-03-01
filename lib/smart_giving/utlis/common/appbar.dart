import 'package:flutter/material.dart';

PreferredSize buildAppBar({
  String title = "SMART GIVING",
  String subtitle = "Connecting Donors to Educational Causes",
  Color backgroundColor = Colors.grey,
  Color titleColor = Colors.green,
  Color subtitleColor = Colors.black,
  IconData? leadingIcon,
  VoidCallback? onLeadingPressed,
  List<Widget>? actions,
}) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(56),
    child: AppBar(
      backgroundColor: Colors.grey.shade200,
      elevation: 5,
      leading:
          leadingIcon != null
              ? IconButton(
                icon: Icon(leadingIcon, color: titleColor),
                onPressed: onLeadingPressed,
              )
              : null, // If no icon is passed, leading is null
      title: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              subtitle,
              style: TextStyle(fontSize: 14, color: subtitleColor),
            ),
          ),
        ],
      ),
      actions: actions, // Pass optional actions
    ),
  );
}
