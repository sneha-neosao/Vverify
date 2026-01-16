import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/screen/VerificationForms/PanVerification/Blocs/pan_update_form_bloc/pan_update_form_cubit.dart';
import 'package:v_verify/screen/VerificationForms/PanVerification/Blocs/pan_show_details_bloc/pan_show_details_cubit.dart';
import 'package:v_verify/screen/VerificationForms/PanVerification/Blocs/pan_show_details_bloc/pan_show_details_state.dart';
import 'package:v_verify/screen/VerificationForms/PanVerification/Models/pan_show_details_model.dart';
import 'package:v_verify/screen/VerificationForms/common/validator.dart';
import 'package:v_verify/widgets/custom_required_text_field.dart';

import '../../../../commonComponent/bloc/shared_preferences_cubit.dart';
import '../../common/form_widget.dart';
import '../../common/id.dart';
import '../Blocs/pan_update_form_bloc/pan_update_form_state.dart';

class PanUpdateFormScreen extends StatefulWidget {
  String uid;

  PanUpdateFormScreen({super.key, required this.uid});

  @override
  State<PanUpdateFormScreen> createState() => _PanUpdateFormScreenState();
}

class _PanUpdateFormScreenState extends State<PanUpdateFormScreen> {
  String? rejection_reason;
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
              // rejection_reason = data.data!.reason;
              // setState(() {
              // });
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
                  Text(
                    "Let's Verify PAN Card",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.orange),
                  ),
                  // Text(
                  //   "Rejected Reason",
                  //   style: Theme.of(context)
                  //       .textTheme
                  //       .bodyLarge!
                  //       .copyWith(color: Colors.red),
                  // ),
                  // const SizedBox(
                  //   height: 4,
                  // ),
                  // Text(
                  //   rejection_reason ?? "",
                  //   style: Theme.of(context)
                  //       .textTheme
                  //       .bodySmall!
                  //       .copyWith(color: Colors.red),
                  // ),

                  const SizedBox(
                    height: 16,
                  ),
                  CustomRequiredTextField(
                      validator: validatePAN,
                      // maskFormatter: [panMaskFormatter],
                      controller: panVerificationController,
                      titleText: "Tenant's PAN Number",
                      hintText: "Enter Tenant's PAN Number",
                      textInputType: TextInputType.text
                  ),
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
