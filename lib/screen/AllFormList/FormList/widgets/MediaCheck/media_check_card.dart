import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../apiServices/api_services.dart';
import '../../../../../commonComponent/custom_button.dart';
import '../../../../VerificationForms/common/form_widget.dart';
import '../common_widgets.dart';
import 'Model/media_check_response_model.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

class MediaCheckCard extends StatefulWidget {
  final String? serviceTitle;
  final Map<String, dynamic>? serviceData;
  final Map<String, dynamic>? applicantData;

  const MediaCheckCard({
    super.key,
    this.serviceTitle,
    this.serviceData,
    this.applicantData,
  });

  @override
  State<MediaCheckCard> createState() => _MediaCheckCardState();
}

class _MediaCheckCardState extends State<MediaCheckCard> {
  final TextEditingController _keywordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isFetchingDetails = false;
  MediaCheckShowData? _verifiedDetails;
  bool _isDownloadingPdf = false;
  int _downloadProgress = 0;

  @override
  void initState() {
    super.initState();
    _checkAndFetchDetails();
  }

  @override
  void dispose() {
    _keywordController.dispose();
    super.dispose();
  }

  Future<void> _checkAndFetchDetails(
      {String? uidFromResponse, bool showDialogAfterFetch = false}) async {
    final status =
        widget.serviceData?['status']?.toString().toLowerCase() ?? "";
    final uid = uidFromResponse ?? widget.serviceData?['uid']?.toString() ?? "";

    if (status == "done" || status == "verified" || uid.isNotEmpty) {
      if (mounted) {
        setState(() {
          _isFetchingDetails = true;
        });
      }
      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token') ?? "";
        if (token.isNotEmpty && uid.isNotEmpty) {
          final response =
              await ApiService().mediaCheckShow(token: token, uid: uid);
          if (response.statusCode == 200 || response.statusCode == 201) {
            final showResponse = MediaCheckShowResponseModel.fromJson(
                Map<String, dynamic>.from(response.data));
            if (showResponse.status == 200 && showResponse.data != null) {
              if (mounted) {
                setState(() {
                  _verifiedDetails = showResponse.data;
                  if (_verifiedDetails!.keyword != null) {
                    _keywordController.text = _verifiedDetails!.keyword!;
                  }
                });
              }

              if (showDialogAfterFetch &&
                  _verifiedDetails!.apiResponse != null &&
                  mounted) {
                _showReportsDialog(
                  context,
                  _verifiedDetails!.apiResponse!,
                  pdfUrl: _verifiedDetails!.pdfUrl,
                );
              }
            }
          }
        }
      } catch (e) {
        log("Error fetching media check details: $e");
      } finally {
        if (mounted) {
          setState(() {
            _isFetchingDetails = false;
          });
        }
      }
    }
  }

  String _stripHtml(String htmlString) {
    final RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '').replaceAll('&nbsp;', ' ').trim();
  }

  String _formatPubDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return "";
    try {
      final parts = rawDate.split(' ');
      if (parts.length >= 4) {
        final day = parts[1];
        final monthStr = parts[2];
        final year = parts[3];
        String month = monthStr;
        switch (monthStr.toLowerCase()) {
          case 'jan':
            month = 'January';
            break;
          case 'feb':
            month = 'February';
            break;
          case 'mar':
            month = 'March';
            break;
          case 'apr':
            month = 'April';
            break;
          case 'may':
            month = 'May';
            break;
          case 'jun':
            month = 'June';
            break;
          case 'jul':
            month = 'July';
            break;
          case 'aug':
            month = 'August';
            break;
          case 'sep':
            month = 'September';
            break;
          case 'oct':
            month = 'October';
            break;
          case 'nov':
            month = 'November';
            break;
          case 'dec':
            month = 'December';
            break;
        }
        return "$month $day, $year";
      }
    } catch (_) {}
    return rawDate;
  }

  Future<void> _launchURL(String urlString) async {
    try {
      // Try to launch specifically in Google Chrome using Chrome custom schemes
      String chromeUrl = urlString;
      if (urlString.startsWith('https://')) {
        chromeUrl = urlString.replaceFirst('https://', 'googlechromes://');
      } else if (urlString.startsWith('http://')) {
        chromeUrl = urlString.replaceFirst('http://', 'googlechrome://');
      }

      final Uri chromeUri = Uri.parse(chromeUrl);
      if (await canLaunchUrl(chromeUri)) {
        await launchUrl(chromeUri, mode: LaunchMode.externalApplication);
        return;
      }
    } catch (_) {
      // Ignore and fall through to standard launcher fallback
    }

    // Fallback: Launch in standard system default external browser
    final Uri standardUri = Uri.parse(urlString);
    try {
      if (!await launchUrl(standardUri, mode: LaunchMode.externalApplication)) {
        log('Could not launch $urlString');
      }
    } catch (e) {
      log('Error launching URL: $e');
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token') ?? "";
        final customerId = prefs.getString('id') ?? "";

        final requestId = widget.applicantData?['request_id']?.toString() ?? "";
        final serviceRequestId =
            widget.serviceData?['service_request_id']?.toString() ?? "";
        final serviceId = widget.serviceData?['service_id']?.toString() ?? "";
        final keyword = _keywordController.text.trim();

        if (token.isEmpty) {
          throw Exception(
              "Authentication token is missing. Please log in again.");
        }

        final apiService = ApiService();
        final response = await apiService.mediaCheckStore(
          token: token,
          requestId: requestId,
          serviceRequestId: serviceRequestId,
          customerId: customerId,
          serviceId: serviceId,
          keyword: keyword,
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          final resData = response.data;
          final responseModel = MediaCheckResponseModel.fromJson(
              Map<String, dynamic>.from(resData));
          final status = responseModel.status;
          if (status == 200) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(responseModel.message ??
                      "Media check verified successfully."),
                  backgroundColor: Colors.green,
                ),
              );
            }
            if (responseModel.uid != null) {
              await _checkAndFetchDetails(
                  uidFromResponse: responseModel.uid,
                  showDialogAfterFetch: true);
            }
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(responseModel.message ??
                      "Media check verification failed."),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Server error: ${response.statusCode}"),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error: ${e.toString()}"),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _showReportsDialog(BuildContext context, MediaCheckData mediaData,
      {String? pdfUrl}) {
    final newsList = mediaData.data ?? [];
    final credits = mediaData.credits ?? "N/A";
    final message = mediaData.message?.toUpperCase() ?? "VALID";
    final resolvedPdfUrl = pdfUrl ?? "";

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header row
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.collections_outlined,
                            color: Color(0xFFF4511E),
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Media Check Reports",
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF263238),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () => Navigator.pop(dialogContext),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Color(0xFFECEFF1), height: 1),

                // Content body
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        // Media Insights VALID Pill & Credits Row
                        Center(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Media ",
                                    style: GoogleFonts.outfit(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF263238),
                                    ),
                                  ),
                                  Text(
                                    "Insights",
                                    style: GoogleFonts.outfit(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFFF4511E),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8F5E9),
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                          color: const Color(0xFFA5D6A7)),
                                    ),
                                    child: Text(
                                      message,
                                      style: GoogleFonts.outfit(
                                        color: const Color(0xFF2E7D32),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.folder_open_outlined,
                                    size: 16,
                                    color: Color(0xFFFFB74D),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    "SYSTEM CREDITS: $credits",
                                    style: GoogleFonts.outfit(
                                      color: const Color(0xFF78909C),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                              if (resolvedPdfUrl.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                CustomButton(
                                  text: "Download Report PDF",
                                  width: 200,
                                  height: 38,
                                  prefixIcon: Icons.picture_as_pdf,
                                  iconSize: 16,
                                  gradientColors: const [
                                    Color(0xFF37474F),
                                    Color(0xFF546E7A),
                                  ],
                                  onTap: () {
                                    _launchURL(resolvedPdfUrl);
                                  },
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),

                        // List of news reports
                        if (newsList.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40.0),
                            child: Text(
                              "No media matches found.",
                              style: GoogleFonts.outfit(
                                color: Colors.grey.shade500,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        else
                          ...newsList
                              .map((item) => _buildNewsCard(context, item)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNewsCard(BuildContext context, MediaNewsItem item) {
    final title = item.title ?? "";
    final link = item.link ?? "";
    final pubDate = _formatPubDate(item.pubDate);
    final description = _stripHtml(item.description ?? "");
    final source = item.source?.t ?? "News Source";

    final sourceInitial = source.isNotEmpty ? source[0].toUpperCase() : "N";

    final int sourceHash = source.hashCode;
    final List<Color> gradientColors = [
      HSLColor.fromAHSL(1.0, (sourceHash % 360).toDouble(), 0.8, 0.9).toColor(),
      HSLColor.fromAHSL(1.0, ((sourceHash + 30) % 360).toDouble(), 0.8, 0.95)
          .toColor(),
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFECEFF1), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left Part: Thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Container(
                width: 130,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned(
                      right: -10,
                      bottom: -10,
                      child: Icon(
                        Icons.newspaper_outlined,
                        size: 80,
                        color: Colors.white.withOpacity(0.4),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      left: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4511E),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          source.toUpperCase(),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Right Part: Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Date
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 13,
                          color: Color(0xFFF4511E),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          pubDate,
                          style: GoogleFonts.outfit(
                            color: const Color(0xFFF4511E),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Title
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF263238),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Description
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Bottom Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 11,
                                backgroundColor: HSLColor.fromAHSL(1.0,
                                        (sourceHash % 360).toDouble(), 0.7, 0.4)
                                    .toColor()
                                    .withOpacity(0.1),
                                child: Text(
                                  sourceInitial,
                                  style: GoogleFonts.outfit(
                                    color: HSLColor.fromAHSL(
                                            1.0,
                                            (sourceHash % 360).toDouble(),
                                            0.7,
                                            0.4)
                                        .toColor(),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  source.toUpperCase(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.outfit(
                                    color: const Color(0xFF546E7A),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Read More
                        InkWell(
                          onTap: () {
                            if (link.isNotEmpty) {
                              _launchURL(link);
                            }
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "READ MORE",
                                style: GoogleFonts.outfit(
                                  color: const Color(0xFFF4511E),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 10,
                                color: Color(0xFFF4511E),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isFetchingDetails) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF4511E)),
          ),
        ),
      );
    }

    String currentStatus = _verifiedDetails?.status ??
        widget.serviceData?['status']?.toString() ??
        "PENDING";
    bool isVerified = currentStatus.toLowerCase() == "verified" ||
        currentStatus.toLowerCase() == "done";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  const Icon(Icons.perm_media_outlined,
                      color: Color(0xFFFFB74D), size: 28),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      widget.serviceTitle ?? "Media Check",
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF263238),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            StatusChip(
              status: currentStatus.isNotEmpty
                  ? '${currentStatus[0].toUpperCase()}${currentStatus.substring(1).toLowerCase()}'
                  : "Pending",
            ),
          ],
        ),
        const SizedBox(height: 24),
        if (isVerified) ...[
          Form(
            key: _formKey,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: form_widget(
                    controller: _keywordController,
                    titleText: "Search Media",
                    hintText: "Enter keyword...",
                    textInputType: TextInputType.text,
                    isReadOnly: true,
                  ),
                ),
                const SizedBox(width: 16),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: InkWell(
                    onTap: _isDownloadingPdf
                        ? null
                        : () {
                            final pdfUrl = _verifiedDetails?.pdfUrl ?? "";
                            if (pdfUrl.isNotEmpty) {
                              setState(() {
                                _isDownloadingPdf = true;
                                _downloadProgress = 0;
                              });

                              String fileName = "Media_Check_Report";
                              try {
                                final uri = Uri.parse(pdfUrl);
                                final pathParam = uri.queryParameters['path'];
                                if (pathParam != null &&
                                    pathParam.contains('/')) {
                                  final fileSegment = pathParam.split('/').last;
                                  if (fileSegment.contains('.')) {
                                    fileName = fileSegment.split('.').first;
                                  } else {
                                    fileName = fileSegment;
                                  }
                                }
                              } catch (_) {}

                              FileDownloader.downloadFile(
                                notificationType: NotificationType.disabled,
                                url: pdfUrl,
                                name: fileName,
                                onProgress: (fileName, progress) {
                                  if (mounted) {
                                    setState(() {
                                      _downloadProgress = progress.round();
                                    });
                                  }
                                },
                                onDownloadCompleted: (path) {
                                  if (mounted) {
                                    setState(() {
                                      _isDownloadingPdf = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "File downloaded successfully!"),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                },
                                onDownloadError: (error) {
                                  if (mounted) {
                                    setState(() {
                                      _isDownloadingPdf = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text("Download failed: $error"),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                              );
                            }
                          },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F0FE),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_isDownloadingPdf)
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF1A73E8)),
                              ),
                            )
                          else
                            const Icon(
                              Icons.download,
                              color: Color(0xFF1A73E8),
                              size: 20,
                            ),
                          const SizedBox(width: 8),
                          Text(
                            _isDownloadingPdf
                                ? "Downloading..."
                                : "Download PDF",
                            style: GoogleFonts.outfit(
                              color: const Color(0xFF1A73E8),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_verifiedDetails?.apiResponse != null) ...[
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () {
                  if (_verifiedDetails?.apiResponse != null) {
                    _showReportsDialog(
                      context,
                      _verifiedDetails!.apiResponse!,
                      pdfUrl: _verifiedDetails!.pdfUrl,
                    );
                  }
                },
                icon: const Icon(Icons.insights,
                    color: Color(0xFFF4511E), size: 18),
                label: Text(
                  "View Media Insights & Matching Articles",
                  style: GoogleFonts.outfit(
                    color: const Color(0xFFF4511E),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ] else ...[
          Form(
            key: _formKey,
            child: form_widget(
              controller: _keywordController,
              titleText: "Search Media",
              hintText: "Enter keyword...",
              textInputType: TextInputType.text,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Please enter a keyword to search";
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomButton(
                  text: _isLoading ? "Searching..." : "Submit",
                  width: 140,
                  height: 48,
                  prefixIcon: _isLoading ? null : Icons.send,
                  iconSize: 18,
                  gradientColors: const [
                    Color(0xFFF4511E),
                    Color(0xFFFFB74D),
                  ],
                  onTap: _isLoading ? null : _submitForm,
                ),
                if (_isLoading)
                  const Positioned(
                    left: 12,
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
