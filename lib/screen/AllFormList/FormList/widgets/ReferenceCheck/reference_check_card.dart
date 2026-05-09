import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../commonComponent/custom_button.dart';
import '../../../../VerificationForms/common/form_widget.dart';
import '../common_widgets.dart';

class ReferenceCheckCard extends StatelessWidget {
  final String? serviceTitle;
  const ReferenceCheckCard({super.key, this.serviceTitle});

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
                  const Icon(Icons.people_outline,
                      color: Color(0xFFFFB74D), size: 28),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      serviceTitle ?? "Reference Check",
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
        _buildReferencePerson(context, "Reference Person 1"),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Divider(color: Color(0xFFEEEEEE), thickness: 1),
        ),
        _buildReferencePerson(context, "Reference Person 2"),
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

  Widget _buildReferencePerson(BuildContext context, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: const Color(0xFFF4511E),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF263238),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        form_widget(
          controller: TextEditingController(),
          titleText: "Name",
          hintText: "Person's Name",
          textInputType: TextInputType.name,
        ),
        form_widget(
          controller: TextEditingController(),
          titleText: "Mobile Number",
          hintText: "10-digit Mobile Number",
          textInputType: TextInputType.phone,
        ),
        form_widget(
          controller: TextEditingController(),
          titleText: "Relation",
          hintText: "e.g. Manager, Colleague",
          textInputType: TextInputType.text,
        ),
        form_widget(
          controller: TextEditingController(),
          titleText: "Email",
          hintText: "email@example.com",
          textInputType: TextInputType.emailAddress,
        ),
        form_widget(
          controller: TextEditingController(),
          titleText: "Alt. Mobile / Landline",
          hintText: "Alternate contact",
          textInputType: TextInputType.phone,
        ),
      ],
    );
  }
}
