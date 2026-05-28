import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../commonComponent/custom_button.dart';
import '../../../../VerificationForms/common/form_widget.dart';
import '../common_widgets.dart';
import 'bloc/aadhaar_ocr_cubit.dart';
import 'bloc/aadhaar_ocr_state.dart';
import 'bloc/aadhaar_show_details_cubit.dart';
import 'bloc/aadhaar_show_details_state.dart';
import 'model/pan_show_details_model.dart';
import '../../../../../apiServices/api_services.dart';
import 'aadhaar_webview_screen.dart';
import '../../../../../commonComponent/bloc/shared_preferences_cubit.dart';
import '../../../../VerificationPending/bloc/pendingDoc_cubit.dart';
import '../../../../VerificationPending/Pagination/DashBoard/bloc/pending_doc_navigation_cubit.dart';

class AadhaarDigilockerCard extends StatefulWidget {
  final TextEditingController controller;
  final String? serviceTitle;
  final Map<String, dynamic>? serviceData;
  final Map<String, dynamic>? applicantData;

  const AadhaarDigilockerCard({
    super.key,
    required this.controller,
    this.serviceTitle,
    this.serviceData,
    this.applicantData,
  });

  @override
  State<AadhaarDigilockerCard> createState() => _AadhaarDigilockerCardState();
}

class _AadhaarDigilockerCardState extends State<AadhaarDigilockerCard> {
  bool _isSubmitting = false;
  late final AadhaarVerificationShowCubit _showDetailsCubit;
  bool isReadOnly = false;

  @override
  void initState() {
    super.initState();
    _showDetailsCubit = AadhaarVerificationShowCubit(ApiService());
    _checkAndFetchDetails();
  }

