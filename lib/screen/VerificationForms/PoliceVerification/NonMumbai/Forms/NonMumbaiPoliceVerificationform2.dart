import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/NonMumbai/Forms/textController/editcontroller.dart';
import 'package:v_verify/screen/VerificationForms/common/form_widget.dart';
import 'package:v_verify/screen/VerificationForms/common/pickphoto.dart';

import '../../../../../commonComponent/custom_button.dart';
import '../../../common/validator.dart';
import 'Bloc/nonMumbai_verification_cubit.dart';
import 'NonMumbaiPoliceVerificationForm3.dart';

class NonMumbaiPoliceVerificationForm2 extends StatefulWidget {
  const NonMumbaiPoliceVerificationForm2({super.key});

  @override
  State<NonMumbaiPoliceVerificationForm2> createState() =>
      _NonMumbaiPoliceVerificationForm2State();
}

class _NonMumbaiPoliceVerificationForm2State
    extends State<NonMumbaiPoliceVerificationForm2> {
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

      setState(() {
        selectedBirthDate = pickedDate;
        nonMumbaiTextController.tenantBirthDateController.text = formattedDate;
      });
    }
  }

  @override
  void initState() {
    super.initState();
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tenant's Details",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).primaryColorDark, fontSize: 18),
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
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w700, color: Colors.red),
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
                  controller: nonMumbaiTextController.tenantBirthDateController,
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
                      FilteringTextInputFormatter.digitsOnly, // allows only digits 0–9
                    ],
                    textInputType: TextInputType.number,
                    controller: nonMumbaiTextController.tenantAgeController,
                    titleText: "Tenant's Age",
                    hintText: " Enter Tenant's Age"),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  "Employed",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontWeight: FontWeight.w700),
                ),
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
                                          ? Theme.of(context).primaryColorLight
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
                                        ? Theme.of(context).primaryColorLight
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
                                BlocBuilder<NonMumbaiTenantCompanyLetterImage,
                                    File>(builder: (context, letterImage) {
                                  return PickPhoto(
                                    widthSize: double.infinity,
                                    title: "Select Company Letter Image",
                                    mainTitle: "Tenant's Company Letter",
                                    onPressedPickImage: () {
                                      context
                                          .read<
                                              NonMumbaiTenantCompanyLetterImage>()
                                          .pickFile()
                                          .then((_) {
                                        context.pop();
                                      });
                                    },
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
                    controller:
                        nonMumbaiTextController.tenantFatherAddressController,
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
                            if (_formKey.currentState?.validate() ?? false) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const NonMumbaiPoliceVerificationForm3()));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Please fill all fields")));
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
            ),
          ),
        ),
      ),
    );
  }
}
