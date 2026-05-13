import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../apiServices/api_services.dart';
import '../../../../../commonComponent/custom_button.dart';
import '../../../../VerificationForms/common/form_widget.dart';
import '../common_widgets.dart';
import 'Bloc/education_save_form_bloc/education_save_form_cubit.dart';
import 'Bloc/education_save_form_bloc/education_save_form_state.dart';
import 'Bloc/education_update_form_bloc/education_update_form_cubit.dart';
import 'Bloc/education_update_form_bloc/education_update_form_state.dart';
import 'Bloc/education_show_details_bloc/education_show_details_cubit.dart';
import 'Bloc/education_show_details_bloc/education_show_details_state.dart';
import 'Model/education_save_form_model.dart';
import 'Model/education_update_form_model.dart';
import 'Model/education_show_details_model.dart';
import '../../../../VerificationForms/VerifyDeatils/Bloc/verify_details_cubit.dart';
import '../../../../VerificationForms/VerifyDeatils/Bloc/verify_details_state.dart';
import '../../../../VerificationPending/bloc/pendingDoc_cubit.dart';
import '../../../../../commonComponent/bloc/shared_preferences_cubit.dart';

class EducationVerificationCard extends StatefulWidget {
  final String? serviceTitle;
  final Map<String, dynamic>? serviceData;
  final Map<String, dynamic>? applicantData;

  const EducationVerificationCard({
    super.key,
    this.serviceTitle,
    this.serviceData,
    this.applicantData,
  });

  @override
  State<EducationVerificationCard> createState() =>
      _EducationVerificationCardState();
}

