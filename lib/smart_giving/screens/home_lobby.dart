import 'package:clone/smart_giving/admin/views/admin_container.dart';
import 'package:clone/smart_giving/admin/views/admin_view_funds.dart';
import 'package:clone/smart_giving/admin/views/donor_deatils.dart';
import 'package:clone/smart_giving/admin/views/view_panel_deatils.dart';
import 'package:clone/smart_giving/donor/view/check_donor_deatils.dart';
import 'package:clone/smart_giving/donor/view/fund_request_screen.dart';
import 'package:clone/smart_giving/providers/auth_provider.dart';
import 'package:clone/smart_giving/screens/chec_donation_scrceen.dart';
import 'package:clone/smart_giving/screens/common_screen.dart'
    show CommonScreen;
import 'package:clone/smart_giving/user/reqest_fundscreen.dart';
import 'package:clone/smart_giving/user/view_fund_request.dart';
import 'package:clone/smart_giving/utlis/common/container_screen.dart';
import 'package:clone/smart_giving/utlis/common/images.dart';
import 'package:clone/smart_giving/utlis/common/spacers.dart';
import 'package:clone/smart_giving/utlis/navigator/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminPanel extends StatefulWidget {
  final String? role;
  const AdminPanel({super.key, this.role});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  String getUserImage(String? userType) {
    switch (userType) {
      case "ADMIN":
        return "assets/adminface.jpg";
      case "USER":
        return "assets/studnet.jpg";
      case "DONOR":
        return "assets/heping.jpg";
      default:
        return "assets/default_image.jpg";
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Smart Giving App",
          style: TextStyle(
            color: Colors.green,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.grey.shade100,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () {
              authProvider.logout();
              MyRouter.pushRemoveUntil(screen: CommonScreen());
            },
          ),
        ],
      ),

      body:
          authProvider.userData == null
              ? const Center(
                child: Text(
                  "No User Logged In",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Colors.grey.shade200,
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 52,
                              backgroundColor: Colors.green,
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage: AssetImage(
                                  authProvider.userData?["profile"] ??
                                      getUserImage(
                                        authProvider.userData?["userType"],
                                      ),
                                ),
                                backgroundColor: Colors.grey.shade300,
                              ),
                            ),
                            hSpace18,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Name: ${authProvider.userData!["name"]}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                vSpace4,
                                Text(
                                  "Mobile: ${authProvider.userData!["mobileno"]}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                                vSpace4,
                                Text(
                                  "Member:${authProvider.userData!["userType"]}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    vSpace8,
                    widget.role == "ADMIN"
                        ? Expanded(
                          child: ListView(
                            children: [
                              AdminContainer(
                                image: userIMage,
                                viewTText: 'View Request',
                                content:
                                    'Funded Dreams;Browse Student Request for support',
                                onTap: () {
                                  MyRouter.push(screen: AdminViewFunds());
                                },
                              ),
                              vSpace8,
                              AdminContainer(
                                image: donorImage,
                                viewTText: "View Donor's",
                                content:
                                    'Champions of Change: See Who"s Makking a Difference ',
                                onTap: () {
                                  MyRouter.push(screen: DonorDetails());
                                },
                              ),
                              vSpace8,

                              AdminContainer(
                                image: adminImage,
                                viewTText: 'View My Panel',
                                content:
                                    'Manage with Purpose Your Control Center for Smart Giving',
                                onTap: () {
                                  MyRouter.push(screen: ViewPanelDeatils());
                                },
                              ),
                            ],
                          ),
                        )
                        : widget.role == "DONOR"
                        ? Expanded(
                          child: ListView(
                            children: [
                              ReusableContainer(
                                title: 'Total Donation',
                                subtitle:
                                    'Upcoming Fund : \nStay Tuned ! New Funds Will launched soon',
                                onTap: () {
                                  MyRouter.push(screen: FundRequestScreen());
                                },
                                contion: 'View',
                              ),
                              vSpace8,
                              ReusableContainer(
                                title: 'Donation History',
                                subtitle:
                                    'Get an in-depth look at your donation activities-view the amounts,dates,and specific cauces you"ve supported over time',
                                onTap: () {
                                  MyRouter.push(screen: CheckDonorDeatils());
                                },
                                contion: 'Check',
                              ),
                            ],
                          ),
                        )
                        //user
                        : Expanded(
                          child: ListView(
                            children: [
                              ReusableContainer(
                                title: 'Request Fund',
                                subtitle:
                                    'Need funding? Submit your request now,and take the first step towards gettting the financial support you deserve',
                                onTap: () {
                                  MyRouter.push(screen: ReqestFundscreen());
                                },
                                contion: 'Request',
                              ),
                              vSpace8,
                              ReusableContainer(
                                title: 'View Fund Request',
                                subtitle:
                                    'Stay in control by monitoring your fund request,checking their approval stages and ensuring everything is on track',
                                onTap: () {
                                  MyRouter.push(screen: ViewFundRequest());
                                },
                                contion: 'View',
                              ),

                              vSpace8,
                              ReusableContainer(
                                title: 'Check Donation Deatils',
                                subtitle:
                                    "Gain a detailed insight into your donation activities—track the amounts, dates, and specific causes you've supported over time.",
                                onTap: () {
                                  MyRouter.push(screen: ChecDonationScrceen());
                                },
                                contion: 'Check',
                              ),
                            ],
                          ),
                        ),
                  ],
                ),
              ),
    );
  }
}
