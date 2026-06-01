import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final List<Color> gradientColors;
  final bool isLoading;
  final double? width;
  final double? height;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Color? iconColor;
  final double? iconSize;
  final Color? borderColor;
  final double? borderWidth;
  final TextStyle? textStyle;
  final bool enabled;

  const CustomButton({
    Key? key,
    required this.text,
    this.onTap,
    this.gradientColors = const [Colors.blue, Colors.green], // Default gradient
    this.isLoading = false,
    this.width,
    this.height,
    this.prefixIcon,
    this.suffixIcon,
    this.iconColor,
    this.iconSize,
    this.borderColor,
    this.borderWidth,
    this.textStyle,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (isLoading || !enabled) ? null : onTap,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: (borderColor != null && borderWidth != null)
              ? Border.all(color: borderColor!, width: borderWidth!)
              : null,
        ),
        child: ElevatedButton(
          onPressed: (isLoading || !enabled) ? null : onTap,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero, // Remove default padding
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  8), // Match the border radius of the container
            ),
            elevation: 0, // Remove the default elevation
            backgroundColor: Colors
                .transparent, // Set the background to transparent so the gradient shows through
          ),
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (prefixIcon != null) ...[
                      Icon(prefixIcon,
                          color: iconColor ?? Colors.white, size: iconSize),
                      const SizedBox(
                          width: 8), // Space between prefix icon and text
                    ],
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          text,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: textStyle ??
                              TextStyle(
                                color: enabled ? Colors.white : Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                    if (suffixIcon != null) ...[
                      const SizedBox(
                          width: 8), // Space between text and suffix icon
                      Icon(suffixIcon,
                          color: iconColor ?? Colors.white, size: iconSize),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
