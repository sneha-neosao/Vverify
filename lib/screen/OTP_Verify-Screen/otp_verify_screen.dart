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
      pushNotification();
      context.go('/bottomNav');
    });
  }

  void pushNotification()async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    context.read<TokenCubit>().getToken();
    context.read<IdCubit>().getId().then((_){

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
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Enter OTP",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              textAlign: TextAlign.center,
              "We’ve sent an OTP code to your mobile number \n +91-${widget.mobileNum}",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Pinput(
                  controller: otpController,
                  length: 6,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {},
                  onCompleted: (value) {
                    print("OTP Completed: $value");
                  },
                  defaultPinTheme: PinTheme(
                    width: 48,
                    height: 48,
                    textStyle: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(color: const Color(0xFF8C8B8B)),
                    ),
                  ),
                  focusedPinTheme: PinTheme(
                    width: 48,
                    height: 48,
                    textStyle: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(color: Colors.blue),
                    ),
                  ),
                  submittedPinTheme: PinTheme(
                    width: 48,
                    height: 48,
                    textStyle: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(color: Colors.green),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            BlocProvider(
              create: (_) => TimerCubit()..startTimer(),
              child: BlocBuilder<TimerCubit, int>(builder: (context, timer) {
                return RichText(
                  text: TextSpan(
                    text: 'We will resend the code in ',
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: <TextSpan>[
                      timer == 0
                          ? TextSpan(
                              text: 'Resend OTP',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColorLight,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400))
                          : TextSpan(
                              text: '$timer s',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColorLight,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400)),
                    ],
                  ),
                );
              }),
            ),
            const SizedBox(
              height: 32,
            ),
            BlocConsumer<OtpVerifyCubit, OtpVerifyState>(
                listener: (context, otpVerify) {
              if (otpVerify is OtpVerifySuccess) {
                OtpVerifyModel? data = otpVerify.otpVerifyModel;
                if (data.status == 200) {
                  if (data.accountExist == 0) {
                    context.pushReplacementNamed("completeProfile",
                        pathParameters: {'mobileNumber': widget.mobileNum});
                  } else {
                    saveUserData(
                        id: data.result!.id.toString(),
                        token: data.token.toString());
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(data.message.toString())));
                }
              }
            }, builder: (context, otpVerify) {
              return CustomButton(
                isLoading: otpVerify is OtpVerifyLoading,
                onTap: () {
                  userOtpVerify(otpController.text);
                },
                text: "Verify",
                gradientColors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColorLight
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
