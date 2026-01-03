import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/screen/VerificationForms/PanVerification/update/Bloc/pan_verification_update_bloc.dart';
import 'package:v_verify/screen/VerificationForms/PanVerification/update/show/Bloc/pan_verification_show_cubit.dart';
import 'package:v_verify/screen/VerificationForms/PanVerification/update/show/Bloc/pan_verification_show_state.dart';
import 'package:v_verify/screen/VerificationForms/PanVerification/update/show/model/pan_verification_show_model.dart';

import '../../../../commonComponent/bloc/shared_preferences_cubit.dart';
import '../../common/form_widget.dart';
import '../../common/id.dart';
import 'Bloc/pan_verification_update_state.dart';

class PanVerificationUpdate extends StatefulWidget {
  String uid;

  PanVerificationUpdate({super.key, required this.uid});

  @override
  State<PanVerificationUpdate> createState() => _PanVerificationUpdateState();
}

class _PanVerificationUpdateState extends State<PanVerificationUpdate> {
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
        child: BlocProvider(
          create: (_) => PanVerificationShowCubit(ApiService())
            ..panCardNumberShow(
                token: token,
                uid: widget.uid,
                request_id: requestId!,
                service_request_id: serviceRequestId!,
                customer_id: customerId),
          child:
              BlocConsumer<PanVerificationShowCubit, PanVerificationShowState>(
                  listener: (context, showData) {
            if (showData is PanVerificationShowSuccessState) {
              PanVerificationShowModel data = showData.panVerificationShowModel;
              panVerificationController.text = data.data!.panNumber.toString();
            }
          }, builder: (context, panShowData) {
            return Form(
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
                  // const SizedBox(
                  //   height: 16,
                  // ),
                  // TextFormField(
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
                    create: (_) => PanVerificationUpdateBloc(ApiService()),
                    child: BlocConsumer<PanVerificationUpdateBloc,
                            PanVerificationUpdateState>(
                        listener: (context, panNumber) {
                      if (panNumber is PanVerificationUpdateSuccessState) {
                        if (panNumber.data["status"] == 200) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(panNumber.data["message"])));
                          context.pushReplacementNamed("bottomNav");
                        }
                      } else if (panNumber is PanVerificationUpdateErrorState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(panNumber.message)));
                      }
                    }, builder: (context, panNumber) {
                      return CustomButton(
                        isLoading:
                            panNumber is PanVerificationUpdateLoadingState,
                        onTap: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            context
                                .read<PanVerificationUpdateBloc>()
                                .panCardNumberUpdate(
                                    customer_id: customerId,
                                    requestId: requestId!,
                                    token: token,
                                    serviceRequestId: serviceRequestId!,
                                    panNumber: panVerificationController.text
                                        .toUpperCase());
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Please validate PAN number")));
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
            );
          }),
        ),
      ),
    );
  }
}
