import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentForm/TextController/EmploymentSaveFormControllerNew.dart';
import 'package:v_verify/screen/VerificationForms/common/form_widget.dart';
import '../../../../../commonComponent/custom_button.dart';
import '../../../common/id.dart';
import '../Bloc/EmploymentSaveForm.dart';
import '../Bloc/EmploymentSaveFormState.dart';
import '../Model/employmentSaveForm_model.dart';

class EmploymentSaveFormNew extends StatefulWidget {
  const EmploymentSaveFormNew({super.key});

  @override
  State<EmploymentSaveFormNew> createState() => _EmploymentSaveFormNewState();
}

class _EmploymentSaveFormNewState extends State<EmploymentSaveFormNew> {
  final _formKey = GlobalKey<FormState>();
  var maskFormatter = MaskTextInputFormatter(
      mask: '##-##-####', filter: {"#": RegExp(r'[0-9]')});
  TextEditingController joinDateController = TextEditingController();
  TextEditingController leaveDateController = TextEditingController();

  @override
  void initState() {
    employmentControllerRecreateNew();
    super.initState();
  }

  DateTime _selectedDate = DateTime.now();

  // Function to calculate the date 18 years ago
  // DateTime _getDate18YearsAgo() {
  //   DateTime today = DateTime.now();
  //   return DateTime(today.year - 18, today.month, today.day);
  // }

  // Function to show the date picker
  Future<void> _selectLeaveDate(BuildContext context) async {
    // DateTime date18YearsAgo = _getDate18YearsAgo();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950), // Min date: 18 years ago
      lastDate: DateTime.now(), // Max date: today
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);

      //setState(() {
      _selectedDate = pickedDate;
      leaveDateController.text = formattedDate;
      // });
    }
  }

  // Function to show the date picker
  Future<void> _selectJoinDate(BuildContext context) async {
    // DateTime date18YearsAgo = _getDate18YearsAgo();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950), // Min date: 18 years ago
      lastDate: DateTime.now(), // Max date: today
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);

      //setState(() {
      _selectedDate = pickedDate;
      joinDateController.text = formattedDate;
      // });
    }
  }

  void employmentSaveForm() {
    String token = context.read<TokenCubit>().state;
    String customerId = context.read<IdCubit>().state;

    print('EmploymentSaveFormModel:');
    print('request_id: $requestId');
    print('service_request_id: $serviceRequestId');
    print('customer_id: $customerId');
    print('employer_name: ${employmentTextControllerNew.employmentEmployerNameController.text}');
    print('employed_from: ${joinDateController.text}');
    print('employed_to: ${leaveDateController.text}');
    print('designation: ${employmentTextControllerNew.employmentDesignationController.text}');
    print('department: ${employmentTextControllerNew.employmentDepartmentController.text}');
    print('remunaration: ${employmentTextControllerNew.employmentRemunerationController.text}');
    print('reporting_manager: ${employmentTextControllerNew.employmentReportingManagerController.text}');
    print('reason_for_leaving: ${employmentTextControllerNew.employmentReasonForLeavingController.text}');

    context.read<EmploymentSaveFormCubit>().employmentSaveForm(
        customer_id: customerId,
        token: token,
        employmentSaveFormModel: EmploymentSaveFormModel(
            request_id: requestId!,
            service_request_id: serviceRequestId!,
            customer_id: customerId,
            employer_name: employmentTextControllerNew.employmentEmployerNameController.text,
            employed_from: joinDateController.text,
            employed_to: leaveDateController.text,
            designation: employmentTextControllerNew.employmentDesignationController.text,
            department: employmentTextControllerNew.employmentDepartmentController.text,
            remunaration: employmentTextControllerNew.employmentRemunerationController.text,
            reporting_manager: employmentTextControllerNew.employmentReportingManagerController.text,
            reason_for_leaving: employmentTextControllerNew.employmentReasonForLeavingController.text,
        ));
  }

  @override
  void dispose() {
    clearEmploymentControllerNew();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Employment Verification Form",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Theme.of(context).primaryColorDark),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Employment Details",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).primaryColorDark, fontSize: 16),
                  ),
                  form_widget(
                      maskFormatter: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                      ],
                      controller: employmentTextControllerNew.employmentEmployerNameController,
                      titleText: "Employer Name",
                      hintText: "Enter Employer Name",
                      textInputType: TextInputType.text),
                  const SizedBox(
                    height: 16,
                  ),
                  RichText(
                      text: TextSpan(
                          text: "From Date (Joining)",
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter joining date';
                      }
                      return null;
                    },
                    style: Theme.of(context).textTheme.bodySmall,
                    keyboardType: TextInputType.number,
                    inputFormatters: [maskFormatter],
                    controller: joinDateController,
                    decoration: InputDecoration(
                      hintText: "DD-MM-YYYY",
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectJoinDate(
                            context), // Open date picker when icon is pressed
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  RichText(
                      text: TextSpan(
                          text: "To Date (Leaving)",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontWeight: FontWeight.w700),
                          )),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    readOnly: true,
                    style: Theme.of(context).textTheme.bodySmall,
                    keyboardType: TextInputType.number,
                    inputFormatters: [maskFormatter],
                    controller: leaveDateController,
                    decoration: InputDecoration(
                      hintText: "DD-MM-YYYY",
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectLeaveDate(
                            context), // Open date picker when icon is pressed
                      ),
                    ),
                  ),
                  FormFieldNotRequired(
                      controller: employmentTextControllerNew.employmentDesignationController,
                      titleText: "Designation",
                      hintText: "Enter Designation",
                      textInputType: TextInputType.text),
                  FormFieldNotRequired(
                      controller: employmentTextControllerNew.employmentDepartmentController,
                      titleText: "Department",
                      hintText: "Enter Department",
                      textInputType: TextInputType.text),
                  FormFieldNotRequired(
                      controller: employmentTextControllerNew.employmentRemunerationController,
                      titleText: "Remuneration",
                      hintText: "Enter Remuneration",
                      textInputType: TextInputType.text),
                  FormFieldNotRequired(
                      controller: employmentTextControllerNew.employmentReportingManagerController,
                      titleText: "Reporting Manager",
                      hintText: "Enter Reporting Manager",
                      textInputType: TextInputType.text),
                  form_widget(
                      controller: employmentTextControllerNew.employmentReasonForLeavingController,
                      titleText: "Reason For Leaving",
                      hintText: "Enter Reason For Leaving",
                      textInputType: TextInputType.text),
                  const SizedBox(
                    height: 24,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  BlocConsumer<EmploymentSaveFormCubit,
                      EmploymentSaveFormState>(
                      listener: (context, employSave) {
                        if (employSave is EmploymentSaveFormSuccessState) {
                          if (employSave.data["status"] == 200) {
                            context.pushReplacementNamed("EmployDataList");

                            context.read<EmploymentLetterImage>().clearImage();
                            context.read<EmploymentSupportDocumentImage>().clearImage();
                          }
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(employSave.data["message"])));
                        } else if (employSave is EmploymentSaveFormErrorState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(employSave.message)));
                        }
                      }, builder: (context, employSave) {
                    return CustomButton(
                        isLoading:
                        employSave is EmploymentSaveFormLoadingState,
                        height: 45,
                        onTap: () {
                          // context.pushReplacementNamed("EmployDataList");
                          FocusManager.instance.primaryFocus?.unfocus();
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (_formKey.currentState?.validate() ?? false) {
                            employmentSaveForm();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Please fill fields")));
                          }
                        },
                        text: "SUBMIT",
                        gradientColors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColorDark,
                        ]);
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
