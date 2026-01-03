import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/NonMumbai/Forms/textController/editcontroller.dart';
import 'package:v_verify/screen/VerificationForms/common/pickphoto.dart';

import '../../../common/form_widget.dart';
import '../../../common/validator.dart';
import 'Bloc/nonMumbai_verification_cubit.dart';
import 'NonMumbaiPoliceVerificationform2.dart';

class NonMumbaiPoliceVerification extends StatefulWidget {
  const NonMumbaiPoliceVerification({super.key});

  @override
  State<NonMumbaiPoliceVerification> createState() =>
      _NonMumbaiPoliceVerificationState();
}

class _NonMumbaiPoliceVerificationState
    extends State<NonMumbaiPoliceVerification> {
  // List of items in the dropdown menu
  final List<String> items = ['Pan', 'Aadhaar', 'Passport', 'Voter ID'];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    nonMumbaiControllerRecreate();
    super.initState();
  }

  @override
  void dispose() {
    nonMumbaiControllerCLear();
    super.dispose();
  }

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
                    "Police Verification For Non-Mumbai",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).primaryColorDark,
                        ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomButton(
                      height: 45,
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();

                        context.pushReplacementNamed("MumbaiForm");
                      },
                      text: "Mumbai Police Verification",
                      gradientColors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColorDark,
                      ]),
                  const SizedBox(
                    height: 16,
                  ),
                  Text("Choose an Option:",
                      style: Theme.of(context).textTheme.bodySmall),
                  BlocProvider(
                    create: (_) => FormUploadCubit(),
                    child: BlocBuilder<FormUploadCubit, bool>(
                        builder: (context, frmUpload) {
                      return Column(
                        children: [
                          ListTile(
                            splashColor: Colors.transparent,
                            onTap: () {
                              context
                                  .read<FormUploadCubit>()
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
                              context
                                  .pushReplacementNamed("nonMumbaiUploadDoc");

                              context
                                  .read<FormUploadCubit>()
                                  .formUploadYesNo(yesNo: false);

                              context
                                  .read<FormUploadCubit>()
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
                  Text(
                    "Tenant's Details",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 16),
                  ),
                  form_widget(
                    maskFormatter: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                    ],
                    textInputType: TextInputType.text,
                    controller: nonMumbaiTextController.tenantNameController,
                    titleText: "Tenant's Name",
                    hintText: "Enter Tenant's Name",
                  ),
                  form_widget(
                    validator: addressValidator,
                    textInputType: TextInputType.text,
                    controller:
                        nonMumbaiTextController.permanentAddressController,
                    titleText: "Tenant's Permanent Address",
                    hintText: "Enter Tenant's Permanent Address",
                  ),
                  form_widget(
                    textInputType: TextInputType.text,
                    controller: nonMumbaiTextController.cityDistrictController,
                    titleText: "Tenant's City/District",
                    hintText: "Enter City/District",
                  ),
                  form_widget(
                    textInputType: TextInputType.text,
                    controller: nonMumbaiTextController.stateController,
                    titleText: 'State',
                    hintText: "Enter State",
                  ),
                  form_widget(
                    maskFormatter: [pinMask],
                    validator: validatePinCode,
                    textInputType: TextInputType.number,
                    controller: nonMumbaiTextController.pinCodeController,
                    titleText: 'Pin Code',
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
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.red),
                        ),
                      ])),
                  const SizedBox(
                    height: 8,
                  ),
                  DropdownButtonFormField<String>(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Select Identity Proof';
                      }
                      return null;
                    },
                    focusColor: Theme.of(context).cardColor,
                    dropdownColor: Theme.of(context).cardColor,
                    hint: Text("Select a Identity Proof of Tenant's",
                        style: Theme.of(context).textTheme.bodySmall),
                    value: nonMumbaiSelectedIdProof,
                    onChanged: (String? newValue) {
                      setState(() {
                        nonMumbaiSelectedIdProof = newValue;
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
                    controller:
                        nonMumbaiTextController.identityProofNoController,
                    titleText: "Tenant's Identity Proof no",
                    hintText: "Enter Tenant's Identity Proof no",
                  ),
                  form_widget(
                    textInputType: TextInputType.text,
                    controller:
                        nonMumbaiTextController.identificationMarkController,
                    titleText: "Tenant's identification Mark",
                    hintText: "Enter Tenant's identification Mark",
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  BlocBuilder<NonMumbaiPhotoCubit, File>(
                      builder: (context, tenantPhoto) {
                    return PickPhoto(
                        mainTitle: "Tenant's Photo",
                        widthSize: 150,
                        onPressedPickImage: () {
                          context
                              .read<NonMumbaiPhotoCubit>()
                              .pickImageFromGallery()
                              .then((_) {
                            context.pop();
                          });
                        },
                        onPressedTakePhoto: () {
                          context
                              .read<NonMumbaiPhotoCubit>()
                              .pickImageFromCamera()
                              .then((_) {
                            context.pop();
                          });
                        },
                        title: "Select Tenant's Photo",
                        image: tenantPhoto);
                  }),
                  const SizedBox(
                    height: 16,
                  ),
                  BlocBuilder<NonMumbaiIdentityProof, File>(
                      builder: (context, identityProof) {
                    return PickPhoto(
                        mainTitle: "Upload Tenant's Identity Proof",
                        widthSize: double.infinity,
                        onPressedPickImage: () {
                          context
                              .read<NonMumbaiIdentityProof>()
                              .pickFile()
                              .then((_) {
                            context.pop();
                          });
                        },
                        onPressedTakePhoto: () {
                          context
                              .read<NonMumbaiIdentityProof>()
                              .pickImageFromCamera()
                              .then((_) {
                            context.pop();
                          });
                        },
                        title: "Select Identity proof Image",
                        image: identityProof);
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
                          },
                          text: "PREV",
                          gradientColors: [
                            Theme.of(context).primaryColor.withOpacity(0.5),
                            Theme.of(context).primaryColorDark.withOpacity(0.5),
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
                                        .read<NonMumbaiPhotoCubit>()
                                        .state
                                        .path
                                        .isEmpty ||
                                    context
                                        .read<NonMumbaiIdentityProof>()
                                        .state
                                        .path
                                        .isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text("Please upload Documents")));
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const NonMumbaiPoliceVerificationForm2()));
                                }
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
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
