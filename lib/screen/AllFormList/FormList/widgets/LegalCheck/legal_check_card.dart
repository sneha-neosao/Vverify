import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../apiServices/api_services.dart';
import '../../../../../commonComponent/custom_button.dart';
import '../../../../VerificationForms/common/form_widget.dart';
import '../common_widgets.dart';
import 'Bloc/court_verification_cubit.dart';
import 'Bloc/court_verification_state.dart';
import 'Bloc/court_details_cubit.dart';
import 'Bloc/court_details_state.dart';
import 'Model/court_verification_model.dart';
import '../../../../VerificationPending/bloc/pendingDoc_cubit.dart';
import '../../../../VerificationPending/Pagination/DashBoard/bloc/pending_doc_navigation_cubit.dart';
import '../../../../../commonComponent/bloc/shared_preferences_cubit.dart';

class LegalCheckCard extends StatefulWidget {
  final String? serviceTitle;
  final Map<String, dynamic>? serviceData;
  final Map<String, dynamic>? applicantData;

  const LegalCheckCard({
    super.key,
    this.serviceTitle,
    this.serviceData,
    this.applicantData,
  });

  @override
  State<LegalCheckCard> createState() => _LegalCheckCardState();
}

class _LegalCheckCardState extends State<LegalCheckCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isReadOnly = false;
  bool isEditing = false;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController fatherNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  late final CourtVerificationCubit _cubit;
  late final CourtDetailsCubit _detailsCubit;

  @override
  void initState() {
    super.initState();
    _cubit = CourtVerificationCubit(ApiService());
    _detailsCubit = CourtDetailsCubit(ApiService());

    _populateFromApplicantData();
    _checkAndFetchDetails();
  }

  void _populateFromApplicantData() {
    if (widget.applicantData != null) {
      firstNameController.text = widget.applicantData?['first_name'] ?? "";
      lastNameController.text = widget.applicantData?['last_name'] ?? "";
    }
  }

  Future<void> _checkAndFetchDetails(
      {bool force = false, String? uidFromResponse}) async {
    if (force ||
        widget.applicantData?['details_updated'] == 1 ||
        widget.serviceData?['status'] == "DONE") {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? "";
      final uid = uidFromResponse ??
          widget.serviceData?['uid']?.toString() ??
          widget.applicantData?['uid']?.toString() ??
          "";

      if (token.isNotEmpty && uid.isNotEmpty) {
        _detailsCubit.fetchCourtDetails(
          token: token,
          uid: uid,
        );
      }
    }
  }

  @override
  void dispose() {
    _cubit.close();
    _detailsCubit.close();
    firstNameController.dispose();
    lastNameController.dispose();
    fatherNameController.dispose();
    addressController.dispose();
    dobController.dispose();
    super.dispose();
  }

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? "";
      final customerId = prefs.getString('id') ?? "";

      final requestId = widget.applicantData?['request_id']?.toString() ?? "";
      final serviceRequestId =
          widget.serviceData?['service_request_id']?.toString() ?? "";

      if (isEditing) {
        _cubit.updateCourtVerificationForm(
          customer_id: customerId,
          token: token,
          request_id: requestId,
          serviceRequestId: serviceRequestId,
          first_name: firstNameController.text.trim(),
          last_name: lastNameController.text.trim(),
          father_name: fatherNameController.text.trim(),
          dob: dobController.text.trim(),
          address: addressController.text.trim(),
        );
      } else {
        _cubit.courtVerificationForm(
          customer_id: customerId,
          token: token,
          request_id: requestId,
          serviceRequestId: serviceRequestId,
          first_name: firstNameController.text.trim(),
          last_name: lastNameController.text.trim(),
          father_name: fatherNameController.text.trim(),
          dob: dobController.text.trim(),
          address: addressController.text.trim(),
        );
      }
    }
  }

  void _populateData(Data data) {
    setState(() {
      isReadOnly = true;
      isEditing = false;
      firstNameController.text = data.firstName ?? "";
      lastNameController.text = data.lastName ?? "";
      fatherNameController.text = data.fatherName ?? "";
      addressController.text = data.address ?? "";
      if (data.dob != null) {
        dobController.text =
            "${data.dob!.day.toString().padLeft(2, '0')}-${data.dob!.month.toString().padLeft(2, '0')}-${data.dob!.year}";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _cubit),
        BlocProvider.value(value: _detailsCubit),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<CourtVerificationCubit, CourtVerificationState>(
            listener: (context, state) {
              if (state is CourtVerificationSuccessState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Court verification submitted successfully!"),
                    backgroundColor: Colors.green,
                  ),
                );
                setState(() {
                  isReadOnly = true;
                  isEditing = false;
                });
                String? uid;
                if (state.data['data'] != null &&
                    state.data['data']['uid'] != null) {
                  uid = state.data['data']['uid'].toString();
                }
                _checkAndFetchDetails(force: true, uidFromResponse: uid);

                // Refresh Verification List respecting current entity filter
                final token = context.read<TokenCubit>().state;
                final customerId = context.read<IdCubit>().state;
                final navState = context.read<PendingDocNavigationCubit>().state;
                context.read<PendingDocCubit>().getPendingDoc(
                      token: token,
                      customerId: int.tryParse(customerId) ?? 0,
                      page: 1,
                      limit: 100,
                      entityId: navState.entityId,
                      isLoading: false,
                    );
              } else if (state is CourtVerificationErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
          BlocListener<CourtDetailsCubit, CourtDetailsState>(
            listener: (context, state) {
              if (state is CourtDetailsSuccess) {
                _populateData(state.data);
              } else if (state is CourtDetailsError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(state.error), backgroundColor: Colors.red),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<CourtDetailsCubit, CourtDetailsState>(
          builder: (context, detailsState) {
            if (detailsState is CourtDetailsLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            String currentStatus =
                widget.serviceData?['status']?.toString() ?? "PENDING";
            if (detailsState is CourtDetailsSuccess) {
              currentStatus = detailsState.data.status ?? currentStatus;
            }
            bool isRejected = currentStatus.toLowerCase().contains("reject");

            return BlocBuilder<CourtVerificationCubit, CourtVerificationState>(
              builder: (context, state) {
                return Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                const Icon(Icons.gavel_outlined,
                                    color: Color(0xFFFFB74D), size: 28),
                                const SizedBox(width: 12),
                                Flexible(
                                  child: Text(
                                    widget.serviceTitle ?? "Legal Check",
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
                      if (isRejected &&
                          (detailsState is CourtDetailsSuccess) &&
                          (detailsState.data.reason?.isNotEmpty ?? false))
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 12),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEBEE),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color:
                                    const Color(0xFFEF9A9A).withOpacity(0.5)),
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
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "${detailsState.data.reason}",
                                style: GoogleFonts.outfit(
                                  color:
                                      const Color(0xFFD32F2F).withOpacity(0.9),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 24),
                      form_widget(
                        controller: firstNameController,
                        titleText: "First Name",
                        hintText: "Enter first name",
                        textInputType: TextInputType.name,
                        isReadOnly: isReadOnly,
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                                ? "First name is required"
                                : null,
                      ),
                      form_widget(
                        controller: lastNameController,
                        titleText: "Last Name",
                        hintText: "Enter last name",
                        textInputType: TextInputType.name,
                        isReadOnly: isReadOnly,
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                                ? "Last name is required"
                                : null,
                      ),
                      form_widget(
                        controller: fatherNameController,
                        titleText: "Father Name",
                        hintText: "Enter father name",
                        textInputType: TextInputType.name,
                        isReadOnly: isReadOnly,
                        isRequired: false,
                      ),
                      form_widget(
                        controller: addressController,
                        titleText: "Address",
                        hintText: "Enter full address",
                        textInputType: TextInputType.streetAddress,
                        isReadOnly: isReadOnly,
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                                ? "Address is required"
                                : null,
                      ),
                      form_widget(
                        controller: dobController,
                        titleText: "Date of Birth",
                        hintText: "DD-MM-YYYY",
                        textInputType: TextInputType.datetime,
                        isReadOnly: isReadOnly,
                        isRequired: false,
                        onTap: isReadOnly
                            ? null
                            : () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                );
                                if (pickedDate != null) {
                                  dobController.text =
                                      "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
                                }
                              },
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
                              onTap: state is CourtVerificationLoadingState
                                  ? null
                                  : () {
                                      setState(() {
                                        isReadOnly = true;
                                        isEditing = false;
                                        _formKey.currentState?.reset();
                                      });
                                      if (detailsState is CourtDetailsSuccess) {
                                        _populateData(detailsState.data);
                                      }
                                    },
                            ),
                            const SizedBox(width: 16),
                            CustomButton(
                              text: state is CourtVerificationLoadingState
                                  ? "Saving..."
                                  : "Save",
                              width: 120,
                              height: 48,
                              prefixIcon: state is CourtVerificationLoadingState
                                  ? null
                                  : Icons.save,
                              iconSize: 18,
                              gradientColors: const [
                                Color(0xFFF4511E),
                                Color(0xFFFFB74D),
                              ],
                              onTap: state is CourtVerificationLoadingState
                                  ? null
                                  : () => _submitForm(context),
                            ),
                          ],
                        )
                      else if (!isReadOnly || (isReadOnly && isRejected))
                        Align(
                          alignment: Alignment.centerRight,
                          child: CustomButton(
                            text: state is CourtVerificationLoadingState
                                ? "Submitting..."
                                : (isReadOnly && isRejected)
                                    ? "Update"
                                    : "Submit",
                            width: 140,
                            height: 48,
                            prefixIcon: state is CourtVerificationLoadingState
                                ? null
                                : (isReadOnly && isRejected
                                    ? Icons.edit
                                    : Icons.send),
                            iconSize: 18,
                            gradientColors: const [
                              Color(0xFFF4511E),
                              Color(0xFFFFB74D),
                            ],
                            onTap: state is CourtVerificationLoadingState
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
        ),
      ),
    );
  }
}
