import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/commonComponent/screen_size.dart';
import 'package:v_verify/screen/VerificationForms/common/pickphoto.dart';

import '../../../../../commonComponent/custom_button.dart';
import '../../../common/form_widget.dart';
import '../../../common/validator.dart';
import '../PoliceStationId/Bloc/police_station_id_cubit.dart';
import '../PoliceStationId/Bloc/police_station_id_state.dart';
import '../PoliceStationId/model/police_station_city_id_model.dart';
import '../PoliceStationId/model/police_station_id_model.dart';
import 'MumbaiPoliceVerificationForm2.dart';
import 'TextController/mumbai_text_controller.dart';
import 'bloc/mumbaiPolice_verification_blocCubit.dart';

class MumbaiPoliceVerificationForm1 extends StatefulWidget {
  const MumbaiPoliceVerificationForm1({super.key});

  @override
  State<MumbaiPoliceVerificationForm1> createState() =>
      _MumbaiPoliceVerificationForm1State();
}

class _MumbaiPoliceVerificationForm1State
    extends State<MumbaiPoliceVerificationForm1> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    mumbaiControllerRecreate();
    policeStationCityIdLoadData();
    super.initState();
  }

  @override
  void dispose() {
    clearMumbaiController();
    super.dispose();
  }

  void policeStationIdLoadData(city_id) {
    print(city_id);
    String token = context.read<TokenCubit>().state;
    context
        .read<PoliceStationIdCubit>()
        .policeStationList(token: token, city_id: city_id);
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
    String token = context.read<TokenCubit>().state;
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
                  "Police Verification For Mumbai",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Theme.of(context).primaryColorDark),
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomButton(
                    height: 45,
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      context.pushReplacementNamed("nonMumbaiForm");
                    },
                    text: "Non-Mumbai Police Verification",
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
                  create: (_) => FormUploadMumbaiCubit(),
                  child: BlocBuilder<FormUploadMumbaiCubit, bool>(
                      builder: (context, frmUpload) {
                    return Column(
                      children: [
                        ListTile(
                          splashColor: Colors.transparent,
                          onTap: () {
                            context
                                .read<FormUploadMumbaiCubit>()
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
                                .pushReplacementNamed("UploadDocumentsMumbai");

                            context
                                .read<FormUploadMumbaiCubit>()
                                .formUploadYesNo(yesNo: false);

                            context
                                .read<FormUploadMumbaiCubit>()
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
                  "Property Owners Details",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).primaryColorDark, fontSize: 16),
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
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w700, color: Colors.red),
                      ),
                    ])),
                const SizedBox(
                  height: 8,
                ),
                BlocBuilder<PoliceStationCityIdCubit, PoliceStationCityIdState>(
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

                      for (int i = 0; i < data.data!.length; i++) {
                        policeStationCityList.add(data.data![i].cityName!);
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButtonFormField<String>(
                            validator: (value) {
                              if (value == null && value!.isEmpty) {
                                return "Please select Select City/District";
                              }
                              return null;
                            },
                            dropdownColor: Theme.of(context).cardColor,
                            hint: Text('Select City/District',
                                style: Theme.of(context).textTheme.bodySmall),
                            value: policeStationCityName,
                            onChanged: (String? newValue) {
                              setState(() {
                                int index =
                                    policeStationCityList.indexOf(newValue!);

                                policeStationIdLoadData(
                                    data.data![index].id.toString());

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
                          ),
                        ],
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                        text: TextSpan(
                            text: "Police Station",
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
                          return DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            dropdownColor: Colors.white,
                            isExpanded: true,
                            value: "No Data Found",
                            items: ['No Data Found']
                                .map((city) => DropdownMenuItem(
                                    value: city,
                                    child: Text(
                                      city,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    )))
                                .toList(),
                            onChanged: (val) {},
                          );

                          // return Center(
                          //   child: Text(policeStationId.message),
                          // );
                        } else if (policeStationId
                            is PoliceStationIdSuccessState) {
                          PoliceStationIdModel data =
                              policeStationId.policeStationIdModel;

                          List<String> policeStationList = [];

                          for (int i = 0; i < data.data!.length; i++) {
                            policeStationList.add(data.data![i].stationName!);
                          }
                          return DropdownButtonFormField<String>(
                            validator: (value) {
                              if (value == null && value!.isEmpty) {
                                return "Please select police station";
                              }
                              return null;
                            },
                            dropdownColor: Theme.of(context).cardColor,
                            hint: Text('Select Police Station',
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
                          child: Text("Select police station"),
                        );
                      },
                    ),
                  ],
                ),
                form_widget(
                  maskFormatter: [mobileMaskFormatter],
                  validator: validateMobile,
                  textInputType: TextInputType.number,
                  controller:
                      mumbaiTextController.ownerMobileNumberMumbaiController,
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
                  controller:
                      mumbaiTextController.ownerFullNameMumbaiController,
                  titleText: 'Full Name',
                  hintText: "Enter Full Name",
                ),
                form_widget(
                  validator: validateEmail,
                  textInputType: TextInputType.text,
                  controller:
                      mumbaiTextController.ownerEmailAddressMumbaiController,
                  titleText: 'Email Address',
                  hintText: "Enter Email Address",
                ),
                // form_widget(
                //   textInputType: TextInputType.text,
                //   controller: ownerCityDistrictMumbaiController,
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
                  return PickPhoto(
                    mainTitle: "Profile Image",
                    widthSize: ScreenSize.screenWidth / 2,
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
                    title: 'Select Profile Image',
                    image: profileImage,
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
                                  .read<PropertyOwnersProfileImage>()
                                  .state
                                  .path
                                  .isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Please upload profile image")));
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MumbaiPoliceVerificationForm2()));
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
