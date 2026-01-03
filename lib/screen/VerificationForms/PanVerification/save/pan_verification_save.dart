import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'package:v_verify/commonComponent/custom_button.dart';

import '../../../../commonComponent/bloc/shared_preferences_cubit.dart';
import '../../common/form_widget.dart';
import '../../common/id.dart';
import 'Bloc/pan_verification_save_bloc.dart';
import 'Bloc/pan_verification_save_state.dart';

class PanVerificationSave extends StatefulWidget {
  const PanVerificationSave({super.key});

  @override
  State<PanVerificationSave> createState() => _PanVerificationSaveState();
}

class _PanVerificationSaveState extends State<PanVerificationSave> {
  final panMaskFormatter = MaskTextInputFormatter(
    mask: 'AAAAA####A',
    filter: {"A": RegExp(r'[A-Za-z]'), "#": RegExp(r'[0-9]')},
  );
  TextEditingController panVerificationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String token = context.read<TokenCubit>().state;
    String customerId = context.read<IdCubit>().state;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "PAN Card Verification",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Theme.of(context).primaryColorDark),
              ),
              const SizedBox(
                height: 16,
              ),
              Center(
                  child: Text(
                "Let's Verify PAN Card",
                style: Theme.of(context).textTheme.bodyLarge,
              )),
              // Center(
              //     child: Text(
              //   "Tenant's PAN number",
              //   style: Theme.of(context).textTheme.bodySmall,
              // )),
              const SizedBox(
                height: 16,
              ),
              form_widget(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter PAN card number';
                    }
                    final emailRegExp =
                        RegExp(r'^[A-Z]{3}[PCHABGJLFT][A-Z][0-9]{4}[A-Z]$');
                    if (!emailRegExp.hasMatch(value)) {
                      return 'Please enter a valid PAN card';
                    }
                    return null;
                  },
                  maskFormatter: [panMaskFormatter],
                  controller: panVerificationController,
                  titleText: "Tenant's PAN number",
                  hintText: "Enter Tenant's PAN number",
                  textInputType: TextInputType.text),
              // TextFormField(
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter PAN card number';
              //     }
              //     final emailRegExp =
              //         RegExp(r'^[A-Z]{3}[PCHABGJLFT][A-Z][0-9]{4}[A-Z]$');
              //     if (!emailRegExp.hasMatch(value)) {
              //       return 'Please enter a valid PAN card';
              //     }
              //     return null;
              //   },
              //   textCapitalization: TextCapitalization.characters,
              //   style: Theme.of(context).textTheme.bodySmall,
              //   keyboardType: TextInputType.text,
              //   inputFormatters: [panMaskFormatter],
              //   controller: panVerificationController,
              //   decoration: InputDecoration(
              //     hintText: "Enter PAN Number",
              //     focusedBorder: OutlineInputBorder(
              //       borderSide: BorderSide(
              //           color: Theme.of(context).canvasColor, width: 1.0),
              //     ),
              //   ),
              // ),
              const SizedBox(
                height: 24,
              ),
              BlocProvider(
                create: (_) => PanVerificationSaveBloc(ApiService()),
                child: BlocConsumer<PanVerificationSaveBloc,
                    PanVerificationSaveState>(listener: (context, panNumber) {
                  if (panNumber is PanVerificationSaveSuccessState) {
                    if (panNumber.data["status"] == 200) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(panNumber.data["message"])));
                      context.pushReplacementNamed("bottomNav");
                    }
                  } else if (panNumber is PanVerificationSaveErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(panNumber.message)));
                  }
                }, builder: (context, panNumber) {
                  return CustomButton(
                    isLoading: panNumber is PanVerificationSaveLoadingState,
                    onTap: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        print("click");
                        context
                            .read<PanVerificationSaveBloc>()
                            .panCardNumberSave(
                                customer_id: customerId,
                                requestId: requestId!,
                                token: token,
                                serviceRequestId: serviceRequestId!,
                                panNumber: panVerificationController.text
                                    .toUpperCase());
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please validate PAN number")));
                      }
                    },
                    text: "SUBMIT",
                    gradientColors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColorDark
                    ],
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
