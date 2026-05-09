import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../VerificationForms/common/form_widget.dart';

class ApplicantDetailsCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const ApplicantDetailsCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.person_outline,
                color: Theme.of(context).primaryColorLight, size: 28),
            const SizedBox(width: 12),
            Text(
              "Personal Details",
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF263238),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (data['company_name'] != null &&
            data['company_name'].toString().isNotEmpty)
          form_widget(
            controller:
                TextEditingController(text: data['company_name'].toString()),
            titleText: "Company Name",
            hintText: "",
            textInputType: TextInputType.text,
            isReadOnly: true,
          ),
        if (data['first_name'] != null &&
            data['first_name'].toString().isNotEmpty)
          form_widget(
            controller: TextEditingController(
                text: data['first_name']?.toString() ?? ""),
            titleText: "First Name",
            hintText: "",
            textInputType: TextInputType.text,
            isReadOnly: true,
          ),
        if (data['last_name'] != null &&
            data['last_name'].toString().isNotEmpty)
          form_widget(
            controller: TextEditingController(
                text: data['last_name']?.toString() ?? ""),
            titleText: "Last Name",
            hintText: "",
            textInputType: TextInputType.text,
            isReadOnly: true,
          ),
        if (data['phone'] != null && data['phone'].toString().isNotEmpty)
          form_widget(
            controller:
                TextEditingController(text: data['phone']?.toString() ?? ""),
            titleText: "Phone Number",
            hintText: "",
            textInputType: TextInputType.phone,
            isReadOnly: true,
          ),
        if (data['email'] != null && data['email'].toString().isNotEmpty)
          form_widget(
            controller:
                TextEditingController(text: data['email']?.toString() ?? ""),
            titleText: "Email Address",
            hintText: "",
            textInputType: TextInputType.emailAddress,
            isReadOnly: true,
          ),
        if (data['dob'] != null && data['dob'].toString().isNotEmpty)
          form_widget(
            controller: TextEditingController(text: data['dob'].toString()),
            titleText: "Date of Birth",
            hintText: "",
            textInputType: TextInputType.datetime,
            isReadOnly: true,
          ),
      ],
    );
  }
}
