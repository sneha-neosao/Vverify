import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/screen/VerificationForms/common/validator.dart';

import '../../../../../commonComponent/custom_button.dart';
import '../../../common/form_widget.dart';
import 'MumbaiPoliceVerificationForm5.dart';
import 'TextController/mumbai_text_controller.dart';

class MumbaiPoliceVerificationForm4 extends StatefulWidget {
  const MumbaiPoliceVerificationForm4({super.key});

  @override
  State<MumbaiPoliceVerificationForm4> createState() =>
      _MumbaiPoliceVerificationForm4State();
}

class _MumbaiPoliceVerificationForm4State
    extends State<MumbaiPoliceVerificationForm4> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
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
                form_widget(
                  maskFormatter: [mobileMaskFormatter],
                  validator: validateMobile,
                  textInputType: TextInputType.number,
                  controller: mumbaiTextController
                      .tenantMobileNumberWorkPlaceMumbaiController,
                  titleText: "Tenant's Mobile Number",
                  hintText: "Enter Mobile No",
                ),
                form_widget(
                  textInputType: TextInputType.text,
                  controller: mumbaiTextController
                      .tenantOccupationWorkPlaceMumbaiController,
                  titleText: "Tenant's Occupation",
                  hintText: "Enter Occupation",
                ),
                form_widget(
                  textInputType: TextInputType.text,
                  controller: mumbaiTextController
                      .tenantCityDistrictWorkPlaceMumbaiController,
                  titleText: "Tenant's City/District",
                  hintText: "Enter City/District",
                ),
                form_widget(
                  maskFormatter: [pinMask],
                  validator: validatePinCode,
                  textInputType: TextInputType.number,
                  controller: mumbaiTextController
                      .tenantPinCodeWorkPlaceMumbaiController,
                  titleText: "Tenant's Pin Code",
                  hintText: "Enter Pin Code",
                ),
                form_widget(
                  validator: validateEmail,
                  textInputType: TextInputType.text,
                  controller: mumbaiTextController
                      .tenantEmailIdWorkPlaceMumbaiController,
                  titleText: "Tenant's Email id",
                  hintText: "Enter Email id",
                ),
                form_widget(
                  validator: addressValidator,
                  textInputType: TextInputType.text,
                  controller: mumbaiTextController
                      .tenantAddressPlaceOfWorkPlaceMumbaiController,
                  titleText: "Address of Tenant's Place Of Work",
                  hintText: "Enter Address Place Of Work",
                ),
                form_widget(
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
                                          const MumbaiPoliceVerificationForm5()));
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
    );
  }
}
