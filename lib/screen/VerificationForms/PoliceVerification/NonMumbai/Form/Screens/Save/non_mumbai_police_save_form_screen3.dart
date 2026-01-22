import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/NonMumbai/Form/TextControllers/non_mumbai_form_text_controller.dart';
import 'package:v_verify/screen/VerificationForms/common/validator.dart';

import '../../../../../../../commonComponent/custom_button.dart';
import '../../../../../common/form_widget.dart';
import '../../Blocs/non_mumbai_save_form_bloc/non_mumbai_save_form_cubit.dart';
import 'non_mumbai_police_save_form_screen4.dart';

class NonMumbaiPoliceSaveFormScreen3 extends StatefulWidget {
  const NonMumbaiPoliceSaveFormScreen3({super.key});

  @override
  State<NonMumbaiPoliceSaveFormScreen3> createState() =>
      _NonMumbaiPoliceSaveFormScreen3State();
}

class _NonMumbaiPoliceSaveFormScreen3State
    extends State<NonMumbaiPoliceSaveFormScreen3> {
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
                  "Person Knowing Tenant's",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).primaryColorDark, fontSize: 18),
                ),
                form_widget(
                    maskFormatter: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                    ],
                    textInputType: TextInputType.text,
                    controller: nonMumbaiTextController.person1NameController,
                    titleText: "Person 1 Name",
                    hintText: "Enter Person 1 Name"),
                form_widget(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an address';
                      }
                      //List<String> words = value.trim().split(RegExp(r'\s+'));
                      if (value.length <= 20) {
                        return 'Please enter more than 20 char for the address';
                      }
                      return null;
                    },
                    textInputType: TextInputType.text,
                    controller:
                        nonMumbaiTextController.person1AddressController,
                    titleText: "Person 1 Address",
                    hintText: "Enter Person 1 Address"),
                form_widget(
                    textInputType: TextInputType.text,
                    controller: nonMumbaiTextController.person2NameController,
                    titleText: "Person 2 Name",
                    hintText: "Enter Person 2 Name"),
                form_widget(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an address';
                      }
                      //List<String> words = value.trim().split(RegExp(r'\s+'));
                      if (value.length <= 20) {
                        return 'Please enter more than 20 char for the address';
                      }
                      return null;
                    },
                    textInputType: TextInputType.text,
                    controller:
                        nonMumbaiTextController.person2AddressController,
                    titleText: "Person 2 Address",
                    hintText: "Enter Person 2 Address"),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  "Criminal Offences Registered",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  width: double.infinity,
                  child: BlocBuilder<CriminalCubit, bool>(
                      builder: (context, criminalYesNo) {
                    return Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: ListTile(
                            splashColor: Colors.transparent,
                            onTap: () {
                              context
                                  .read<CriminalCubit>()
                                  .criminalYesNo(yesNo: true);
                            },
                            contentPadding: const EdgeInsets.all(0),
                            leading: Icon(Icons.radio_button_checked,
                                color: criminalYesNo
                                    ? Theme.of(context).primaryColorLight
                                    : Theme.of(context).iconTheme.color),
                            title: Text("Yes",
                                style: Theme.of(context).textTheme.bodySmall),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: ListTile(
                            splashColor: Colors.transparent,
                            onTap: () {
                              context
                                  .read<CriminalCubit>()
                                  .criminalYesNo(yesNo: false);
                            },
                            contentPadding: const EdgeInsets.all(0),
                            leading: Icon(
                              Icons.radio_button_checked,
                              color: !criminalYesNo
                                  ? Theme.of(context).primaryColorLight
                                  : Theme.of(context).iconTheme.color,
                            ),
                            title: Text("No",
                                style: Theme.of(context).textTheme.bodySmall),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  "Arrested Status",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  width: double.infinity,
                  child: BlocBuilder<ArrestedCubit, bool>(
                      builder: (context, arrestedYesNO) {
                    return Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: ListTile(
                            splashColor: Colors.transparent,
                            onTap: () {
                              context
                                  .read<ArrestedCubit>()
                                  .arrestedYesNo(yesNo: true);
                            },
                            contentPadding: const EdgeInsets.all(0),
                            leading: Icon(Icons.radio_button_checked,
                                color: arrestedYesNO
                                    ? Theme.of(context).primaryColorLight
                                    : Theme.of(context).iconTheme.color),
                            title: Text("Yes",
                                style: Theme.of(context).textTheme.bodySmall),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: ListTile(
                            splashColor: Colors.transparent,
                            onTap: () {
                              context
                                  .read<ArrestedCubit>()
                                  .arrestedYesNo(yesNo: false);
                            },
                            contentPadding: const EdgeInsets.all(0),
                            leading: Icon(
                              Icons.radio_button_checked,
                              color: !arrestedYesNO
                                  ? Theme.of(context).primaryColorLight
                                  : Theme.of(context).iconTheme.color,
                            ),
                            title: Text("No",
                                style: Theme.of(context).textTheme.bodySmall),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                form_widget(
                    validator: addressValidator,
                    textInputType: TextInputType.text,
                    controller: nonMumbaiTextController
                        .residentialPoliceStationController3,
                    titleText: "Tenant's Earlier Residential Police Station",
                    hintText: "Enter Earlier Residential Police Station"),
                form_widget(
                    maskFormatter: [
                      LengthLimitingTextInputFormatter(3),
                      FilteringTextInputFormatter.digitsOnly, // allows only digits 0–9
                    ],
                    validator: (value) {
                      if (value == null && value!.isEmpty) {
                        return "Please Fill The Field";
                      } else if (int.parse(value) > 100) {
                        return "The tenant earlier residential years less than 100.";
                      }
                      return null;
                    },
                    textInputType: TextInputType.number,
                    controller:
                        nonMumbaiTextController.residentialYearsController,
                    titleText: "Tenant's Earlier Residential Years",
                    hintText: "Enter Years"),
                const SizedBox(
                  width: 8,
                ),
                form_widget(
                    maskFormatter: [
                      LengthLimitingTextInputFormatter(2),
                      FilteringTextInputFormatter.digitsOnly, // allows only digits 0–9
                    ],
                    validator: (value) {
                      if (value == null && value!.isEmpty) {
                        return "Please Fill The Field";
                      } else if (int.parse(value) > 12) {
                        return "The tenant earlier residential month less than 12.";
                      }
                      return null;
                    },
                    textInputType: TextInputType.number,
                    controller:
                        nonMumbaiTextController.residentialMonthController,
                    titleText: "Tenant's Earlier Residential Months",
                    hintText: "Enter Months"),
                BlocBuilder<CriminalCubit, bool>(
                  builder: (context, criminalYesNO) {
                    return BlocBuilder<ArrestedCubit, bool>(
                      builder: (context, arrestedYesNo) {
                        return Column(
                          children: [
                            criminalYesNO || arrestedYesNo
                                ? form_widget(
                                    textInputType: TextInputType.text,
                                    controller: nonMumbaiTextController
                                        .caseRegNoController,
                                    titleText: "Case Reg. No. & Section",
                                    hintText: "Enter Case Reg. No. & Section")
                                : const SizedBox(),
                            criminalYesNO || arrestedYesNo
                                ? form_widget(
                                    textInputType: TextInputType.text,
                                    controller: nonMumbaiTextController
                                        .caseStatusController,
                                    titleText: "Case Status",
                                    hintText: "Enter Case Status")
                                : const SizedBox(),
                          ],
                        );
                      },
                    );
                  },
                ),
                form_widget(
                    validator: addressValidator,
                    textInputType: TextInputType.text,
                    controller: nonMumbaiTextController
                        .earlierResidentialPlaceController,
                    titleText: "Tenant's Earlier Residential Place",
                    hintText: "Enter Earlier Residential Place"),
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
                                          const NonMumbaiPoliceSaveFormScreen4()));
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
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
