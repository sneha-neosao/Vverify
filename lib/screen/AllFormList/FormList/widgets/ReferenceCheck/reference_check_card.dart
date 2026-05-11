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
import 'Model/verify_request_response_model.dart';

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

  @override
  void initState() {
    super.initState();
    _cubit = ReferenceStoreCubit(ApiService());

    // Only load local "app data" if the form hasn't been submitted to API yet
    if (widget.applicantData?['details_updated'] != 1) {
      _loadPersistedData();
      _addListeners();
    }

    _checkAndFetchDetails();
  }

  void _addListeners() {
    p1NameController.addListener(_savePersistedData);
    p1MobileController.addListener(_savePersistedData);
    p1RelationController.addListener(_savePersistedData);
    p1EmailController.addListener(_savePersistedData);
    p1AltMobileController.addListener(_savePersistedData);
    p2NameController.addListener(_savePersistedData);
    p2MobileController.addListener(_savePersistedData);
    p2RelationController.addListener(_savePersistedData);
    p2EmailController.addListener(_savePersistedData);
    p2AltMobileController.addListener(_savePersistedData);
  }

  void _removeListeners() {
    p1NameController.removeListener(_savePersistedData);
    p1MobileController.removeListener(_savePersistedData);
    p1RelationController.removeListener(_savePersistedData);
    p1EmailController.removeListener(_savePersistedData);
    p1AltMobileController.removeListener(_savePersistedData);
    p2NameController.removeListener(_savePersistedData);
    p2MobileController.removeListener(_savePersistedData);
    p2RelationController.removeListener(_savePersistedData);
    p2EmailController.removeListener(_savePersistedData);
    p2AltMobileController.removeListener(_savePersistedData);
  }

  Future<void> _loadPersistedData() async {
    if (isReadOnly) return;
    final prefs = await SharedPreferences.getInstance();
    final requestId = widget.applicantData?['request_id']?.toString() ?? "";

    p1NameController.text = prefs.getString('ref_p1_name_$requestId') ?? "";
    p1MobileController.text = prefs.getString('ref_p1_mobile_$requestId') ?? "";
    p1RelationController.text =
        prefs.getString('ref_p1_relation_$requestId') ?? "";
    p1EmailController.text = prefs.getString('ref_p1_email_$requestId') ?? "";
    p1AltMobileController.text = prefs.getString('ref_p1_alt_$requestId') ?? "";

    p2NameController.text = prefs.getString('ref_p2_name_$requestId') ?? "";
    p2MobileController.text = prefs.getString('ref_p2_mobile_$requestId') ?? "";
    p2RelationController.text =
        prefs.getString('ref_p2_relation_$requestId') ?? "";
    p2EmailController.text = prefs.getString('ref_p2_email_$requestId') ?? "";
    p2AltMobileController.text = prefs.getString('ref_p2_alt_$requestId') ?? "";
  }

  Future<void> _savePersistedData() async {
    if (isReadOnly) return;
    final prefs = await SharedPreferences.getInstance();
    final requestId = widget.applicantData?['request_id']?.toString() ?? "";

    await prefs.setString('ref_p1_name_$requestId', p1NameController.text);
    await prefs.setString('ref_p1_mobile_$requestId', p1MobileController.text);
    await prefs.setString(
        'ref_p1_relation_$requestId', p1RelationController.text);
    await prefs.setString('ref_p1_email_$requestId', p1EmailController.text);
    await prefs.setString('ref_p1_alt_$requestId', p1AltMobileController.text);

    await prefs.setString('ref_p2_name_$requestId', p2NameController.text);
    await prefs.setString('ref_p2_mobile_$requestId', p2MobileController.text);
    await prefs.setString(
        'ref_p2_relation_$requestId', p2RelationController.text);
    await prefs.setString('ref_p2_email_$requestId', p2EmailController.text);
    await prefs.setString('ref_p2_alt_$requestId', p2AltMobileController.text);
  }

  Future<void> _checkAndFetchDetails() async {
    if (widget.applicantData?['details_updated'] == 1 ||
        widget.serviceData?['status'] == "DONE") {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? "";
      final requestId = widget.applicantData?['request_id']?.toString() ?? "";

      if (token.isNotEmpty && requestId.isNotEmpty) {
        _cubit.fetchReferenceDetails(
          token: token,
          requestId: requestId,
        );
      }
    }
  }

  @override
  void dispose() {
    _removeListeners();
    _cubit.close();
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
        _cubit.storeReferenceForm(
          token: token,
          model: model,
        );
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
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<ReferenceStoreCubit, ReferenceStoreState>(
        listener: (context, state) {
          if (state is ReferenceStoreSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message), backgroundColor: Colors.green),
            );
            // Refresh details and set to read-only
            final requestId =
                widget.applicantData?['request_id']?.toString() ?? "";
            SharedPreferences.getInstance().then((prefs) {
              final token = prefs.getString('token') ?? "";
              if (mounted) {
                context.read<ReferenceStoreCubit>().fetchReferenceDetails(
                      token: token,
                      requestId: requestId,
                    );
              }
            });
          } else if (state is ReferenceDetailsSuccess) {
            _populateData(state.data);
          } else if (state is ReferenceDetailsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          } else if (state is ReferenceStoreError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is ReferenceDetailsLoading) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ),
            );
          }
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
                    const StatusChip(status: "PENDING"),
                  ],
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
                    if (value.trim().length != 10) return "Must be 10 digits";
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
                ),
                const SizedBox(height: 24),
                if (!isReadOnly)
                  Align(
                    alignment: Alignment.centerRight,
                    child: CustomButton(
                      text: state is ReferenceStoreLoading
                          ? "Submitting..."
                          : "Submit",
                      width: 140,
                      height: 48,
                      prefixIcon:
                          state is ReferenceStoreLoading ? null : Icons.send,
                      iconSize: 18,
                      gradientColors: const [
                        Color(0xFFF4511E),
                        Color(0xFFFFB74D),
                      ],
                      onTap: state is ReferenceStoreLoading
                          ? null
                          : () => _submitForm(context),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _populateData(ReferenceCheckVerification data) {
    // Stop listening to changes once we load verified API data
    _removeListeners();
    setState(() {
      isReadOnly = true;
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
