import 'dart:ui';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:v_verify/commonComponent/CustomMobileTextField.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/commonComponent/screen_size.dart';
import 'package:v_verify/screen/Login-Screen/bloc/login_cubit.dart';
import 'package:v_verify/screen/Login-Screen/bloc/login_state.dart';
import 'package:v_verify/screen/Login-Screen/model/login_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController mobileController = TextEditingController();

  void loginWithMobileNumber(mobileNum) async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("No internet connection please check your internet!"),
        backgroundColor: Colors.red,
      ));
    } else {
      context.read<LoginCubit>().Login(mobileNumber: mobileNum);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  var maskFormatter = MaskTextInputFormatter(
      mask: '##########', filter: {"#": RegExp(r'[0-9]')});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            image: const DecorationImage(
                opacity: 0.12,
                fit: BoxFit.fill,
                image: AssetImage(
                  "assets/images/splash.png",
                ))),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 75, left: 16, right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical:ScreenSize.screenHeight * 0.04),
                    child: Image.asset(
                      "assets/images/full_logo.png",
                      width: ScreenSize.screenWidth * 0.70,
                      height: ScreenSize.screenHeight * 0.12,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Image.asset(
                    "assets/images/login_page_logo.png",
                    width: ScreenSize.screenWidth * 0.8,
                    height: ScreenSize.screenHeight * 0.25,
                  ),
                  Text(
                    "Let's Verify!!",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                      textAlign: TextAlign.center,
                      "To get started, please enter your mobile \n number.",
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 32),
                  CustomMobileTextField(
                      formatter: [maskFormatter],
                      hintText: "Enter Mobile Number",
                      keyboardType: TextInputType.number,
                      controller: mobileController),
                  const SizedBox(height: 24),
                  BlocConsumer<LoginCubit, LoginState>(
                      listener: (context, login) {
                    if (login is LoginSuccess) {
                      LoginModel data = login.loginModel;
                      if (data.status == 200) {
                        context.pushNamed("otpVerifyScreen", pathParameters: {
                          'mobileNumber': mobileController.text
                        });
                      }
                    } else if (login is LoginError) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Something went wrong")));
                    }
                  }, builder: (context, login) {
                    return CustomButton(
                      isLoading: login is LoginLoading,
                      onTap: () {
                        loginWithMobileNumber(mobileController.text);
                      },
                      text: "Continue",
                      gradientColors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColorLight
                      ],
                    );
                  }),
                  const SizedBox(height: 34),
                  Text(
                    "By proceeding, I accept Pehchaan360’s",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Terms & Conditions ',
                      style: TextStyle(
                          color: Theme.of(context).primaryColorLight,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'and ',
                            style: Theme.of(context).textTheme.bodySmall),
                        TextSpan(
                          text: 'Privacy Policies.',
                          style: TextStyle(
                              color: Theme.of(context).primaryColorLight,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
