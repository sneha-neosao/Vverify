import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/commonComponent/screen_size.dart';
import 'package:v_verify/screen/AllFormList/FormList/widgets/PoliceVerfication/Mumbai/police_verification_mumbai.dart';
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
  int cartCount = 0;

  @override
  void initState() {
    context.read<TokenCubit>().getToken();
    context.read<IdCubit>().getId().then((value) {
      getProfile();
      loadEntity();
    });
    checkInternet(context);
    info();
    _updateCartCount();
    super.initState();
  }

  Future<void> _updateCartCount() async {
    final prefs = await SharedPreferences.getInstance();
    final cartStr = prefs.getString('checkout_cart');
    if (cartStr != null) {
      final List<dynamic> cartItems = jsonDecode(cartStr);
      setState(() {
        cartCount = cartItems.length;
      });
    } else {
      setState(() {
        cartCount = 0;
      });
    }
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
        padding: const EdgeInsets.only(left: 16, right: 16),
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
                      return Skeletonizer(
                        enabled: true,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(0),
                          title: Container(
                            width: 150,
                            height: 20,
                            color: Colors.white,
                          ),
                        ),
                      );
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
                          data.profileResult!.userType?.toLowerCase() ==
                                  "company"
                              ? "Hi ${data.profileResult!.companyName}"
                              : "Hi ${(("${data.profileResult!.firstName} ${data.profileResult!.lastName}").toUpperCase())}",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        trailing: Stack(
                          children: [
                            IconButton(
                              onPressed: () async {
                                await context.pushNamed('checkOut');
                                _updateCartCount();
                              },
                              icon: Icon(
                                Icons.shopping_cart_outlined,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            if (cartCount > 0)
                              Positioned(
                                right: 8,
                                top: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 16,
                                    minHeight: 16,
                                  ),
                                  child: Text(
                                    '$cartCount',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    }
                    return const Center(
                      child: Text("Error..."),
                    );
                  }),
                  Text(
                    "Select Whom you want to verify",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Theme.of(context).primaryColorLight),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "To select a whom you want to verify, Click the icons below to select entities & verification services.",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.normal, color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: 16),
              BlocBuilder<HomeScreenCubit, HomeScreenState>(
                buildWhen: (previous, current) {
                  if (previous is HomeScreenSuccessState &&
                      current is HomeScreenSuccessState) {
                    return previous.homeScreenModel != current.homeScreenModel;
                  }
                  return true;
                },
                builder: (context, entity) {
                  if (entity is HomeScreenLoadingState) {
                    return Skeletonizer(
                      enabled: true,
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 6,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.2,
                        ),
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    width: 80,
                                    height: 12,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else if (entity is HomeScreenErrorState) {
                    return const Center(
                      child: Text("Something went wrong"),
                    );
                  } else if (entity is HomeScreenSuccessState) {
                    HomeScreenModel data = entity.homeScreenModel;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data.data?.length ?? 0,
                      itemBuilder: (context, groupIndex) {
                        final group = data.data![groupIndex];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  group.title?.toUpperCase() ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Divider(
                                    color: Theme.of(context).primaryColorLight,
                                    thickness: 1,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 1.2,
                              ),
                              itemCount: group.entities?.length ?? 0,
                              itemBuilder: (context, index) {
                                final item = group.entities![index];
                                return Material(
                                  elevation: 2,
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(12),
                                  child: Stack(
                                    children: [
                                      InkWell(
                                        borderRadius: BorderRadius.circular(12),
                                        onTap: () async {
                                          context.read<CountCubit>().clear();
                                          await context.pushNamed(
                                              "servicesAndPrice",
                                              pathParameters: {
                                                'id': item.id.toString()
                                              });
                                          _updateCartCount();
                                          // showModalBottomSheet<void>(
                                          //   context: context,
                                          //   builder: (BuildContext context) {
                                          //     return BottomSheetWidget(
                                          //       entity_id: item.id.toString(),
                                          //       serviceName:
                                          //           item.entityName.toString(),
                                          //     );
                                          //   },
                                          // );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          width: double.infinity,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.network(
                                                item.entityIcon!,
                                                width: 40,
                                                height: 40,
                                                fit: BoxFit.contain,
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                item.entityName!,
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.outfit(
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 4,
                                        right: 4,
                                        child: InkWell(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => Dialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                insetPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16),
                                                child: Container(
                                                  width: double.infinity,
                                                  padding:
                                                      const EdgeInsets.all(24),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              item.entityName!,
                                                              style: GoogleFonts
                                                                  .outfit(
                                                                textStyle: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .titleSmall!
                                                                    .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                          IconButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context),
                                                            icon: const Icon(
                                                                Icons.close),
                                                            padding:
                                                                EdgeInsets.zero,
                                                            constraints:
                                                                const BoxConstraints(),
                                                          ),
                                                        ],
                                                      ),
                                                      const Divider(height: 32),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Image.network(
                                                            item.entityIcon!,
                                                            width: 40,
                                                            height: 40,
                                                          ),
                                                          const SizedBox(
                                                              width: 16),
                                                          Expanded(
                                                            child: Text(
                                                              item.entityDescription ??
                                                                  "No description available.",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyMedium!
                                                                  .copyWith(
                                                                    height: 1.5,
                                                                    color: Colors
                                                                            .grey[
                                                                        700],
                                                                  ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .justify,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 32),
                                                      SizedBox(
                                                        width: double.infinity,
                                                        child: CustomButton(
                                                          onTap: () =>
                                                              Navigator.pop(
                                                                  context),
                                                          text: "Got It",
                                                          gradientColors: [
                                                            Theme.of(context)
                                                                .primaryColor,
                                                            Theme.of(context)
                                                                .primaryColorLight,
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          child: Icon(
                                            Icons.info_outline,
                                            size: 18,
                                            color: Colors.grey[400],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 24),
                          ],
                        );
                      },
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
