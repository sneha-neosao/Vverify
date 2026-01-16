import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/screen/VerificationForms/common/validator.dart';
import 'package:v_verify/widgets/custom_required_text_field.dart';

import '../../../../commonComponent/bloc/shared_preferences_cubit.dart';
import '../../common/form_widget.dart';
import '../../common/id.dart';
import '../Blocs/pan_save_form_bloc/pan_save_form_cubit.dart';
import '../Blocs/pan_save_form_bloc/pan_save_form_state.dart';

class PanSaveFormScreen extends StatefulWidget {
  const PanSaveFormScreen({super.key});

  @override
  State<PanSaveFormScreen> createState() => _PanSaveFormScreenState();
}

class _PanSaveFormScreenState extends State<PanSaveFormScreen> {
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
              Text(
                "Let's Verify PAN Card",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.orange)
              ),
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
                                content: Text("Please enter PAN number")));
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
