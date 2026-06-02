import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomNotRequiredTextField extends StatelessWidget {
  const CustomNotRequiredTextField(
      {super.key,
      required this.controller,
      required this.titleText,
      required this.hintText,
      required this.textInputType,
      this.enabled = true,
      this.readOnly = false,
      this.validator,
      this.maskFormatter});

  final TextEditingController controller;
  final String titleText;
  final hintText;
  final TextInputType textInputType;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? maskFormatter;
  final bool readOnly;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 16,
        ),
        Text(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          titleText,
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(
          height: 4,
        ),
        TextFormField(
            enabled: enabled,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) {
              FocusScope.of(context).nextFocus();
            },
            inputFormatters: maskFormatter,
            validator: validator,
            readOnly: readOnly,
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
