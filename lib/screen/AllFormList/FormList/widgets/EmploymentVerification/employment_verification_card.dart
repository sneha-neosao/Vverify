import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../commonComponent/custom_button.dart';
import '../../../../VerificationForms/common/form_widget.dart';
import '../common_widgets.dart';

class EmploymentVerificationCard extends StatelessWidget {
  final String? serviceTitle;
  const EmploymentVerificationCard({super.key, this.serviceTitle});

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
                  const Icon(Icons.work_outline, color: Color(0xFFFFB74D), size: 28),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      serviceTitle ?? "Employment Verification",
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
        Text(
          "Employment 1: Add New Record",
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF263238),
          ),
        ),
        const SizedBox(height: 16),
        form_widget(
          controller: TextEditingController(),
          titleText: "Employer Name",
          hintText: "Enter employer name",
          textInputType: TextInputType.text,
        ),
        FormDateWidget(
          controller: TextEditingController(),
          titleText: "Joining Date",
          hintText: "DD-MM-YYYY",
          onTap: () {
            // Show Date Picker
          },
        ),
        FormDateWidget(
          controller: TextEditingController(),
          titleText: "Leaving Date",
          hintText: "DD-MM-YYYY",
          onTap: () {
            // Show Date Picker
          },
        ),
        Row(
          children: [
            Checkbox(value: false, onChanged: (v) {}),
            Text("Till Date", style: GoogleFonts.outfit(fontSize: 12)),
          ],
        ),
        form_widget(
          controller: TextEditingController(),
          titleText: "Designation",
          hintText: "Enter designation",
          textInputType: TextInputType.text,
        ),
        form_widget(
          controller: TextEditingController(),
          titleText: "Department",
          hintText: "Enter department",
          textInputType: TextInputType.text,
        ),
        form_widget(
          controller: TextEditingController(),
          titleText: "Remuneration",
          hintText: "Enter remuneration",
          textInputType: TextInputType.text,
        ),
        form_widget(
          controller: TextEditingController(),
          titleText: "Reporting Manager",
          hintText: "Enter reporting manager",
          textInputType: TextInputType.text,
        ),
        const SizedBox(height: 16),
        RichText(
          text: TextSpan(
            text: "Reason for Leaving",
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF263238),
            ),
            children: const [
              TextSpan(
                text: " * ",
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          maxLines: 4,
          decoration: InputDecoration(
            hintText: "Enter reason for leaving",
            hintStyle: GoogleFonts.outfit(color: Colors.grey, fontSize: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey, width: 1.0),
            ),
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
