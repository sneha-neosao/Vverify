import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentVerification/Form/Blocs/employment_show_details_bloc/employ_show_details_cubit.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentVerification/Form/Blocs/employment_show_details_bloc/employ_show_details_state.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentVerification/Form/Blocs/employment_update_form_bloc/employment_update_form_cubit.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentVerification/Form/Blocs/employment_update_form_bloc/employment_update_form_state.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentVerification/Form/Models/employment_show_details_model.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentVerification/Form/Models/employment_update_form_model.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentVerification/Form/TextController/employment_text_controllers.dart';
import 'package:v_verify/widgets/custom_not_required_text_field.dart';
import 'package:v_verify/widgets/custom_required_text_field.dart';
import '../../../../../commonComponent/custom_button.dart';
import '../../../common/id.dart';

class EmploymentUpdateFormScreen extends StatefulWidget {
  final String uid;
  final String case_uuid;
  final String employment_uuid;

  const EmploymentUpdateFormScreen(
      {super.key,
      required this.uid,
      required this.case_uuid,
      required this.employment_uuid});

  @override
  State<EmploymentUpdateFormScreen> createState() =>
      _EmploymentUpdateFormScreenState();
}

class _EmploymentUpdateFormScreenState
    extends State<EmploymentUpdateFormScreen> {
  bool isChecked = false;
  final _formKey = GlobalKey<FormState>();
  var maskFormatter = MaskTextInputFormatter(
      mask: '##-##-####', filter: {"#": RegExp(r'[0-9]')});
  TextEditingController joinDateController = TextEditingController();
  TextEditingController leaveDateController = TextEditingController();

  @override
  void initState() {
    employmentControllerRecreateNew();
    employmentDetailsDataLoad();
    super.initState();
  }

  void employmentDetailsDataLoad() {
    String token = context.read<TokenCubit>().state;
    context
        .read<EmployShowDataCubit>()
        .employShowData(token: token, uid: widget.uid);
  }

  DateTime _selectedDate = DateTime.now();

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
    print(
        'employer_name: ${employmentTextControllerNew.employmentEmployerNameController.text}');
    print('employed_from: ${joinDateController.text}');
    print('employed_to: ${leaveDateController.text}');
    print(
        'designation: ${employmentTextControllerNew.employmentDesignationController.text}');
    print(
        'department: ${employmentTextControllerNew.employmentDepartmentController.text}');
    print(
        'remunaration: ${employmentTextControllerNew.employmentRemunerationController.text}');
    print(
        'reporting_manager: ${employmentTextControllerNew.employmentReportingManagerController.text}');
    print(
        'reason_for_leaving: ${employmentTextControllerNew.employmentReasonForLeavingController.text}');
    print(
        'reason_for_leaving: ${employmentTextControllerNew.employmentReasonForLeavingController.text}');
    print('case_uuid: ${widget.case_uuid}');
    print('till_date: ${isChecked == 1 ? 1 : null}');

    context.read<EmploymentUpdateFormCubit>().employmentUpdateForm(
        customer_id: customerId,
        token: token,
        employmentUpdateFormModel: EmploymentUpdateFormModel(
            uid: widget.uid,
            request_id: requestId!,
            service_request_id: serviceRequestId!,
            customer_id: customerId,
            employer_name: employmentTextControllerNew
                .employmentEmployerNameController.text,
            employed_from: joinDateController.text,
            employed_to: leaveDateController.text,
            designation: employmentTextControllerNew
                .employmentDesignationController.text,
            department:
                employmentTextControllerNew.employmentDepartmentController.text,
            remunaration: employmentTextControllerNew
                .employmentRemunerationController.text,
            reporting_manager: employmentTextControllerNew
                .employmentReportingManagerController.text,
            reason_for_leaving: employmentTextControllerNew
                .employmentReasonForLeavingController.text,
            case_uuid: widget.case_uuid,
            till_date: isChecked == true ? 1 : null,
            employment_uuid: widget.employment_uuid));
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
              child: BlocConsumer<EmployShowDataCubit, EmployShowDataState>(
                  listener: (context, employData) {
                if (employData is EmployShowDataSuccessState) {
                  EmploymentShowDataModel data =
                      employData.employmentShowDataModel;
                  employmentTextControllerNew.employmentEmployerNameController
                      .text = data.data!.employer_name ?? "";
                  joinDateController.text = data.data!.employed_from ?? "";
                  leaveDateController.text = data.data!.employed_to ?? "";
                  employmentTextControllerNew.employmentDesignationController
                      .text = data.data!.designation ?? "";
                  employmentTextControllerNew.employmentDepartmentController
                      .text = data.data!.department ?? "";
                  employmentTextControllerNew.employmentRemunerationController
                      .text = data.data!.remunaration ?? "";
                  employmentTextControllerNew
                      .employmentReportingManagerController
                      .text = data.data!.reporting_manager ?? "";
                  employmentTextControllerNew
                      .employmentReasonForLeavingController
                      .text = data.data!.reason_for_leaving ?? "";
                  // ✅ Checkbox logic
                  isChecked = (data.data!.employed_to == null ||
                      data.data!.employed_to!.isEmpty);
                  setState(() {});
                }
              }, builder: (context, employData) {
                if (employData is EmployShowDataLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (employData is EmployShowDataErrorState) {
                  return Center(
                    child: Text(employData.message),
                  );
                } else if (employData is EmployShowDataSuccessState) {
                  EmploymentShowDataModel detailsData =
                      employData.employmentShowDataModel;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Employment Verification Form",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                color: Theme.of(context).primaryColorDark),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Verification Remark:",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.red),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        detailsData.data!.verification_remark!,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Note: * Indicates required fields.",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Employment Details",
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).primaryColorDark, fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      CustomRequiredTextField(
                          controller: employmentTextControllerNew
                              .employmentEmployerNameController,
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
                      Row(
                        children: [
                          Checkbox(
                            value: isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked = value ?? false;

                                if (isChecked) { leaveDateController.clear(); }
                              });
                            },
                            activeColor:
                                Colors.orange, // fill color when checked
                            checkColor: Colors.white, // tick mark color
                          ),
                          Text(
                            "Till Date",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      CustomNotRequiredTextField(
                          controller: employmentTextControllerNew
                              .employmentDesignationController,
                          titleText: "Designation",
                          hintText: "Enter Designation",
                          textInputType: TextInputType.text),
                      CustomNotRequiredTextField(
                          controller: employmentTextControllerNew
                              .employmentDepartmentController,
                          titleText: "Department",
                          hintText: "Enter Department",
                          textInputType: TextInputType.text),
                      CustomNotRequiredTextField(
                          controller: employmentTextControllerNew
                              .employmentRemunerationController,
                          titleText: "Remuneration",
                          hintText: "Enter Remuneration",
                          textInputType: TextInputType.text),
                      CustomNotRequiredTextField(
                          controller: employmentTextControllerNew
                              .employmentReportingManagerController,
                          titleText: "Reporting Manager",
                          hintText: "Enter Reporting Manager",
                          textInputType: TextInputType.text),
                      CustomRequiredTextField(
                          controller: employmentTextControllerNew
                              .employmentReasonForLeavingController,
                          titleText: "Reason For Leaving",
                          hintText: "Enter Reason For Leaving",
                          textInputType: TextInputType.text),
                      const SizedBox(
                        height: 24,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      BlocConsumer<EmploymentUpdateFormCubit,
                              EmploymentUpdateFormState>(
                          listener: (context, employSave) {
                        if (employSave is EmploymentUpdateFormSuccessState) {
                          if (employSave.data["status"] == 200) {
                            context
                                .pushNamed("EmployDataList", pathParameters: {
                              'uid':
                                  employData.employmentShowDataModel.data!.uid!
                            });
                          }
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(employSave.data["message"])));
                        } else if (employSave
                            is EmploymentUpdateFormErrorState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(employSave.message)));
                        }
                      }, builder: (context, employSave) {
                        return CustomButton(
                            isLoading:
                                employSave is EmploymentUpdateFormLoadingState,
                            height: 45,
                            onTap: () {
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
