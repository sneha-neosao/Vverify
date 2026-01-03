import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';

import '../../../../commonComponent/custom_button.dart';
import '../../common/form_widget.dart';
import '../../common/id.dart';
import 'bloc/aadhaarVerifyOtp_cubit.dart';
import 'bloc/aadhaarVerifyOtp_state.dart';

class AadhaarVerifyOtp extends StatefulWidget {
  String number;
  String otp;

  AadhaarVerifyOtp({super.key, required this.number, required this.otp});

  @override
  State<AadhaarVerifyOtp> createState() => _AadhaarVerifyOtpState();
}

class _AadhaarVerifyOtpState extends State<AadhaarVerifyOtp> {
  TextEditingController aadhaarNumberController = TextEditingController();
  TextEditingController aadhaarOtpVerifyController = TextEditingController();

  void aadhaarVerifyOtp() {
    String token = context.read<TokenCubit>().state;
    String customerId = context.read<IdCubit>().state;
    context.read<AadhaarVerifyOtpCubit>().aadhaarVerifyOtp(
        token: token,
        serviceRequestId: serviceRequestId!,
        aadhaarNumber: aadhaarNumberController.text.replaceAll("-", ""),
        otp: aadhaarOtpVerifyController.text,
        requestId: requestId!, customerId: customerId);
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    aadhaarNumberController.dispose();
    aadhaarOtpVerifyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var maskFormatter = MaskTextInputFormatter(
        mask: '####-####-####', filter: {"#": RegExp(r'[0-9]')});
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Aadhaar Verification",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Theme.of(context).primaryColorDark),
              ),
              const SizedBox(
                height: 16,
              ),
              RichText(
                  text: TextSpan(
                      text: "Aadhaar Card Number",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontWeight: FontWeight.w700),
                      children: [
                    TextSpan(
                      text: " * ",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w700, color: Colors.red),
                    ),
                  ])),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                readOnly: true,
                keyboardType: TextInputType.none,
                controller: aadhaarNumberController..text = widget.number,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: Theme.of(context).canvasColor, width: 1.0),
                  ),
                  hintStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: Theme.of(context).canvasColor, width: 1.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18.0,
                    vertical: 14.0,
                  ),
                  filled: true,
                  // fillColor: Colors.white,
                ),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.grey),
              ),
              form_widget(
                  textInputType: TextInputType.number,
                  controller: aadhaarOtpVerifyController..text = widget.otp,
                  titleText: "OTP",
                  hintText: "Enter OTP"),
              const SizedBox(
                height: 24,
              ),
              BlocConsumer<AadhaarVerifyOtpCubit, AadhaarVerifyOtpState>(
                  listener: (context, aadhaarOtp) {
                if (aadhaarOtp is AadhaarVerifyOtpErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(aadhaarOtp.message)));
                } else if (aadhaarOtp is AadhaarVerifyOtpSuccessState) {
                  if (aadhaarOtp.data["status"] == 200) {
                    context.pushReplacementNamed("bottomNav");
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(aadhaarOtp.data["message"])));
                }
              }, builder: (context, aadhaarOtp) {
                return CustomButton(
                  isLoading: aadhaarOtp is AadhaarVerifyOtpLoadingState,
                  onTap: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      aadhaarVerifyOtp();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Please Fill All Fields")));
                    }
                  },
                  text: "Verify OTP",
                  gradientColors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColorDark
                  ],
                );
              }),
              const SizedBox(height: 16)
            ],
          ),
        ),
      ),
    );
  }
}
