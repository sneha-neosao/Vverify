import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Preview extends StatefulWidget {
  String url;

  Preview({super.key, required this.url});

  @override
  State<Preview> createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: widget.url.contains("pdf")
            ? SfPdfViewer.network(widget.url)
            : Center(child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: widget.url,
          placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) =>
          const Icon(Icons.error),
        ))
    );
  }
}
