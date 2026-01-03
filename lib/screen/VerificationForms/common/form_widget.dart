import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../commonComponent/customTextFiled.dart';

class form_widget extends StatelessWidget {
  const form_widget(
      {super.key,
      required this.controller,
      required this.titleText,
      required this.hintText,
      required this.textInputType,
      this.validator,
      this.maskFormatter,
      this.titleDetails,
        this.onSaveValue
      });

  final TextEditingController controller;
  final String titleText;
  final hintText;
  final TextInputType textInputType;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? maskFormatter;
  final String? titleDetails;
  final void Function(String?)? onSaveValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 16,
        ),
        RichText(
            text: TextSpan(
                text: titleText,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontWeight: FontWeight.w700),
                children: [
              TextSpan(
                text: titleText.isEmpty ? "" : " * ",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontWeight: FontWeight.w700, color: Colors.red),
              ),
                  TextSpan(
                    text:titleDetails,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontWeight: FontWeight.w700, color: Colors.grey),
                  )
            ])),
        const SizedBox(
          height: 4,
        ),
        CustomTextField(
          maskFormatter: maskFormatter,
          validator: validator,
          controller: controller,
          keyboardType: textInputType,
          hintText: hintText,
          labelText: titleText,
          onSaveValue: onSaveValue,

        )
      ],
    );
  }
}

class FormFieldNotRequired extends StatelessWidget {
  const FormFieldNotRequired(
      {super.key,
      required this.controller,
      required this.titleText,
      required this.hintText,

      required this.textInputType,
      this.validator,
      this.maskFormatter});

  final TextEditingController controller;
  final String titleText;
  final hintText;
  final TextInputType textInputType;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? maskFormatter;

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
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) {
              FocusScope.of(context).nextFocus();
            },
            inputFormatters: maskFormatter,
            validator: validator ,
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
