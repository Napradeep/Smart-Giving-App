// import 'package:flutter/material.dart';

// class FundRequestCard extends StatelessWidget {
//   final Map<String, dynamic> record;

//   const FundRequestCard({super.key, required this.record});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(10),
//       child: Container(
//         width: 300,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: Colors.black),
//         ),
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [

//             Row(
//               children: [
//                 const CircleAvatar(
//                   radius: 30,
//                   backgroundImage: AssetImage("assets/studnet.jpg"),
//                 ),
//                 const SizedBox(width: 12),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       record["name"] ?? "No Name",
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       record["mobile"] ?? "No Mobile",
//                       style: const TextStyle(fontSize: 14, color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const Divider(),
//             ListTile(
//               leading: const Icon(Icons.attach_money, color: Colors.green),
//               title: Text("Amount: ₹${record["amount"]}"),
//             ),
//             ListTile(
//               leading: const Icon(Icons.currency_rupee, color: Colors.blue),
//               title: Text("UPI: ${record["upi"]}"),
//             ),
//             ListTile(
//               leading: const Icon(Icons.person, color: Colors.orange),
//               title: Text("User Type: ${record["userType"]}"),
//             ),
//             ListTile(
//               leading: const Icon(Icons.work, color: Colors.red),
//               title: Text("Project: ${record["projectType"]}"),
//             ),
//             ListTile(
//               leading: Icon(
//                 record["status"] == "waiting"
//                     ? Icons.hourglass_empty
//                     : Icons.check_circle,
//                 color:
//                     record["status"] == "waiting"
//                         ? Colors.orange
//                         : Colors.green,
//               ),
//               title: Text("Status: ${record["status"]}"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:animate_do/animate_do.dart';
import 'package:clone/smart_giving/utlis/common/images.dart';
import 'package:flutter/material.dart';

class FundRequestCard extends StatefulWidget {
  final Map<String, dynamic> record;

  const FundRequestCard({super.key, required this.record});

  @override
  FundRequestCardState createState() => FundRequestCardState();
}

class FundRequestCardState extends State<FundRequestCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.9, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeOutBack,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserInfo(),
                const SizedBox(height: 10),
                Divider(color: Colors.grey[300], thickness: 1),
                const SizedBox(height: 8),
                _buildDetails(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// **🔹 User Profile Section**
  Widget _buildUserInfo() {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // ignore: deprecated_member_use
            border: Border.all(color: Colors.black.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              userIMage,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.person, size: 40, color: Colors.grey);
              },
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.record["name"],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                  letterSpacing: 0.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                widget.record["mobile"] ?? "No Mobile",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// **🔹 Details Section**
  Widget _buildDetails() {
    return Column(
      children: [
        _buildAnimatedTile(
          icon: Icons.attach_money,
          color: Colors.green,
          title: "Amount",
          subtitle: "₹${widget.record["amount"] ?? "0"}",
        ),
        _buildAnimatedTile(
          icon: Icons.currency_rupee,
          color: Colors.blue,
          title: "UPI",
          subtitle: widget.record["upi"] ?? "Not provided",
        ),
        _buildAnimatedTile(
          icon: Icons.person,
          color: Colors.orange,
          title: "Purpose",
          subtitle: widget.record["userType"] ?? "Unknown",
        ),
        _buildAnimatedTile(
          icon: Icons.work,
          color: Colors.red,
          title: "Project",
          subtitle: widget.record["projectType"] ?? "N/A",
        ),
        _buildAnimatedTile(
          icon:
              widget.record["status"] == "waiting"
                  ? Icons.hourglass_empty
                  : Icons.check_circle,
          color:
              widget.record["status"] == "waiting"
                  ? Colors.orange
                  : Colors.green,
          title: "Status",
          subtitle: widget.record["status"] ?? "Pending",
        ),
      ],
    );
  }

  /// **🔹 Animated ListTile**
  Widget _buildAnimatedTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return FadeInLeft(
      delay: const Duration(milliseconds: 200),
      child: ListTile(
        leading: Icon(icon, size: 26, color: color),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ),
    );
  }
}
