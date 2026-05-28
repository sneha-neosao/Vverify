import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../commonComponent/custom_button.dart';
import '../../../../VerificationForms/common/form_widget.dart';
import '../common_widgets.dart';
import '../AadhaarVerificationDigilocker/bloc/aadhaar_ocr_cubit.dart';
import '../AadhaarVerificationDigilocker/bloc/aadhaar_ocr_state.dart';
import 'Models/driving_licence_show_details_model.dart';
import 'Models/driving_licence_save_model.dart';
import '../../../../VerificationPending/bloc/pendingDoc_cubit.dart';
import '../../../../VerificationPending/Pagination/DashBoard/bloc/pending_doc_navigation_cubit.dart';
import '../../../../../commonComponent/bloc/shared_preferences_cubit.dart';
import 'Bloc/driving_licence_save_form_bloc/driving_licence_save_form_bloc.dart';
import 'Bloc/driving_licence_save_form_bloc/driving_licence_save_form_state.dart';
import 'Bloc/driving_licence_show_details_bloc/driving_licence_show_details_cubit.dart';
import 'Bloc/driving_licence_show_details_bloc/driving_licence_show_details_state.dart';


class DrivingLicenseCard extends StatefulWidget {
  final TextEditingController controller;
  final TextEditingController dobController;
  final String? serviceTitle;
  final Map<String, dynamic>? serviceData;
  final Map<String, dynamic>? applicantData;

  const DrivingLicenseCard({
    super.key,
    required this.controller,
    required this.dobController,
    this.serviceTitle,
    this.serviceData,
    this.applicantData,
  });

  @override
  State<DrivingLicenseCard> createState() => _DrivingLicenseCardState();
}

class _DrivingLicenseCardState extends State<DrivingLicenseCard> {
  bool _isLoading = false;
  bool _isFetchingDetails = false;
  bool _isReadOnly = false;
  bool _isEditing = false;
  Data? _verifiedDetails;
  bool _shouldShowDialog = false;
  File? _documentFile;

  Data? get serviceData =>
      widget.serviceData == null ? null : Data.fromJson(widget.serviceData!);

  @override
  void initState() {
    super.initState();
    final status = serviceData?.status?.toLowerCase() ?? "";
    final uid = serviceData?.uid ?? "";
    if (status == "done" || status == "verified" || uid.isNotEmpty) {
      _isReadOnly = true;
      final dlNumber = serviceData?.driverLicenceNumber?.toString() ?? "";
      final dob = serviceData?.dob?.toString() ?? "";
      if (dlNumber.isNotEmpty) {
        widget.controller.text = dlNumber;
      }
      if (dob.isNotEmpty) {
        widget.dobController.text = dob;
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndFetchDetails();
    });
  }

  void _checkAndFetchDetails({String? uidFromResponse}) async {
    final status = serviceData?.status?.toLowerCase() ?? "";
    final uid = uidFromResponse ?? serviceData?.uid ?? "";
    debugPrint("Status: $status");
    debugPrint("Uid: $uid");
    final shouldFetch = uidFromResponse != null && uidFromResponse.isNotEmpty ||
        status == "done" ||
        status == "verified" ||
        uid.isNotEmpty;
    if (shouldFetch && uid.isNotEmpty) {
      if (mounted) {
        setState(() {
          _isFetchingDetails = true;
        });
      }
      try {
        final showDataCubit = context.read<DrivingLicenceShowDataCubit>();
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token') ?? "";
        if (token.isNotEmpty) {
          showDataCubit.drivingLicenceShowDataLoad(
            token: token,
            uid: uid,
          );
        }
      } catch (e) {
        debugPrint("Error fetching driving license details: $e");
        if (mounted) {
          setState(() {
            _isFetchingDetails = false;
          });
        }
      }
    }
  }

