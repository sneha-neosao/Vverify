import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CouponTextField extends StatelessWidget {
  const CouponTextField(
      {super.key,
      required this.controller,
      required this.titleText,
      required this.hintText,
      required this.textInputType,
      this.readOnly = false,
      this.validator,
      this.maskFormatter,
      this.titleDetails,
      this.onSaveValue});

  final TextEditingController controller;
  final String titleText;
  final hintText;
  final TextInputType textInputType;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? maskFormatter;
  final String? titleDetails;
  final void Function(String?)? onSaveValue;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 16,
        ),
        TextFormField(
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) {
              FocusScope.of(context).nextFocus();
            },
            readOnly: readOnly,
            inputFormatters: maskFormatter,
            validator: (value) {
              if (validator != null) {
                return validator!(value);
              }
              if (value == null || value.trim().isEmpty) {
                return "$titleText is required";
              }
              return null;
            },
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                    color: Theme.of(context).canvasColor, width: 1.0),
              ),
              hintStyle: const TextStyle(color: Colors.grey),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey, width: 1.0),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                    color: Theme.of(context).canvasColor, width: 1.0),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 14.0,
              ),
              filled: true,
              hintText: hintText,
            ),
            style: Theme.of(context).textTheme.bodyMedium,
            controller: controller,
            keyboardType: textInputType)
      ],
    );
  }
}
