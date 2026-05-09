import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/PanVerification/pan_verification_card.dart';
import 'widgets/AadhaarVerification/aadhaar_verification_card.dart';
import 'widgets/ReferenceCheck/reference_check_card.dart';
import 'widgets/LegalCheck/legal_check_card.dart';
import 'widgets/MediaCheck/media_check_card.dart';
import 'widgets/AddressVerification/address_verification_card.dart';
import 'widgets/EducationVerification/education_verification_card.dart';
import 'widgets/EmploymentVerification/employment_verification_card.dart';
import 'widgets/CreditHistory/credit_history_card.dart';
import 'widgets/DrivingLicense/driving_license_card.dart';
import 'widgets/BankAccount/bank_account_card.dart';
import 'widgets/CompanyFinancial/company_financial_card.dart';
import 'widgets/GstVerification/gst_verification_card.dart';
import 'widgets/ApplicantDetails/applicant_details_card.dart';

class FormListScreen extends StatefulWidget {
  final Map<String, dynamic>? applicantData;
  final String? serviceNavigate;
  final String? serviceTitle;

  const FormListScreen({
    super.key,
    this.applicantData,
    this.serviceNavigate,
    this.serviceTitle,
  });

  @override
  State<FormListScreen> createState() => _FormListScreenState();
}

class _FormListScreenState extends State<FormListScreen> {
  final TextEditingController panController = TextEditingController();
  final TextEditingController aadhaarController = TextEditingController();

  Widget _getServiceCard(String? navigate, String? title) {
    switch (navigate) {
      case "pan-card-verification":
        return PanVerificationCard(
            controller: panController, serviceTitle: title);
      case "aadhaar":
        return AadhaarDigilockerCard(
            controller: aadhaarController, serviceTitle: title);
      case "reference-check-verification":
        return ReferenceCheckCard(serviceTitle: title);
      case "court-legal-verification":
        return LegalCheckCard(serviceTitle: title);
      case "media-check":
        return MediaCheckCard(serviceTitle: title);
      case "address-verifcation":
        return AddressVerificationCard(serviceTitle: title);
      case "education-verification-list":
        return EducationVerificationCard(serviceTitle: title);
      case "employment-verification-list":
        return EmploymentVerificationCard(serviceTitle: title);
      case "credit-history":
        return CreditHistoryCard(serviceTitle: title);
      case "driving-licence-verification":
        return DrivingLicenseCard(serviceTitle: title);
      case "bank-check":
        return BankAccountCard(serviceTitle: title);
      case "gst-cin-pan-verification":
        return GstVerificationCard(serviceTitle: title);
      case "director":
        return CompanyFinancialCard(serviceTitle: title);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildSelectedForm() {
    final services = widget.applicantData?['services'] as List?;

    if (services == null || services.isEmpty) {
      // Fallback if no services data (optional)
      return const Center(child: Text("No services found"));
    }

    return Column(
      children: List.generate(services.length, (index) {
        final service = services[index];
        final navigate = service['service_navigate']?.toString();
        final title = service['service_title']?.toString();

        return Column(
          children: [
            _getServiceCard(navigate, title),
            if (index < services.length - 1) const CardDivider(),
          ],
        );
      }),
    );
  }

  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    // Delay rendering of heavy forms to ensure smooth navigation transition
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) {
        setState(() {
          _isLoaded = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final services = widget.applicantData?['services'] as List? ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.serviceTitle ?? "Verification Forms",
          style: GoogleFonts.outfit(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: !_isLoaded
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF6366F1), // Premium indigo color
              ),
            )
          : CustomScrollView(
              cacheExtent: 1500, // Pre-render forms before they appear
              slivers: [
                SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        if (widget.applicantData != null) ...[
                          ApplicantDetailsCard(data: widget.applicantData!),
                          const CardDivider(),
                        ],
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final service = services[index];
                        final navigate =
                            service['service_navigate']?.toString();
                        final title = service['service_title']?.toString();

                        return RepaintBoundary(
                          child: Column(
                            key: ValueKey(navigate ?? index.toString()),
                            children: [
                              _getServiceCard(navigate, title),
                              if (index < services.length - 1)
                                const CardDivider(),
                              if (index == services.length - 1)
                                const SizedBox(height: 40),
                            ],
                          ),
                        );
                      },
                      childCount: services.length,
                      addAutomaticKeepAlives: true,
                      addRepaintBoundaries: true,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class CardDivider extends StatelessWidget {
  const CardDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 30),
      child: Divider(color: Color(0xFFE0E0E0), thickness: 1),
    );
  }
}
