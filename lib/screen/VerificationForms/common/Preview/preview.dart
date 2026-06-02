import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Preview extends StatefulWidget {
  final String url;

  const Preview({super.key, required this.url});

  @override
  State<Preview> createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  Future<void> _downloadFile(String url) async {
    String fileName = url.split('/').last;
    if (fileName.isEmpty || !fileName.contains('.')) {
      fileName =
          "file_${DateTime.now().millisecondsSinceEpoch}${widget.url.contains('pdf') ? '.pdf' : '.jpg'}";
    }

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Downloading $fileName..."),
          duration: const Duration(seconds: 1),
        ),
      );

      final tempDir = await getTemporaryDirectory();
      final tempFilePath = '${tempDir.path}/$fileName';

      // 1. Download file using Dio to temporary directory
      final dio = Dio();
      await dio.download(
        url,
        tempFilePath,
      );

      // 2. Initialize MediaStore and save to Downloads/VVerify
      await MediaStore.ensureInitialized();
      MediaStore.appFolder = "vverify";

      final result = await MediaStore().saveFile(
        tempFilePath: tempFilePath,
        dirType: DirType.download,
        dirName: DirName.download,
      );

      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Downloaded Successfully to Downloads/vverify/$fileName"),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      } else {
        throw Exception("Failed to save to downloads folder.");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Download Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isPdf = widget.url.toLowerCase().contains("pdf");

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isPdf ? "PDF Preview" : "Image Preview",
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded),
            onPressed: () => _downloadFile(widget.url),
            tooltip: "Download",
          ),
        ],
      ),
      body: isPdf
          ? SfPdfViewer.network(widget.url)
          : Center(
              child: InteractiveViewer(
                child: CachedNetworkImage(
                  fit: BoxFit.contain,
                  imageUrl: widget.url,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _downloadFile(widget.url),
        backgroundColor: const Color(0xFF4F46E5),
        child: const Icon(Icons.file_download, color: Colors.white),
      ),
    );
  }
}
