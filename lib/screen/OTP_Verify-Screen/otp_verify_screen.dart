import 'dart:ui';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../commonComponent/bloc/shared_preferences_cubit.dart';
import '../../commonComponent/custom_button.dart';
import '../PushNotification/Bloc/push_notification_cubit.dart';
import '../PushNotification/firebase_token.dart';
import 'bloc/otpVerify_cubit.dart';
import 'bloc/otpVerify_state.dart';
import 'model/otpVerify_model.dart';

class OtpVerifyScreen extends StatefulWidget {
  String mobileNum;

  OtpVerifyScreen({super.key, required this.mobileNum});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  TextEditingController otpController = TextEditingController();

  void userOtpVerify(otp) {
    context
        .read<OtpVerifyCubit>()
        .otpVerify(mobileNumber: widget.mobileNum, otp: otp);
  }

  void saveUserData({required String id, required String token}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('id', id);
    await prefs.setString('token', token).then((value) {
      context.read<TokenCubit>().setToken(token);
      context.read<IdCubit>().setId(id);
      pushNotification();
      context.go('/bottomNav');
    });
  }

  void pushNotification() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    context.read<TokenCubit>().getToken();
    context.read<IdCubit>().getId().then((_) {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
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
          child: Padding(
            padding: const EdgeInsets.only(top: 80, left: 24, right: 24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  // A beautiful lock header icon or illustration
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.shield_outlined,
                      size: 72,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    "Verification Code",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "We have sent a 6-digit OTP code to\n",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600,
                            height: 1.5,
                          ),
                      children: [
                        TextSpan(
                          text: "+91-${widget.mobileNum}",
                          style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Pinput(
                    autofocus: true,
                    controller: otpController,
                    length: 6,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {},
                    onCompleted: (value) {},
                    defaultPinTheme: PinTheme(
                      width: 52,
                      height: 56,
                      textStyle: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        border:
                            Border.all(color: Colors.grey.shade300, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                    ),
                    focusedPinTheme: PinTheme(
                      width: 52,
                      height: 56,
                      textStyle: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        border: Border.all(
                            color: Theme.of(context).primaryColor, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .primaryColor
                                .withOpacity(0.15),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                    ),
                    submittedPinTheme: PinTheme(
                      width: 52,
                      height: 56,
                      textStyle: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        border:
                            Border.all(color: Colors.green.shade400, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  BlocProvider(
                    create: (_) => TimerCubit()..startTimer(),
                    child: BlocBuilder<TimerCubit, int>(
                        builder: (timerContext, timer) {
                      return GestureDetector(
                        onTap: timer == 0
                            ? () {
                                context
                                    .read<OtpVerifyCubit>()
                                    .resendOtp(mobileNumber: widget.mobileNum);
                                timerContext.read<TimerCubit>().resetTimer();
                                timerContext.read<TimerCubit>().startTimer();
                              }
                            : null,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: timer == 0
                                ? Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.06)
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: RichText(
                            text: TextSpan(
                              text: timer == 0
                                  ? "Didn't receive code? "
                                  : "Resend code in ",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.grey.shade600,
                                    fontSize: 13,
                                  ),
                              children: <TextSpan>[
                                timer == 0
                                    ? TextSpan(
                                        text: 'Resend OTP',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColorDark,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold))
                                    : TextSpan(
                                        text: '$timer s',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColorDark,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 48),
                  BlocConsumer<OtpVerifyCubit, OtpVerifyState>(
                      listener: (context, otpVerify) {
                    if (otpVerify is OtpVerifySuccess) {
                      OtpVerifyModel? data = otpVerify.otpVerifyModel;
                      if (data.status == 200) {
                        if (data.accountExist == 0) {
                          context.pushReplacementNamed("completeProfile",
                              pathParameters: {
                                'mobileNumber': widget.mobileNum
                              });
                        } else {
                          saveUserData(
                              id: data.result!.id.toString(),
                              token: data.token.toString());
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(data.message.toString())));
                      }
                    } else if (otpVerify is ResendOtpSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(otpVerify.message)));
                    } else if (otpVerify is ResendOtpError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(otpVerify.errorMessage)));
                    }
                  }, builder: (context, otpVerify) {
                    return CustomButton(
                      isLoading: otpVerify is OtpVerifyLoading,
                      onTap: () {
                        if (otpController.text.length == 6) {
                          userOtpVerify(otpController.text);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please enter 6-digit OTP')));
                        }
                      },
                      text: "Verify & Proceed",
                      gradientColors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColorLight
                      ],
                    );
                  }),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
