import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/NonMumbai/Form/TextControllers/non_mumbai_form_text_controller.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/NonMumbai/Form/Blocs/non_mumbai_show_details_bloc/non_mumbai_show_details_cubit.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/NonMumbai/Form/Blocs/non_mumbai_show_details_bloc/non_mumbai_show_details_state.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/NonMumbai/Form/Models/non_mumbai_show_details_model.dart';
import 'package:v_verify/screen/VerificationForms/common/form_widget.dart';
import 'package:v_verify/screen/VerificationForms/common/pickphoto.dart';

import '../../../../../../../commonComponent/custom_button.dart';
import '../../../../../common/validator.dart';
import '../../Blocs/non_mumbai_save_form_bloc/non_mumbai_save_form_cubit.dart';
import 'non_mumbai_police_update_form_screen3.dart';

class NonMumbaiUpdtaeFormScreen2 extends StatefulWidget {
  const NonMumbaiUpdtaeFormScreen2({super.key});

  @override
  State<NonMumbaiUpdtaeFormScreen2> createState() =>
      _NonMumbaiUpdtaeFormScreen2State();
}

class _NonMumbaiUpdtaeFormScreen2State
    extends State<NonMumbaiUpdtaeFormScreen2> {
  final _formKey = GlobalKey<FormState>();
  DateTime selectedBirthDate = DateTime.now();

  // Function to calculate the date 18 years ago
  DateTime _getDate18YearsAgo() {
    DateTime today = DateTime.now();
    return DateTime(today.year - 18, today.month, today.day);
  }

  // Function to show the date picker
  Future<void> _selectStartDate(BuildContext context) async {
    DateTime date18YearsAgo = _getDate18YearsAgo();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: date18YearsAgo,
      firstDate: DateTime(1950), // Min date: 18 years ago
      lastDate: date18YearsAgo, // Max date: today
    );

    if (pickedDate != null && pickedDate != selectedBirthDate) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      selectedBirthDate = pickedDate;
      nonMumbaiTextController.tenantBirthDateController.text = formattedDate;

      // setState(() {
      //   selectedBirthDate = pickedDate;
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    var maskFormatter = MaskTextInputFormatter(
        mask: '####-##-##', filter: {"#": RegExp(r'[0-9]')});
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
          child: Form(
            key: _formKey,
            child: BlocBuilder<NonMumbaiShowDataCubit, NonMumbaiShowDataState>(
                builder: (context, nonMumbaiShowData) {
              if (nonMumbaiShowData is NonMumbaiShowDataLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (nonMumbaiShowData is NonMumbaiShowDataErrorState) {
                return Center(
                  child: Text(nonMumbaiShowData.message),
                );
              } else if (nonMumbaiShowData is NonMumbaiShowDataSuccessState) {
                NonMumbaiShowDataModel data =
                    nonMumbaiShowData.nonMumbaiShowDataModel;
                data.data!.tenantIsEmployed == 1
                    ? context.read<EmployedCubit>().employedYesNo(yesNo: true)
                    : context.read<EmployedCubit>().employedYesNo(yesNo: false);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tenant's Details",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 18),
                    ),
                    form_widget(
                        textInputType: TextInputType.text,
                        controller:
                            nonMumbaiTextController.tenantBirthPlaceController,
                        titleText: "Tenant's Birth Place",
                        hintText: "Enter Tenant's Birth Place"),
                    const SizedBox(
                      height: 16,
                    ),
                    RichText(
                        text: TextSpan(
                            text: "Tenant's Birth Date",
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
                    TextFormField(
                      readOnly: true,
                      validator: validateDate,
                      style: Theme.of(context).textTheme.bodySmall,
                      keyboardType: TextInputType.number,
                      inputFormatters: [maskFormatter],
                      controller: nonMumbaiTextController
                          .tenantBirthDateController,
                      decoration: InputDecoration(
                        hintText: "YYYY-MM-DD",
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => _selectStartDate(
                              context), // Open date picker when icon is pressed
                        ),
                      ),
                    ),
                    form_widget(
                        maskFormatter: [
                          LengthLimitingTextInputFormatter(2),
                          FilteringTextInputFormatter.digitsOnly,
                          // allows only digits 0–9
                        ],
                        textInputType: TextInputType.number,
                        controller: nonMumbaiTextController.tenantAgeController,
                        titleText: "Tenant's Age",
                        hintText: " Enter Tenant's Age"),
                    const SizedBox(
                      height: 16,
                    ),
                    RichText(
                        text: TextSpan(
                            text: "Employed",
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
                    BlocBuilder<EmployedCubit, bool>(
                        builder: (context, employedYesNO) {
                      return Column(
                        children: [
                          SizedBox(
                              width: double.infinity,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: ListTile(
                                      splashColor: Colors.transparent,
                                      onTap: () {
                                        context
                                            .read<EmployedCubit>()
                                            .employedYesNo(yesNo: true);
                                      },
                                      contentPadding: const EdgeInsets.all(0),
                                      leading: Icon(Icons.radio_button_checked,
                                          color: employedYesNO
                                              ? Theme.of(context)
                                                  .primaryColorLight
                                              : Theme.of(context).iconTheme.color),
                                      title: Text("Yes",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: ListTile(
                                      splashColor: Colors.transparent,
                                      onTap: () {
                                        context
                                            .read<EmployedCubit>()
                                            .employedYesNo(yesNo: false);
                                      },
                                      contentPadding: const EdgeInsets.all(0),
                                      leading: Icon(
                                        Icons.radio_button_checked,
                                        color: !employedYesNO
                                            ? Theme.of(context)
                                                .primaryColorLight
                                            : Theme.of(context).iconTheme.color,
                                      ),
                                      title: Text("No",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall),
                                    ),
                                  ),
                                ],
                              )),
                          employedYesNO
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    form_widget(
                                        textInputType: TextInputType.text,
                                        controller: nonMumbaiTextController
                                            .tenantCompanyNameController,
                                        titleText: "Tenant's Company Name",
                                        hintText: " Enter Tenant's Company Name"),
                                    form_widget(
                                        textInputType: TextInputType.number,
                                        controller: nonMumbaiTextController
                                            .tenantEmploymentYearsController,
                                        titleText: "Tenant's Employment Years",
                                        hintText:
                                            " Enter Tenant's Employment Years"),
                                    form_widget(
                                        textInputType: TextInputType.number,
                                        controller: nonMumbaiTextController
                                            .tenantEmploymentMonthController,
                                        titleText: "Tenant's Employment Month",
                                        hintText:
                                            " Enter Tenant's Employment Month"),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    BlocBuilder<
                                        NonMumbaiTenantCompanyLetterImage,
                                        File>(builder: (context, letterImage) {
                                      return PickPhotoUpdate(
                                        widthSize: double.infinity,
                                        title: "Select Tenant's Company Letter",
                                        mainTitle: "Tenant's Company Letter",
                                        onPressedTakePhoto: () {
                                          context
                                              .read<
                                                  NonMumbaiTenantCompanyLetterImage>()
                                              .pickImageFromCamera()
                                              .then((_) {
                                            context.pop();
                                          });
                                        },
                                        image: letterImage,
                                        uploadImage: data
                                            .data!.tenantLetterFromEmployer!,
                                        onPressedPickImage: () {
                                          context
                                              .read<
                                                  NonMumbaiTenantCompanyLetterImage>()
                                              .pickFile()
                                              .then((_) {
                                            context.pop();
                                          });
                                        },
                                      );
                                    }),
                                  ],
                                )
                              : const SizedBox(),
                        ],
                      );
                    }),
                    form_widget(
                        textInputType: TextInputType.text,
                        controller:
                            nonMumbaiTextController.tenantFatherNameController,
                        titleText: "Tenant's Father Name",
                        hintText: " Enter Tenant's Father Name"),
                    form_widget(
                        validator: addressValidator,
                        textInputType: TextInputType.text,
                        controller: nonMumbaiTextController
                            .tenantFatherAddressController,
                        titleText: "Tenant's Father Address",
                        hintText: " Enter Tenant's Father Address"),
                    form_widget(
                        textInputType: TextInputType.text,
                        controller: nonMumbaiTextController
                            .tenantFatherOccupationController,
                        titleText: "Tenant's Father Occupation",
                        hintText: " Enter Tenant's Father Occupation"),
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
                                              const NonMumbaiPoliceUpdateFormScreen3()));
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
