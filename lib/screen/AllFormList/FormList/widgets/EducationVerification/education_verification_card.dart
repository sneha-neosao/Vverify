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
import 'Bloc/education_list_cubit.dart';
import 'Bloc/education_list_state.dart';
import 'Model/education_save_form_model.dart';
import 'Model/education_update_form_model.dart';
import 'Model/education_show_details_model.dart';
import '../../../../VerificationForms/VerifyDeatils/Bloc/verify_details_cubit.dart';
import '../../../../VerificationForms/VerifyDeatils/Bloc/verify_details_state.dart';
import '../../../../VerificationPending/bloc/pendingDoc_cubit.dart';
import '../../../../VerificationPending/Pagination/DashBoard/bloc/pending_doc_navigation_cubit.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
  String? _uid;
  String? _educationUuid;

  String currentStatus = "Pending";
  String? rejectionReason;
  bool isRejected = false;

  late final EducationSaveFormCubit _saveCubit;
  late final EducationUpdateFormCubit _updateCubit;
  late final EducationShowDetailsCubit _detailsCubit;
  late final EducationListCubit _listCubit;
  late final VerifyDetailsCubit _verifyDetailsCubit;

  @override
  void initState() {
    super.initState();
    _saveCubit = EducationSaveFormCubit(ApiService());
    _updateCubit = EducationUpdateFormCubit(ApiService());
    _detailsCubit = EducationShowDetailsCubit(ApiService());
    _listCubit = EducationListCubit(ApiService());
    _verifyDetailsCubit = VerifyDetailsCubit(ApiService());

    caseUuidFromApi = widget.applicantData?['case_uuid']?.toString() ?? "";
    currentStatus = widget.serviceData?['status']?.toString() ?? "Pending";

    _fetchEducationList();
    _fetchVerifyDetails();
  }

  @override
  void dispose() {
    _saveCubit.close();
    _updateCubit.close();
    _detailsCubit.close();
    _listCubit.close();
    _verifyDetailsCubit.close();
    universityNameController.dispose();
    institutionNameController.dispose();
    yearOfPassingController.dispose();
    degreeNameController.dispose();
    gradeObtainedController.dispose();
    super.dispose();
  }

  Future<void> _fetchEducationList() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? "";
    final requestId =
        int.tryParse(widget.applicantData?['request_id']?.toString() ?? "");
    final serviceRequestId = int.tryParse(
        widget.serviceData?['service_request_id']?.toString() ?? "");

    debugPrint('Education List token: $token');
    debugPrint('Education List request_id: $requestId');
    debugPrint('Education List service_request_id: $serviceRequestId');

    if (token.isNotEmpty && requestId != null && serviceRequestId != null) {
      _listCubit.educationList(
        token: token,
        requestId: requestId,
        serviceRequestId: serviceRequestId,
      );
    }
  }

  Future<void> _fetchVerifyDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? "";
    final requestId = widget.applicantData?['request_id']?.toString() ?? "";
    if (token.isNotEmpty && requestId.isNotEmpty) {
      _verifyDetailsCubit.verifyDetails(token: token, requestId: requestId);
    }
  }

  Future<void> _fetchShowData({required String uid}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? "";
    if (token.isNotEmpty && uid.isNotEmpty) {
      _detailsCubit.educationUpdateForm(token: token, uid: uid);
    }
  }

  Future<void> _checkAndFetchDetails({bool force = false}) async {
    _fetchEducationList();
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

        final serviceUid = widget.serviceData?['uid']?.toString() ?? "";
        if (_uid == null || _uid!.isEmpty) {
          _uid = serviceUid.isNotEmpty ? serviceUid : (data.uid ?? "");
        }

        final eduUuid = widget.serviceData?['education_uuid']?.toString() ?? "";
        if (_educationUuid == null || _educationUuid!.isEmpty) {
          _educationUuid = eduUuid.isNotEmpty ? eduUuid : (data.uid ?? "");
        }

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
    final navState = context.read<PendingDocNavigationCubit>().state;

    context.read<PendingDocCubit>().getPendingDoc(
          token: token,
          customerId: customerId,
          page: 1,
          limit: 100,
          entityId: navState.entityId,
          isLoading: false,
        );
  }

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? "";
      final customerId = prefs.getString('id') ?? "";

      final requestId = widget.applicantData?['request_id']?.toString() ?? "";
      final serviceRequestId =
          widget.serviceData?['service_request_id']?.toString() ?? "";

      final caseUuid = caseUuidFromApi ??
          widget.applicantData?['case_uuid']?.toString() ??
          "";

      debugPrint("case uuid: $caseUuid");

      if (caseUuid.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Case UUID is required to submit education details."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (isEditing) {
        final finalUid = (_uid != null && _uid!.isNotEmpty)
            ? _uid!
            : (widget.serviceData?['uid']?.toString() ?? "");

        final finalEduUuid =
            (_educationUuid != null && _educationUuid!.isNotEmpty)
                ? _educationUuid!
                : (widget.serviceData?['education_uuid']?.toString() ?? "");

        final updateModel = EducationUpdateFormModel(
          uid: finalUid,
          request_id: requestId,
          service_request_id: serviceRequestId,
          university_name: universityNameController.text.trim(),
          instituition_name: institutionNameController.text.trim(),
          year_of_passing: yearOfPassingController.text.trim(),
          degree_qualification_name: degreeNameController.text.trim(),
          grades_type: selectedGradeType ?? "",
          grades_obtained: gradeObtainedController.text.trim(),
          case_uuid: caseUuid,
          education_uuid: finalEduUuid,
        );
        _updateCubit.educationUpdateForm(
          token: token,
          customer_id: customerId,
          educationUpdateFormModel: updateModel,
        );
      } else {
        final saveModel = EducationSaveFormModel(
          request_id: requestId,
          service_request_id: serviceRequestId,
          university_name: universityNameController.text.trim(),
          instituition_name: institutionNameController.text.trim(),
          year_of_passing: yearOfPassingController.text.trim(),
          degree_qualification_name: degreeNameController.text.trim(),
          grades_type: selectedGradeType ?? "",
          grades_obtained: gradeObtainedController.text.trim(),
          case_uuid: caseUuid,
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
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _saveCubit),
        BlocProvider.value(value: _updateCubit),
        BlocProvider.value(value: _detailsCubit),
        BlocProvider.value(value: _listCubit),
        BlocProvider.value(value: _verifyDetailsCubit),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<EducationListCubit, EducationDataListState>(
            listener: (context, state) {
              if (state is EducationDataListSuccessState) {
                final records = state.educationListDataModel.data;
                if (records != null && records.isNotEmpty) {
                  final uid = records.first.uid ?? "";
                  final educationUuid = records.first.educationUuid ?? "";
                  setState(() {
                    _uid = uid;
                    _educationUuid = educationUuid;
                  });
                  if (uid.isNotEmpty) {
                    _fetchShowData(uid: uid);
                  }
                }
              }
            },
          ),
          BlocListener<EducationSaveFormCubit, EducationSaveFormState>(
            listener: (context, state) {
              if (state is EducationSaveFormSuccessState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Education details saved successfully!"),
                    backgroundColor: Colors.green,
                  ),
                );
                setState(() {
                  isReadOnly = true;
                  isEditing = false;
                });
                _checkAndFetchDetails(force: true);
                _refreshPendingDocs(context);
              } else if (state is EducationSaveFormErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
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
                    backgroundColor: Colors.green,
                  ),
                );
                setState(() {
                  isReadOnly = true;
                  isEditing = false;
                });
                _checkAndFetchDetails(force: true);
                _refreshPendingDocs(context);
              } else if (state is EducationUpdateFormErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
          BlocListener<EducationShowDetailsCubit, EducationShowDetailsState>(
            listener: (context, state) {
              if (state is EducationShowDetailsSuccessState) {
                _populateData(state.educationDataDetailsModel);
              } else if (state is EducationShowDetailsErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
          BlocListener<VerifyDetailsCubit, VerifyDetailsState>(
            listener: (context, state) {
              if (state is VerifyDetailsSuccessState) {
                setState(() {
                  caseUuidFromApi = state.verifyDetailsModel.data?.caseUuid ??
                      state.verifyDetailsModel.data?.uuid;
                });
                debugPrint(
                    "Fetched case uuid via VerifyDetailsCubit: $caseUuidFromApi");
              }
            },
          ),
        ],
        child: BlocBuilder<EducationListCubit, EducationDataListState>(
          builder: (context, listState) {
            return BlocBuilder<EducationShowDetailsCubit,
                EducationShowDetailsState>(
              builder: (context, showState) {
                return BlocBuilder<EducationSaveFormCubit,
                    EducationSaveFormState>(
                  builder: (context, saveState) {
                    return BlocBuilder<EducationUpdateFormCubit,
                        EducationUpdateFormState>(
                      builder: (context, updateState) {
                        if (listState is EducationDataListLoadingState ||
                            showState is EducationShowDetailsLoadingState ||
                            saveState is EducationSaveFormLoadingState ||
                            updateState is EducationUpdateFormLoadingState) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        String currentStatus =
                            widget.serviceData?['status']?.toString() ??
                                "PENDING";
                        if (listState is EducationDataListEmptyState) {
                          currentStatus = "Pending";
                        } else if (showState
                            is EducationShowDetailsSuccessState) {
                          currentStatus = showState
                                  .educationDataDetailsModel.data?.vStatus ??
                              currentStatus;
                        }

                        if (currentStatus.trim().isEmpty ||
                            currentStatus == "-") {
                          currentStatus = "Pending";
                        }

                        final bool isRejected = currentStatus
                                .toLowerCase()
                                .contains("reject") ||
                            currentStatus.toLowerCase().contains("discrepancy");

                        String? rejectionReason = this.rejectionReason;
                        if (showState is EducationShowDetailsSuccessState) {
                          rejectionReason = showState.educationDataDetailsModel
                                  .data?.verificationRemark ??
                              rejectionReason;
                        }

                        return Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.disabled,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        const Icon(Icons.school_outlined,
                                            color: Color(0xFFFFB74D), size: 28),
                                        const SizedBox(width: 12),
                                        Flexible(
                                          child: Text(
                                            widget.serviceTitle ??
                                                "Education Verification",
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
                              if (rejectionReason != null &&
                                  rejectionReason.isNotEmpty)
                                Builder(builder: (context) {
                                  final bool isRejectTheme = isRejected;
                                  final Color bgColor = isRejectTheme
                                      ? const Color(0xFFFFEBEE)
                                      : const Color(0xFFE8F5E9);
                                  final Color borderColor = isRejectTheme
                                      ? const Color(0xFFEF9A9A).withOpacity(0.5)
                                      : const Color(0xFFA5D6A7)
                                          .withOpacity(0.5);
                                  final Color textColor = isRejectTheme
                                      ? const Color(0xFFD32F2F)
                                      : const Color(0xFF2E7D32);
                                  final IconData icon = isRejectTheme
                                      ? Icons.info_outline
                                      : Icons.check_circle_outline;

                                  return Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(top: 12),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: bgColor,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: borderColor),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(icon,
                                                color: textColor, size: 18),
                                            const SizedBox(width: 8),
                                            Text(
                                              "Verification Remark",
                                              style: GoogleFonts.outfit(
                                                color: textColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.2,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          rejectionReason!,
                                          style: GoogleFonts.outfit(
                                            color: textColor.withOpacity(0.9),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            height: 1.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              const SizedBox(height: 24),
                              form_widget(
                                controller: universityNameController,
                                titleText: "University Name",
                                hintText: "University Name",
                                textInputType: TextInputType.text,
                                isReadOnly: isReadOnly,
                                validator: (value) =>
                                    (value == null || value.trim().isEmpty)
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
                                validator: (value) =>
                                    (value == null || value.trim().isEmpty)
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
                                  if (value == null || value.trim().isEmpty) {
                                    return "Year of passing is required";
                                  }
                                  if (value.length != 4) {
                                    return "Enter a valid year (YYYY)";
                                  }
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
                              if (artefactImgUrl != null &&
                                  artefactImgUrl!.isNotEmpty)
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
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              color: const Color(0xFFE0E7FF)),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.link,
                                                color: Color(0xFF4F46E5),
                                                size: 18),
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
                              if (!isReadOnly && isEditing)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    CustomButton(
                                      text: "Cancel",
                                      width: 120,
                                      height: 48,
                                      iconSize: 18,
                                      gradientColors: const [
                                        Color(0xFF9E9E9E),
                                        Color(0xFFBDBDBD),
                                      ],
                                      onTap: () {
                                        setState(() {
                                          isReadOnly = true;
                                          isEditing = false;
                                          _formKey.currentState?.reset();
                                        });
                                        if (showState
                                            is EducationShowDetailsSuccessState) {
                                          _populateData(showState
                                              .educationDataDetailsModel);
                                        }
                                      },
                                    ),
                                    const SizedBox(width: 16),
                                    CustomButton(
                                      text: "Save",
                                      width: 120,
                                      height: 48,
                                      prefixIcon: Icons.save,
                                      iconSize: 18,
                                      gradientColors: const [
                                        Color(0xFFF4511E),
                                        Color(0xFFFFB74D),
                                      ],
                                      onTap: () => _submitForm(context),
                                    ),
                                  ],
                                )
                              else if (!isReadOnly ||
                                  (isReadOnly && isRejected))
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: CustomButton(
                                    text: (isReadOnly && isRejected)
                                        ? "Update"
                                        : "Submit",
                                    width: 140,
                                    height: 48,
                                    prefixIcon: (isReadOnly && isRejected
                                        ? Icons.edit
                                        : Icons.send),
                                    iconSize: 18,
                                    gradientColors: const [
                                      Color(0xFFF4511E),
                                      Color(0xFFFFB74D),
                                    ],
                                    onTap: () {
                                      if (isReadOnly && isRejected) {
                                        setState(() {
                                          isReadOnly = false;
                                          isEditing = true;
                                        });
                                      } else {
                                        _submitForm(context);
                                      }
                                    },
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
