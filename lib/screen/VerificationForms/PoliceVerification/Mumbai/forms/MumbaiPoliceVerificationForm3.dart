import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/screen/VerificationForms/common/pickphoto.dart';
import 'package:v_verify/screen/VerificationForms/common/validator.dart';

import '../../../../../commonComponent/custom_button.dart';
import '../../../common/form_widget.dart';
import 'MumbaiPoliceVerificationForm4.dart';
import 'TextController/mumbai_text_controller.dart';
import 'bloc/mumbaiPolice_verification_blocCubit.dart';

class MumbaiPoliceVerificationForm3 extends StatefulWidget {
  const MumbaiPoliceVerificationForm3({super.key});

  @override
  State<MumbaiPoliceVerificationForm3> createState() =>
      _MumbaiPoliceVerificationForm3State();
}

class _MumbaiPoliceVerificationForm3State
    extends State<MumbaiPoliceVerificationForm3> {
  // List of items in the dropdown menu
  final List<String> items = ['Pan', 'Aadhaar', 'Passport', 'Voter ID'];
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
                  " Tenant's Details",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).primaryColorDark,
                      ),
                ),
                form_widget(
                  textInputType: TextInputType.text,
                  controller: mumbaiTextController.tenantNameMumbaiController,
                  titleText: "Tenant's Name",
                  hintText: "Enter Tenant's Name",
                ),
                form_widget(
                  textInputType: TextInputType.text,
                  controller:
                      mumbaiTextController.tenantCityDistrictMumbaiController,
                  titleText: "Tenant's City/District",
                  hintText: "Enter Tenant's City/District",
                ),
                form_widget(
                  maskFormatter: [pinMask],
                  validator: validatePinCode,
                  textInputType: TextInputType.number,
                  controller:
                      mumbaiTextController.tenantPinCodeMumbaiController,
                  titleText: "Pin Code",
                  hintText: "Enter Pin Code",
                ),
                const SizedBox(
                  height: 16,
                ),
                RichText(
                    text: TextSpan(
                        text: "Identity Proof of Tenant's",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(fontWeight: FontWeight.w700),
                        children: [
                      TextSpan(
                        text: " * ",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w700, color: Colors.red),
                      ),
                    ])),
                const SizedBox(
                  height: 8,
                ),
                DropdownButtonFormField<String>(
                  validator: (value) {
                    if (value == null && value!.isEmpty) {
                      return "Please select identity proof of tenant";
                    }
                    return null;
                  },
                  focusColor: Theme.of(context).cardColor,
                  dropdownColor: Theme.of(context).cardColor,
                  hint: Text("Select a Identity Proof of Tenant's",
                      style: Theme.of(context).textTheme.bodySmall),
                  value: mumbaiSelectedValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      mumbaiSelectedValue = newValue;
                    });
                  },
                  items: items.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        textAlign: TextAlign.center,
                        value,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    );
                  }).toList(),
                ),
                form_widget(
                  textInputType: TextInputType.text,
                  controller: mumbaiTextController
                      .tenantIdentityProofNoMumbaiController,
                  titleText: "Tenant's Identity Proof no",
                  hintText: "Enter Identity Proof no",
                ),
                form_widget(
                  validator: addressValidator,
                  textInputType: TextInputType.text,
                  controller: mumbaiTextController
                      .tenantPermanentAddressMumbaiController,
                  titleText: "Tenant's Permanent Address",
                  hintText: "Enter Tenant's Permanent Address",
                ),
                form_widget(
                  textInputType: TextInputType.text,
                  controller: mumbaiTextController.tenantStateMumbaiController,
                  titleText: "State",
                  hintText: "Enter Tenant's State",
                ),
                form_widget(
                    maskFormatter: [validateNOMask],
                    validator: validateNO,
                    textInputType: TextInputType.number,
                    controller: mumbaiTextController.tenantNoOfMaleController,
                    titleText: "No. Of Male",
                    hintText: "Enter No. Of Male"),
                const SizedBox(
                  width: 4,
                ),
                form_widget(
                    maskFormatter: [validateNOMask],
                    validator: validateNO,
                    textInputType: TextInputType.number,
                    controller: mumbaiTextController.tenantNoOfFemaleController,
                    titleText: "No. Of Female",
                    hintText: "Enter No. Of Female"),
                const SizedBox(
                  width: 4,
                ),
                form_widget(
                    maskFormatter: [validateNOMask],
                    validator: validateNO,
                    textInputType: TextInputType.number,
                    controller: mumbaiTextController.tenantNoOfChildController,
                    titleText: "No. Of Child",
                    hintText: "Enter No. Of Child"),
                const SizedBox(
                  height: 16,
                ),
                BlocBuilder<TenantPhotoProfileImage, File>(
                    builder: (context, profileImage) {
                  return PickPhoto(
                    widthSize: double.infinity,
                    mainTitle: "Tenant's Photo",
                    onPressedPickImage: () {
                      context
                          .read<TenantPhotoProfileImage>()
                          .pickImageFromGallery()
                          .then((_) {
                        context.pop();
                      });
                    },
                    onPressedTakePhoto: () {
                      context
                          .read<TenantPhotoProfileImage>()
                          .pickImageFromCamera()
                          .then((_) {
                        context.pop();
                      });
                    },
                    title: 'Select Profile Image',
                    image: profileImage,
                  );
                }),
                const SizedBox(
                  height: 16,
                ),
                const SizedBox(
                  height: 8,
                ),
                BlocBuilder<TenantIdentityProofImage, File>(
                    builder: (context, identityProof) {
                  return PickPhoto(
                    widthSize: double.infinity,
                    mainTitle: "Upload Tenant's identity Proof",
                    onPressedPickImage: () {
                      context
                          .read<TenantIdentityProofImage>()
                          .pickFile()
                          .then((_) {
                        context.pop();
                      });
                    },
                    onPressedTakePhoto: () {
                      context
                          .read<TenantIdentityProofImage>()
                          .pickImageFromCamera()
                          .then((_) {
                        context.pop();
                      });
                    },
                    title: 'Select Profile Image',
                    image: identityProof,
                  );
                }),
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
                              if (context
                                      .read<TenantPhotoProfileImage>()
                                      .state
                                      .path
                                      .isEmpty ||
                                  context
                                      .read<TenantIdentityProofImage>()
                                      .state
                                      .path
                                      .isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("Please upload documents")));
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MumbaiPoliceVerificationForm4()));
                              }
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
