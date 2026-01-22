import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/NonMumbai/Form/TextControllers/non_mumbai_form_text_controller.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/NonMumbai/Form/Blocs/non_mumbai_show_details_bloc/non_mumbai_show_details_cubit.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/NonMumbai/Form/Blocs/non_mumbai_show_details_bloc/non_mumbai_show_details_state.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/NonMumbai/Form/Models/non_mumbai_show_details_model.dart';
import 'package:v_verify/widgets/custom_required_text_field.dart';
import '../../../../../../../commonComponent/custom_button.dart';
import '../../../../../common/form_widget.dart';
import '../../../../../common/validator.dart';
import '../../Blocs/non_mumbai_save_form_bloc/non_mumbai_save_form_cubit.dart';
import 'non_mumbai_police_update_form_screen4.dart';

class NonMumbaiPoliceUpdateFormScreen3 extends StatefulWidget {
  const NonMumbaiPoliceUpdateFormScreen3({super.key});

  @override
  State<NonMumbaiPoliceUpdateFormScreen3> createState() =>
      _NonMumbaiPoliceUpdateFormScreen3State();
}

class _NonMumbaiPoliceUpdateFormScreen3State
    extends State<NonMumbaiPoliceUpdateFormScreen3> {
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
                  data.data!.tenantHasCriminalOffenses == true
                      ? context.read<CriminalCubit>().criminalYesNo(yesNo: true)
                      : context.read<CriminalCubit>().criminalYesNo(yesNo: false);
        
                  data.data!.tenantWhetherArrested == 1
                      ? context.read<ArrestedCubit>().arrestedYesNo(yesNo: true)
                      : context.read<ArrestedCubit>().arrestedYesNo(yesNo: false);
        
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Person Knowing Tenant's",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: 18),
                      ),
                      CustomRequiredTextField(
                          maskFormatter: [
                            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                          ],
                          textInputType: TextInputType.text,
                          controller: nonMumbaiTextController.person1NameController,
                          titleText: "Person 1 Name",
                          hintText: "Enter Person 1 Name"),
                      CustomRequiredTextField(
                          validator: addressValidator,
                          textInputType: TextInputType.text,
                          controller: nonMumbaiTextController.person1AddressController,
                          titleText: "Person 1 Address",
                          hintText: "Enter Person 1 Address"),
                      CustomRequiredTextField(
                          textInputType: TextInputType.text,
                          controller: nonMumbaiTextController.person2NameController,
                          titleText: "Person 2 Name",
                          hintText: "Enter Person 2 Name"),
                      CustomRequiredTextField(
                          validator: addressValidator,
                          textInputType: TextInputType.text,
                          controller: nonMumbaiTextController.person2AddressController,
                          titleText: "Person 2 Address",
                          hintText: "Enter Person 2 Address"),
                      const SizedBox(
                        height: 16,
                      ),
                      RichText(
                          text: TextSpan(
                              text: "Criminal Offences Registered",
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
                                      style:
                                          Theme.of(context).textTheme.bodySmall),
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
                                      style:
                                          Theme.of(context).textTheme.bodySmall),
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      RichText(
                          text: TextSpan(
                              text: "Arrested Status",
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
                                      style:
                                          Theme.of(context).textTheme.bodySmall),
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
                                      style:
                                          Theme.of(context).textTheme.bodySmall),
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                      CustomRequiredTextField(
                          textInputType: TextInputType.text,
                          controller: nonMumbaiTextController.residentialPoliceStationController3,
                          titleText:
                              "Tenant's Earlier Residential Police Station",
                          hintText: "Enter Earlier Residential Police Station"),
                      CustomRequiredTextField(
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
                          controller: nonMumbaiTextController.residentialYearsController,
                          titleText: "Tenant's Earlier Residential Years",
                          hintText: "Enter Years"),
                      const SizedBox(
                        width: 8,
                      ),
                      CustomRequiredTextField(
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
                          controller: nonMumbaiTextController.residentialMonthController,
                          titleText: "Tenant's Earlier Residential Months",
                          hintText: "Enter Months"),
                      BlocBuilder<CriminalCubit, bool>(
                        builder: (context, criminalYesNO) {
                          return BlocBuilder<ArrestedCubit, bool>(
                            builder: (context, arrestedYesNo) {
                              return Column(
                                children: [
                                  criminalYesNO || arrestedYesNo
                                      ? CustomRequiredTextField(
                                          textInputType: TextInputType.text,
                                          controller: nonMumbaiTextController.caseRegNoController
                                            ..text =
                                                data.data!.tenantCrnoSection!,
                                          titleText: "Case Reg. No. & Section",
                                          hintText:
                                              "Enter Case Reg. No. & Section")
                                      : const SizedBox(),
                                  criminalYesNO || arrestedYesNo
                                      ? CustomRequiredTextField(
                                          textInputType: TextInputType.text,
                                          controller: nonMumbaiTextController.caseStatusController
                                            ..text = data
                                                .data!.tenantPresentCaseStatus!,
                                          titleText: "Case Status",
                                          hintText: "Enter Case Status")
                                      : const SizedBox(),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      CustomRequiredTextField(
                        validator: addressValidator,
                          textInputType: TextInputType.text,
                          controller: nonMumbaiTextController.earlierResidentialPlaceController,
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
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const NonMumbaiPoliceUpdateFormScreen4()));
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
                      ),
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
      ),
    );
  }
}
