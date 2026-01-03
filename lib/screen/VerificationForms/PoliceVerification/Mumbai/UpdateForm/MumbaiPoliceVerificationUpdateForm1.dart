import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/Mumbai/UpdateForm/showDetails/Bloc/mumbaiShowData_cubit.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/Mumbai/UpdateForm/showDetails/Bloc/mumbaiShowData_state.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/Mumbai/UpdateForm/showDetails/Model/MumbaiShowData_model.dart';
import 'package:v_verify/screen/VerificationForms/common/pickphoto.dart';
import 'package:v_verify/screen/VerificationForms/common/validator.dart';

import '../../../../../commonComponent/custom_button.dart';
import '../../../common/form_widget.dart';
import '../PoliceStationId/Bloc/police_station_id_cubit.dart';
import '../PoliceStationId/Bloc/police_station_id_state.dart';
import '../PoliceStationId/model/police_station_city_id_model.dart';
import '../PoliceStationId/model/police_station_id_model.dart';
import '../forms/TextController/mumbai_text_controller.dart';
import '../forms/bloc/mumbaiPolice_verification_blocCubit.dart';
import 'MumbaiPoliceVerificationUpdateForm2.dart';

class MumbaiPoliceVerificationUpdateForm1 extends StatefulWidget {
  String uid;

  MumbaiPoliceVerificationUpdateForm1({super.key, required this.uid});

  @override
  State<MumbaiPoliceVerificationUpdateForm1> createState() =>
      _MumbaiPoliceVerificationUpdateForm1State();
}

