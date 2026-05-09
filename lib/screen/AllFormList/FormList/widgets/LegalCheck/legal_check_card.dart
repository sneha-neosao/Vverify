import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../commonComponent/custom_button.dart';
import '../../../../VerificationForms/common/form_widget.dart';
import '../common_widgets.dart';

class LegalCheckCard extends StatelessWidget {
  final String? serviceTitle;
  const LegalCheckCard({super.key, this.serviceTitle});

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
                  const Icon(Icons.gavel_outlined, color: Color(0xFFFFB74D), size: 28),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      serviceTitle ?? "Legal Check",
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
          titleText: "First Name",
          hintText: "abc",
          textInputType: TextInputType.name,
        ),
        form_widget(
          controller: TextEditingController(),
          titleText: "Last Name",
          hintText: "xyz",
          textInputType: TextInputType.name,
        ),
        form_widget(
          controller: TextEditingController(),
          titleText: "Father Name",
          hintText: "Enter father name",
          textInputType: TextInputType.name,
        ),
        form_widget(
          controller: TextEditingController(),
          titleText: "Address",
          hintText: "Enter full address",
          textInputType: TextInputType.streetAddress,
        ),
        form_widget(
          controller: TextEditingController(),
          titleText: "Date of Birth",
          hintText: "DD-MM-YYYY",
          textInputType: TextInputType.datetime,
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
