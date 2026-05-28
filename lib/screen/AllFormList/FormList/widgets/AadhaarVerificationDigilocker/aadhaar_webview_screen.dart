import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../../apiServices/api_services.dart';
import 'bloc/aadhaar_verify_cubit.dart';
import 'bloc/aadhaar_verify_state.dart';

class AadhaarWebviewScreen extends StatefulWidget {
  final String url;
  final String token;
  final int requestId;
  final int serviceRequestId;
  final int customerId;
  final String aadhaarNumber;
  final String unifiedTransactionId;
  final int serviceId;

  const AadhaarWebviewScreen({
    super.key,
    required this.url,
    required this.token,
    required this.requestId,
    required this.serviceRequestId,
    required this.customerId,
    required this.aadhaarNumber,
    required this.unifiedTransactionId,
    required this.serviceId,
  });

  @override
  State<AadhaarWebviewScreen> createState() => _AadhaarWebviewScreenState();
}

class _AadhaarWebviewScreenState extends State<AadhaarWebviewScreen> {
  late final WebViewController _webViewController;
  bool _isLoading = true;
  late final AadhaarVerifyCubit _verifyCubit;

  @override
  void initState() {
    super.initState();
    _verifyCubit = AadhaarVerifyCubit(ApiService());
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Can be used for progress bar if needed
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
            _checkUrlForVerification(url);
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint("WebView resource error: ${error.description}");
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  void _checkUrlForVerification(String url) {
    final lowerUrl = url.toLowerCase();
    // Digitap / Digilocker redirection URL success pattern matching
    if (lowerUrl.contains("success") ||
        lowerUrl.contains("complete") ||
        lowerUrl.contains("approved") ||
        lowerUrl.contains("verified") ||
        lowerUrl.contains("callback")) {
      _triggerVerification();
    }
  }

  void _triggerVerification() {
    if (_verifyCubit.state is AadhaarVerifyLoadingState ||
        _verifyCubit.state is AadhaarVerifySuccessState) return;

    // Introduce a 1.5-second delay to allow the server-to-server transaction status propagation to complete
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      if (_verifyCubit.state is AadhaarVerifyLoadingState ||
          _verifyCubit.state is AadhaarVerifySuccessState) return;

      _verifyCubit.verifyAadhaar(
        token: widget.token,
        request_id: widget.requestId,
        service_request_id: widget.serviceRequestId,
        customer_id: widget.customerId,
        aadhaar_number: widget.aadhaarNumber,
        status: "success",
        unifiedTransactionId: widget.unifiedTransactionId,
        service_id: widget.serviceId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _verifyCubit,
      child: BlocConsumer<AadhaarVerifyCubit, AadhaarVerifyState>(
        listener: (context, state) {
          if (state is AadhaarVerifySuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.responseData['message'] ??
                      "Aadhaar verification completed successfully!",
                  style: GoogleFonts.outfit(),
                ),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true); // Return success to parent
          } else if (state is AadhaarVerifyErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message, style: GoogleFonts.outfit()),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        builder: (context, state) {
          final isVerifying = state is AadhaarVerifyLoadingState;

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF263238)),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                "Aadhaar Digilocker Verification",
                style: GoogleFonts.outfit(
                  color: const Color(0xFF263238),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh, color: Color(0xFF263238)),
                  onPressed: () => _webViewController.reload(),
                ),
              ],
            ),
            body: Stack(
              children: [
                WebViewWidget(controller: _webViewController),
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFF4511E),
                    ),
                  ),
                if (isVerifying)
                  Container(
                    color: Colors.black.withOpacity(0.6),
                    child: Center(
                      child: Card(
                        margin: const EdgeInsets.symmetric(horizontal: 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 32),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CircularProgressIndicator(
                                color: Color(0xFFF4511E),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                "Finalizing Verification...",
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF263238),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Please wait while we confirm your Aadhaar status.",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
