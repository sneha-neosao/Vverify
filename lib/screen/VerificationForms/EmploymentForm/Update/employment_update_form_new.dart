import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentForm/Save/Bloc/EmploymentSaveForm.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentForm/TextController/EmploymentSaveFormControllerNew.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentForm/Update/Bloc/employment_update_form.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentForm/Update/Bloc/employment_update_form_state.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentForm/Update/Model/employment_update_form_model.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentForm/Update/showData/Bloc/employ_show_data_cubit.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentForm/Update/showData/Bloc/employ_show_data_state.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentForm/Update/showData/Model/employ_show_data_model.dart';
import 'package:v_verify/screen/VerificationForms/common/form_widget.dart';
import '../../../../commonComponent/custom_button.dart';
import '../../common/id.dart';

class EmploymentUpdateFormNew extends StatefulWidget {
  final String uid;

  const EmploymentUpdateFormNew({super.key, required this.uid});

  @override
  State<EmploymentUpdateFormNew> createState() => _EmploymentUpdateFormNewState();
}

class _EmploymentUpdateFormNewState extends State<EmploymentUpdateFormNew> {
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
    context.read<EmploymentUpdateFormCubit>().employmentUpdateForm(
        customer_id: customerId,
        token: token,
        employmentUpdateFormModel: EmploymentUpdateFormModel(
            uid: widget.uid,
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
            employment_supporting_doc: ""
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
              child: BlocConsumer<EmployShowDataCubit,
                  EmployShowDataState>
                (listener: (context, educationData) {
                if (educationData is EmployShowDataSuccessState) {
                  EmploymentShowDataModel data =
                      educationData.employmentShowDataModel;
                  employmentTextControllerNew.employmentEmployerNameController.text = data.data!.employer_name ?? "";
                  joinDateController.text = data.data!.employed_from ?? "";
                  leaveDateController.text = data.data!.employed_to ?? "";
                  employmentTextControllerNew.employmentDesignationController.text = data.data!.designation ?? "";
                  employmentTextControllerNew.employmentDepartmentController.text = data.data!.department ?? "";
                  employmentTextControllerNew.employmentRemunerationController.text = data.data!.remunaration ?? "";
                  employmentTextControllerNew.employmentReportingManagerController.text = data.data!.reporting_manager ?? "";
                  employmentTextControllerNew.employmentReasonForLeavingController.text = data.data!.reason_for_leaving ?? "";
                }
              }, builder: (context, educationData) {
                if (educationData is EmployShowDataLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (educationData is EmployShowDataErrorState) {
                  return Center(
                    child: Text(educationData.message),
                  );
                } else if (educationData is EmployShowDataSuccessState) {
                  EmploymentShowDataModel detailsData =
                      educationData.employmentShowDataModel;
                  return Column(
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
                      Text("Choose an Option:",
                          style: Theme.of(context).textTheme.bodySmall),
                      BlocProvider(
                        create: (_) => FormUploadEmploymentCubit(),
                        child: BlocBuilder<FormUploadEmploymentCubit, bool>(
                            builder: (context, frmUpload) {
                              return

                                Column(
                                  children: [
                                    ListTile(
                                      splashColor: Colors.transparent,
                                      onTap: () {
                                        context
                                            .read<FormUploadEmploymentCubit>()
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
                                        context.pushReplacementNamed(
                                            "EmploymentUploadDocument");

                                        context
                                            .read<FormUploadEmploymentCubit>()
                                            .formUploadYesNo(yesNo: false);

                                        context
                                            .read<FormUploadEmploymentCubit>()
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
                        "Employment Details",
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).primaryColorDark, fontSize: 16),
                      ),
                      form_widget(
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
                      BlocConsumer<EmploymentUpdateFormCubit,
                          EmploymentUpdateFormState>(
                          listener: (context, employSave) {
                            if (employSave is EmploymentUpdateFormSuccessState) {
                              if (employSave.data["status"] == 200) {
                                context.pushReplacementNamed("EmployDataList");

                                context.read<EmploymentLetterImage>().clearImage();
                                context
                                    .read<EmploymentSupportDocumentImage>()
                                    .clearImage();
                              }
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(employSave.data["message"])));
                            } else if (employSave is EmploymentUpdateFormErrorState) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(employSave.message)));
                            }
                          }, builder: (context, employSave) {
                        return CustomButton(
                            isLoading:
                            employSave is EmploymentUpdateFormLoadingState,
                            height: 45,
                            onTap: () {
                              context.pushReplacementNamed("EmployDataList");
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
