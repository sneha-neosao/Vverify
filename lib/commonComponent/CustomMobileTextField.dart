import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:v_verify/screen/VerificationForms/common/validator.dart';

class CustomMobileTextField extends StatelessWidget {
  final String hintText;
  final String? labelText;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final List<TextInputFormatter>? formatter;

  const CustomMobileTextField(
      {super.key,
      required this.hintText,
      this.labelText,
      required this.keyboardType,
      required this.controller,
      this.formatter});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Text(
              '+91',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(
            height: 50,
            child: VerticalDivider(
              color: Colors.grey,
              thickness: 1.5,
            ),
          ),
          Expanded(
            child: TextFormField(
              validator: validateMobile,
              inputFormatters: formatter,
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                hintText: hintText,
                labelText: labelText,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 14.0,
                ),
                filled: true,
                fillColor: Colors.transparent,
              ),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
