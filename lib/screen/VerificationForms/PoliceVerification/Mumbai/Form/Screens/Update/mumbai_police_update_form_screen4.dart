import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/Mumbai/Form/Blocs/mumbai_police_verification_show_details_bloc/mumbai_police_show_details_cubit.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/Mumbai/Form/Blocs/mumbai_police_verification_show_details_bloc/mumbai_police_show_details_state.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/Mumbai/Form/Models/mumbai_police_show_details_model.dart';
import 'package:v_verify/screen/VerificationForms/common/validator.dart';
import 'package:v_verify/widgets/custom_required_text_field.dart';

import '../../../../../../../commonComponent/custom_button.dart';
import '../../../../../common/form_widget.dart';
import '../../TextControllers/mumbai_police_text_controller.dart';
import 'mumbai_police_updtae_form_screen5.dart';

class MumbaiPoliceVerificationUpdateForm4 extends StatefulWidget {
  const MumbaiPoliceVerificationUpdateForm4({super.key});

  @override
  State<MumbaiPoliceVerificationUpdateForm4> createState() =>
      _MumbaiPoliceVerificationUpdateForm4State();
}

class _MumbaiPoliceVerificationUpdateForm4State
    extends State<MumbaiPoliceVerificationUpdateForm4> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
            child: Form(
              key: _formKey,
              child: BlocBuilder<MumbaiShowDataCubit, MumbaiShowDataState>(
                  builder: (context, mumbaiDataShow) {
                if (mumbaiDataShow is MumbaiShowDataLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (mumbaiDataShow is MumbaiShowDataErrorState) {
                  return Center(child: Text(mumbaiDataShow.message));
                } else if (mumbaiDataShow is MumbaiShowDataSuccessState) {
                  MumbaiShowDataModel data = mumbaiDataShow.mumbaiShowDataModel;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tenant's Work Place Details",
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              color: Theme.of(context).primaryColorDark,
                            ),
                      ),
                      CustomRequiredTextField(
                        validator: validateMobile,
                        textInputType: TextInputType.number,
                        controller: mumbaiTextController.tenantMobileNumberWorkPlaceMumbaiController,
                        titleText: "Tenant's Mobile Number",
                        hintText: "Enter Mobile No",
                      ),
                      CustomRequiredTextField(
                        textInputType: TextInputType.text,
                        controller: mumbaiTextController.tenantOccupationWorkPlaceMumbaiController,
                        titleText: "Tenant's Occupation",
                        hintText: "Enter Occupation",
                      ),
                      CustomRequiredTextField(
                        textInputType: TextInputType.text,
                        controller: mumbaiTextController.tenantCityDistrictWorkPlaceMumbaiController,
                        titleText: "Tenant's City/District",
                        hintText: "Enter City/District",
                      ),
                      CustomRequiredTextField(
                        maskFormatter: [pinMask],
                        validator: validatePinCode,
                        textInputType: TextInputType.number,
                        controller: mumbaiTextController.tenantPinCodeWorkPlaceMumbaiController,
                        titleText: "Tenant's Pin Code",
                        hintText: "Enter Pin Code",
                      ),
                      CustomRequiredTextField(
                        validator: validateEmail,
                        textInputType: TextInputType.text,
                        controller: mumbaiTextController.tenantEmailIdWorkPlaceMumbaiController,
                        titleText: "Tenant's Tenant's email id",
                        hintText: "Enter email id",
                      ),
                      CustomRequiredTextField(
                        validator: addressValidator,
                        textInputType: TextInputType.text,
                        controller: mumbaiTextController.tenantAddressPlaceOfWorkPlaceMumbaiController,
                        titleText: "Address of Tenant Place Of Work",
                        hintText: "Enter Address Place Of Work",
                      ),
                      CustomRequiredTextField(
                        textInputType: TextInputType.text,
                        controller: mumbaiTextController.tenantStateWorkPlaceMumbaiController,
                        titleText: "State",
                        hintText: "Enter State",
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              height: 45,
                              onTap: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                context.pop();
                              },
                              text: "PREV",
                              gradientColors: [
                                Theme.of(context).primaryColor,
                                Theme.of(context).primaryColorDark,
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: CustomButton(
                                height: 45,
                                onTap: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const MumbaiPoliceVerificationUpdateForm5()));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('Please fill all fields')));
                                  }
                                },
                                text: "NEXT",
                                gradientColors: [
                                  Theme.of(context).primaryColor,
                                  Theme.of(context).primaryColorDark,
                                ]),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      )
                    ],
                  );
                }
                return const Center(
                  child: Text("Error..."),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