class _MumbaiPoliceVerificationUpdateForm1State
    extends State<MumbaiPoliceVerificationUpdateForm1> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    mumbaiControllerRecreate();
    mumbaiShowDataLoad();
    policeStationCityIdLoadData();
    super.initState();
  }

  @override
  void dispose() {
    clearMumbaiController();
    super.dispose();
  }

  void mumbaiShowDataLoad() {
    String token = context.read<TokenCubit>().state;

    context
        .read<MumbaiShowDataCubit>()
        .mumbaiShowData(token: token, uid: widget.uid);
  }

  void policeStationIdLoadData({String? city_id}) {
    String token = context.read<TokenCubit>().state;
    context
        .read<PoliceStationIdCubit>()
        .policeStationList(token: token, city_id: city_id!);
  }

  void policeStationCityIdLoadData() {
    String token = context.read<TokenCubit>().state;
    context
        .read<PoliceStationCityIdCubit>()
        .policeStationCityList(token: token);
  }

  String? policeStationName;
  String? policeStationCityName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: BlocConsumer<MumbaiShowDataCubit, MumbaiShowDataState>(
                listener: (context, mumbaiDataShow) {
              if (mumbaiDataShow is MumbaiShowDataSuccessState) {
                MumbaiShowDataModel showData =
                    mumbaiDataShow.mumbaiShowDataModel;

                mumbaiTextController.ownerMobileNumberMumbaiController.text =
                    showData.data!.ownerMobNo!;

                mumbaiTextController.ownerAddressMumbaiController.text =
                    showData.data!.ownerAddress!;

                mumbaiTextController.ownerStateMumbaiController.text = showData.data!.ownerState!;

                mumbaiTextController.ownerFullNameMumbaiController.text =
                    showData.data!.ownerFullName!;

                mumbaiTextController.ownerEmailAddressMumbaiController.text =
                    showData.data!.ownerEmail!;

                // ownerCityDistrictMumbaiController.text =
                //     showData.data!.ownerCityDistrict!.toString();

                mumbaiTextController.ownerPinCodeMumbaiController.text =
                    showData.data!.ownerPostalCode!;

                mumbaiTextController.rentedPropertyAddressMumbaiController.text =
                    showData.data!.rentedAddress.toString();

                mumbaiTextController.rentedPropertyStateMumbaiController.text =
                    showData.data!.rentedState.toString();

                mumbaiTextController.rentedPropertyCityDistrictMumbaiController.text =
                    showData.data!.rentedCity.toString();

                mumbaiTextController.rentedPropertyPinCodeMumbaiController.text =
                    showData.data!.rentedPostalCode.toString();

                mumbaiTextController.tenantNameMumbaiController.text = showData.data!.tenantName!;

                mumbaiTextController.tenantCityDistrictMumbaiController.text =
                    showData.data!.tenantCity!;

                mumbaiTextController.tenantPinCodeMumbaiController.text =
                    showData.data!.tenantPostalCode!;

                mumbaiTextController.tenantIdentityProofNoMumbaiController.text =
                    showData.data!.tenantIdentityProofNo!;

                mumbaiTextController.tenantPermanentAddressMumbaiController.text =
                    showData.data!.tenantAddress!;

                mumbaiTextController.tenantStateMumbaiController.text = showData.data!.tenantState!;

                mumbaiTextController.tenantNoOfMaleController
                  .text = showData.data!.tenantCoResidentMalesNo!;

                mumbaiTextController.tenantNoOfFemaleController.text =
                    showData.data!.tenantCoResidentFemalesNo!;

                mumbaiTextController.tenantNoOfChildController.text =
                    showData.data!.tenantCoResidentChildrenNo!;

                mumbaiTextController.tenantMobileNumberWorkPlaceMumbaiController.text =
                    showData.data!.tenantWorkPhone!;

                mumbaiTextController.tenantOccupationWorkPlaceMumbaiController.text =
                    showData.data!.tenantOccupation!;

                mumbaiTextController.tenantCityDistrictWorkPlaceMumbaiController.text =
                    showData.data!.tenantWorkCity!;

                mumbaiTextController.tenantPinCodeWorkPlaceMumbaiController.text =
                    showData.data!.tenantWorkPostalCode!;

                mumbaiTextController.tenantPinCodeWorkPlaceMumbaiController.text =
                    showData.data!.tenantWorkPostalCode!;

                mumbaiTextController.tenantEmailIdWorkPlaceMumbaiController.text =
                    showData.data!.tenantWorkEmail!;

                mumbaiTextController.tenantAddressPlaceOfWorkPlaceMumbaiController.text =
                    showData.data!.tenantWorkPlaceAddress!;

                mumbaiTextController.tenantStateWorkPlaceMumbaiController.text =
                    showData.data!.tenantState!;

                mumbaiTextController.person1NamePersonKnowingMumbaiController.text =
                    showData.data!.tenantContactOneFullName!;

                mumbaiTextController.person1MobileNoPersonKnowingMumbaiController.text =
                    showData.data!.tenantContactOnePhone!;

                mumbaiTextController.person2NamePersonKnowingMumbaiController.text =
                    showData.data!.tenantContactOneFullName!;

                mumbaiTextController.person2MobileNOPersonKnowingMumbaiController.text =
                    showData.data!.tenantContactTwoPhone!;

                mumbaiTextController.agentNamePersonKnowingMumbaiController.text =
                    showData.data!.agentName!;

                mumbaiTextController.agentDetailsPersonKnowingMumbaiController.text =
                    showData.data!.agentDetails!;
                mumbaiTextController.rentedPropertyAgreementStartDateController
                  .text =
                  "${showData.data!.agreementStartDate!.toLocal()}"
                      .split(' ')[0];
                mumbaiTextController.rentedPropertyAgreementEndDateController
                  .text = "${showData.data!.agreementEndDate!.toLocal()}"
                      .split(' ')[0];
              }
            }, builder: (context, mumbaiDataShow) {
              if (mumbaiDataShow is MumbaiShowDataLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (mumbaiDataShow is MumbaiShowDataErrorState) {
                return Center(child: Text(mumbaiDataShow.message));
              } else if (mumbaiDataShow is MumbaiShowDataSuccessState) {
                MumbaiShowDataModel showData =
                    mumbaiDataShow.mumbaiShowDataModel;

                policeStationIdLoadData(
                    city_id: showData.data!.city_id.toString());
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Police Verification For Mumbai Update",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Theme.of(context).primaryColorDark),
                    ),
                    const SizedBox(
                      height: 16,
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
                      showData.data!.reason!,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.red),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Property Owners Details",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 16),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    RichText(
                        text: TextSpan(
                            text: "City/District",
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
                    BlocBuilder<PoliceStationCityIdCubit,
                        PoliceStationCityIdState>(
                      builder: (context, policeStationCityId) {
                        if (policeStationCityId
                            is PoliceStationCityIdLoadingState) {
                          return const Center(
                              child: SizedBox(
                            height: 50,
                            width: double.infinity,
                          ));
                        } else if (policeStationCityId
                            is PoliceStationCityIdErrorState) {
                          return Center(
                            child: Text(policeStationCityId.message),
                          );
                        } else if (policeStationCityId
                            is PoliceStationCityIdSuccessState) {
                          PoliceStationCityIdModel data =
                              policeStationCityId.policeStationCityIdModel;

                          List<String> policeStationCityList = [];
                          Map<String, dynamic> policeList = {};

                          for (int i = 0; i < data.data!.length; i++) {
                            policeStationCityList.add(data.data![i].cityName!);

                            policeList.addAll({
                              "${data.data![i].id!}": data.data![i].cityName!
                            });
                          }
                          return DropdownButtonFormField<String>(
                            dropdownColor: Theme.of(context).cardColor,
                            hint: Text(
                                "${policeList["${showData.data!.city_id}"]}",
                                style: Theme.of(context).textTheme.bodySmall),
                            value: policeStationCityName,
                            onChanged: (String? newValue) {
                              setState(() {
                                int index =
                                    policeStationCityList.indexOf(newValue!);
                                policeStationIdLoadData(
                                    city_id: data.data![index].id.toString());
                                mumbaiPoliceStationCityId =
                                    data.data![index].id.toString();

                                policeStationCityName = newValue;
                              });
                            },
                            items: policeStationCityList
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
                          );
                        }
                        return const Center(
                          child: Text("Error..."),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    RichText(
                        text: TextSpan(
                            text: "Police Station Id",
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
                    BlocBuilder<PoliceStationIdCubit, PoliceStationIdState>(
                      builder: (context, policeStationId) {
                        if (policeStationId is PoliceStationIdLoadingState) {
                          return const Center(
                              child: SizedBox(
                            height: 50,
                            width: double.infinity,
                          ));
                        } else if (policeStationId
                            is PoliceStationIdErrorState) {
                          return Center(
                            child: Text(policeStationId.message),
                          );
                        } else if (policeStationId
                            is PoliceStationIdSuccessState) {
                          PoliceStationIdModel data =
                              policeStationId.policeStationIdModel;

                          List<String> policeStationList = [];
                          Map<String, dynamic> policeList = {};

                          for (int i = 0; i < data.data!.length; i++) {
                            policeStationList.add(data.data![i].stationName!);

                            policeList.addAll({
                              "${data.data![i].id!}": data.data![i].stationName!
                            });
                          }
                          return DropdownButtonFormField<String>(
                            dropdownColor: Theme.of(context).cardColor,
                            hint: Text(
                                "${policeList["${showData.data!.policeStationId}"]}",
                                style: Theme.of(context).textTheme.bodySmall),
                            value: policeStationName,
                            onChanged: (String? newValue) {
                              setState(() {
                                int index =
                                    policeStationList.indexOf(newValue!);

                                mumbaiPoliceStationId =
                                    data.data![index].id.toString();

                                policeStationName = newValue;
                              });
                            },
                            items: policeStationList
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
                          );
                        }
                        return const Center(
                          child: Text("Error..."),
                        );
                      },
                    ),
                    form_widget(
                      validator: validateMobile,
                      textInputType: TextInputType.number,
                      controller: mumbaiTextController.ownerMobileNumberMumbaiController,
                      titleText: 'Mobile Number',
                      hintText: "Enter Mobile Number",
                    ),
                    form_widget(
                      validator: addressValidator,
                      textInputType: TextInputType.text,
                      controller: mumbaiTextController.ownerAddressMumbaiController,
                      titleText: 'Address',
                      hintText: "Enter Address",
                    ),
                    form_widget(
                      textInputType: TextInputType.text,
                      controller: mumbaiTextController.ownerStateMumbaiController,
                      titleText: 'State',
                      hintText: "Enter State",
                    ),
                    form_widget(
                      maskFormatter: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                      ],
                      textInputType: TextInputType.text,
                      controller: mumbaiTextController.ownerFullNameMumbaiController,
                      titleText: 'Full Name',
                      hintText: "Enter Full Name",
                    ),
                    form_widget(
                      validator: validateEmail,
                      textInputType: TextInputType.text,
                      controller: mumbaiTextController.ownerEmailAddressMumbaiController,
                      titleText: 'Email Address',
                      hintText: "Enter Email Address",
                    ),
                    // form_widget(
                    //   textInputType: TextInputType.text,
                    //   controller: ownerCityDistrictMumbaiController
                    //     ..text = showData.data!.ownerCityDistrict!,
                    //   titleText: 'City/District',
                    //   hintText: "Enter City/District",
                    // ),
                    form_widget(
                      maskFormatter: [pinMask],
                      validator: validatePinCode,
                      textInputType: TextInputType.number,
                      controller: mumbaiTextController.ownerPinCodeMumbaiController,
                      titleText: 'Pin Code',
                      hintText: "Enter Pin Code",
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    BlocBuilder<PropertyOwnersProfileImage, File>(
                        builder: (context, profileImage) {
                      return PickPhotoUpdate(
                          widthSize: double.infinity,
                          onPressedPickImage: () {
                            context
                                .read<PropertyOwnersProfileImage>()
                                .pickImageFromGallery()
                                .then((_) {
                              context.pop();
                            });
                          },
                          onPressedTakePhoto: () {
                            context
                                .read<PropertyOwnersProfileImage>()
                                .pickImageFromCamera()
                                .then((_) {
                              context.pop();
                            });
                          },
                          title: "Select Profile Image",
                          image: profileImage,
                          uploadImage: showData.data!.tenantPhoto!,
                          mainTitle: "Profile Image");
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
                              Theme.of(context)
                                  .primaryColorDark
                                  .withOpacity(0.5),
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
                                              const MumbaiPoliceVerificationUpdateForm2()));
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
                        ),
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
