import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:v_verify/screen/VerificationForms/common/Preview/preview.dart';
import '../../../../../apiServices/api_services.dart';
import '../../../../../commonComponent/custom_button.dart';
import '../../../../../commonComponent/bloc/shared_preferences_cubit.dart';
import '../../../../VerificationForms/common/form_widget.dart';
import '../../../../VerificationPending/bloc/pendingDoc_cubit.dart';
import '../../../../VerificationPending/Pagination/DashBoard/bloc/pending_doc_navigation_cubit.dart';
import '../common_widgets.dart';
import '../AadhaarVerificationDigilocker/bloc/aadhaar_ocr_cubit.dart';
import '../AadhaarVerificationDigilocker/bloc/aadhaar_ocr_state.dart';
import 'Bloc/pan_verification_cubit.dart';
import 'Bloc/pan_verification_state.dart';
import 'Model/pan_verification_model.dart';

class PanVerificationCard extends StatefulWidget {
  final TextEditingController controller;
  final String? serviceTitle;
  final Map<String, dynamic>? applicantData;
  final Map<String, dynamic>? serviceData;

  const PanVerificationCard({
    super.key,
    required this.controller,
    this.serviceTitle,
    this.applicantData,
    this.serviceData,
  });

  @override
  State<PanVerificationCard> createState() => _PanVerificationCardState();
}

class _PanVerificationCardState extends State<PanVerificationCard> {
  late final PanVerificationCubit _panCubit;
  bool isReadOnly = false;
  bool isEditing = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _panCubit = PanVerificationCubit(ApiService());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndFetchDetails();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _checkAndFetchDetails({bool force = false, String? uidFromResponse}) {
    final uid = uidFromResponse ?? widget.serviceData?['uid']?.toString() ?? "";
    if (force ||
        widget.applicantData?['details_updated'] == 1 ||
        widget.serviceData?['status'] == "verified" ||
        widget.serviceData?['status'] == "DONE" ||
        uid.isNotEmpty) {
      final token = context.read<TokenCubit>().state;
      if (uid.isNotEmpty && token.isNotEmpty) {
        _panCubit.fetchPanDetails(token: token, uid: uid);
        setState(() {
          isReadOnly = true;
        });
      }
    }
  }

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      final token = context.read<TokenCubit>().state;
      final customerId = context.read<IdCubit>().state;

      final requestId = widget.applicantData?['request_id']?.toString() ??
          widget.applicantData?['id']?.toString() ??
          "";
      final serviceRequestId =
          widget.serviceData?['service_request_id']?.toString() ??
              widget.serviceData?['id']?.toString() ??
              "";
      final serviceId = widget.serviceData?['service_id']?.toString() ?? "1";

