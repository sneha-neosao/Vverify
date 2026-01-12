import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/screen/VerificationForms/EducationVerification/SaveForm/TextController/education_text_controller_new.dart';
import 'package:v_verify/screen/VerificationForms/EducationVerification/Update/ShowDetails/Bloc/education_show_details_cubit.dart';
import 'package:v_verify/screen/VerificationForms/common/form_widget.dart';
import 'package:v_verify/screen/VerificationForms/common/id.dart';

import '../../../../commonComponent/custom_button.dart';
import '../Names/Collage/Bloc/collage_name_cubit.dart';
import '../Names/University/Bloc/university_name_bloc.dart';
import '../SaveForm/Bloc/education_save_form_bloc.dart';
import 'Bloc/Education_update_form_cubit.dart';
import 'Bloc/education_update_form_state.dart';
import 'Model/education_update_form_model.dart';
import 'ShowDetails/Bloc/education_show_details_state.dart';
import 'ShowDetails/Model/education_show_details_model.dart';

class EducationSaveFormUpdateNew extends StatefulWidget {
  final String uid;
  final String case_uuid;
  final String education_uuid;

  const EducationSaveFormUpdateNew({Key? key, required this.uid, required this.case_uuid, required this.education_uuid}) : super(key: key);

  @override
  State<EducationSaveFormUpdateNew> createState() => _EducationSaveFormUpdateNewState();
}

class _EducationSaveFormUpdateNewState extends State<EducationSaveFormUpdateNew> {
  final _formKey = GlobalKey<FormState>();
  String? selectedGrade;
  List<String> gradeValues = <String>['Percentage', 'CGPA', 'Grade'];
  String? descrepancy_reason ;

  @override
  void initState() {
    educationControllerRecreateNew();
    // universityNameLoad();
    // collageNameLoad();
    educationDetailsDataLoad();
    print(
      "uuid at update form : ${widget.uid}\n"
      "case uuid at update form : ${widget.case_uuid}\n"
      "education uuid at update form : ${widget.education_uuid}"
    );
    super.initState();
  }

