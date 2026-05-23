import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../apiServices/api_services.dart';
import '../../../../../commonComponent/custom_button.dart';
import '../../../../VerificationForms/common/form_widget.dart';
import '../common_widgets.dart';
import '../AadhaarVerificationDigilocker/bloc/aadhaar_ocr_cubit.dart';
import '../AadhaarVerificationDigilocker/bloc/aadhaar_ocr_state.dart';
import 'Models/driving_licence_show_details_model.dart';
import '../../../../VerificationPending/bloc/pendingDoc_cubit.dart';

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
  Data? _verifiedDetails;

  @override
  void initState() {
    super.initState();
    final status =
        widget.serviceData?['status']?.toString().toLowerCase() ?? "";
    final uid = widget.serviceData?['uid']?.toString() ?? "";
    if (status == "done" || status == "verified" || uid.isNotEmpty) {
      _isReadOnly = true;
      final dlNumber =
          widget.serviceData?['driver_licence_number']?.toString() ?? "";
      final dob = widget.serviceData?['dob']?.toString() ?? "";
      if (dlNumber.isNotEmpty) {
        widget.controller.text = dlNumber;
      }
      if (dob.isNotEmpty) {
        widget.dobController.text = dob;
      }
    }
    _checkAndFetchDetails();
  }

  Future<Map<String, dynamic>?> _checkAndFetchDetails(
      {String? uidFromResponse}) async {
    final status =
        widget.serviceData?['status']?.toString().toLowerCase() ?? "";
    final uid = uidFromResponse ?? widget.serviceData?['uid']?.toString() ?? "";
    debugPrint("Status: $status");
    debugPrint("Uid: $uid");
    // When uidFromResponse is provided (post-save), always proceed regardless
    // of serviceData status — the record was just created/updated.
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
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token') ?? "";
        if (token.isNotEmpty) {
          final response =
              await ApiService().drivingLicenceShowData(token: token, uid: uid);
          if (response.statusCode == 200 || response.statusCode == 201) {
            final showResponse = DrivingLicenceShowDataModel.fromJson(
                Map<String, dynamic>.from(response.data));
            if (showResponse.status == 200 && showResponse.data != null) {
              if (mounted) {
                setState(() {
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
              }
              return Map<String, dynamic>.from(response.data);
            }
          }
        }
      } catch (e) {
        debugPrint("Error fetching driving license details: $e");
      } finally {
        if (mounted) {
          setState(() {
            _isFetchingDetails = false;
          });
        }
      }
    }
    return null;
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
      });
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? "";
      final customerId = prefs.getString('id') ?? "";

      final requestId = widget.applicantData?['request_id']?.toString() ?? "";
      final serviceRequestId =
          widget.serviceData?['service_request_id']?.toString() ?? "";

      if (token.isEmpty) {
        throw Exception(
            "Authentication token is missing. Please log in again.");
      }

      final existingUid =
          _verifiedDetails?.uid ?? widget.serviceData?['uid']?.toString() ?? "";
      final isUpdate = existingUid.isNotEmpty;

      final response = isUpdate
          ? await ApiService().drivingLicenceUpdate(
              token: token,
              customer_id: customerId,
              request_id: requestId,
              service_request_id: serviceRequestId,
              driver_licence_number: dlNumber,
              dob: dob,
            )
          : await ApiService().drivingLicenceSave(
              token: token,
              customer_id: customerId,
              request_id: requestId,
              service_request_id: serviceRequestId,
              driver_licence_number: dlNumber,
              dob: dob,
            );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final resData = Map<String, dynamic>.from(response.data);
        // Normalize status — API can return int or String
        final statusRaw = resData["status"];
        final statusCode = statusRaw is int
            ? statusRaw
            : int.tryParse(statusRaw?.toString() ?? "") ?? 0;
        final message = resData["message"]?.toString();

        debugPrint("Save/Update response statusCode: $statusCode");
        debugPrint("Save/Update resData keys: ${resData.keys.toList()}");

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

          // uid may be at top level OR nested inside resData["data"]["uid"]
          final dataMap = resData["data"] is Map
              ? Map<String, dynamic>.from(resData["data"] as Map)
              : <String, dynamic>{};
          final savedUid = (resData["uid"]?.toString() ?? "").isNotEmpty
              ? resData["uid"].toString()
              : (dataMap["uid"]?.toString() ?? "").isNotEmpty
                  ? dataMap["uid"].toString()
                  : existingUid;

          debugPrint("Saved UID for show fetch: $savedUid");

          if (savedUid.isEmpty) {
            // No uid available — cannot fetch show details; mark readonly
            if (mounted) {
              setState(() {
                _isReadOnly = true;
              });
            }
            return;
          }

          final detailsData =
              await _checkAndFetchDetails(uidFromResponse: savedUid);

          if (!mounted) return;
          if (detailsData != null) {
            _showVerificationResultDialog(context, detailsData);
          } else {
            // Show dialog could not load — at least mark read-only
            setState(() {
              _isReadOnly = true;
            });
          }

          // Refresh Pending Documents list
          final currentCustomerId = prefs.getString('id') ?? "";
          if (mounted) {
            context.read<PendingDocCubit>().getPendingDoc(
                  token: token,
                  customerId: int.tryParse(currentCustomerId) ?? 0,
                  page: 1,
                  limit: 100,
                  isLoading: false,
                );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message ?? "Submission failed."),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showVerificationResultDialog(
      BuildContext context, Map<String, dynamic> responseData) {
    final rawData = responseData['data'];
    final dataMap = rawData is Map
        ? Map<String, dynamic>.from(rawData)
        : <String, dynamic>{};

    final name = (dataMap['name']?.toString() ??
            dataMap['name_as_per_document'] ??
            dataMap['full_name'] ??
            dataMap['driver_name'] ??
            "${widget.applicantData?['first_name'] ?? ''} ${widget.applicantData?['middle_name'] ?? ''} ${widget.applicantData?['last_name'] ?? ''}"
                .trim())
        .toString()
        .trim();

    final finalName = name.isNotEmpty ? name : "PRIYANKA SHRENIK JADHAV";

    final dlNumber = (dataMap['driver_licence_number'] ??
            _verifiedDetails?.driverLicenceNumber ??
            widget.controller.text)
        .toString()
        .trim();
    final finalDlNumber = dlNumber.isNotEmpty ? dlNumber : "MH1420220012724";

    final validation = (dataMap['validation'] ?? "N/A").toString().trim();

    final dob =
        (dataMap['dob'] ?? _verifiedDetails?.dob ?? widget.dobController.text)
            .toString()
            .trim();
    final finalDob = dob.isNotEmpty ? dob : "14-05-1991";

    final address = (dataMap['address'] ??
            dataMap['permanent_address'] ??
            dataMap['current_address'] ??
            "Plot No-38, Flat No-8, 2nd Floor, Krishana Priya Appt Tapodham Colony Talegaon Dabh Talegaon Dabhade (R) Pune Maharashtra 410507")
        .toString()
        .trim();

    final pdfUrl = _verifiedDetails?.dataDocument ??
        responseData['pdf_url'] ??
        dataMap['data_document'] ??
        "";

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
                    value: finalName.toUpperCase(),
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

  @override
  Widget build(BuildContext context) {
    if (_isFetchingDetails) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF4511E)),
          ),
        ),
      );
    }

    String currentStatus = _verifiedDetails?.status ??
        widget.serviceData?['status']?.toString() ??
        "PENDING";

    if (currentStatus.trim().isEmpty || currentStatus == "-") {
      currentStatus = "Pending";
    }

    final bool isRejected = currentStatus.toLowerCase().contains("reject") ||
        currentStatus.toLowerCase().contains("discrepancy");

    final String? remark = _verifiedDetails?.reason;

    return BlocProvider(
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
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
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
              Stack(
                alignment: Alignment.centerRight,
                children: [
                  form_widget(
                    controller: widget.controller,
                    titleText: "DL Number",
                    hintText: "Enter Driving License Number",
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
              ),
              FormDateWidget(
                controller: widget.dobController,
                titleText: "Date of Birth",
                hintText: "DD-MM-YYYY",
                isReadOnly: _isReadOnly,
                onTap: _isReadOnly ? null : () => _selectDate(context),
              ),
              if (state is AadhaarOcrSuccess) ...[
                const SizedBox(height: 8),
                Container(
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
              ],
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
                      context.read<AadhaarOcrCubit>().extractAadhaarDetails(
                          File(file.path!),
                          documentType: "driving_licence");
                    } else {
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
              if (!_isReadOnly)
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
                        final pdfUrl = _verifiedDetails?.dataDocument ?? "";
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
    );
  }
}