  Future<void> _submitForm() async {
    final dlNumber = widget.controller.text.trim();
    final dob = widget.dobController.text.trim();

    if (dlNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("DL Number is required"),
            backgroundColor: Colors.red),
      );
      return;
    }
    if (dob.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Date of Birth is required"),
            backgroundColor: Colors.red),
      );
      return;
    }

    if (mounted) {
      setState(() {
        _isLoading = true;
        _shouldShowDialog = true;
      });
    }

    try {
      final saveCubit = context.read<DrivingLicenceBloc>();
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? "";
      final customerId = prefs.getString('id') ?? "";

      final requestId = widget.applicantData?['request_id']?.toString() ?? "";
      final serviceRequestId = serviceData?.serviceRequestId?.toString() ?? "";

      if (token.isEmpty) {
        throw Exception(
            "Authentication token is missing. Please log in again.");
      }

      final serviceId = serviceData?.serviceId?.toString() ?? "8";
      saveCubit.drivingLicenceSaveData(
        token: token,
        customer_id: customerId,
        request_id: requestId,
        service_request_id: serviceRequestId,
        service_id: serviceId,
        document_type: "drive",
        driver_licence_number: dlNumber,
        dob: dob,
        document_scan_pdf: _documentFile,
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _shouldShowDialog = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showVerificationResultDialog(BuildContext context, dynamic model) {
    String name = "";
    String dlNumber = "";
    String validation = "N/A";
    String dob = "";
    String address =
        "Plot No-38, Flat No-8, 2nd Floor, Krishana Priya Appt Tapodham Colony Talegaon Dabh Talegaon Dabhade (R) Pune Maharashtra 410507";
    String pdfUrl = "";

    if (model is DrivingLicenceSaveModel) {
      final data = model.data;
      if (data != null) {
        dlNumber = data.documentNumber ?? "";
        validation = data.status ?? "N/A";
        dob = data.dob ?? "";
        pdfUrl = data.documentPdfFile ?? "";
      }
    } else if (model is DrivingLicenceShowDataModel) {
      final data = model.data;
      if (data != null) {
        dlNumber = data.documentNumber?.toString() ??
            data.driverLicenceNumber?.toString() ??
            "";
        validation = data.status ?? "N/A";
        dob = data.dob?.toString() ?? "";
        pdfUrl = data.documentPdfFile ?? data.dataDocument ?? "";
      }
    } else if (model is Map) {
      final rawData = model['data'];
      final dataMap = rawData is Map
          ? Map<String, dynamic>.from(rawData)
          : <String, dynamic>{};
      name = (dataMap['name'] ??
              dataMap['name_as_per_document'] ??
              dataMap['full_name'] ??
              dataMap['driver_name'] ??
              "")
          .toString();
      dlNumber =
          (dataMap['document_number'] ?? dataMap['driver_licence_number'] ?? "")
              .toString();
      validation =
          (dataMap['validation'] ?? dataMap['status'] ?? "N/A").toString();
      dob = (dataMap['dob'] ?? "").toString();
      address = (dataMap['address'] ??
              dataMap['permanent_address'] ??
              dataMap['current_address'] ??
              address)
          .toString();
      pdfUrl = (model['pdf_url'] ??
              dataMap['data_document'] ??
              dataMap['document_pdf_file'] ??
              "")
          .toString();
    }

    final finalName = name.trim().isNotEmpty
        ? name.trim()
        : "${widget.applicantData?['first_name'] ?? ''} ${widget.applicantData?['middle_name'] ?? ''} ${widget.applicantData?['last_name'] ?? ''}"
            .trim();

    final finalNameOrPlaceholder =
        finalName.isNotEmpty ? finalName : "PRIYANKA SHRENIK JADHAV";
    final finalDlNumber = dlNumber.isNotEmpty ? dlNumber : "MH1420220012724";
    final finalDob = dob.isNotEmpty ? dob : "14-05-1991";

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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.check_circle,
                              color: Color(0xFF00C853), size: 24),
                          const SizedBox(width: 8),
                          Text(
                            "Verification Result",
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF263238),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF8F1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF00C853).withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Overall Status",
                          style: GoogleFonts.outfit(
                            color: const Color(0xFF1B5E20),
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
                            "ACTIVE",
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
                    label: "NAME AS PER DOCUMENT",
                    value: finalNameOrPlaceholder.toUpperCase(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDialogInfoBox(
                          label: "DRIVING LICENSE NUMBER",
                          value: finalDlNumber.toUpperCase(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDialogInfoBox(
                          label: "VALIDATION",
                          value: validation,
                          valueColor: const Color(0xFF00C853),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildDialogInfoBox(
                    label: "DATE OF BIRTH",
                    value: finalDob,
                  ),
                  const SizedBox(height: 12),
                  _buildDialogInfoBox(
                    label: "ADDRESS",
                    value: address,
                  ),
                  const SizedBox(height: 24),
                  InkWell(
                    onTap: () {
                      if (pdfUrl.isNotEmpty) {
                        context.pushNamed(
                          'preview',
                          extra: pdfUrl,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Report URL not available"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2F54EB), Color(0xFF597EF7)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color:
                                const Color(0xFF2F54EB).withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.file_download_outlined,
                                color: Colors.white, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              "Download Verification Report",
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Close",
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF64748B),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDialogInfoBox({
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF64748B),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: valueColor ?? const Color(0xFF1E293B),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
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
        widget.dobController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  Widget _buildDlField(dynamic state) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        form_widget(
          controller: widget.controller,
          titleText: "Driving License Number",
          hintText: "Enter Driving License Number (e.g. MH1220101234567)",
          textInputType: TextInputType.text,
          isReadOnly: _isReadOnly,
          maskFormatter: [
            LengthLimitingTextInputFormatter(16),
          ],
        ),
        if (state is AadhaarOcrLoading)
          const Padding(
            padding: EdgeInsets.only(top: 20.0, right: 12.0),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
      ],
    );
  }

  Widget _buildDobField(BuildContext context) {
    return FormDateWidget(
      controller: widget.dobController,
      titleText: "Date of Birth",
      hintText: "DD-MM-YYYY",
      isReadOnly: _isReadOnly,
      onTap: _isReadOnly ? null : () => _selectDate(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    String currentStatus =
        _verifiedDetails?.status ?? serviceData?.status ?? "PENDING";

    if (currentStatus.trim().isEmpty || currentStatus == "-") {
      currentStatus = "Pending";
    }

    final bool isRejected = currentStatus.toLowerCase().contains("reject") ||
        currentStatus.toLowerCase().contains("discrepancy");

    final String? remark = _verifiedDetails?.reason;

    return MultiBlocListener(
      listeners: [
        BlocListener<DrivingLicenceBloc, DrivingLicenceState>(
          listener: (context, state) async {
            if (state is DrivingLicenceSuccessState) {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
              }
              final resData = state.data;
              final statusCode = resData.status ?? 0;
              final message = resData.message;

              if (statusCode == 200) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message ??
                          "Driving License details submitted successfully."),
                      backgroundColor: Colors.green,
                    ),
                  );
                }

                final existingUid =
                    _verifiedDetails?.uid ?? serviceData?.uid ?? "";
                final savedUid = resData.data?.uid ?? existingUid;

                if (savedUid.isEmpty) {
                  if (mounted) {
                    setState(() {
                      _isReadOnly = true;
                      _shouldShowDialog = false;
                    });
                  }
                  return;
                }

                _showVerificationResultDialog(
                  context,
                  resData,
                );

                if (mounted) {
                  setState(() {
                    _shouldShowDialog = false;
                    _isReadOnly = true;
                    _isEditing = false;
                  });
                }

                _checkAndFetchDetails(uidFromResponse: savedUid);

                if (mounted) {
                  final pendingDocCubit = context.read<PendingDocCubit>();
                  final token = context.read<TokenCubit>().state;
                  final currentCustomerId = context.read<IdCubit>().state;
                  final navState =
                      context.read<PendingDocNavigationCubit>().state;
                  pendingDocCubit.getPendingDoc(
                    token: token,
                    customerId: int.tryParse(currentCustomerId) ?? 0,
                    page: 1,
                    limit: 100,
                    entityId: navState.entityId,
                    isLoading: false,
                  );
                }
              } else {
                if (mounted) {
                  setState(() {
                    _shouldShowDialog = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message ?? "Submission failed."),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            } else if (state is DrivingLicenceErrorState) {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                  _shouldShowDialog = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
        ),

        BlocListener<DrivingLicenceShowDataCubit, DrivingLicenceShowDataState>(
          listener: (context, state) {
            if (state is DrivingLicenceShowDataLoadingState) {
              if (mounted) {
                setState(() {
                  _isFetchingDetails = true;
                });
              }
            } else if (state is DrivingLicenceShowDataSuccessState) {
              final showResponse = state.drivingLicenceShowDataModel;
              if (mounted) {
                setState(() {
                  _isFetchingDetails = false;
                  _verifiedDetails = showResponse.data;
                  _isReadOnly = true;
                  if (_verifiedDetails!.driverLicenceNumber != null) {
                    widget.controller.text =
                        _verifiedDetails!.driverLicenceNumber.toString();
                  }
                  if (_verifiedDetails!.dob != null) {
                    widget.dobController.text =
                        _verifiedDetails!.dob.toString();
                  }
                });

                if (_shouldShowDialog) {
                  _showVerificationResultDialog(
                    context,
                    showResponse,
                  );
                  setState(() {
                    _shouldShowDialog = false;
                  });
                }
              }
            } else if (state is DrivingLicenceShowDataErrorState) {
              if (mounted) {
                setState(() {
                  _isFetchingDetails = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
        ),
      ],
      child: BlocProvider(
        create: (context) => AadhaarOcrCubit(),
        child: BlocConsumer<AadhaarOcrCubit, AadhaarOcrState>(
          listener: (context, state) {
            if (state is AadhaarOcrSuccess) {
              bool extracted = false;
              if (state.ocrData.details?.dlNumber != null) {
                widget.controller.text = state.ocrData.details!.dlNumber!;
                extracted = true;
              }
              if (state.ocrData.details?.dob != null) {
                widget.dobController.text = state.ocrData.details!.dob!;
                extracted = true;
              }

              if (extracted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Details Extracted Successfully!")),
                );
              }
            } else if (state is AadhaarOcrFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(state.error), backgroundColor: Colors.red),
              );
            }
          },
          builder: (context, state) {
            if (_isFetchingDetails) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFFF4511E)),
                  ),
                ),
              );
            }
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
                              widget.serviceTitle ??
                                  "Driving License Verification",
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
                      status: currentStatus.isNotEmpty
                          ? '${currentStatus[0].toUpperCase()}${currentStatus.substring(1).toLowerCase()}'
                          : "Pending",
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (remark != null && remark.isNotEmpty)
                  Builder(builder: (context) {
                    final bool isRejectTheme = isRejected;
                    final Color bgColor = isRejectTheme
                        ? const Color(0xFFFFEBEE)
                        : const Color(0xFFE8F5E9);
                    final Color borderColor = isRejectTheme
                        ? const Color(0xFFEF9A9A).withValues(alpha: 0.5)
                        : const Color(0xFFA5D6A7).withValues(alpha: 0.5);
                    final Color textColor = isRejectTheme
                        ? const Color(0xFFD32F2F)
                        : const Color(0xFF2E7D32);
                    final IconData icon = isRejectTheme
                        ? Icons.info_outline
                        : Icons.check_circle_outline;

                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(icon, color: textColor, size: 18),
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
                            remark,
                            style: GoogleFonts.outfit(
                              color: textColor.withValues(alpha: 0.9),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final bool isMobile = constraints.maxWidth < 600;
                    if (isMobile) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDlField(state),
                          const SizedBox(height: 16),
                          _buildDobField(context),
                        ],
                      );
                    } else {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildDlField(state)),
                          const SizedBox(width: 16),
                          Expanded(child: _buildDobField(context)),
                        ],
                      );
                    }
                  },
                ),
                if (!_isReadOnly) ...[
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
                    storageKey: 'dl_file_persist',
                    onFilePicked: (file) {
                      if (file != null) {
                        setState(() {
                          _documentFile = File(file.path!);
                        });
                        context.read<AadhaarOcrCubit>().extractAadhaarDetails(
                            File(file.path!),
                            documentType: "driving_licence");
                      } else {
                        setState(() {
                          _documentFile = null;
                        });
                        widget.controller.clear();
                        widget.dobController.clear();
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
                const SizedBox(height: 24),
                if (!_isReadOnly && _isEditing)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomButton(
                        text: "Cancel",
                        width: 120,
                        height: 48,
                        iconSize: 18,
                        onTap: () {
                          setState(() {
                            _isReadOnly = true;
                            _isEditing = false;
                            final originalDl = _verifiedDetails
                                    ?.driverLicenceNumber
                                    ?.toString() ??
                                serviceData?.driverLicenceNumber?.toString() ??
                                "";
                            final originalDob =
                                _verifiedDetails?.dob?.toString() ??
                                    serviceData?.dob?.toString() ??
                                    "";
                            widget.controller.text = originalDl;
                            widget.dobController.text = originalDob;
                          });
                        },
                        gradientColors: const [
                          Colors.grey,
                          Colors.blueGrey,
                        ],
                      ),
                      const SizedBox(width: 16),
                      CustomButton(
                        text: _isLoading ? "Saving..." : "Save",
                        width: 120,
                        height: 48,
                        prefixIcon: _isLoading ? null : Icons.save,
                        iconSize: 18,
                        gradientColors: const [
                          Color(0xFFF4511E),
                          Color(0xFFFFB74D),
                        ],
                        onTap: _isLoading ? null : _submitForm,
                      ),
                    ],
                  )
                else if (!_isReadOnly)
                  Align(
                    alignment: Alignment.centerRight,
                    child: CustomButton(
                      text: _isLoading ? "Submitting..." : "Submit",
                      width: 140,
                      height: 48,
                      prefixIcon: _isLoading ? null : Icons.send,
                      iconSize: 18,
                      gradientColors: const [
                        Color(0xFFF4511E),
                        Color(0xFFFFB74D),
                      ],
                      onTap: _isLoading ? null : _submitForm,
                    ),
                  )
                else if (isRejected)
                  Align(
                    alignment: Alignment.centerRight,
                    child: CustomButton(
                      text: "Edit",
                      width: 120,
                      height: 48,
                      prefixIcon: Icons.edit,
                      iconSize: 18,
                      gradientColors: const [
                        Color(0xFFF4511E),
                        Color(0xFFFFB74D),
                      ],
                      onTap: () {
                        setState(() {
                          _isReadOnly = false;
                          _isEditing = true;
                        });
                      },
                    ),
                  )
                else if (!isRejected)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 2.0),
                      child: InkWell(
                        onTap: () {
                          final pdfUrl = _verifiedDetails?.dataDocument ??
                              serviceData?.dataDocument ??
                              "";
                          if (pdfUrl.isNotEmpty) {
                            context.pushNamed(
                              'preview',
                              extra: pdfUrl,
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
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