      _panCubit.submitPanVerification(
        token: token,
        requestId: requestId,
        serviceRequestId: serviceRequestId,
        serviceId: serviceId,
        customerId: customerId,
        documentType: "pan",
        documentNumber: widget.controller.text.trim().toUpperCase(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AadhaarOcrCubit()),
        BlocProvider.value(value: _panCubit),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AadhaarOcrCubit, AadhaarOcrState>(
            listener: (context, state) {
              if (state is AadhaarOcrSuccess) {
                if (state.ocrData.details?.panNumber != null) {
                  widget.controller.text = state.ocrData.details!.panNumber!;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("PAN Number Extracted Successfully!")),
                  );
                }
              } else if (state is AadhaarOcrFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(state.error), backgroundColor: Colors.red),
                );
              }
            },
          ),
          BlocListener<PanVerificationCubit, PanVerificationState>(
            listener: (context, state) {
              if (state is PanVerificationSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.model.message ??
                        "PAN Verification Request Submitted Successfully"),
                    backgroundColor: Colors.green,
                  ),
                );

                // Refresh the pending docs list respecting the current entity filter
                final token = context.read<TokenCubit>().state;
                final customerId = context.read<IdCubit>().state;
                final navState =
                    context.read<PendingDocNavigationCubit>().state;
                context.read<PendingDocCubit>().getPendingDoc(
                      token: token,
                      customerId: int.tryParse(customerId) ?? 0,
                      page: 1,
                      limit: 100,
                      entityId: navState.entityId,
                      isLoading: false,
                    );

                setState(() {
                  isReadOnly = true;
                  isEditing = false;
                });

                _checkAndFetchDetails(
                    force: true, uidFromResponse: state.model.uid);
                _showResultDialog(state.model);
              } else if (state is PanShowSuccess) {
                widget.controller.text = state.data.documentNumber ?? "";
              } else if (state is PanVerificationFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(state.error), backgroundColor: Colors.red),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<PanVerificationCubit, PanVerificationState>(
          builder: (context, panState) {
            if (panState is PanShowLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(
                    color: Color(0xFFF4511E),
                  ),
                ),
              );
            }

            String currentStatus =
                widget.serviceData?['status']?.toString() ?? "PENDING";
            if (panState is PanShowSuccess) {
              currentStatus = panState.data.status ?? currentStatus;
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
                            const Icon(Icons.fingerprint,
                                color: Color(0xFFFFB74D), size: 28),
                            const SizedBox(width: 12),
                            Flexible(
                              child: Text(
                                widget.serviceTitle ?? "PAN Verification",
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
                  if (panState is PanShowSuccess &&
                      panState.data.reason != null &&
                      panState.data.reason!.isNotEmpty)
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
                            "${panState.data.reason}",
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
                  const SizedBox(height: 24),
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      form_widget(
                        controller: widget.controller,
                        titleText: "PAN Number",
                        hintText: "Enter PAN Number (e.g. ABCDE1234F)",
                        textInputType: TextInputType.text,
                        isReadOnly: isReadOnly,
                        maskFormatter: [
                          LengthLimitingTextInputFormatter(10),
                        ],
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "PAN Number is required";
                          }
                          if (value.trim().length < 10) {
                            return "PAN Number must be 10 characters long";
                          }
                          return null;
                        },
                      ),
                      if (context.watch<AadhaarOcrCubit>().state
                          is AadhaarOcrLoading)
                        const Padding(
                          padding: EdgeInsets.only(top: 20.0, right: 12.0),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                    ],
                  ),
                  if (!isReadOnly) ...[
                    const SizedBox(height: 20),
                    Text(
                      "Scan & Auto-fill (optional)",
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    BrowseFileButton(
                      storageKey: 'pan_file_persist',
                      onFilePicked: (file) {
                        if (file != null) {
                          context.read<AadhaarOcrCubit>().extractAadhaarDetails(
                              File(file.path!),
                              documentType: "pan");
                        } else {
                          widget.controller.clear();
                          context.read<AadhaarOcrCubit>().reset();
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Supports: Image / PDF (up to 2MB)",
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                  if (panState is PanShowSuccess &&
                      panState.data.documentPdfFile != null &&
                      panState.data.documentPdfFile!.isNotEmpty) ...[
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
                      onTap: () {
                        final url = panState.data.documentPdfFile;
                        if (url != null && url.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Preview(url: url),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                  const SizedBox(height: 24),
                  BlocBuilder<PanVerificationCubit, PanVerificationState>(
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
                                  if (panState is PanShowSuccess) {
                                    widget.controller.text =
                                        panState.data.documentNumber ?? "";
                                  }
                                });
                              },
                              gradientColors: const [
                                Colors.grey,
                                Colors.blueGrey
                              ],
                            ),
                            const SizedBox(width: 16),
                            CustomButton(
                              text: state is PanVerificationLoading
                                  ? "Saving..."
                                  : "Save",
                              width: 120,
                              height: 48,
                              prefixIcon: state is PanVerificationLoading
                                  ? null
                                  : Icons.save,
                              iconSize: 18,
                              gradientColors: const [
                                Color(0xFFF4511E),
                                Color(0xFFFFB74D),
                              ],
                              onTap: state is PanVerificationLoading
                                  ? null
                                  : () => _submitForm(context),
                            ),
                          ],
                        );
                      }

                      return Align(
                        alignment: Alignment.centerRight,
                        child: CustomButton(
                          text: state is PanVerificationLoading
                              ? (isReadOnly && isRejected
                                  ? "Updating..."
                                  : "Submitting...")
                              : (isReadOnly && isRejected
                                  ? "Update"
                                  : "Submit"),
                          width: 140,
                          height: 48,
                          prefixIcon: state is PanVerificationLoading
                              ? null
                              : (isReadOnly && isRejected
                                  ? Icons.edit
                                  : Icons.send),
                          iconSize: 18,
                          gradientColors: const [
                            Color(0xFFF4511E),
                            Color(0xFFFFB74D),
                          ],
                          onTap: state is PanVerificationLoading
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

  void _showResultDialog(PanVerificationSubmitModel model) {
    final pdfUrl = model.pdfUrl ?? "";
    final name = model.data?.name ?? "N/A";
    final pan = model.data?.pan ?? widget.controller.text;
    final panStatus = model.data?.status ?? "Active";

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
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(0xFFECFDF5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_circle,
                            color: Color(0xFF10B981),
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "Verification Result",
                          style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close,
                          color: Color(0xFF64748B), size: 24),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Divider(color: Color(0xFFF1F5F9), thickness: 1.2),
                const SizedBox(height: 20),

                // Overall Status Row
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Overall Status",
                        style: GoogleFonts.outfit(
                          color: const Color(0xFF047857),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          panStatus.toUpperCase(),
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Name Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFF1F5F9)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "NAME AS PER DOCUMENT",
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF64748B),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        name.toUpperCase(),
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // PAN & Validation Row
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFF1F5F9)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "PAN NUMBER",
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF64748B),
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              pan.toUpperCase(),
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFF1F5F9)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "VALIDATION",
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF64748B),
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Verified ✓",
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF10B981),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                InkWell(
                  onTap: () {
                    if (pdfUrl.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Preview(url: pdfUrl),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Report URL not available")),
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2563EB).withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.download,
                            color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          "Download Verification Report",
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Close Button
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Close",
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF64748B),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
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
}
