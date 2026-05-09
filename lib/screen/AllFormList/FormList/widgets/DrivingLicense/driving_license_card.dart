import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../commonComponent/custom_button.dart';
import '../../../../VerificationForms/common/form_widget.dart';
import '../common_widgets.dart';

class DrivingLicenseCard extends StatelessWidget {
  final String? serviceTitle;
  const DrivingLicenseCard({super.key, this.serviceTitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  const Icon(Icons.fingerprint, color: Color(0xFFFFB74D), size: 28),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      serviceTitle ?? "Driving License",
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
        form_widget(
          controller: TextEditingController(),
          titleText: "Driving License Number",
          hintText: "Enter Driving License Number (e.g. MH1220101234567)",
          textInputType: TextInputType.text,
        ),
        FormDateWidget(
          controller: TextEditingController(),
          titleText: "Date of Birth",
          hintText: "DD-MM-YYYY",
          onTap: () {
            // Show Date Picker
          },
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
        BrowseFileButton(),
        const SizedBox(height: 8),
        Text(
          "Supports: Image / PDF (up to 2MB)",
          style: GoogleFonts.outfit(
            fontSize: 11,
            color: Colors.grey.shade500,
          ),
        ),
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
  }
}
