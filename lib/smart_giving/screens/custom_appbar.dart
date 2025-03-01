import 'package:clone/smart_giving/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? image;

  const CustomAppBar({super.key, required this.title, this.image});

  @override
  Widget build(BuildContext context) {
    Provider.of<AuthProvider>(context, listen: false);

    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.green,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
      backgroundColor: Colors.grey.shade100,

      actions: [
        CircleAvatar(
          maxRadius: 25,
          backgroundColor: Colors.green,
          child: CircleAvatar(
            maxRadius: 23,
            backgroundImage: AssetImage(image ?? ""),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
