import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/commonComponent/custom_button.dart';

import '../../common/id.dart';
import 'Bloc/aadhaar_verification_cubit.dart';
import 'Bloc/aadhaar_verification_state.dart';

class AadhaarGetOtp extends StatefulWidget {
  AadhaarGetOtp({super.key, required});

  @override
  State<AadhaarGetOtp> createState() => _AadhaarGetOtpState();
}

class _AadhaarGetOtpState extends State<AadhaarGetOtp> {
  TextEditingController aadhaarNumberController = TextEditingController();

  void aadhaarVerification() {
    String token = context.read<TokenCubit>().state;
    String customerId = context.read<IdCubit>().state;
    context.read<AadhaarGetOtpCubit>().aadhaarSendOtpForm(
        customer_id: customerId,
        requestId: requestId!,
        token: token,
        serviceRequestId: serviceRequestId!,
        aadhaarNumber: aadhaarNumberController.text.replaceAll("-", ""));
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    aadhaarNumberController.dispose();
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
              TextFormField(
                style: Theme.of(context).textTheme.bodySmall,
                keyboardType: TextInputType.number,
                inputFormatters: [maskFormatter],
                controller: aadhaarNumberController,
                decoration: InputDecoration(
                  hintText: "Enter Aadhaar Number",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).canvasColor, width: 1.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              BlocConsumer<AadhaarGetOtpCubit, AadhaarGetOtpState>(
                  listener: (context, aadhaarOtp) {
                if (aadhaarOtp is AadhaarGetOtpStateSuccessState) {
                  context.pushNamed("aadhaarVerifyOtp", pathParameters: {
                    "number": aadhaarNumberController.text,
                    "otp": aadhaarOtp.data["otp"]
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(aadhaarOtp.data["message"])));
                } else if (aadhaarOtp is AadhaarGetOtpStateErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(aadhaarOtp.message)));
                }
              }, builder: (context, aadhaarOtp) {
                return CustomButton(
                  isLoading: aadhaarOtp is AadhaarGetOtpStateLoadingState,
                  onTap: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      if (aadhaarNumberController.text.length > 13) {
                        aadhaarVerification();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text("Please validate aadhaar number")));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Please fill all fields")));
                    }
                  },
                  text: "SUBMIT",
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
