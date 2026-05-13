import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Preview extends StatefulWidget {
  final String url;

  Preview({super.key, required this.url});

  @override
  State<Preview> createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  void _downloadFile(String url) {
    String fileName = url.split('/').last;
    if (fileName.isEmpty || !fileName.contains('.')) {
      fileName =
          "file_${DateTime.now().millisecondsSinceEpoch}${widget.url.contains('pdf') ? '.pdf' : '.jpg'}";
    }

    FileDownloader.downloadFile(
      url: url,
      name: fileName,
      onProgress: (fileName, progress) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Downloading $fileName: ${progress.toInt()}%"),
            duration: const Duration(milliseconds: 500),
          ),
        );
      },
      onDownloadCompleted: (path) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Downloaded Successfully to: $path"),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      },
      onDownloadError: (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Download Error: $error"),
            backgroundColor: Colors.red,
          ),
        );
      },
    );
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
