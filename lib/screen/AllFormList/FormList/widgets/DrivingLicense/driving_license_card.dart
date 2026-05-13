import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../commonComponent/custom_button.dart';
import '../../../../VerificationForms/common/form_widget.dart';
import '../common_widgets.dart';
import '../AadhaarVerificationDigilocker/bloc/aadhaar_ocr_cubit.dart';
import '../AadhaarVerificationDigilocker/bloc/aadhaar_ocr_state.dart';

class DrivingLicenseCard extends StatefulWidget {
  final TextEditingController controller;
  final TextEditingController dobController;
  final String? serviceTitle;

  const DrivingLicenseCard({
    super.key,
    required this.controller,
    required this.dobController,
    this.serviceTitle,
  });

  @override
  State<DrivingLicenseCard> createState() => _DrivingLicenseCardState();
}

class _DrivingLicenseCardState extends State<DrivingLicenseCard> {
  @override
  void initState() {
    super.initState();
    _loadSavedData();
    widget.controller.addListener(_saveData);
    widget.dobController.addListener(_saveData);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_saveData);
    widget.dobController.removeListener(_saveData);
    super.dispose();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDl = prefs.getString('dl_number_persist');
    if (savedDl != null && widget.controller.text.isEmpty) {
      widget.controller.text = savedDl;
    }
    final savedDob = prefs.getString('dl_dob_persist');
    if (savedDob != null && widget.dobController.text.isEmpty) {
      widget.dobController.text = savedDob;
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('dl_number_persist', widget.controller.text);
    await prefs.setString('dl_dob_persist', widget.dobController.text);
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
                  const StatusChip(status: "PENDING"),
                ],
              ),
              const SizedBox(height: 24),
              Stack(
                alignment: Alignment.centerRight,
                children: [
                  form_widget(
                    controller: widget.controller,
                    titleText: "DL Number",
                    hintText: "Enter Driving License Number",
                    textInputType: TextInputType.text,
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
                onTap: () => _selectDate(context),
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
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: CustomButton(
                  text: "Submit",
                  width: 140,
                  height: 48,
                  prefixIcon: Icons.send,
                  iconSize: 18,
                  gradientColors: const [
                    Color(0xFFF4511E),
                    Color(0xFFFFB74D),
                  ],
                  onTap: () {
                    // Handle Submit
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
