import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? labelText;
  final String hintText;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Function(String)? onChanged;
  final Function(String)? onCompleted;
  final void Function(String?)? onSaveValue;
  final String? Function(String?)? validator;
  final String? validationMessage;
  final bool isCapitalized;
  final VoidCallback? suffixIconOnPressed;
  final bool isReadOnly;
  final FocusNode? focusNode;
  final Decoration? decoration;
  final InputDecoration? inputDecoration;
  final int? maxLine;
  MaskTextInputFormatter? inputFormatter;
  final List<TextInputFormatter>? maskFormatter;

  // Constructor to pass values for customization
  CustomTextField(
      {Key? key,
      required this.controller,
      this.labelText,
      this.hintText = 'Type something...',
      this.prefixIcon,
      this.suffixIcon,
      this.onChanged,
      this.onCompleted,
      this.onSaveValue,
      this.validator,
      this.validationMessage,
      required this.keyboardType,
      this.isCapitalized = false,
      this.suffixIconOnPressed,
      this.isReadOnly = false,
      this.focusNode,
      this.decoration,
      this.inputDecoration,
      this.maxLine,
      this.inputFormatter,
      this.maskFormatter})
      : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _showSuffixIcon = false;

  @override
  void initState() {
    super.initState();
    // Initialize suffix icon visibility based on initial text
    _showSuffixIcon = widget.controller.text.isNotEmpty;

    // Listen to text changes
    //widget.controller.addListener(_updateSuffixIcon);
  }

  //
  // void _updateSuffixIcon() {
  //   final hasText = widget.controller.text.isNotEmpty;
  //   if (hasText != _showSuffixIcon) {
  //     setState(() {
  //       _showSuffixIcon = hasText;
  //     });
  //   }
  // }

  @override
  void dispose() {
    //widget.controller.removeListener(_updateSuffixIcon);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        onSaved: widget.onSaveValue,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: widget.onSaveValue,

        //     (value) {
        //   FocusScope.of(context).nextFocus();
        //
        // },
        inputFormatters: widget.maskFormatter,
        //autofocus: true,
        maxLines: widget.maxLine,
        controller: widget.controller,
        focusNode: widget.focusNode,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                BorderSide(color: Theme.of(context).canvasColor, width: 1.0),
          ),
          hintStyle: const TextStyle(color: Colors.grey),
          labelText: widget.labelText,
          hintText: widget.hintText,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                BorderSide(color: Theme.of(context).canvasColor, width: 1.0),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18.0,
            vertical: 14.0,
          ),
          filled: true,
          // fillColor: Colors.white,
          prefixIcon: widget.prefixIcon != null
              ? Icon(widget.prefixIcon, color: Colors.blue)
              : null,
          suffixIcon: widget.suffixIcon != null && _showSuffixIcon
              ? IconButton(
                  icon: Icon(widget.suffixIcon),
                  onPressed: widget.suffixIconOnPressed ??
                      () {
                        widget.controller.clear();
                        if (widget.onChanged != null) {
                          widget.onChanged!('');
                        }
                      },
                )
              : null,
        ),
        style: Theme.of(context).textTheme.bodyMedium,
        keyboardType: widget.keyboardType,
        // textInputAction: TextInputAction.done,
        onChanged: (value) {
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }
        },
        onEditingComplete: () {},
        validator: (value) {
          if (value == null || value.isEmpty) {
            return widget.validationMessage ??
                '${widget.labelText} is required';
          }
          if (widget.validator != null) {
            return widget.validator!(value);
          }
          return null;
        },
        readOnly: widget.isReadOnly,
        textCapitalization: widget.isCapitalized
            ? TextCapitalization.characters
            : TextCapitalization.none);
  }
}
