import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../apiServices/api_services.dart';
import '../../../../../commonComponent/custom_button.dart';
import '../../../../VerificationForms/common/form_widget.dart';
import '../common_widgets.dart';
import 'Bloc/Save/employment_save_form_cubit.dart';
import 'Bloc/Save/employment_save_form_state.dart';
import 'Bloc/Update/employment_update_form_cubit.dart';
import 'Bloc/Update/employment_update_form_state.dart';
import 'Bloc/List/employment_list_cubit.dart';
import 'Bloc/List/employment_list_state.dart';
import 'Bloc/Show/employ_show_details_cubit.dart';
import 'Bloc/Show/employ_show_details_state.dart';
import 'Model/employment_save_form_model.dart';
import 'Model/employment_update_form_model.dart';
import 'Model/employment_show_details_model.dart';
import '../../../../VerificationForms/VerifyDeatils/Bloc/verify_details_cubit.dart';
import '../../../../VerificationForms/VerifyDeatils/Bloc/verify_details_state.dart';
import '../../../../VerificationPending/bloc/pendingDoc_cubit.dart';
import '../../../../../commonComponent/bloc/shared_preferences_cubit.dart';

class EmploymentVerificationCard extends StatefulWidget {
  final String? serviceTitle;
  final Map<String, dynamic>? serviceData;
  final Map<String, dynamic>? applicantData;

  const EmploymentVerificationCard({
    super.key,
    this.serviceTitle,
    this.serviceData,
    this.applicantData,
  });

  @override
  State<EmploymentVerificationCard> createState() =>
      _EmploymentVerificationCardState();
}

