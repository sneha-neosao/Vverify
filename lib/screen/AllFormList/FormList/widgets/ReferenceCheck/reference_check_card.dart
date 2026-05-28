import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../apiServices/api_services.dart';
import '../../../../../commonComponent/custom_button.dart';
import '../../../../VerificationForms/common/form_widget.dart';
import '../common_widgets.dart';
import 'BlocCubit/reference_store_cubit.dart';
import 'BlocCubit/reference_store_state.dart';
import 'Model/reference_store_model.dart';
import 'BlocCubit/reference_details_cubit.dart';
import 'BlocCubit/reference_details_state.dart';
import 'Model/reference_check_details_model.dart';
import '../../../../VerificationPending/bloc/pendingDoc_cubit.dart';
import '../../../../VerificationPending/Pagination/DashBoard/bloc/pending_doc_navigation_cubit.dart';
import '../../../../../commonComponent/bloc/shared_preferences_cubit.dart';

class ReferenceCheckCard extends StatefulWidget {
  final String? serviceTitle;
  final Map<String, dynamic>? serviceData;
  final Map<String, dynamic>? applicantData;

  const ReferenceCheckCard({
    super.key,
    this.serviceTitle,
    this.serviceData,
    this.applicantData,
  });

  @override
  State<ReferenceCheckCard> createState() => _ReferenceCheckCardState();
}