  @override
  void dispose() {
    super.dispose();
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
        _showDetailsCubit.fetchAadhaarDetails(token: token, uid: uid);
        setState(() {
          isReadOnly = true;
        });
      }
    }
  }

  void _populateData(Data data) {
    widget.controller.text = data.documentNumber ?? "";
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
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

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AadhaarOcrCubit()),
        BlocProvider.value(value: _showDetailsCubit),
      ],
      child: BlocListener<AadhaarOcrCubit, AadhaarOcrState>(
        listener: (context, state) {
          if (state is AadhaarOcrSuccess) {
            if (state.ocrData.details?.aadhaarNumber != null) {
              widget.controller.text =
                  state.ocrData.details!.aadhaarNumber!.replaceAll(' ', '');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Aadhaar Number Extracted Successfully!")),
              );
            }
          } else if (state is AadhaarOcrFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        child: BlocConsumer<AadhaarVerificationShowCubit,
            AadhaarVerificationShowState>(
          listener: (context, state) {
            if (state is AadhaarVerificationShowSuccessState) {
              if (state.aadhaarShowModel.data != null) {
                _populateData(state.aadhaarShowModel.data!);
              }
            }
          },
          builder: (context, showState) {
            if (showState is AadhaarVerificationShowLoadingState) {
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
            if (showState is AadhaarVerificationShowSuccessState) {
              currentStatus =
                  showState.aadhaarShowModel.data?.status ?? currentStatus;
            }

            if (currentStatus.trim().isEmpty || currentStatus == "-") {
              currentStatus = "PENDING";
            }

            final bool isVerified = currentStatus.toLowerCase() == "verified" ||
                currentStatus.toLowerCase() == "done";

            return Column(
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
                              widget.serviceTitle ?? "AADHAAR Via Digi Locker",
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
                if (showState is AadhaarVerificationShowSuccessState &&
                    showState.aadhaarShowModel.data?.reason != null &&
                    showState.aadhaarShowModel.data!.reason!.isNotEmpty)
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
                          "${showState.aadhaarShowModel.data!.reason}",
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
                if (isVerified) ...[
                  const SizedBox(height: 24),
                  form_widget(
                    controller: widget.controller,
                    titleText: "Aadhaar Number",
                    hintText: "Enter 12 digit AADHAAR number",
                    textInputType: TextInputType.number,
                    isReadOnly: true,
                    maskFormatter: [
                      FilteringTextInputFormatter.digitsOnly,
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                      LengthLimitingTextInputFormatter(12),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter Aadhaar number";
                      }
                      if (value.length != 12) {
                        return "Aadhaar must be 12 digits";
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  if (showState is AadhaarVerificationShowSuccessState &&
                      showState.aadhaarShowModel.data?.documentPdfFile !=
                          null &&
                      showState.aadhaarShowModel.data!.documentPdfFile!
                          .isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          final url =
                              showState.aadhaarShowModel.data!.documentPdfFile;
                          if (url != null && url.isNotEmpty) {
                            context.pushNamed(
                              'preview',
                              extra: url,
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Report PDF URL not available"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F0FE),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFD2E3FC)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.download,
                                color: Color(0xFF1A73E8),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Download PDF",
                                style: GoogleFonts.outfit(
                                  color: const Color(0xFF1A73E8),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ] else ...[
                  const SizedBox(height: 24),
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      form_widget(
                        controller: widget.controller,
                        titleText: "Aadhaar Number",
                        hintText: "Enter 12 digit AADHAAR number",
                        textInputType: TextInputType.number,
                        isReadOnly: isReadOnly,
                        maskFormatter: [
                          FilteringTextInputFormatter.digitsOnly,
                          FilteringTextInputFormatter.deny(RegExp(r'\s')),
                          LengthLimitingTextInputFormatter(12),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter Aadhaar number";
                          }
                          if (value.length != 12) {
                            return "Aadhaar must be 12 digits";
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      BlocBuilder<AadhaarOcrCubit, AadhaarOcrState>(
                        builder: (context, state) {
                          if (state is AadhaarOcrLoading) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 20.0, right: 12.0),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
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
                  BlocBuilder<AadhaarOcrCubit, AadhaarOcrState>(
                    builder: (context, ocrState) {
                      return BrowseFileButton(
                        storageKey: 'aadhaar_file_persist',
                        onFilePicked: (file) {
                          if (file != null) {
                            context
                                .read<AadhaarOcrCubit>()
                                .extractAadhaarDetails(File(file.path!));
                          } else {
                            widget.controller.clear();
                            context.read<AadhaarOcrCubit>().reset();
                          }
                        },
                      );
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
                  BlocBuilder<AadhaarOcrCubit, AadhaarOcrState>(
                    builder: (context, ocrState) {
                      if (ocrState is AadhaarOcrSuccess) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.amber.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline,
                                    size: 18, color: Colors.amber.shade800),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "Note: Auto-filled details may be inaccurate—please verify before submitting.",
                                    style: GoogleFonts.outfit(
                                      fontSize: 11,
                                      color: Colors.amber.shade900,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerRight,
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 140,
                            height: 48,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFFF4511E),
                              ),
                            ),
                          )
                        : CustomButton(
                            text: "Submit",
                            width: 140,
                            height: 48,
                            prefixIcon: Icons.send,
                            iconSize: 18,
                            gradientColors: const [
                              Color(0xFFF4511E),
                              Color(0xFFFFB74D),
                            ],
                            onTap: () async {
                              final aadhaarNum = widget.controller.text.trim();
                              if (aadhaarNum.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text("Please enter Aadhaar number"),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                                return;
                              }
                              if (aadhaarNum.length != 12) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Aadhaar must be 12 digits"),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                                return;
                              }

                              setState(() {
                                _isSubmitting = true;
                              });

                              try {
                                final token = context.read<TokenCubit>().state;
                                final customerId =
                                    context.read<IdCubit>().state;

                                final requestId = widget
                                        .applicantData?['request_id']
                                        ?.toString() ??
                                    "";
                                final serviceRequestId = widget
                                        .serviceData?['service_request_id']
                                        ?.toString() ??
                                    widget.serviceData?['id']?.toString() ??
                                    "";
                                final serviceId = widget
                                        .serviceData?['service_id']
                                        ?.toString() ??
                                    "8";

                                final response =
                                    await ApiService().aadhaarDigilockerSave(
                                  token: token,
                                  customer_id: customerId,
                                  request_id: requestId,
                                  service_request_id: serviceRequestId,
                                  document_number: aadhaarNum,
                                  document_type: "aadhaar",
                                  service_id: serviceId,
                                );

                                if (mounted) {
                                  setState(() {
                                    _isSubmitting = false;
                                  });

                                  if (response.data != null &&
                                      response.data['status'] == 200) {
                                    final responseData = response.data['data'];
                                    final webViewUrl =
                                        responseData?['url']?.toString() ?? "";
                                    final unifiedTxnId =
                                        responseData?['unifiedTransactionId']
                                                ?.toString() ??
                                            "";
                                    final uid =
                                        response.data['uid']?.toString() ?? "";

                                    if (webViewUrl.isNotEmpty) {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AadhaarWebviewScreen(
                                            url: webViewUrl,
                                            token: token,
                                            requestId:
                                                int.tryParse(requestId) ?? 0,
                                            serviceRequestId: int.tryParse(
                                                    serviceRequestId) ??
                                                0,
                                            customerId:
                                                int.tryParse(customerId) ?? 0,
                                            aadhaarNumber: aadhaarNum,
                                            unifiedTransactionId: unifiedTxnId,
                                            serviceId:
                                                int.tryParse(serviceId) ?? 8,
                                          ),
                                        ),
                                      );

                                      if (result == true && mounted) {
                                        _checkAndFetchDetails(
                                            force: true, uidFromResponse: uid);

                                        final navState = context
                                            .read<PendingDocNavigationCubit>()
                                            .state;
                                        context
                                            .read<PendingDocCubit>()
                                            .getPendingDoc(
                                              token: token,
                                              customerId:
                                                  int.tryParse(customerId) ?? 0,
                                              page: 1,
                                              limit: 100,
                                              entityId: navState.entityId,
                                              isLoading: false,
                                            );
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              "Verification URL not returned by server"),
                                          backgroundColor: Colors.redAccent,
                                        ),
                                      );
                                    }
                                  } else {
                                    final msg = response.data?['message'] ??
                                        "Failed to submit request.";
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(msg),
                                        backgroundColor: Colors.redAccent,
                                      ),
                                    );
                                  }
                                }
                              } catch (e) {
                                if (mounted) {
                                  setState(() {
                                    _isSubmitting = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Error: $e"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