class _EducationVerificationCardState extends State<EducationVerificationCard> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final universityNameController = TextEditingController();
  final institutionNameController = TextEditingController();
  final yearOfPassingController = TextEditingController();
  final degreeNameController = TextEditingController();
  final gradeObtainedController = TextEditingController();

  String? selectedGradeType;
  final List<String> gradeTypes = ["Percentage", "CGPA", "Grade"];

  bool isReadOnly = false;
  bool isEditing = false;
  String? artefactImgUrl;
  String? caseUuidFromApi;

  String currentStatus = "Pending";
  String? rejectionReason;
  bool isRejected = false;

  late EducationSaveFormCubit _saveCubit;
  late EducationUpdateFormCubit _updateCubit;
  late EducationShowDetailsCubit _detailsCubit;

  @override
  void initState() {
    super.initState();
    _saveCubit = context.read<EducationSaveFormCubit>();
    _updateCubit = context.read<EducationUpdateFormCubit>();
    _detailsCubit = context.read<EducationShowDetailsCubit>();

    currentStatus = widget.serviceData?['status'] ?? "Pending";

    _fetchDetails();
    _fetchCaseUuid();
  }

  void _fetchDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? "";

    _detailsCubit.educationUpdateForm(
      token: token,
      uid: widget.serviceData?['uid']?.toString() ?? "",
    );
  }

  void _fetchCaseUuid() {
    final token = context.read<TokenCubit>().state;
    context.read<VerifyDetailsCubit>().verifyDetails(
          token: token,
          requestId: widget.applicantData?['request_id']?.toString() ?? "",
        );
  }

  void _populateData(EducationDataDetailsModel response) {
    final data = response.data;
    if (data != null) {
      setState(() {
        isReadOnly = true;
        isEditing = false;
        universityNameController.text = data.universityName ?? "";
        institutionNameController.text = data.institutionName ?? "";
        yearOfPassingController.text = data.yearOfPassing?.toString() ?? "";
        degreeNameController.text = data.degreeQualificationName ?? "";
        selectedGradeType = data.gradesType;
        gradeObtainedController.text = data.gradesObtained ?? "";
        artefactImgUrl = data.artefactImg;

        currentStatus = data.vStatus ?? currentStatus;
        rejectionReason = data.verificationRemark;
        isRejected = (currentStatus.toLowerCase() == 'discrepancy' ||
            currentStatus.toLowerCase() == 'reject');
      });
    }
  }

  void _refreshPendingDocs(BuildContext context) {
    final token = context.read<TokenCubit>().state;
    final customerIdStr = context.read<IdCubit>().state;
    final customerId = int.tryParse(customerIdStr) ?? 0;

    context.read<PendingDocCubit>().getPendingDoc(
          token: token,
          customerId: customerId,
          page: 1,
          limit: 100,
          isLoading: false,
        );
  }

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? "";
      final customerId = prefs.getString('id') ?? "";

      if (isEditing) {
        final updateModel = EducationUpdateFormModel(
          uid: widget.serviceData?['uid']?.toString() ?? "",
          request_id: widget.applicantData?['request_id']?.toString() ?? "",
          service_request_id:
              widget.serviceData?['service_request_id']?.toString() ?? "",
          university_name: universityNameController.text.trim(),
          instituition_name: institutionNameController.text.trim(),
          year_of_passing: yearOfPassingController.text.trim(),
          degree_qualification_name: degreeNameController.text.trim(),
          grades_type: selectedGradeType ?? "",
          grades_obtained: gradeObtainedController.text.trim(),
          case_uuid: caseUuidFromApi ??
              widget.applicantData?['case_uuid']?.toString() ??
              "",
          education_uuid:
              widget.serviceData?['education_uuid']?.toString() ?? "",
        );
        _updateCubit.educationUpdateForm(
          token: token,
          customer_id: customerId,
          educationUpdateFormModel: updateModel,
        );
      } else {
        final saveModel = EducationSaveFormModel(
          request_id: widget.applicantData?['request_id']?.toString() ?? "",
          service_request_id:
              widget.serviceData?['service_request_id']?.toString() ?? "",
          university_name: universityNameController.text.trim(),
          instituition_name: institutionNameController.text.trim(),
          year_of_passing: yearOfPassingController.text.trim(),
          degree_qualification_name: degreeNameController.text.trim(),
          grades_type: selectedGradeType ?? "",
          grades_obtained: gradeObtainedController.text.trim(),
          case_uuid: caseUuidFromApi ??
              widget.applicantData?['case_uuid']?.toString() ??
              "",
        );
        _saveCubit.educationSaveForm(
          token: token,
          customer_id: customerId,
          educationSaveFormModel: saveModel,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<VerifyDetailsCubit, VerifyDetailsState>(
          listener: (context, state) {
            if (state is VerifyDetailsSuccessState) {
              setState(() {
                caseUuidFromApi = state.verifyDetailsModel.data?.caseUuid;
              });
            }
          },
        ),
        BlocListener<EducationShowDetailsCubit, EducationShowDetailsState>(
          listener: (context, state) {
            if (state is EducationShowDetailsSuccessState) {
              _populateData(state.educationDataDetailsModel);
            }
          },
        ),
        BlocListener<EducationSaveFormCubit, EducationSaveFormState>(
          listener: (context, state) {
            if (state is EducationSaveFormSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Education details saved successfully!"),
                    backgroundColor: Colors.green),
              );
              setState(() {
                isReadOnly = true;
                isEditing = false;
              });
              _fetchDetails();
              _refreshPendingDocs(context);
            } else if (state is EducationSaveFormErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(state.message), backgroundColor: Colors.red),
              );
            }
          },
        ),
        BlocListener<EducationUpdateFormCubit, EducationUpdateFormState>(
          listener: (context, state) {
            if (state is EducationUpdateFormSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Education details updated successfully!"),
                    backgroundColor: Colors.green),
              );
              setState(() {
                isReadOnly = true;
                isEditing = false;
              });
              _fetchDetails();
              _refreshPendingDocs(context);
            } else if (state is EducationUpdateFormErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(state.message), backgroundColor: Colors.red),
              );
            }
          },
        ),
      ],
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(Icons.school_outlined,
                              color: Color(0xFFFFB74D), size: 28),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              widget.serviceTitle ?? "Education Verification",
                              style: GoogleFonts.outfit(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF263238),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    StatusChip(
                      status: (currentStatus.isNotEmpty)
                          ? '${currentStatus[0].toUpperCase()}${currentStatus.substring(1).toLowerCase()}'
                          : "Pending",
                    ),
                  ],
                ),
                if (isRejected && rejectionReason != null)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 12),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: const Color(0xFFEF9A9A).withOpacity(0.5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.info_outline,
                                color: Color(0xFFD32F2F), size: 18),
                            const SizedBox(width: 8),
                            Text(
                              "Verification Remark",
                              style: GoogleFonts.outfit(
                                color: const Color(0xFFD32F2F),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          rejectionReason ?? "No remark provided",
                          style: GoogleFonts.outfit(
                            color: const Color(0xFFB71C1C),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            form_widget(
              controller: universityNameController,
              titleText: "University Name",
              hintText: "University Name",
              textInputType: TextInputType.text,
              isReadOnly: isReadOnly,
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? "University name is required"
                  : null,
            ),
            form_widget(
              controller: institutionNameController,
              titleText: "Institute Name",
              hintText: "College/School",
              textInputType: TextInputType.text,
              isReadOnly: isReadOnly,
              isRequired: false,
            ),
            form_widget(
              controller: degreeNameController,
              titleText: "Degree Name",
              hintText: "B.Tech, MBA, etc.",
              textInputType: TextInputType.text,
              isReadOnly: isReadOnly,
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? "Degree name is required"
                  : null,
            ),
            form_widget(
              controller: yearOfPassingController,
              titleText: "Year of Passing",
              hintText: "YYYY",
              textInputType: TextInputType.number,
              isReadOnly: isReadOnly,
              validator: (value) {
                if (value == null || value.trim().isEmpty)
                  return "Year of passing is required";
                if (value.length != 4) return "Enter a valid year (YYYY)";
                return null;
              },
            ),
            FormDropdownWidget(
              titleText: "Grade Type",
              hintText: "Select Grade Type",
              items: gradeTypes,
              value: selectedGradeType,
              isRequired: false,
              onChanged: isReadOnly
                  ? null
                  : (val) {
                      setState(() => selectedGradeType = val);
                    },
            ),
            form_widget(
              controller: gradeObtainedController,
              titleText: "Grade Obtained",
              hintText: "Grade/Percentage/Cgpa",
              textInputType: TextInputType.text,
              isReadOnly: isReadOnly,
              isRequired: false,
            ),
            if (artefactImgUrl != null && artefactImgUrl!.isNotEmpty)
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: InkWell(
                    onTap: () {
                      context.pushNamed(
                        'preview',
                        extra: artefactImgUrl,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F4FF),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE0E7FF)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.link,
                              color: Color(0xFF4F46E5), size: 18),
                          const SizedBox(width: 8),
                          Text(
                            "View Artefact",
                            style: GoogleFonts.outfit(
                              color: const Color(0xFF4F46E5),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            if (!isReadOnly || isEditing)
              Align(
                alignment: Alignment.centerRight,
                child: CustomButton(
                  text: isEditing ? "Update" : "Submit",
                  width: 140,
                  height: 48,
                  prefixIcon: isEditing ? Icons.edit : Icons.send,
                  iconSize: 18,
                  gradientColors: const [
                    Color(0xFFF4511E),
                    Color(0xFFFFB74D),
                  ],
                  onTap: () => _submitForm(context),
                ),
              )
            else if (isReadOnly)
              Align(
                alignment: Alignment.centerRight,
                child: CustomButton(
                  text: "Edit",
                  width: 120,
                  height: 48,
                  prefixIcon: Icons.edit_note,
                  iconSize: 18,
                  gradientColors: const [
                    Color(0xFF455A64),
                    Color(0xFF78909C),
                  ],
                  onTap: () {
                    setState(() {
                      isReadOnly = false;
                      isEditing = true;
                    });
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
