import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../commonComponent/custom_button.dart';
import '../../../../VerificationForms/common/form_widget.dart';
import '../common_widgets.dart';
import 'bloc/aadhaar_ocr_cubit.dart';
import 'bloc/aadhaar_ocr_state.dart';

class AadhaarDigilockerCard extends StatefulWidget {
  final TextEditingController controller;
  final String? serviceTitle;

  const AadhaarDigilockerCard({
    super.key,
    required this.controller,
    this.serviceTitle,
  });

  @override
  State<AadhaarDigilockerCard> createState() => _AadhaarDigilockerCardState();
}

class _AadhaarDigilockerCardState extends State<AadhaarDigilockerCard> {
  @override
  void initState() {
    super.initState();
    _loadSavedData();
    widget.controller.addListener(_saveData);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_saveData);
    super.dispose();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedAadhaar = prefs.getString('aadhaar_number_persist');
    if (savedAadhaar != null && widget.controller.text.isEmpty) {
      widget.controller.text = savedAadhaar;
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('aadhaar_number_persist', widget.controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AadhaarOcrCubit(),
      child: BlocConsumer<AadhaarOcrCubit, AadhaarOcrState>(
        listener: (context, state) {
          if (state is AadhaarOcrSuccess) {
            if (state.ocrData.details?.aadhaarNumber != null) {
              // Remove spaces from extracted Aadhaar number
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
                            widget.serviceTitle ?? "AADHAAR Via Digilocker",
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
                    titleText: "Aadhaar Number",
                    hintText: "Enter 12 digit AADHAAR number",
                    textInputType: TextInputType.number,
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
              ),
              const SizedBox(height: 8),
              Text(
                "Supports: Image / PDF (up to 2MB)",
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                ),
              ),
              if (state is AadhaarOcrSuccess) ...[
                const SizedBox(height: 16),
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
              const SizedBox(height: 24),
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