class _EmploymentVerificationCardState
    extends State<EmploymentVerificationCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isReadOnly = false;
  bool isEditing = false;
  bool isTillDate = false;

  final TextEditingController employerNameController = TextEditingController();
  final TextEditingController joiningDateController = TextEditingController();
  final TextEditingController leavingDateController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController remunerationController = TextEditingController();
  final TextEditingController reportingManagerController =
      TextEditingController();
  final TextEditingController reasonForLeavingController =
      TextEditingController();

  late final EmploymentSaveFormCubit _saveCubit;
  late final EmploymentUpdateFormCubit _updateCubit;
  late final EmployShowDataCubit _showCubit;
  late final EmployDataListCubit _listCubit;
  late final VerifyDetailsCubit _verifyDetailsCubit;

  String? artefactImgUrl;
  String? caseUuidFromApi;

  @override
  void initState() {
    super.initState();
    _saveCubit = EmploymentSaveFormCubit(ApiService());
    _updateCubit = EmploymentUpdateFormCubit(ApiService());
    _showCubit = EmployShowDataCubit(ApiService());
    _listCubit = EmployDataListCubit(ApiService());
    _verifyDetailsCubit = VerifyDetailsCubit(ApiService());

    _fetchEmploymentList();
    _fetchVerifyDetails();
  }

  Future<void> _fetchVerifyDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? "";
    final requestId = widget.applicantData?['request_id']?.toString() ?? "";
    if (token.isNotEmpty && requestId.isNotEmpty) {
      _verifyDetailsCubit.verifyDetails(token: token, requestId: requestId);
    }
  }

  /// Step 1: Fetch the employment list to get the UID for this service request.
  Future<void> _fetchEmploymentList() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? "";
    final requestId =
        int.tryParse(widget.applicantData?['request_id']?.toString() ?? "");
    final serviceRequestId = int.tryParse(
        widget.serviceData?['service_request_id']?.toString() ?? "");

    debugPrint('@@@@@@@@@@@@@token: $token');
    debugPrint('@@@@@@@@@@@@@request_id: $requestId');
    debugPrint('@@@@@@@@@@@@@service_request_id: $serviceRequestId');

    if (token.isNotEmpty && requestId != null && serviceRequestId != null) {
      _listCubit.employmentList(
        token: token,
        requestId: requestId,
        serviceRequestId: serviceRequestId,
      );
    }
  }

  /// Step 2: Once UID is obtained from list, call the show API.
  Future<void> _fetchShowData({required String uid}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? "";
    debugPrint('@@@@@@@@@@@@@show uid: $uid');
    if (token.isNotEmpty && uid.isNotEmpty) {
      _showCubit.employShowData(token: token, uid: uid);
    }
  }

  /// Called after save/update to refresh data.
  Future<void> _checkAndFetchDetails({bool force = false}) async {
    _fetchEmploymentList();
  }

  @override
  void dispose() {
    employerNameController.dispose();
    joiningDateController.dispose();
    leavingDateController.dispose();
    designationController.dispose();
    departmentController.dispose();
    remunerationController.dispose();
    reportingManagerController.dispose();
    reasonForLeavingController.dispose();
    _saveCubit.close();
    _updateCubit.close();
    _showCubit.close();
    _listCubit.close();
    super.dispose();
  }

  String _formatIncomingDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty || dateStr == "Till Date") {
      return dateStr ?? "";
    }
    try {
      if (dateStr.contains('-')) {
        final parts = dateStr.split('-');
        if (parts[0].length == 4) {
          // yyyy-MM-dd
          DateTime parsed = DateFormat('yyyy-MM-dd').parse(dateStr);
          return DateFormat('dd-MM-yyyy').format(parsed);
        }
      }
      return dateStr;
    } catch (_) {
      return dateStr;
    }
  }

  void _populateData(EmploymentShowDataModel response) {
    final data = response.data;
    if (data != null) {
      setState(() {
        isReadOnly = true;
        isEditing = false;
        employerNameController.text = data.employer_name ?? "";
        joiningDateController.text = _formatIncomingDate(data.employed_from);
        leavingDateController.text = _formatIncomingDate(data.employed_to);
        designationController.text = data.designation ?? "";
        departmentController.text = data.department ?? "";
        remunerationController.text = data.remunaration ?? "";
        reportingManagerController.text = data.reporting_manager ?? "";
        reasonForLeavingController.text = data.reason_for_leaving ?? "";
        isTillDate = data.employed_to == "Till Date" ||
            data.employed_to == null ||
            data.employed_to == "";
        if (isTillDate) {
          leavingDateController.text = "Till Date";
        }
        artefactImgUrl = data.artefact_img;
      });
    }
  }

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? "";
      final customerId = prefs.getString('id') ?? "";

      if (isEditing) {
        final updateModel = EmploymentUpdateFormModel(
          uid: widget.serviceData?['uid']?.toString() ?? "",
          request_id: widget.applicantData?['request_id']?.toString() ?? "",
          service_request_id:
              widget.serviceData?['service_request_id']?.toString() ?? "",
          customer_id: customerId,
          employer_name: employerNameController.text.trim(),
          employed_from: joiningDateController.text.trim(),
          employed_to: isTillDate ? "" : leavingDateController.text.trim(),
          designation: designationController.text.trim(),
          department: departmentController.text.trim(),
          remunaration: remunerationController.text.trim(),
          reporting_manager: reportingManagerController.text.trim(),
          reason_for_leaving: reasonForLeavingController.text.trim(),
          case_uuid: caseUuidFromApi ??
              widget.applicantData?['case_uuid']?.toString() ??
              "",
          till_date: isTillDate ? 1 : 0,
          employment_uuid:
              widget.serviceData?['employment_uuid']?.toString() ?? "",
        );
        _updateCubit.employmentUpdateForm(
          token: token,
          customer_id: customerId,
          employmentUpdateFormModel: updateModel,
        );
      } else {
        final saveModel = EmploymentSaveFormModel(
          request_id: widget.applicantData?['request_id']?.toString() ?? "",
          service_request_id:
              widget.serviceData?['service_request_id']?.toString() ?? "",
          customer_id: customerId,
          employer_name: employerNameController.text.trim(),
          employed_from: joiningDateController.text.trim(),
          employed_to: isTillDate ? "" : leavingDateController.text.trim(),
          designation: designationController.text.trim(),
          department: departmentController.text.trim(),
          remunaration: remunerationController.text.trim(),
          reporting_manager: reportingManagerController.text.trim(),
          reason_for_leaving: reasonForLeavingController.text.trim(),
          case_uuid: caseUuidFromApi ??
              widget.applicantData?['case_uuid']?.toString() ??
              "",
          till_date: isTillDate ? 1 : 0,
        );
        _saveCubit.employmentSaveForm(
          token: token,
          customer_id: customerId,
          employmentSaveFormModel: saveModel,
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
        BlocProvider.value(value: _showCubit),
        BlocProvider.value(value: _listCubit),
        BlocProvider.value(value: _verifyDetailsCubit),
      ],
      child: MultiBlocListener(
        listeners: [
          // List API listener: on success extract uid → call show API
          BlocListener<EmployDataListCubit, EmployDataListState>(
            listener: (context, state) {
              if (state is EmployDataListSuccessState) {
                final records = state.employListDataModel.data;
                if (records != null && records.isNotEmpty) {
                  final uid = records.first.uid ?? "";
                  if (uid.isNotEmpty) {
                    _fetchShowData(uid: uid);
                  }
                }
              }
            },
          ),
          BlocListener<EmploymentSaveFormCubit, EmploymentSaveFormState>(
            listener: (context, state) {
              if (state is EmploymentSaveFormSuccessState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Employment details saved successfully"),
                      backgroundColor: Colors.green),
                );
                setState(() {
                  isReadOnly = true;
                  isEditing = false;
                });
                _checkAndFetchDetails(force: true);
                _refreshPendingDocs(context);
              } else if (state is EmploymentSaveFormErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red),
                );
              }
            },
          ),
          BlocListener<EmploymentUpdateFormCubit, EmploymentUpdateFormState>(
            listener: (context, state) {
              if (state is EmploymentUpdateFormSuccessState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Employment details updated successfully"),
                      backgroundColor: Colors.green),
                );
                setState(() {
                  isReadOnly = true;
                  isEditing = false;
                });
                _checkAndFetchDetails(force: true);
                _refreshPendingDocs(context);
              } else if (state is EmploymentUpdateFormErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red),
                );
              }
            },
          ),
          BlocListener<EmployShowDataCubit, EmployShowDataState>(
            listener: (context, state) {
              if (state is EmployShowDataSuccessState) {
                _populateData(state.employmentShowDataModel);
              } else if (state is EmployShowDataErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red),
                );
              }
            },
          ),
          BlocListener<VerifyDetailsCubit, VerifyDetailsState>(
            listener: (context, state) {
              if (state is VerifyDetailsSuccessState) {
                setState(() {
                  caseUuidFromApi = state.verifyDetailsModel.data?.caseUuid;
                });
              }
            },
          ),
        ],
        child: BlocBuilder<EmployDataListCubit, EmployDataListState>(
          builder: (context, listState) {
            return BlocBuilder<EmployShowDataCubit, EmployShowDataState>(
              builder: (context, showState) {
                return BlocBuilder<EmploymentSaveFormCubit,
                    EmploymentSaveFormState>(
                  builder: (context, saveState) {
                    return BlocBuilder<EmploymentUpdateFormCubit,
                        EmploymentUpdateFormState>(
                      builder: (context, updateState) {
                        // Single loading indicator for ALL API calls
                        if (listState is EmployDataListLoadingState ||
                            showState is EmployShowDataLoadingState ||
                            saveState is EmploymentSaveFormLoadingState ||
                            updateState is EmploymentUpdateFormLoadingState) {
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
                        String? rejectionReason;
                        if (showState is EmployShowDataSuccessState) {
                          currentStatus = showState
                                  .employmentShowDataModel.data?.v_status ??
                              currentStatus;
                          rejectionReason = showState.employmentShowDataModel
                              .data?.verification_remark;
                        }
                        bool isRejected = currentStatus
                                .toLowerCase()
                                .contains("reject") ||
                            currentStatus.toLowerCase().contains("discrepancy");
                        bool isLoading = false; // handled by spinner above

                        return Form(
                          key: _formKey,
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
                                        const Icon(Icons.work_outline,
                                            color: Color(0xFFFFB74D), size: 28),
                                        const SizedBox(width: 12),
                                        Flexible(
                                          child: Text(
                                            widget.serviceTitle ??
                                                "Employment Verification",
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
                                        color: const Color(0xFFEF9A9A)
                                            .withOpacity(0.5)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.info_outline,
                                              color: Color(0xFFD32F2F),
                                              size: 18),
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
                                        rejectionReason,
                                        style: GoogleFonts.outfit(
                                          color: const Color(0xFFD32F2F)
                                              .withOpacity(0.9),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              const SizedBox(height: 24),
                              Text(
                                "Employment Details",
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF263238),
                                ),
                              ),
                              const SizedBox(height: 16),
                              form_widget(
                                controller: employerNameController,
                                titleText: "Employer Name",
                                hintText: "Enter employer name",
                                textInputType: TextInputType.text,
                                isRequired: true,
                                isReadOnly: isReadOnly,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) =>
                                    (value == null || value.trim().isEmpty)
                                        ? "Employer name is required"
                                        : null,
                              ),
                              FormDateWidget(
                                controller: joiningDateController,
                                titleText: "Joining Date",
                                hintText: "DD-MM-YYYY",
                                isRequired: true,
                                isReadOnly: isReadOnly,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                onTap: isReadOnly
                                    ? null
                                    : () => _selectDate(
                                          context,
                                          joiningDateController,
                                          lastDate: leavingDateController
                                                  .text.isNotEmpty
                                              ? DateFormat('dd-MM-yyyy').parse(
                                                  leavingDateController.text)
                                              : DateTime.now(),
                                        ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "Joining date is required";
                                  }
                                  if (leavingDateController.text.isNotEmpty) {
                                    DateTime joinDate = DateFormat('dd-MM-yyyy')
                                        .parse(value.trim());
                                    DateTime leaveDate =
                                        DateFormat('dd-MM-yyyy').parse(
                                            leavingDateController.text.trim());
                                    if (joinDate.isAfter(leaveDate)) {
                                      return "Joining date must be before leaving date";
                                    }
                                  }
                                  return null;
                                },
                              ),
                              if (!isTillDate)
                                FormDateWidget(
                                  controller: leavingDateController,
                                  titleText: "Leaving Date",
                                  hintText: "DD-MM-YYYY",
                                  isRequired: true,
                                  isReadOnly: isReadOnly,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  onTap: isReadOnly
                                      ? null
                                      : () => _selectDate(
                                            context,
                                            leavingDateController,
                                            firstDate: joiningDateController
                                                    .text.isNotEmpty
                                                ? DateFormat('dd-MM-yyyy')
                                                    .parse(joiningDateController
                                                        .text)
                                                : DateTime(1900),
                                            lastDate: DateTime.now(),
                                          ),
                                  validator: (value) {
                                    if (!isTillDate &&
                                        (value == null ||
                                            value.trim().isEmpty)) {
                                      return "Leaving date is required";
                                    }
                                    if (!isTillDate &&
                                        value != null &&
                                        joiningDateController.text.isNotEmpty) {
                                      DateTime joinDate =
                                          DateFormat('dd-MM-yyyy').parse(
                                              joiningDateController.text
                                                  .trim());
                                      DateTime leaveDate =
                                          DateFormat('dd-MM-yyyy')
                                              .parse(value.trim());
                                      if (leaveDate.isBefore(joinDate)) {
                                        return "Leaving date must be after joining date";
                                      }
                                    }
                                    return null;
                                  },
                                ),
                              Row(
                                children: [
                                  Checkbox(
                                    value: isTillDate,
                                    activeColor: const Color(0xFFF4511E),
                                    onChanged: isReadOnly
                                        ? null
                                        : (v) {
                                            setState(() {
                                              isTillDate = v ?? false;
                                              if (isTillDate) {
                                                leavingDateController.clear();
                                              }
                                            });
                                          },
                                  ),
                                  Text("Till Date",
                                      style: GoogleFonts.outfit(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                              form_widget(
                                controller: designationController,
                                titleText: "Designation",
                                hintText: "Enter designation",
                                textInputType: TextInputType.text,
                                isRequired: false,
                                isReadOnly: isReadOnly,
                              ),
                              form_widget(
                                controller: departmentController,
                                titleText: "Department",
                                hintText: "Enter department",
                                textInputType: TextInputType.text,
                                isReadOnly: isReadOnly,
                                isRequired: false,
                              ),
                              form_widget(
                                controller: remunerationController,
                                titleText: "Remuneration",
                                hintText: "Enter remuneration",
                                textInputType: TextInputType.text,
                                isReadOnly: isReadOnly,
                                isRequired: false,
                              ),
                              form_widget(
                                controller: reportingManagerController,
                                titleText: "Reporting Manager",
                                hintText: "Enter reporting manager",
                                textInputType: TextInputType.text,
                                isReadOnly: isReadOnly,
                                isRequired: false,
                              ),
                              const SizedBox(height: 16),
                              RichText(
                                text: TextSpan(
                                  text: "Reason for Leaving",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(fontWeight: FontWeight.w500),
                                  children: const [
                                    TextSpan(
                                      text: " * ",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              TextFormField(
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                                controller: reasonForLeavingController,
                                maxLines: 4,
                                readOnly: isReadOnly,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) =>
                                    (value == null || value.trim().isEmpty)
                                        ? "Reason for leaving is required"
                                        : null,
                                decoration: InputDecoration(
                                  hintText: "Enter reason for leaving",
                                  hintStyle: GoogleFonts.outfit(
                                      color: Colors.grey, fontSize: 14),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                ),
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
                                      gradientColors: const [
                                        Color(0xFF9E9E9E),
                                        Color(0xFFBDBDBD),
                                      ],
                                      onTap: isLoading
                                          ? null
                                          : () {
                                              setState(() {
                                                isReadOnly = true;
                                                isEditing = false;
                                              });
                                              if (showState
                                                  is EmployShowDataSuccessState) {
                                                _populateData(showState
                                                    .employmentShowDataModel);
                                              }
                                            },
                                    ),
                                    const SizedBox(width: 16),
                                    CustomButton(
                                      text: isLoading ? "Saving..." : "Save",
                                      width: 120,
                                      height: 48,
                                      prefixIcon: isLoading ? null : Icons.save,
                                      gradientColors: const [
                                        Color(0xFFF4511E),
                                        Color(0xFFFFB74D),
                                      ],
                                      onTap: isLoading
                                          ? null
                                          : () => _submitForm(context),
                                    ),
                                  ],
                                )
                              else if (!isReadOnly ||
                                  (isReadOnly && isRejected))
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: CustomButton(
                                    text: isLoading
                                        ? "Submitting..."
                                        : (isReadOnly && isRejected)
                                            ? "Update"
                                            : "Submit",
                                    width: 140,
                                    height: 48,
                                    prefixIcon: isLoading
                                        ? null
                                        : (isReadOnly && isRejected
                                            ? Icons.edit
                                            : Icons.send),
                                    gradientColors: const [
                                      Color(0xFFF4511E),
                                      Color(0xFFFFB74D),
                                    ],
                                    onTap: isLoading
                                        ? null
                                        : () {
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

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller,
      {DateTime? firstDate, DateTime? lastDate}) async {
    DateTime initialDate = DateTime.now();
    if (controller.text.isNotEmpty) {
      try {
        initialDate = DateFormat('dd-MM-yyyy').parse(controller.text);
      } catch (_) {
        initialDate = DateTime.now();
      }
    }

    DateTime effectiveFirstDate = firstDate ?? DateTime(1900);
    DateTime effectiveLastDate = lastDate ?? DateTime.now();

    if (initialDate.isBefore(effectiveFirstDate)) {
      initialDate = effectiveFirstDate;
    }
    if (initialDate.isAfter(effectiveLastDate)) {
      initialDate = effectiveLastDate;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: effectiveFirstDate,
      lastDate: effectiveLastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFF4511E),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  void _refreshPendingDocs(BuildContext context) {
    final token = context.read<TokenCubit>().state;
    final customerId = context.read<IdCubit>().state;
    context.read<PendingDocCubit>().getPendingDoc(
          token: token,
          customerId: int.tryParse(customerId) ?? 0,
          page: 1,
          limit: 100,
          isLoading: false,
        );
  }
}
