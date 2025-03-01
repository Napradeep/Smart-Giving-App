import 'package:flutter/material.dart';

class DonorTile extends StatelessWidget {
  final String donorImage;
  final String profileName;
  final String donorId;
  final String donorDetails; 
  final VoidCallback onViewDetails;
  final String? role;

  const DonorTile({
    super.key,
    required this.donorImage,
    required this.profileName,
    required this.donorId,
    required this.donorDetails,
    required this.onViewDetails,
    this.role,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      backgroundColor: Colors.white,
      onExpansionChanged: (isExpanded) {
        if (isExpanded) {
          onViewDetails(); 
        }
      },
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Donor Image
          CircleAvatar(backgroundImage: AssetImage(donorImage), radius: 20),
          const SizedBox(width: 10),

          // Donor Name & ID
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profileName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Donor ID: $donorId",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
      
      // Expanded Section
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "About Donor:",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                donorDetails,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
