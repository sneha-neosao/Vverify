import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../commonComponent/custom_button.dart';
import '../../../../VerificationForms/common/form_widget.dart';
import '../common_widgets.dart';

class EducationVerificationCard extends StatelessWidget {
  final String? serviceTitle;
  const EducationVerificationCard({super.key, this.serviceTitle});

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
                  const Icon(Icons.school_outlined, color: Color(0xFFFFB74D), size: 28),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      serviceTitle ?? "Education Verification",
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
          titleText: "University Name",
          hintText: "University Name",
          textInputType: TextInputType.text,
        ),
        form_widget(
          controller: TextEditingController(),
          titleText: "Institute Name",
          hintText: "College/School",
          textInputType: TextInputType.text,
        ),
        form_widget(
          controller: TextEditingController(),
          titleText: "Degree Name",
          hintText: "B.Tech, MBA, etc.",
          textInputType: TextInputType.text,
        ),
        form_widget(
          controller: TextEditingController(),
          titleText: "Year of Passing",
          hintText: "YYYY",
          textInputType: TextInputType.number,
        ),
        const FormDropdownWidget(
          titleText: "Grade Type",
          hintText: "Select Grade Type",
          items: ["Percentage", "CGPA", "Grade"],
        ),
        form_widget(
          controller: TextEditingController(),
          titleText: "Grade Obtained",
          hintText: "Grade/Percentage/Cgpa",
          textInputType: TextInputType.text,
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
