import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/commonComponent/screen_size.dart';
import 'package:v_verify/screen/Home%20screen/bloc/home_screen_state.dart';
import 'package:v_verify/screen/Home%20screen/bloc/home_screnn_cubit.dart';
import 'package:v_verify/screen/Home%20screen/model/home_Screen_model.dart';
import 'package:v_verify/screen/ProfileScreen/bloc/profile_cubit.dart';
import 'package:v_verify/screen/ProfileScreen/bloc/profile_state.dart';
import 'package:v_verify/screen/ProfileScreen/model/profile_model.dart';
import '../../commonComponent/check_internet.dart';
import '../../commonComponent/custom_button.dart';
import '../PushNotification/Bloc/push_notification_cubit.dart';
import '../PushNotification/firebase_token.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    context.read<TokenCubit>().getToken();
    context.read<IdCubit>().getId().then((value) {
      getProfile();
      loadEntity();
    });
    checkInternet(context);
    info();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void userTermsCondition() {
    showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            alignment: Alignment.center,
            backgroundColor: Theme.of(context).cardColor,
            title: Text(
              "Disclaimer",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            content: const Text(
              textAlign: TextAlign.justify,
              "By using our verification services, you acknowledge that we retrieve data from official sources and are not responsible for any inaccuracies. This includes Aadhaar, GST, CIN, PAN, police verification, address verification, reference checks, and driving license verification. Please ensure all details are correct before proceeding.",
            ),
            actions: <Widget>[
              BlocProvider(
                create: (_) => AgreeCheck(),
                child:
                    BlocBuilder<AgreeCheck, bool>(builder: (context, isCheck) {
                  return Column(
                    children: [
                      CheckboxListTile(
                        side: const BorderSide(color: Colors.red),
                        activeColor: Colors.green,
                        title: Text(
                          textAlign: TextAlign.center,
                          'Accept Terms and Conditions',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        value: isCheck,
                        onChanged: (value) {
                          context.read<AgreeCheck>().toggleCheckbox(value);
                        },
                        controlAffinity: ListTileControlAffinity
                            .leading, // Optional: Position the checkbox
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      BlocProvider(
                        create: (_) => UserTermsConditionCubit(ApiService()),
                        child: BlocConsumer<UserTermsConditionCubit,
                                UserTermsConditionState>(
                            listener: (context, agree) {
                          if (agree is UserTermsConditionSuccessState) {
                            if (agree.data["status"] == 200) {
                              context.pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Welcome to pehchaan360")));
                            }
                          } else if (agree is UserTermsConditionErrorState) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(agree.message)));
                          }
                        }, builder: (context, agree) {
                          return CustomButton(
                            isLoading: agree is UserTermsConditionLoadingState,
                            onTap: () {
                              if (isCheck) {
                                String token = context.read<TokenCubit>().state;
                                String id = context.read<IdCubit>().state;
                                context
                                    .read<UserTermsConditionCubit>()
                                    .termsCondition(
                                        token: token,
                                        customer_id: id,
                                        flag: "1");
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("Please click check-box")));
                              }
                            },
                            text: "Agree",
                            gradientColors: [
                              isCheck
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.5),
                              isCheck
                                  ? Theme.of(context).primaryColorDark
                                  : Theme.of(context)
                                      .primaryColorDark
                                      .withOpacity(0.5)
                            ],
                          );
                        }),
                      )
                    ],
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  void pushNotification() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    final String token = context.read<TokenCubit>().state;
    final String id = context.read<IdCubit>().state;
    context.read<PushNotificationCubit>().pushNotification(
        token: token,
        customerId: id,
        firebaseId: firebaseToken!,
        os_version: androidInfo.version.release,
        app_version: "1.0",
        mobile_model: androidInfo.model,
        device_type: "mobile");
  }

  void info() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print("print ${androidInfo.version.release}");
  }

  void userType({required String typeId}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userType', typeId).then((value) {
      context.read<UserTypeId>().getUserTypeId();
    });
  }

  void getProfile() {
    final String token = context.read<TokenCubit>().state;
    final String id = context.read<IdCubit>().state;
    print(token);
    print(id);
    context.read<ProfileCubit>().getProfile(token: token, id: id);
  }

  void loadEntity() {
    final String token = context.read<TokenCubit>().state;
    context.read<HomeScreenCubit>().getEntity(token: token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 16, right: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  BlocConsumer<ProfileCubit, ProfileState>(
                      listener: (context, profile) {
                    if (profile is ProfileSuccess) {
                      ProfileModel data = profile.profileModel;
                      if (data.profileResult!.isAgree == 0) {
                        userTermsCondition();
                      }

                      userType(
                          typeId: data.profileResult!.userTypeId.toString());
                    }
                  }, builder: (context, profile) {
                    if (profile is ProfileLoading) {
                      return ListTile(
                          title: Shimmer.fromColors(
                        baseColor: Colors.grey[400]!,
                        highlightColor: Colors.grey[50]!,
                        child: const Text("Name Loading",
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
                      return ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        // leading: Container(
                        //   decoration: BoxDecoration(
                        //     border: Border.all(
                        //         color: Theme.of(context).primaryColorDark,
                        //         width: 2),
                        //     borderRadius: BorderRadius.circular(100),
                        //   ),
                        //   width: 40,
                        //   height: 40,
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
                        title: Text(
                          data.profileResult!.userType?.toLowerCase() == "company"
                              ? "Hi ${data.profileResult!.companyName}"
                              : "Hi ${(("${data.profileResult!.firstName} ${data.profileResult!.lastName}").toUpperCase())}",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      );
                    }
                    return const Center(
                      child: Text("Error..."),
                    );
                  }),
                  Text(
                    "Whom do you want to Verify?",
                    style: GoogleFonts.outfit(
                      textStyle: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
              BlocBuilder<HomeScreenCubit, HomeScreenState>(
                buildWhen: (previous, current) {
                  // Only rebuild if the data has changed
                  if (previous is HomeScreenSuccessState &&
                      current is HomeScreenSuccessState) {
                    return previous.homeScreenModel != current.homeScreenModel;
                  }
                  return true;
                },
                builder: (context, entity) {
                  if (entity is HomeScreenLoadingState) {
                    return GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[400]!,
                          highlightColor: Colors.grey[50]!,
                          child: Container(
                              height: ScreenSize.screenHeight / 6,
                              width: ScreenSize.screenWidth / 6,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12))),
                        );
                      },
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                    );
                  } else if (entity is HomeScreenErrorState) {
                    return const Center(
                      child: Text("Something went wrong"),
                    );
                  } else if (entity is HomeScreenSuccessState) {
                    HomeScreenModel data = entity.homeScreenModel;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: data.data!.length,
                        itemBuilder: (context, index) {
                          return Material(
                            elevation: 4,
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                context.read<CountCubit>().clear();
                                showModalBottomSheet<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return BottomSheetWidget(
                                      entity_id:
                                          data.data![index].id.toString(),
                                      serviceName: data.data![index].entityName
                                          .toString(),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.network(
                                      data.data![index].entityIcon!,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.contain,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      textAlign: TextAlign.center,
                                      data.data![index].entityName!,
                                      style: GoogleFonts.outfit(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return const Center(
                    child: Text("error..."),
                  );
                },
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomSheetWidget extends StatelessWidget {
  String entity_id;
  String serviceName;

  BottomSheetWidget(
      {super.key, required this.entity_id, required this.serviceName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      height: ScreenSize.screenHeight / 2.5,
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(16), topLeft: Radius.circular(16))),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
                width: 60,
                height: 6,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(16))),
            const SizedBox(
              height: 24,
            ),
            Text(
              textAlign: TextAlign.center,
              'How many $serviceName you want to verify?',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 20),
            ),
            const SizedBox(
              height: 12,
            ),
            BlocBuilder<CountCubit, int>(builder: (context, count) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        context.read<CountCubit>().countRemove();
                      },
                      icon: const Icon(Icons.remove)),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    count.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 40),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  IconButton(
                      onPressed: () {
                        context.read<CountCubit>().countAdd();
                      },
                      icon: const Icon(Icons.add)),
                ],
              );
            }),
            const SizedBox(
              height: 32,
            ),
            CustomButton(
              onTap: () {
                context.pushNamed("servicesAndPrice",
                    pathParameters: {'id': entity_id});
                context.pop();

              },
              text: "Proceed",
              gradientColors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColorLight
              ],
            )
          ],
        ),
      ),
    );
  }
}
