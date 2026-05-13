import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/file_view_screen.dart';

class StatusChip extends StatelessWidget {
  final String status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final String lowerStatus = status.toLowerCase();

    Color textColor = const Color(0xFFF57C00);
    Color bgColor = const Color(0xFFFFFDE7);
    Color borderColor = const Color(0xFFFFF59D);
    IconData icon = Icons.access_time;

    if (lowerStatus == 'pending') {
      textColor = const Color(0xFFF57C00);
      bgColor = const Color(0xFFFFFDE7);
      borderColor = const Color(0xFFFFF59D);
    } else if (lowerStatus.contains('reject') ||
        lowerStatus.contains('discrepancy')) {
      textColor = const Color(0xFFD32F2F);
      bgColor = const Color(0xFFFFEBEE);
      borderColor = const Color(0xFFEF9A9A);
      icon = Icons.cancel_outlined;
    } else if (lowerStatus.contains('verified') ||
        lowerStatus.contains('done') ||
        lowerStatus.contains('Clear')) {
      textColor = const Color(0xFF388E3C);
      bgColor = const Color(0xFFE8F5E9);
      borderColor = const Color(0xFFA5D6A7);
      icon = Icons.check_circle_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 16),
          const SizedBox(width: 6),
          Text(
            status,
            style: GoogleFonts.outfit(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class BrowseFileButton extends StatefulWidget {
  final Function(PlatformFile?)? onFilePicked;
  final String? initialFilePath;
  final String? storageKey; // Key to save/load file path from SharedPreferences

  const BrowseFileButton({
    super.key,
    this.onFilePicked,
    this.initialFilePath,
    this.storageKey,
  });

  @override
  State<BrowseFileButton> createState() => _BrowseFileButtonState();
}

class _BrowseFileButtonState extends State<BrowseFileButton> {
  PlatformFile? _pickedFile;

  @override
  void initState() {
    super.initState();
    _loadPersistedFile();
  }

  Future<void> _loadPersistedFile() async {
    if (widget.initialFilePath != null) {
      final file = File(widget.initialFilePath!);
      if (await file.exists()) {
        final length = await file.length();
        setState(() {
          _pickedFile = PlatformFile(
            name: file.path.split('/').last,
            path: file.path,
            size: length,
          );
        });
      }
    } else if (widget.storageKey != null) {
      final prefs = await SharedPreferences.getInstance();
      final savedPath = prefs.getString(widget.storageKey!);
      if (savedPath != null) {
        final file = File(savedPath);
        if (await file.exists()) {
          final length = await file.length();
          setState(() {
            _pickedFile = PlatformFile(
              name: file.path.split(Platform.pathSeparator).last,
              path: file.path,
              size: length,
            );
          });
        }
      }
    }
  }

  Future<void> _savePersistedFile(String? path) async {
    if (widget.storageKey != null) {
      final prefs = await SharedPreferences.getInstance();
      if (path != null) {
        await prefs.setString(widget.storageKey!, path);
      } else {
        await prefs.remove(widget.storageKey!);
      }
    }
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      );

      if (result != null) {
        setState(() {
          _pickedFile = result.files.first;
        });
        await _savePersistedFile(_pickedFile?.path);
        if (widget.onFilePicked != null) {
          widget.onFilePicked!(_pickedFile);
        }
      }
    } catch (e) {
      debugPrint("Error picking file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 200,
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: InkWell(
            onTap: _pickFile,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cloud_upload_outlined,
                    color: Color(0xFF455A64), size: 20),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    _pickedFile?.name ?? "Browse File",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF455A64),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                if (_pickedFile != null)
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.close, size: 16, color: Colors.red),
                    onPressed: () async {
                      setState(() {
                        _pickedFile = null;
                      });
                      await _savePersistedFile(null);
                      if (widget.onFilePicked != null) {
                        widget.onFilePicked!(null);
                      }
                    },
                  ),
              ],
            ),
          ),
        ),
        if (_pickedFile != null) ...[
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              if (_pickedFile?.path != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FileViewScreen(
                      filePath: _pickedFile!.path!,
                      fileName: _pickedFile!.name,
                    ),
                  ),
                );
              }
            },
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _pickedFile!.extension?.toLowerCase() == 'pdf'
                    ? Container(
                        color: Colors.red.withOpacity(0.1),
                        child: const Icon(Icons.picture_as_pdf,
                            color: Colors.red, size: 30),
                      )
                    : Image.file(
                        File(_pickedFile!.path!),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, color: Colors.grey),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Tap to preview",
            style: GoogleFonts.outfit(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
        ],
      ],
    );
  }
}

class FormDropdownWidget extends StatelessWidget {
  final String titleText;
  final String hintText;
  final List<String> items;
  final String? value;
  final Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final bool isRequired;

  const FormDropdownWidget({
    super.key,
    required this.titleText,
    required this.hintText,
    required this.items,
    this.value,
    this.onChanged,
    this.validator,
    this.isRequired = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        RichText(
          text: TextSpan(
            text: titleText,
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF455A64),
            ),
            children: [
              if (isRequired)
                const TextSpan(
                  text: " * ",
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: value,
          dropdownColor: Colors.white,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF455A64)),
          style:
              GoogleFonts.outfit(color: const Color(0xFF263238), fontSize: 14),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.outfit(color: Colors.grey, fontSize: 14),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  const BorderSide(color: Color(0xFFE0E0E0), width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  const BorderSide(color: Color(0xFFE0E0E0), width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  const BorderSide(color: Color(0xFF3F51B5), width: 1.5),
            ),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: GoogleFonts.outfit(fontSize: 14)),
            );
          }).toList(),
          onChanged: onChanged,
          validator: validator,
        ),
      ],
    );
  }
}

class FormDateWidget extends StatelessWidget {
  final String titleText;
  final String hintText;
  final TextEditingController controller;
  final VoidCallback? onTap;
  final bool isRequired;
  final bool isReadOnly;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;

  const FormDateWidget({
    super.key,
    required this.titleText,
    required this.hintText,
    required this.controller,
    this.onTap,
    this.isRequired = true,
    this.isReadOnly = false,
    this.validator,
    this.autovalidateMode,
  });

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
                .copyWith(fontWeight: FontWeight.w500),
            children: [
              if (isRequired)
                const TextSpan(
                  text: " * ",
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          style: GoogleFonts.outfit(color: Colors.black, fontSize: 14),
          readOnly: true,
          onTap: isReadOnly ? null : onTap,
          validator: validator,
          autovalidateMode: autovalidateMode,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.outfit(color: Colors.grey, fontSize: 14),
            prefixIcon: const Icon(Icons.calendar_today_outlined, size: 20),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey, width: 1.0),
            ),
          ),
        ),
      ],
    );
  }
}
