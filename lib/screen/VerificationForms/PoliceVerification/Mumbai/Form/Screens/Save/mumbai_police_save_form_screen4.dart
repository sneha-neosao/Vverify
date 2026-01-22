import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/screen/VerificationForms/common/validator.dart';
import 'package:v_verify/widgets/custom_required_text_field.dart';

import '../../../../../../../commonComponent/custom_button.dart';
import '../../../../../common/form_widget.dart';
import 'mumbai_police_save_form_screen5.dart';
import '../../TextControllers/mumbai_police_text_controller.dart';

class MumbaiPoliceSaveFormScreen4 extends StatefulWidget {
  const MumbaiPoliceSaveFormScreen4({super.key});

  @override
  State<MumbaiPoliceSaveFormScreen4> createState() =>
      _MumbaiPoliceSaveFormScreen4State();
}

class _MumbaiPoliceSaveFormScreen4State
    extends State<MumbaiPoliceSaveFormScreen4> {
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tenant's Work Place Details",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).primaryColorDark,
                        ),
                  ),
                  CustomRequiredTextField(
                    maskFormatter: [mobileMaskFormatter],
                    validator: validateMobile,
                    textInputType: TextInputType.number,
                    controller: mumbaiTextController
                        .tenantMobileNumberWorkPlaceMumbaiController,
                    titleText: "Tenant's Mobile Number",
                    hintText: "Enter Mobile No",
                  ),
                  CustomRequiredTextField(
                    textInputType: TextInputType.text,
                    controller: mumbaiTextController
                        .tenantOccupationWorkPlaceMumbaiController,
                    titleText: "Tenant's Occupation",
                    hintText: "Enter Occupation",
                  ),
                  CustomRequiredTextField(
                    textInputType: TextInputType.text,
                    controller: mumbaiTextController
                        .tenantCityDistrictWorkPlaceMumbaiController,
                    titleText: "Tenant's City/District",
                    hintText: "Enter City/District",
                  ),
                  CustomRequiredTextField(
                    maskFormatter: [pinMask],
                    validator: validatePinCode,
                    textInputType: TextInputType.number,
                    controller: mumbaiTextController
                        .tenantPinCodeWorkPlaceMumbaiController,
                    titleText: "Tenant's Pin Code",
                    hintText: "Enter Pin Code",
                  ),
                  CustomRequiredTextField(
                    validator: validateEmail,
                    textInputType: TextInputType.text,
                    controller: mumbaiTextController
                        .tenantEmailIdWorkPlaceMumbaiController,
                    titleText: "Tenant's Email id",
                    hintText: "Enter Email id",
                  ),
                  CustomRequiredTextField(
                    validator: addressValidator,
                    textInputType: TextInputType.text,
                    controller: mumbaiTextController
                        .tenantAddressPlaceOfWorkPlaceMumbaiController,
                    titleText: "Address of Tenant's Place Of Work",
                    hintText: "Enter Address Place Of Work",
                  ),
                  CustomRequiredTextField(
                    textInputType: TextInputType.text,
                    controller:
                        mumbaiTextController.tenantStateWorkPlaceMumbaiController,
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
                              if (_formKey.currentState?.validate() ?? false) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MumbaiPoliceSaveFormScreen5()));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Please fill all fields')));
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
                  const SizedBox(height: 16)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
