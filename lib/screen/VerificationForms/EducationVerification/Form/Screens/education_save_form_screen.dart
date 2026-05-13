import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/screen/AllFormList/FormList/widgets/EducationVerification/Bloc/education_save_form_bloc/education_save_form_cubit.dart';
import 'package:v_verify/screen/AllFormList/FormList/widgets/EducationVerification/Bloc/education_save_form_bloc/education_save_form_state.dart';
import 'package:v_verify/screen/VerificationForms/EducationVerification/Form/TextController/education_text_controllers.dart';
import 'package:v_verify/screen/VerificationForms/common/id.dart';
import 'package:v_verify/widgets/custom_not_required_text_field.dart';
import 'package:v_verify/widgets/custom_required_text_field.dart';

import '../../../../../commonComponent/custom_button.dart';
import '../../Names/Collage/Bloc/collage_name_cubit.dart';
import '../../Names/University/Bloc/university_name_bloc.dart';
import '../../../../AllFormList/FormList/widgets/EducationVerification/Model/education_save_form_model.dart';

class EducationSaveFormScreen extends StatefulWidget {
  String Case_uuid;

  EducationSaveFormScreen({
    super.key,
    required this.Case_uuid,
  });

  @override
  State<EducationSaveFormScreen> createState() =>
      _EducationSaveFormScreenState();
}

class _EducationSaveFormScreenState extends State<EducationSaveFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedGrade;
  List<String> gradeValues = <String>['Percentage', 'CGPA', 'Grade'];

  @override
  void initState() {
    educationControllerRecreateNew();
    // universityNameLoad();
    // collageNameLoad();
    print("case uuid at save form : ${widget.Case_uuid}");
    super.initState();
  }

  @override
  void dispose() {
    clearEducationControllerNew();
    super.dispose();
  }

  void educationSaveData() {
    String token = context.read<TokenCubit>().state;
    String customerId = context.read<IdCubit>().state;
    debugPrint('''
    Education Form Data:
    request_id: $requestId
    service_request_id: $serviceRequestId
    university_name: ${educationTextControllerNew.educationUniversityNameController.text}
    institution_name: ${educationTextControllerNew.educationInstitutionNameController.text}
    year_of_passing: ${educationTextControllerNew.educationYearOfPassingController.text}
    degree_qualification_name: ${educationTextControllerNew.educationDegreeQualificationNameController.text}
    grades_type: ${selectedGrade ?? ""}
    grades_obtained: ${educationTextControllerNew.educationGradeObtainedController.text},
    case_uuid: ${widget.Case_uuid}
    ''');

    context.read<EducationSaveFormCubit>().educationSaveForm(
        customer_id: customerId,
        token: token,
        educationSaveFormModel: EducationSaveFormModel(
          request_id: requestId!,
          service_request_id: serviceRequestId!,
          university_name:
              educationTextControllerNew.educationUniversityNameController.text,
          instituition_name: educationTextControllerNew
              .educationInstitutionNameController.text,
          year_of_passing:
              educationTextControllerNew.educationYearOfPassingController.text,
          degree_qualification_name: educationTextControllerNew
              .educationDegreeQualificationNameController.text,
          grades_type: selectedGrade ?? "",
          grades_obtained:
              educationTextControllerNew.educationGradeObtainedController.text,
          case_uuid: widget.Case_uuid,
        ));
  }

  void universityNameLoad() {
    String token = context.read<TokenCubit>().state;
    context.read<UniversityNameBloc>().universityList(token: token);
  }

  void collageNameLoad() {
    String token = context.read<TokenCubit>().state;
    context.read<CollageNameCubit>().collageNameList(token: token);
  }

  String? dropDownUniBordName;
  String? dropDownCollageName;

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
                    "Education Verification",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Theme.of(context).primaryColorDark),
                  ),
                  const SizedBox(height: 4),
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
                    "Education Details",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  CustomRequiredTextField(
                      controller: educationTextControllerNew
                          .educationUniversityNameController,
                      titleText: "Name Of University",
                      hintText: "Enter Name Of University",
                      textInputType: TextInputType.text),
                  CustomNotRequiredTextField(
                      controller: educationTextControllerNew
                          .educationInstitutionNameController,
                      titleText: "Name Of Institute/College",
                      hintText: "Enter Name Of Institute/College",
                      textInputType: TextInputType.text),
                  CustomRequiredTextField(
                      controller: educationTextControllerNew
                          .educationYearOfPassingController,
                      titleText: "Year Of Passing",
                      hintText: "Enter Year Of Passing",
                      textInputType: TextInputType.text),
                  CustomRequiredTextField(
                      controller: educationTextControllerNew
                          .educationDegreeQualificationNameController,
                      titleText: "Name Of Degree",
                      hintText: "Enter Name Of Degree",
                      textInputType: TextInputType.text),
                  const SizedBox(
                    height: 16,
                  ),
                  RichText(
                      text: TextSpan(
                    text: "Percentage/CGPA/Grade",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontWeight: FontWeight.w700),
                  )),
                  const SizedBox(
                    height: 4,
                  ),
                  SizedBox(
                    height: 54,
                    child: DropdownButtonFormField<String>(
                      value: gradeValues.contains(selectedGrade)
                          ? selectedGrade
                          : null,
                      hint: Text(
                        "Select Percentage/CGPA/Grade",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Colors.grey),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          selectedGrade = value;
                        });
                      },
                      items: gradeValues.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              style: Theme.of(context).textTheme.bodyMedium),
                        );
                      }).toList(),
                      dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18.0, vertical: 14.0),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: Theme.of(context).canvasColor, width: 1.0),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: Theme.of(context).canvasColor, width: 1.0),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
                  ),
                  CustomNotRequiredTextField(
                      controller: educationTextControllerNew
                          .educationGradeObtainedController,
                      titleText: "Percentage/CGPA/Grade Obtained",
                      hintText: "Enter Percentage/CGPA/Grade Obtained",
                      textInputType: TextInputType.text),
                  const SizedBox(
                    height: 24,
                  ),
                  BlocConsumer<EducationSaveFormCubit, EducationSaveFormState>(
                      listener: (context, education) {
                    if (education is EducationSaveFormSuccessState) {
                      if (education.data["status"] == 200) {
                        educationUniversityBoards = null;
                        educationSchoolBoards = null;
                        context.pushNamed("EducationList",
                            pathParameters: {'uid': widget.Case_uuid});
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(education.data["message"])));
                    } else if (education is EducationSaveFormErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(education.message)));
                    }
                  }, builder: (context, education) {
                    return CustomButton(
                        height: 45,
                        isLoading: education is EducationSaveFormLoadingState,
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (_formKey.currentState?.validate() ?? false) {
                            educationSaveData();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Please fill all fields")));
                          }
                        },
                        text: "Submit",
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