class _ReferenceCheckCardState extends State<ReferenceCheckCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isReadOnly = false;
  bool isEditing = false;

  // Person 1 Controllers
  final TextEditingController p1NameController = TextEditingController();
  final TextEditingController p1MobileController = TextEditingController();
  final TextEditingController p1RelationController = TextEditingController();
  final TextEditingController p1EmailController = TextEditingController();
  final TextEditingController p1AltMobileController = TextEditingController();

  // Person 2 Controllers
  final TextEditingController p2NameController = TextEditingController();
  final TextEditingController p2MobileController = TextEditingController();
  final TextEditingController p2RelationController = TextEditingController();
  final TextEditingController p2EmailController = TextEditingController();
  final TextEditingController p2AltMobileController = TextEditingController();

  late final ReferenceStoreCubit _cubit;
  late final ReferenceDetailsCubit _detailsCubit;

  @override
  void initState() {
    super.initState();
    _cubit = ReferenceStoreCubit(ApiService());
    _detailsCubit = ReferenceDetailsCubit(ApiService());

    _checkAndFetchDetails();
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
        _detailsCubit.fetchReferenceDetails(
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
    p1NameController.dispose();
    p1MobileController.dispose();
    p1RelationController.dispose();
    p1EmailController.dispose();
    p1AltMobileController.dispose();
    p2NameController.dispose();
    p2MobileController.dispose();
    p2RelationController.dispose();
    p2EmailController.dispose();
    p2AltMobileController.dispose();
    super.dispose();
  }

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? "";
      final customerId = prefs.getString('id') ?? "";

      final model = ReferenceStoreModel(
        serviceRequestId: widget.serviceData?['service_request_id']?.toString(),
        requestId: widget.applicantData?['request_id']?.toString(),
        customerId: customerId,
        personName1: p1NameController.text.trim(),
        personMobileNumber1: p1MobileController.text.trim(),
        personRelation1: p1RelationController.text.trim(),
        personEmail1: p1EmailController.text.trim(),
        personAlternateMobile1: p1AltMobileController.text.trim(),
        personName2: p2NameController.text.trim(),
        personMobileNumber2: p2MobileController.text.trim(),
        personRelation2: p2RelationController.text.trim(),
        personEmail2: p2EmailController.text.trim(),
        personAlternateMobile2: p2AltMobileController.text.trim(),
      );

      if (context.mounted) {
        if (isEditing) {
          _cubit.updateReferenceForm(
            token: token,
            model: model,
          );
        } else {
          _cubit.storeReferenceForm(
            token: token,
            model: model,
          );
        }
      }
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
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
          BlocListener<ReferenceStoreCubit, ReferenceStoreState>(
            listener: (context, state) {
              if (state is ReferenceStoreSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.green),
                );
                setState(() {
                  isReadOnly = true;
                  isEditing = false;
                });
                _checkAndFetchDetails(force: true, uidFromResponse: state.uid);

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
              } else if (state is ReferenceStoreError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(state.error), backgroundColor: Colors.red),
                );
              }
            },
          ),
          BlocListener<ReferenceDetailsCubit, ReferenceDetailsState>(
            listener: (context, state) {
              if (state is ReferenceDetailsSuccess) {
                _populateData(state.data);
              } else if (state is ReferenceDetailsError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(state.error), backgroundColor: Colors.red),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<ReferenceDetailsCubit, ReferenceDetailsState>(
          builder: (context, detailsState) {
            if (detailsState is ReferenceDetailsLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            String currentStatus =
                widget.serviceData?['status']?.toString() ?? "PENDING";
            if (detailsState is ReferenceDetailsSuccess) {
              currentStatus = detailsState.data.status ?? currentStatus;
            }
            bool isRejected = currentStatus.toLowerCase().contains("reject");

            return BlocBuilder<ReferenceStoreCubit, ReferenceStoreState>(
              builder: (context, state) {
                return Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                const Icon(Icons.people_outline,
                                    color: Color(0xFFFFB74D), size: 28),
                                const SizedBox(width: 12),
                                Flexible(
                                  child: Text(
                                    widget.serviceTitle ?? "Reference Check",
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
                          (detailsState is ReferenceDetailsSuccess) &&
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
                      _buildReferencePerson(
                        context,
                        "Reference Person 1",
                        p1NameController,
                        p1MobileController,
                        p1RelationController,
                        p1EmailController,
                        p1AltMobileController,
                        isRequired: true,
                        isReadOnly: isReadOnly,
                        nameValidator: (value) =>
                            (value == null || value.trim().isEmpty)
                                ? "Name is required"
                                : null,
                        mobileValidator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Mobile Number is required";
                          }
                          if (value.trim().length != 10)
                            return "Must be 10 digits";
                          return null;
                        },
                        relationValidator: (value) =>
                            (value == null || value.trim().isEmpty)
                                ? "Relation is required"
                                : null,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Divider(color: Color(0xFFEEEEEE), thickness: 1),
                      ),
                      _buildReferencePerson(
                        context,
                        "Reference Person 2",
                        p2NameController,
                        p2MobileController,
                        p2RelationController,
                        p2EmailController,
                        p2AltMobileController,
                        isRequired: false,
                        isReadOnly: isReadOnly,
                        mobileValidator: (value) {
                          if (value != null && value.trim().isNotEmpty) {
                            if (value.trim().length != 10) {
                              return "Must be 10 digits";
                            }
                          }
                          return null;
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
                              // prefixIcon: Icons.cancel_outlined,
                              iconSize: 18,
                              gradientColors: const [
                                Color(0xFF9E9E9E),
                                Color(0xFFBDBDBD),
                              ],
                              onTap: state is ReferenceStoreLoading
                                  ? null
                                  : () {
                                      setState(() {
                                        isReadOnly = true;
                                        isEditing = false;
                                        _formKey.currentState?.reset();
                                      });
                                      if (detailsState
                                          is ReferenceDetailsSuccess) {
                                        _populateData(detailsState.data);
                                      }
                                    },
                            ),
                            const SizedBox(width: 16),
                            CustomButton(
                              text: state is ReferenceStoreLoading
                                  ? "Saving..."
                                  : "Save",
                              width: 120,
                              height: 48,
                              prefixIcon: state is ReferenceStoreLoading
                                  ? null
                                  : Icons.save,
                              iconSize: 18,
                              gradientColors: const [
                                Color(0xFFF4511E),
                                Color(0xFFFFB74D),
                              ],
                              onTap: state is ReferenceStoreLoading
                                  ? null
                                  : () => _submitForm(context),
                            ),
                          ],
                        )
                      else if (!isReadOnly || (isReadOnly && isRejected))
                        Align(
                          alignment: Alignment.centerRight,
                          child: CustomButton(
                            text: state is ReferenceStoreLoading
                                ? "Submitting..."
                                : (isReadOnly && isRejected)
                                    ? "Update"
                                    : "Submit",
                            width: 140,
                            height: 48,
                            prefixIcon: state is ReferenceStoreLoading
                                ? null
                                : (isReadOnly && isRejected
                                    ? Icons.edit
                                    : Icons.send),
                            iconSize: 18,
                            gradientColors: const [
                              Color(0xFFF4511E),
                              Color(0xFFFFB74D),
                            ],
                            onTap: state is ReferenceStoreLoading
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

  void _populateData(ReferenceCheckDetailsData data) {
    setState(() {
      isReadOnly = true;
      isEditing = false;
      p1NameController.text = data.personName1 ?? "";
      p1MobileController.text = data.personMobileNumber1 ?? "";
      p1RelationController.text = data.personRelation1 ?? "";
      p1EmailController.text = data.personEmail1 ?? "";
      p1AltMobileController.text = data.personAlternateMobile1 ?? "";

      p2NameController.text = data.personName2 ?? "";
      p2MobileController.text = data.personMobileNumber2 ?? "";
      p2RelationController.text = data.personRelation2 ?? "";
      p2EmailController.text = data.personEmail2 ?? "";
      p2AltMobileController.text = data.personAlternateMobile2 ?? "";
    });
  }

  Widget _buildReferencePerson(
    BuildContext context,
    String title,
    TextEditingController nameController,
    TextEditingController mobileController,
    TextEditingController relationController,
    TextEditingController emailController,
    TextEditingController altMobileController, {
    required bool isRequired,
    required bool isReadOnly,
    String? Function(String?)? nameValidator,
    String? Function(String?)? mobileValidator,
    String? Function(String?)? relationValidator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: const Color(0xFFF4511E),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF263238),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        form_widget(
          controller: nameController,
          titleText: "Name",
          hintText: "Person's Name",
          textInputType: TextInputType.name,
          isRequired: isRequired,
          isReadOnly: isReadOnly,
          validator: nameValidator,
        ),
        form_widget(
          controller: mobileController,
          titleText: "Mobile Number",
          hintText: "10-digit Mobile Number",
          textInputType: TextInputType.phone,
          isRequired: isRequired,
          isReadOnly: isReadOnly,
          validator: mobileValidator,
        ),
        form_widget(
          controller: relationController,
          titleText: "Relation",
          hintText: "e.g. Manager, Colleague",
          textInputType: TextInputType.text,
          isRequired: isRequired,
          isReadOnly: isReadOnly,
          validator: relationValidator,
        ),
        form_widget(
          controller: emailController,
          titleText: "Email",
          hintText: "email@example.com",
          textInputType: TextInputType.emailAddress,
          isRequired: false,
          isReadOnly: isReadOnly,
        ),
        form_widget(
          controller: altMobileController,
          titleText: "Alt. Mobile / Landline",
          hintText: "Alternate contact",
          textInputType: TextInputType.phone,
          isRequired: false,
          isReadOnly: isReadOnly,
        ),
      ],
    );
  }
}
