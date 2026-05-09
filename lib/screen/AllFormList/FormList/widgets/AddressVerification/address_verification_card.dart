import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../commonComponent/custom_button.dart';
import '../../../../VerificationForms/common/form_widget.dart';
import '../common_widgets.dart';

class AddressVerificationCard extends StatelessWidget {
  final String? serviceTitle;
  const AddressVerificationCard({super.key, this.serviceTitle});

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
                  const Icon(Icons.home_outlined, color: Color(0xFFFFB74D), size: 28),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      serviceTitle ?? "Address Verification",
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
          titleText: "Address Line 1",
          hintText: "Building No, Street Name",
          textInputType: TextInputType.streetAddress,
        ),
        form_widget(
          controller: TextEditingController(),
          titleText: "Address Line 2 (Optional)",
          hintText: "Floor, Area, Landmark",
          textInputType: TextInputType.streetAddress,
        ),
        form_widget(
          controller: TextEditingController(),
          titleText: "City",
          hintText: "Enter City",
          textInputType: TextInputType.text,
        ),
        form_widget(
          controller: TextEditingController(),
          titleText: "State",
          hintText: "Enter State",
          textInputType: TextInputType.text,
        ),
        form_widget(
          controller: TextEditingController(),
          titleText: "Pincode",
          hintText: "Enter 6-digit Pincode",
          textInputType: TextInputType.number,
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
