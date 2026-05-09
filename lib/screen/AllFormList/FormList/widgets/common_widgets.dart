import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import '../widgets/file_view_screen.dart';

class StatusChip extends StatelessWidget {
  final String status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDE7),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFFF59D)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.access_time, color: Color(0xFFF57C00), size: 16),
          const SizedBox(width: 6),
          Text(
            status,
            style: GoogleFonts.outfit(
              color: const Color(0xFFF57C00),
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
  const BrowseFileButton({super.key, this.onFilePicked});

  @override
  State<BrowseFileButton> createState() => _BrowseFileButtonState();
}

class _BrowseFileButtonState extends State<BrowseFileButton> {
  PlatformFile? _pickedFile;

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
                    onPressed: () {
                      setState(() {
                        _pickedFile = null;
                      });
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

  const FormDropdownWidget({
    super.key,
    required this.titleText,
    required this.hintText,
    required this.items,
    this.value,
    this.onChanged,
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
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF263238),
            ),
            children: const [
              TextSpan(
                text: " * ",
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.outfit(color: Colors.grey, fontSize: 14),
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
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: GoogleFonts.outfit(fontSize: 14)),
            );
          }).toList(),
          onChanged: onChanged,
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

  const FormDateWidget({
    super.key,
    required this.titleText,
    required this.hintText,
    required this.controller,
    this.onTap,
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
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF263238),
            ),
            children: const [
              TextSpan(
                text: " * ",
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          readOnly: true,
          onTap: onTap,
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
