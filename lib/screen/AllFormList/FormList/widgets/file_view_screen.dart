import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class FileViewScreen extends StatelessWidget {
  final String filePath;
  final String fileName;

  const FileViewScreen({
    super.key,
    required this.filePath,
    required this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    bool isPdf = filePath.toLowerCase().endsWith('.pdf');

    return Scaffold(
      appBar: AppBar(
        title: Text(fileName),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: isPdf
            ? SfPdfViewer.file(File(filePath))
            : InteractiveViewer(
                child: Image.file(File(filePath)),
              ),
      ),
    );
  }
}
