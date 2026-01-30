import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:v_verify/screen/ProfileScreen/bloc/profile_cubit.dart';
import 'package:v_verify/screen/ProfileScreen/bloc/profile_state.dart';

import '../../commonComponent/custom_button.dart';
import '../Bottom/bottomNavbar.dart';
import '../Order History/load_more/load_more.dart';
import 'model/profile_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            children: [
              BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, profile) {
                if (profile is ProfileLoading) {
                  return ListTile(
                      title: Shimmer.fromColors(
                    baseColor: Colors.grey[400]!,
                    highlightColor: Colors.grey[50]!,
                    child: const Text("Profile Loading",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.41,
                        )),
                  ));
                } else if (profile is ProfileError) {
                  return const Center(
                    child: Text("Error"),
                  );
                } else if (profile is ProfileSuccess) {
                  ProfileModel data = profile.profileModel;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Container(
                      //   decoration: BoxDecoration(
                      //     border: Border.all(
                      //         color: Theme.of(context).primaryColorDark,
                      //         width: 2),
                      //     borderRadius: BorderRadius.circular(100),
                      //   ),
                      //   width: 80,
                      //   height: 80,
                      //   child: CircleAvatar(
                      //       radius: 40.0,
                      //       backgroundColor: Colors.white,
                      //       backgroundImage:
                      //           data.profileResult!.profilePhoto!.isEmpty
                      //               ? const AssetImage(
                      //                   "assets/images/profile_icon.png")
                      //               : NetworkImage(
                      //                   data.profileResult!.profilePhoto!)),
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      Text(
                        data.profileResult!.userType == "1"
                            ? "${data.profileResult!.firstName} ${data.profileResult!.lastName}"  // show mobile if userType == 1
                            : "${data.profileResult!.companyName}",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 37,
                        width: 130,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(48),
                          border: Border.all(
                            color: const Color(0xFFF67B3B),
                            width: 1,
                          ),
                          color: const Color(0xFFF67B3B).withOpacity(0.09),
                        ),
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.person,
                                size: 30,
                                color: Color(0xFFF67B3B),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "${data.profileResult!.userType}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        data.profileResult!.userType == "1"
                            ? "+91-${data.profileResult!.mobileNumber}"   // show mobile if userType == 1
                            : "+91-${data.profileResult!.companyHrNumber}",          // show HR number if userType == 2
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0,
                        ),
                      ),
                      Text(
                        data.profileResult!.userType == "1"
                            ? "${data.profileResult!.email}"  // show mobile if userType == 1
                            : "${data.profileResult!.companyEmail}",
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomButton(
                        text: "Edit Profile",
                        onTap: () {
                          context.pushNamed("edit_profile",
                            pathParameters: {'user_type': data.profileResult!.userType!}, // must be non-empty
                          );
                        },
                        gradientColors: const [
                          Color(0xFFEE3B27),
                          Color(0xFFFEC051),
                        ],
                        isLoading: false,
                        width: 107,
                        height: 43,
                      ),
                    ],
                  );
                }
                return const Center(
                  child: Text("Error..."),
                );
              }),

              // List of settings or actions below profile
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text("Order History",
                            style: Theme.of(context).textTheme.bodySmall),
                        trailing: Icon(
                          color: Theme.of(context).textTheme.bodySmall!.color,
                          Icons.arrow_forward_ios,
                          size: 20,
                        ),
                        onTap: () {
                          // context.pushNamed("order_history");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrderHistory()));
                        },
                      ),
                      ListTile(
                        title: Text("Privacy Policy",
                            style: Theme.of(context).textTheme.bodySmall),
                        trailing: Icon(
                          color: Theme.of(context).textTheme.bodySmall!.color,
                          Icons.arrow_forward_ios,
                          size: 20,
                        ),
                        onTap: () {
                          context.pushNamed("PrivacyPolicy");
                        },
                      ),
                      ListTile(
                        title: Text("Terms & Conditions",
                            style: Theme.of(context).textTheme.bodySmall),
                        trailing: Icon(
                          color: Theme.of(context).textTheme.bodySmall!.color,
                          Icons.arrow_forward_ios,
                          size: 20,
                        ),
                        onTap: () {
                          context.pushNamed("TermsConditions");
                        },
                      ),
                      ListTile(
                        title: Text("Refund Policy",
                            style: Theme.of(context).textTheme.bodySmall),
                        trailing: Icon(
                          color: Theme.of(context).textTheme.bodySmall!.color,
                          Icons.arrow_forward_ios,
                          size: 20,
                        ),
                        onTap: () {
                          context.pushNamed("RefundPolicy");
                        },
                      ),
                      ListTile(
                        title: Text(
                          "Sign Out",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        trailing: Icon(
                          color: Theme.of(context).textTheme.bodySmall!.color,
                          Icons.arrow_forward_ios,
                          size: 20,
                        ),
                        onTap: () async {
                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.remove('id');
                          await prefs.remove('userType');
                          await prefs.remove('token').then((_) {
                            selectedIndex = 0;
                            // Print the token after removal to verify
                            String? token = prefs.getString('token');
                            print('Token after removal: $token');
                            context.go('/login');
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
