import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/screen/VerificationForms/GST_TIN_CIN/Save/Bloc/gst_pan_cin_save_cubit.dart';
import 'package:v_verify/screen/VerificationForms/common/form_widget.dart';
import 'package:v_verify/screen/VerificationForms/common/id.dart';

import 'Bloc/gst_pan_cin_save_state.dart';

class GstPanCinScreen extends StatefulWidget {
  const GstPanCinScreen({super.key});

  @override
  State<GstPanCinScreen> createState() => _GstPanCinScreenState();
}

class _GstPanCinScreenState extends State<GstPanCinScreen> {
  TextEditingController gstNumberController = TextEditingController();
  TextEditingController panNumberController = TextEditingController();
  TextEditingController cinNumberController = TextEditingController();

  @override
  void dispose() {
    gstNumberController.dispose();
    panNumberController.dispose();
    cinNumberController.dispose();
    super.dispose();
  }

  void gstPanCinSaveData() {
    String token = context.read<TokenCubit>().state;
    String customerId = context.read<IdCubit>().state;
    context.read<GstPanCinSaveCubit>().gstPanCinSaveData(
        customer_id: customerId,
        token: token,
        request_id: requestId!,
        service_request_id: serviceRequestId!,
        gst_number: gstNumberController.text.toUpperCase(),
        pan_number: panNumberController.text.toUpperCase(),
        cin_number: cinNumberController.text.toUpperCase());
  }

  String? validatePan(String? value) {
    // Check if the field is not empty and then validate
    if (value != null && value.isNotEmpty) {
      // Example validation: check if it's a valid email
      if (!RegExp(r"^[a-zA-Z]{5}[0-9]{4}[a-zA-Z]{1}$").hasMatch(value)) {
        return 'Please enter a valid PAN number';
      }
    }
    // Return null if valid or empty (valid for non-required fields)
    return null;
  }

  String? validateGst(String? value) {
    // Check if the field is not empty and then validate
    if (value != null && value.isNotEmpty) {
      // Example validation: check if it's a valid email
      if (!RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z][1-9A-Z]Z[0-9A-Z]$')
          .hasMatch(value)) {
        return 'Please enter a valid GST number.';
      }
    }
    // Return null if valid or empty (valid for non-required fields)
    return null;
  }

  String? validateCin(String? value) {
    // Check if the field is not empty and then validate
    if (value != null && value.isNotEmpty) {
      // Example validation: check if it's a valid email
      if (!RegExp(
              r"^[a-zA-Z]{1}[0-9]{5}[a-zA-Z]{2}[0-9]{4}[a-zA-Z]{3}[0-9]{6}$")
          .hasMatch(value)) {
        return 'Please enter a valid CIN number.';
      }
    }
    // Return null if valid or empty (valid for non-required fields)
    return null;
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "GST PAN CIN Verification",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Theme.of(context).primaryColorDark),
                ),
                const SizedBox(height: 16,),
                Text("Choose an Option:",style: Theme.of(context).textTheme.bodySmall),
                BlocProvider(
                  create: (_) => FormUploadGstPanCinCubit(),
                  child: BlocBuilder<FormUploadGstPanCinCubit, bool>(
                      builder: (context, frmUpload) {
                    return Column(
                      children: [
                        ListTile(
                          splashColor: Colors.transparent,
                          onTap: () {
                            context
                                .read<FormUploadGstPanCinCubit>()
                                .formUploadYesNo(yesNo: false);
                          },
                          contentPadding: const EdgeInsets.all(0),
                          leading: Icon(Icons.radio_button_checked,
                              color: !frmUpload
                                  ? Theme.of(context).primaryColorLight
                                  : Theme.of(context).iconTheme.color),
                          title: Text("Fill the Form Manually",
                              style: Theme.of(context).textTheme.bodySmall),
                        ),
                        ListTile(
                          splashColor: Colors.transparent,
                          onTap: () {
                            context.pushReplacementNamed("GstPanCinDocUpload");

                            context
                                .read<FormUploadGstPanCinCubit>()
                                .formUploadYesNo(yesNo: false);

                            context
                                .read<FormUploadGstPanCinCubit>()
                                .formUploadYesNo(yesNo: true);
                          },
                          contentPadding: const EdgeInsets.all(0),
                          leading: Icon(
                            Icons.radio_button_checked,
                            color: frmUpload
                                ? Theme.of(context).primaryColorLight
                                : Theme.of(context).iconTheme.color,
                          ),
                          title: Text("Upload Documents",
                              style: Theme.of(context).textTheme.bodySmall),
                        ),
                      ],
                    );
                  }),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                    "Note : At least one of GST, PAN, or CIN required"),
                const SizedBox(
                  height: 8,
                ),
                FormFieldNotRequired(
                  validator: validateGst,
                  controller: gstNumberController,
                  titleText: 'GST Number',
                  hintText: "Enter GST Number",
                  textInputType: TextInputType.text,
                ),
                FormFieldNotRequired(
                  validator: validatePan,
                  controller: panNumberController,
                  titleText: 'PAN Number',
                  hintText: "Enter PAN Number",
                  textInputType: TextInputType.text,
                ),
                FormFieldNotRequired(
                  validator: validateCin,
                  controller: cinNumberController,
                  titleText: 'CIN Number',
                  hintText: "Enter CIN Number",
                  textInputType: TextInputType.text,
                ),
                const SizedBox(
                  height: 24,
                ),
                BlocConsumer<GstPanCinSaveCubit, GstPanCinSaveState>(
                    listener: (context, gstPanCin) {
                  if (gstPanCin is GstPanCinSaveSuccessState) {
                    if (gstPanCin.data["status"] == 200) {
                      context.pushReplacementNamed("bottomNav");
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(gstPanCin.data["message"])));
                  } else if (gstPanCin is GstPanCinSaveErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(gstPanCin.message)));
                  }
                }, builder: (context, gstPanCin) {
                  return CustomButton(
                    isLoading: gstPanCin is GstPanCinSaveLoadingState,
                    text: "SUBMIT",
                    onTap: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        if (gstNumberController.text.isEmpty &&
                            panNumberController.text.isEmpty &&
                            cinNumberController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Please fill any one fields")));
                        } else {
                          gstPanCinSaveData();
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please fill all fields")));
                      }
                    },
                    gradientColors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColorDark
                    ],
                  );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
