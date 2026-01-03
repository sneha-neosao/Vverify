import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/screen/VerificationForms/common/form_widget.dart';
import 'package:v_verify/screen/VerificationForms/common/id.dart';

import 'Bloc/gst_pan_cin_update_cubit.dart';
import 'Bloc/gst_pan_cin_update_state.dart';
import 'ShowData/Bloc/GstPanCin_show_data_cubit.dart';
import 'ShowData/Bloc/GstPanCin_show_data_state.dart';
import 'ShowData/Model/GstPanCin_show_data_model.dart';

class GstPanCinUpdateScreen extends StatefulWidget {
  String uid;

  GstPanCinUpdateScreen({super.key, required this.uid});

  @override
  State<GstPanCinUpdateScreen> createState() => _GstPanCinUpdateScreenState();
}

class _GstPanCinUpdateScreenState extends State<GstPanCinUpdateScreen> {
  TextEditingController gstNumberController = TextEditingController();
  TextEditingController panNumberController = TextEditingController();
  TextEditingController cinNumberController = TextEditingController();

  @override
  void initState() {
    gstPanCinShowDataLoad();
    super.initState();
  }

  @override
  void dispose() {
    gstNumberController.dispose();
    panNumberController.dispose();
    cinNumberController.dispose();
    super.dispose();
  }

  void gstPanCinUpdateData() {
    String token = context.read<TokenCubit>().state;
    String customerId = context.read<IdCubit>().state;
    context.read<GstPanCinUpdateCubit>().gstPanCinUpdate(
        customer_id: customerId,
        token: token,
        request_id: requestId!,
        service_request_id: serviceRequestId!,
        gst_number: gstNumberController.text.toUpperCase(),
        pan_number: panNumberController.text.toUpperCase(),
        cin_number: cinNumberController.text.toUpperCase());
  }

  void gstPanCinShowDataLoad() {
    String token = context.read<TokenCubit>().state;
    context
        .read<GstPanCinShowDataCubit>()
        .gstPanCinShowData(token: token, uid: widget.uid);
  }

  final _formKey = GlobalKey<FormState>();

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
      if (!RegExp(r"^[0-9]{2}[0-9a-zA-Z]{10}[0-9]{1}[a-zA_Z]{1}[a-zA-Z]{1}$")
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
          child: BlocBuilder<GstPanCinShowDataCubit, GstPanCinShowDataState>(
              builder: (context, showData) {
            if (showData is GstPanCinShowDataLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (showData is GstPanCinShowDataErrorState) {
              return const Center(
                child: Text("Error..."),
              );
            } else if (showData is GstPanCinShowDataSuccessState) {
              GstPanCinShowDataModel data = showData.gstPanCinShowDataModel;
              return Form(
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
                    Text(
                      "Rejected Reason",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Colors.red),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      data.data!.reason!,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.red),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                        "Note : At least one of GST, PAN, or CIN required"),
                    const SizedBox(
                      height: 16,
                    ),
                    FormFieldNotRequired(
                        validator: validateGst,
                        controller: gstNumberController
                          ..text = data.data!.gstNumber ?? "",
                        titleText: "GST Number",
                        hintText: "Enter GST Number",
                        textInputType: TextInputType.text),
                    FormFieldNotRequired(
                        validator: validatePan,
                        controller: panNumberController
                          ..text = data.data!.panNumber ?? "",
                        titleText: "PAN Number",
                        hintText: "Enter PAN Number",
                        textInputType: TextInputType.text),
                    FormFieldNotRequired(
                        validator: validateCin,
                        controller: cinNumberController
                          ..text = data.data!.cinNumber ?? "",
                        titleText: "CIN Number",
                        hintText: "Enter CIN Number",
                        textInputType: TextInputType.text),
                    const SizedBox(
                      height: 24,
                    ),
                    BlocConsumer<GstPanCinUpdateCubit, GstPanCinUpdateState>(
                        listener: (context, gstPanCin) {
                      if (gstPanCin is GstPanCinUpdateSuccessState) {
                        if (gstPanCin.data["status"] == 200) {
                          context.pushReplacementNamed("bottomNav");
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(gstPanCin.data["message"])));
                      } else if (gstPanCin is GstPanCinUpdateErrorState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(gstPanCin.message)));
                      }
                    }, builder: (context, gstPanCin) {
                      return CustomButton(
                        isLoading: gstPanCin is GstPanCinUpdateLoadingState,
                        text: "SUBMIT",
                        onTap: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            gstPanCinUpdateData();
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
              );
            }
            return const Center(
              child: Text("Error..."),
            );
          }),
        ),
      ),
    );
  }
}