  void educationDetailsDataLoad() {
    String token = context.read<TokenCubit>().state;
    context
        .read<EducationShowDetailsCubit>()
        .educationUpdateForm(token: token, uid: widget.uid);
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
    grades_obtained: ${educationTextControllerNew.educationGradeObtainedController.text}
    uuid: ${widget.uid}
    case_uuid: ${widget.case_uuid}
    education: ${widget.education_uuid}
    ''');

    context.read<EducationUpdateFormCubit>().educationUpdateForm(
        customer_id: customerId,
        token: token,
        educationUpdateFormModel: EducationUpdateFormModel(
          uid: widget.uid,
          request_id: requestId!,
          service_request_id: serviceRequestId!,
          university_name: educationTextControllerNew.educationUniversityNameController.text,
          instituition_name: educationTextControllerNew.educationInstitutionNameController.text,
          year_of_passing: educationTextControllerNew.educationYearOfPassingController.text,
          degree_qualification_name: educationTextControllerNew.educationDegreeQualificationNameController.text,
          grades_type: selectedGrade ?? "",
          grades_obtained: educationTextControllerNew.educationGradeObtainedController.text,
          case_uuid: widget.case_uuid,
          education_uuid: widget.education_uuid
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
              child: BlocConsumer<EducationShowDetailsCubit,
                  EducationShowDetailsState>
                (listener: (context, educationData) {
                if (educationData is EducationShowDetailsSuccessState) {
                  EducationDataDetailsModel data =
                      educationData.educationDataDetailsModel;
                  educationTextControllerNew.educationUniversityNameController.text = data.data!.universityName ?? "";
                  educationTextControllerNew.educationInstitutionNameController.text = data.data!.institutionName ?? "";
                  educationTextControllerNew.educationDegreeQualificationNameController.text = data.data!.degreeQualificationName ?? "";
                  educationTextControllerNew.educationYearOfPassingController.text = data.data!.yearOfPassing.toString() ?? "";
                  educationTextControllerNew.educationGradeObtainedController.text = data.data!.gradesObtained ?? "";

                  // Set the dropdown initially if API provides value
                  setState(() {
                    selectedGrade = gradeValues.contains(data.data!.gradesType)
                        ? data.data!.gradesType
                        : null; // null means hint will show
                    descrepancy_reason = data.data!.verificationRemark;
                  });

                }
              }, builder: (context, educationData) {
                if (educationData is EducationShowDetailsLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (educationData is EducationShowDetailsErrorState) {
                  return Center(
                    child: Text(educationData.message),
                  );
                } else if (educationData is EducationShowDetailsSuccessState) {
                  EducationDataDetailsModel detailsData =
                      educationData.educationDataDetailsModel;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Education Verification",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Theme.of(context).primaryColorDark),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      // Text("Choose an Option:",
                      //     style: Theme.of(context).textTheme.bodySmall),

                      // BlocProvider(
                      //   create: (_) => FormUploadEducationtCubit(),
                      //   child: BlocBuilder<FormUploadEducationtCubit, bool>(
                      //       builder: (context, frmUpload) {
                      //         return Column(
                      //           children: [
                      //             ListTile(
                      //               splashColor: Colors.transparent,
                      //               onTap: () {
                      //                 context
                      //                     .read<FormUploadEducationtCubit>()
                      //                     .formUploadYesNo(yesNo: false);
                      //               },
                      //               contentPadding: const EdgeInsets.all(0),
                      //               leading: Icon(Icons.radio_button_checked,
                      //                   color: !frmUpload
                      //                       ? Theme.of(context).primaryColorLight
                      //                       : Theme.of(context).iconTheme.color),
                      //               title: Text("Fill the Form Manually",
                      //                   style: Theme.of(context).textTheme.bodySmall),
                      //             ),
                      //             ListTile(
                      //               splashColor: Colors.transparent,
                      //               onTap: () {
                      //                 context.pushReplacementNamed("EducationDocUpload");
                      //                 context
                      //                     .read<FormUploadEducationtCubit>()
                      //                     .formUploadYesNo(yesNo: true);
                      //               },
                      //               contentPadding: const EdgeInsets.all(0),
                      //               leading: Icon(
                      //                 Icons.radio_button_checked,
                      //                 color: frmUpload
                      //                     ? Theme.of(context).primaryColorLight
                      //                     : Theme.of(context).iconTheme.color,
                      //               ),
                      //               title: Text("Upload Documents",
                      //                   style: Theme.of(context).textTheme.bodySmall),
                      //             ),
                      //           ],
                      //         );
                      //       }),
                      // ),
                      Text(
                        "Rejected Reason:",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.red),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        descrepancy_reason ?? "NA",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Colors.white),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        "Educational Details",
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).primaryColorDark, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        "Note : Fill all required fields.",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(fontSize: 12, color: Colors.grey),
                      ),
                      form_widget(
                          controller: educationTextControllerNew.educationUniversityNameController,
                          titleText: "Name Of University",
                          hintText: "Enter Name Of University",
                          textInputType: TextInputType.text),
                      FormFieldNotRequired(
                          controller: educationTextControllerNew.educationInstitutionNameController,
                          titleText: "Name Of Institute/College",
                          hintText: "Enter Name Of Institute/College",
                          textInputType: TextInputType.text),
                      form_widget(
                        controller: educationTextControllerNew.educationYearOfPassingController,
                        titleText: 'Year Of Passing',
                        hintText: "Enter Year Of Passing",
                        textInputType: TextInputType.number,
                      ),

                      form_widget(
                        controller: educationTextControllerNew.educationDegreeQualificationNameController,
                        titleText: 'Name Of Degree',
                        hintText: "Enter Name Of Degree",
                        textInputType: TextInputType.text,
                      ),
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
                          value: gradeValues.contains(selectedGrade) ? selectedGrade : null,
                          hint: Text(
                            "Select Percentage/CGPA/Grade",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: Colors.grey),
                          ),
// validator: (value) {
//   if (value == null || value.isEmpty) {
//     return "Please Select Gender";
//   }
//   return null;
// },
                          onChanged: (String? value) {
                            setState(() {
                              selectedGrade = value;
                            });
                          },
                          items: gradeValues.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
                            );
                          }).toList(),
                          dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                          decoration: InputDecoration(
                            contentPadding:
                            const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                              BorderSide(color: Theme.of(context).canvasColor, width: 1.0),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Theme.of(context).canvasColor, width: 1.0),
                            ),
                            filled: true,
                            fillColor: Theme.of(context).scaffoldBackgroundColor,
                          ),
                        ),
                      ),
                      FormFieldNotRequired(
                        controller: educationTextControllerNew.educationGradeObtainedController,
                        titleText: 'Percentage/CGPA/Grade Obtained',
                        hintText: "Enter Percentage/CGPA/Grade Obtained",
                        textInputType: TextInputType.text,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      BlocConsumer<EducationUpdateFormCubit,
                          EducationUpdateFormState>(
                          listener: (context, education) {
                            if (education is EducationUpdateFormSuccessState) {
                              if (education.data["status"] == 200) {
                                context.pushNamed("EducationList",pathParameters: {
                                  'uid': widget.case_uuid
                                });
                                context
                                    .read<EducationCertificateDocuments>()
                                    .clearImage();
                              }
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(education.data["message"])));
                            } else if (education is EducationUpdateFormErrorState) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(education.message)));
                            }
                          }, builder: (context, educationUpdate) {
                        return CustomButton(
                            isLoading: educationUpdate
                            is EducationUpdateFormLoadingState,
                            height: 45,
                            onTap: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              if (_formKey.currentState?.validate() ?? false) {
                                educationSaveData();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                        Text("Please fill all fields")));
                              }
                            },
                            text: "Update",
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