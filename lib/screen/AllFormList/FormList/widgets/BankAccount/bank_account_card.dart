import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/screen/VerificationPending/bloc/pendingDoc_cubit.dart';
import '../../../../../apiServices/api_services.dart';
import '../../../../../commonComponent/custom_button.dart';
import '../../../../VerificationForms/common/form_widget.dart';
import '../common_widgets.dart';
import 'Bloc/bank_account_cubit.dart';
import 'Bloc/bank_account_state.dart';
import 'Bloc/bank_details_cubit.dart';
import 'Bloc/bank_details_state.dart';
import 'Model/bank_account_model.dart';

class BankAccountCard extends StatefulWidget {
  final String? serviceTitle;
  final Map<String, dynamic>? applicantData;
  final Map<String, dynamic>? serviceData;

  const BankAccountCard({
    super.key,
    this.serviceTitle,
    this.applicantData,
    this.serviceData,
  });

  @override
  State<BankAccountCard> createState() => _BankAccountCardState();
}

class _BankAccountCardState extends State<BankAccountCard> {
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController ifscCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late final BankAccountCubit _cubit;
  late final BankDetailsCubit _detailsCubit;

  bool isReadOnly = false;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _cubit = BankAccountCubit(ApiService());
    _detailsCubit = BankDetailsCubit(ApiService());
    _checkAndFetchDetails();
  }

  Future<void> _checkAndFetchDetails(
      {bool force = false, String? uidFromResponse}) async {
    final uid = uidFromResponse ?? widget.serviceData?['uid']?.toString() ?? "";

    if (force ||
        widget.applicantData?['details_updated'] == 1 ||
        widget.serviceData?['status'] == "verified" ||
        widget.serviceData?['status'] == "DONE" ||
        uid.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? "";

      if (uid.isNotEmpty && token.isNotEmpty) {
        _detailsCubit.fetchBankDetails(token: token, uid: uid);
        setState(() {
          isReadOnly = true;
        });
      }
    }
  }

  void _populateData(Data data) {
    accountNumberController.text = data.accountNumber ?? "";
    ifscCodeController.text = data.ifscCode ?? "";
  }

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      final token = context.read<TokenCubit>().state;
      final customerId = context.read<IdCubit>().state;

      final requestId = widget.applicantData?['request_id']?.toString() ?? "";
      final serviceRequestId =
          widget.serviceData?['service_request_id']?.toString() ?? "";
      final serviceId = widget.serviceData?['service_id']?.toString() ?? "";

      final data = {
        "customer_id": customerId,
        "request_id": requestId,
        "service_request_id": serviceRequestId,
        "service_id": serviceId,
        "account_number": accountNumberController.text.trim(),
        "ifsc_code": ifscCodeController.text.trim(),
      };

      if (isEditing) {
        _cubit.updateBankVerificationForm(token: token, data: data);
      } else {
        _cubit.bankVerificationForm(token: token, data: data);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _cubit),
        BlocProvider.value(value: _detailsCubit),
      ],
      child: BlocListener<BankAccountCubit, BankAccountState>(
        listener: (context, state) {
          if (state is BankAccountSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    state.data['message'] ?? "Form submitted successfully"),
                backgroundColor: Colors.green,
              ),
            );
            // Refresh Verification List
            final token = context.read<TokenCubit>().state;
            final customerId = context.read<IdCubit>().state;
            context.read<PendingDocCubit>().getPendingDoc(
                  token: token,
                  customerId: int.tryParse(customerId) ?? 0,
                  page: 1,
                  limit: 100,
                  isLoading: false,
                );
            setState(() {
              isReadOnly = true;
              isEditing = false;
            });

            String? uid;
            if (state.data['uid'] != null) {
              uid = state.data['uid'].toString();
            }
            _checkAndFetchDetails(force: true, uidFromResponse: uid);
            _showResultDialog(state.data);
          } else if (state is BankAccountErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        child: BlocConsumer<BankDetailsCubit, BankDetailsState>(
          listener: (context, state) {
            if (state is BankDetailsSuccess) {
              _populateData(state.data);
            } else if (state is BankDetailsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(state.error), backgroundColor: Colors.red),
              );
            }
          },
          builder: (context, detailsState) {
            if (detailsState is BankDetailsLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            String currentStatus =
                widget.serviceData?['status']?.toString() ?? "PENDING";
            if (detailsState is BankDetailsSuccess) {
              currentStatus = detailsState.data.status ?? currentStatus;
            }

            final bool isRejected = currentStatus.toUpperCase() == "REJECTED";

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
                            const Icon(Icons.account_balance_outlined,
                                color: Color(0xFFFFB74D), size: 28),
                            const SizedBox(width: 12),
                            Flexible(
                              child: Text(
                                widget.serviceTitle ??
                                    "Bank Account Verification",
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
                      StatusChip(status: currentStatus),
                    ],
                  ),
                  if (detailsState is BankDetailsSuccess &&
                      detailsState.data.reason != null &&
                      detailsState.data.reason!.isNotEmpty)
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
                                  color: const Color(0xFFB71C1C),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${detailsState.data.reason}",
                            style: GoogleFonts.outfit(
                              color: const Color(0xFFD32F2F).withOpacity(0.9),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (detailsState is BankDetailsSuccess &&
                      detailsState.data.nameAtBank != null &&
                      detailsState.data.nameAtBank!.isNotEmpty)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 12),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: const Color(0xFFA5D6A7).withOpacity(0.5)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.check_circle_outline,
                                  color: Color(0xFF2E7D32), size: 18),
                              const SizedBox(width: 8),
                              Text(
                                "Bank Response",
                                style: GoogleFonts.outfit(
                                  color: const Color(0xFF1B5E20),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _buildDetailRow("Beneficiary Name",
                              "${detailsState.data.beneficiaryName ?? detailsState.data.nameAtBank}"),
                          if (detailsState.data.bankName != null &&
                              detailsState.data.bankName!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            _buildDetailRow(
                                "Bank Name", "${detailsState.data.bankName}"),
                          ],
                          if (detailsState.data.documentPdfFile != null &&
                              detailsState
                                  .data.documentPdfFile!.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            const Divider(height: 1),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () {
                                // Logic to open PDF URL
                                // Usually using url_launcher or a PDF viewer screen
                                debugPrint(
                                    "Opening PDF: ${detailsState.data.documentPdfFile}");
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.picture_as_pdf,
                                      color: Color(0xFFD32F2F), size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    "View Verification Report",
                                    style: GoogleFonts.outfit(
                                      color: const Color(0xFFD32F2F),
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  const SizedBox(height: 24),
                  form_widget(
                    controller: accountNumberController,
                    titleText: "Account Number",
                    hintText: "Enter Account Number",
                    textInputType: TextInputType.number,
                    isReadOnly: isReadOnly,
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                            ? "Account number is required"
                            : null,
                  ),
                  form_widget(
                    controller: ifscCodeController,
                    titleText: "IFSC Code",
                    hintText: "Enter IFSC Code",
                    textInputType: TextInputType.text,
                    isReadOnly: isReadOnly,
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                            ? "IFSC code is required"
                            : null,
                  ),
                  if (detailsState is BankDetailsSuccess &&
                      detailsState.data.documentPdfFile != null &&
                      detailsState.data.documentPdfFile!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    CustomButton(
                      text: "Download PDF Report",
                      width: double.infinity,
                      height: 45,
                      prefixIcon: Icons.picture_as_pdf,
                      iconSize: 20,
                      gradientColors: const [
                        Color(0xFFD32F2F),
                        Color(0xFFEF5350),
                      ],
                      onTap: () async {
                        final url = detailsState.data.documentPdfFile;
                        if (url != null && url.isNotEmpty) {
                          final uri = Uri.parse(url);
                          if (!await launchUrl(uri,
                              mode: LaunchMode.externalApplication)) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Could not launch report")),
                              );
                            }
                          }
                        }
                      },
                    ),
                  ],
                  const SizedBox(height: 24),
                  BlocBuilder<BankAccountCubit, BankAccountState>(
                    builder: (context, state) {
                      if (currentStatus.toLowerCase() == "verified" ||
                          currentStatus.toLowerCase() == "done") {
                        return const SizedBox.shrink();
                      }

                      if (!isReadOnly && isEditing) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomButton(
                              text: "Cancel",
                              width: 120,
                              height: 48,
                              iconSize: 18,
                              onTap: () {
                                setState(() {
                                  isReadOnly = true;
                                  isEditing = false;
                                  _populateData(
                                      detailsState is BankDetailsSuccess
                                          ? detailsState.data
                                          : Data());
                                });
                              },
                              gradientColors: const [
                                Colors.grey,
                                Colors.blueGrey
                              ],
                            ),
                            const SizedBox(width: 16),
                            CustomButton(
                              text: state is BankAccountLoadingState
                                  ? "Saving..."
                                  : "Save",
                              width: 120,
                              height: 48,
                              prefixIcon: state is BankAccountLoadingState
                                  ? null
                                  : Icons.save,
                              iconSize: 18,
                              gradientColors: const [
                                Color(0xFFF4511E),
                                Color(0xFFFFB74D),
                              ],
                              onTap: state is BankAccountLoadingState
                                  ? null
                                  : () => _submitForm(context),
                            ),
                          ],
                        );
                      }

                      return Align(
                        alignment: Alignment.centerRight,
                        child: CustomButton(
                          text: state is BankAccountLoadingState
                              ? (isReadOnly && isRejected
                                  ? "Updating..."
                                  : "Submitting...")
                              : (isReadOnly && isRejected
                                  ? "Update"
                                  : "Submit"),
                          width: 140,
                          height: 48,
                          prefixIcon: state is BankAccountLoadingState
                              ? null
                              : (isReadOnly && isRejected
                                  ? Icons.edit
                                  : Icons.send),
                          iconSize: 18,
                          gradientColors: const [
                            Color(0xFFF4511E),
                            Color(0xFFFFB74D),
                          ],
                          onTap: state is BankAccountLoadingState
                              ? null
                              : () {
                                  if (isReadOnly && isRejected) {
                                    setState(() {
                                      isReadOnly = false;
                                      isEditing = true;
                                    });
                                  } else if (!isReadOnly) {
                                    _submitForm(context);
                                  }
                                },
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            "$label:",
            style: GoogleFonts.outfit(
              color: const Color(0xFF455A64),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.outfit(
              color: const Color(0xFF263238),
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  void _showResultDialog(Map<String, dynamic> responseData) {
    String nameAtBank = "N/A";
    String pdfUrl =
        responseData['pdf_url'] ?? responseData['document_pdf_file'] ?? "";

    try {
      if (responseData['data'] != null &&
          responseData['data']['data'] != null &&
          responseData['data']['data']['data'] != null) {
        nameAtBank =
            responseData['data']['data']['data']['nameAtBank'] ?? "N/A";
      }
    } catch (e) {
      debugPrint("Error parsing nameAtBank: $e");
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle,
                              color: Color(0xFF00C853), size: 24),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Bank Verification Result",
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF263238),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F8E9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Overall Status",
                        style: GoogleFonts.outfit(
                          color: const Color(0xFF2E7D32),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00C853),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "VERIFIED",
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildDialogInfoBox(
                  label: "NAME AT BANK",
                  value: nameAtBank.toUpperCase(),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildDialogInfoBox(
                        label: "ACCOUNT NUMBER",
                        value: accountNumberController.text,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDialogInfoBox(
                        label: "IFSC CODE",
                        value: ifscCodeController.text,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: "Download Report",
                  width: double.infinity,
                  height: 48,
                  prefixIcon: Icons.download_rounded,
                  gradientColors: const [Color(0xFF2962FF), Color(0xFF536DFE)],
                  onTap: () async {
                    if (pdfUrl.isNotEmpty) {
                      final uri = Uri.parse(pdfUrl);
                      if (!await launchUrl(uri,
                          mode: LaunchMode.externalApplication)) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Could not open PDF")),
                          );
                        }
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Report URL not available")),
                      );
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Close",
                    style: GoogleFonts.outfit(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDialogInfoBox({required String label, required String value}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF263238),
            ),
          ),
        ],
      ),
    );
  }
}
