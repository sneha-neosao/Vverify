import 'package:flutter/material.dart';

class CustomSalutationTextField extends StatelessWidget {
  const CustomSalutationTextField({
    super.key,
    required this.controller,
    required this.titleText,
    required this.hintText,
    required this.textInputType,
    required this.salutations,
    required this.selectedSalutation,
    required this.onSalutationChanged,
    this.validator,
  });

  final TextEditingController controller;
  final String titleText;
  final String hintText;
  final TextInputType textInputType;
  final List<String> salutations;
  final String? selectedSalutation;
  final void Function(String?) onSalutationChanged;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        RichText(
          text: TextSpan(
            text: titleText,
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(fontWeight: FontWeight.w700),
            children: [
              TextSpan(
                text: " * ",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontWeight: FontWeight.w700, color: Colors.red),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            // Dropdown for Salutation - Now with same styling as TextField
            SizedBox(
              height: 45,
              width: 100,
              child: DropdownButtonFormField<String>(
                initialValue: salutations.contains(selectedSalutation)
                    ? selectedSalutation
                    : null,
                hint: const Text(
                  "select",
                  style: TextStyle(color: Colors.grey),
                ),
                onChanged: onSalutationChanged,
                items: salutations.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,
                        style: Theme.of(context).textTheme.bodyMedium),
                  );
                }).toList(),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: const TextStyle(color: Colors.grey),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 14.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).canvasColor, width: 1.0),
                  ),
                  filled: true,
                ),
                style: Theme.of(context).textTheme.bodyMedium,
                dropdownColor: Colors.white,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 8,
              ),
            ),
            const SizedBox(width: 12),
            // TextField for HR Name
            Expanded(
              child: TextFormField(
                controller: controller,
                keyboardType: textInputType,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (validator != null) return validator!(value);
                  if (value == null || value.trim().isEmpty) {
                    return "$titleText is required";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: const TextStyle(color: Colors.grey),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 14.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).canvasColor, width: 1.0),
                  ),
                  filled: true,
                ),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
