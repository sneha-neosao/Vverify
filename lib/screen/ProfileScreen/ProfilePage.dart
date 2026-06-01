import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:v_verify/screen/ProfileScreen/bloc/profile_cubit.dart';
import 'package:v_verify/screen/ProfileScreen/bloc/profile_state.dart';
import 'package:v_verify/screen/ProfileScreen/bloc/sign_out_cubit.dart';
import 'package:v_verify/screen/ProfileScreen/bloc/sign_out_state.dart';

import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import '../../commonComponent/custom_button.dart';
import '../Bottom/bottomNavbar.dart';
import '../Order History/load_more/load_more.dart';
import 'package:v_verify/screen/ProfileScreen/model/profile_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void _showSignOutDialog(BuildContext parentContext,
      {required String token, required String customerId}) {
    showGeneralDialog(
      context: parentContext,
      barrierDismissible: true,
      barrierLabel: "SignOutDialog",
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.center,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Warning/LogOut Icon Container
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFEE2E2), // Soft red
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.logout_rounded,
                      color: Color(0xFFEF4444), // Crimson red
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Dialog Title
                  Text(
                    "Sign Out",
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Dialog Message
                  Text(
                    "Are you sure you want to sign out of your Vverify account? You will need to log in again to access your account.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      color: Theme.of(context).textTheme.bodySmall!.color,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Action Buttons Row
                  Row(
                    children: [
                      // Cancel Button
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              side: BorderSide(
                                color: Colors.grey.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              "Cancel",
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Confirm Sign Out Button
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: CustomButton(
                            onTap: () {
                              Navigator.of(context).pop();
                              parentContext.read<SignOutCubit>().signOut(
                                  token: token, customerId: customerId);
                            },
                            text: "Yes, Sign Out",
                            gradientColors: const [
                              Color(0xFFEF4444),
                              Color(0xFFDC2626),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.9, end: 1.0).animate(
            CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic),
          ),
          child: FadeTransition(
            opacity: anim1,
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String token = context.read<TokenCubit>().state;
    final String customerId = context.read<IdCubit>().state;

    return BlocListener<SignOutCubit, SignOutState>(
      listener: (context, state) {
        if (state is SignOutLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is SignOutSuccess) {
          Navigator.of(context).pop();
          selectedIndex = 0;
          context.go('/login');
        } else if (state is SignOutError) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    textAlign: TextAlign.left,
                    "Profile",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Theme.of(context).primaryColorLight),
                  ),
                ),
              ),

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
                        data.profileResult!.userTypeId == 1
                            ? "${data.profileResult!.firstName} ${data.profileResult!.lastName}" // show mobile if userType == 1
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
                                    .copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        data.profileResult!.userTypeId == 1
                            ? "+91-${data.profileResult!.mobileNumber}" // show mobile if userType == 1
                            : "+91-${data.profileResult!.companyHrNumber}", // show HR number if userType == 2
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0,
                        ),
                      ),
                      Text(
                        data.profileResult!.userTypeId == 1
                            ? "${data.profileResult!.email}" // show mobile if userType == 1
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
                          context.pushNamed(
                            "edit_profile",
                            pathParameters: {
                              'user_type': data.profileResult!.userType!
                            }, // must be non-empty
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
                        onTap: () {
                          _showSignOutDialog(context,
                              token: token, customerId: customerId);
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
