import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/Mumbai/Form/Blocs/mumbai_police_verification_show_details_bloc/mumbai_police_show_details_cubit.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/Mumbai/Form/Blocs/mumbai_police_verification_show_details_bloc/mumbai_police_show_details_state.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/Mumbai/Form/Models/mumbai_police_show_details_model.dart';
import 'package:v_verify/screen/VerificationForms/common/pickphoto.dart';
import 'package:v_verify/screen/VerificationForms/common/validator.dart';

import '../../../../../../../commonComponent/custom_button.dart';
import '../../../../../common/form_widget.dart';
import '../../TextControllers/mumbai_police_text_controller.dart';
import '../../Blocs/mumbai_police_verification_save_bloc/mumbai_police_save_form_cubit.dart';
import 'mumbai_police_update_form_screen4.dart';

class MumbaiPoliceVerificationUpdateForm3 extends StatefulWidget {
  const MumbaiPoliceVerificationUpdateForm3({super.key});

  @override
  State<MumbaiPoliceVerificationUpdateForm3> createState() =>
      _MumbaiPoliceVerificationForm3State();
}

class _MumbaiPoliceVerificationForm3State
    extends State<MumbaiPoliceVerificationUpdateForm3> {
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
                      " Tenant's Details",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).primaryColorDark,
                          ),
                    ),
                    form_widget(
                      textInputType: TextInputType.text,
                      controller:
                          mumbaiTextController.tenantNameMumbaiController
                            ..text = data.data!.tenantName!,
                      titleText: "Tenant's Name",
                      hintText: "Enter Tenant's Name",
                    ),
                    form_widget(
                      textInputType: TextInputType.text,
                      controller: mumbaiTextController
                          .tenantCityDistrictMumbaiController,
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
                            text: "Identity Proof of Tenant",
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
                    SizedBox(
                      height: 50,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(gapPadding: 0)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            dropdownColor: Theme.of(context).cardColor,
                            hint: Text(data.data!.tenantIdentityProofDocType!,
                                style: Theme.of(context).textTheme.bodySmall),
                            value: mumbaiSelectedValue,
                            onChanged: (String? newValue) {
                              setState(() {
                                mumbaiSelectedValue = newValue;
                              });
                            },
                            items: items
                                .map<DropdownMenuItem<String>>((String value) {
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
                        ),
                      ),
                    ),
                    form_widget(
                      textInputType: TextInputType.number,
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
                      controller:
                          mumbaiTextController.tenantStateMumbaiController,
                      titleText: "State",
                      hintText: "Enter Tenant's State",
                    ),

                    form_widget(
                        maskFormatter: [validateNOMask],
                        validator: validateNO,
                        textInputType: TextInputType.number,
                        controller:
                            mumbaiTextController.tenantNoOfMaleController,
                        titleText: "No. Of Male",
                        hintText: "Enter No. Of Male"),
                    const SizedBox(
                      width: 4,
                    ),
                    form_widget(
                        maskFormatter: [validateNOMask],
                        validator: validateNO,
                        textInputType: TextInputType.number,
                        controller:
                            mumbaiTextController.tenantNoOfFemaleController,
                        titleText: "No. Of Female",
                        hintText: "Enter No. Of Female"),
                    const SizedBox(
                      width: 4,
                    ),
                    form_widget(
                        maskFormatter: [validateNOMask],
                        validator: validateNO,
                        textInputType: TextInputType.number,
                        controller:
                            mumbaiTextController.tenantNoOfChildController,
                        titleText: "No. Of Child",
                        hintText: "Enter No. Of Child"),
                    // SizedBox(
                    //   width: double.infinity,
                    //   child: Row(
                    //     children: [
                    //       Expanded(
                    //         child: form_widget(
                    //           validator: validateNO,
                    //             textInputType: TextInputType.number,
                    //             controller: mumbaiTextController.tenantNoOfMaleController,
                    //             titleText: "Co-resident",
                    //             hintText: "No. Of Male"),
                    //       ),
                    //       const SizedBox(
                    //         width: 4,
                    //       ),
                    //       Expanded(
                    //         child: form_widget(
                    //           validator: validateNO,
                    //             textInputType: TextInputType.number,
                    //             controller: mumbaiTextController.tenantNoOfFemaleController,
                    //             titleText: "",
                    //             hintText: "No. Of Female"),
                    //       ),
                    //       const SizedBox(
                    //         width: 4,
                    //       ),
                    //       Expanded(
                    //         child: form_widget(
                    //           validator: validateNO,
                    //             textInputType: TextInputType.number,
                    //             controller: mumbaiTextController.tenantNoOfChildController,
                    //             titleText: "",
                    //             hintText: "No. Of Child"),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    const SizedBox(
                      height: 16,
                    ),
                    BlocBuilder<TenantPhotoProfileImage, File>(
                        builder: (context, profileImage) {
                      return PickPhotoUpdate(
                          widthSize: double.infinity,
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
                          title: "Select Tenant's Photo",
                          image: profileImage,
                          uploadImage: data.data!.tenantPhoto!,
                          mainTitle: "Tenant's Photo");
                    }),
                    const SizedBox(
                      height: 16,
                    ),
                    BlocBuilder<TenantIdentityProofImage, File>(
                        builder: (context, identityProof) {
                      return PickPhotoUpdate(
                        widthSize: double.infinity,
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
                        title: 'select identity Proof',
                        image: identityProof,
                        uploadImage: data.data!.tenantIdentityProofDoc!,
                        mainTitle: "Upload Tenant's identity Proof",
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
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MumbaiPoliceVerificationUpdateForm4()));
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
    );
  }
}
