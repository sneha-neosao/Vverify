import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/screen/VerificationForms/common/form_widget.dart';
import 'package:v_verify/screen/AllFormList/FormList/widgets/common_widgets.dart';

class PoliceVerificationMumbai extends StatefulWidget {
  final String? serviceTitle;
  const PoliceVerificationMumbai({super.key, this.serviceTitle});

  @override
  State<PoliceVerificationMumbai> createState() =>
      _PoliceVerificationMumbaiState();
}

class _PoliceVerificationMumbaiState extends State<PoliceVerificationMumbai> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 5;

  // Global Key for form validation
  final List<GlobalKey<FormState>> _formKeys =
      List.generate(5, (index) => GlobalKey<FormState>());

  // Step 1 Controllers
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _ownerMobileController = TextEditingController();
  final TextEditingController _ownerEmailController = TextEditingController();
  final TextEditingController _ownerAddressController = TextEditingController();
  final TextEditingController _ownerPincodeController = TextEditingController();
  String? _isForMumbai;
  String? _ownerCity;
  String? _policeStation;
  String? _ownerState;

  // Step 2 Controllers
  final TextEditingController _rentedAddressController =
      TextEditingController();
  final TextEditingController _rentedCityController = TextEditingController();
  final TextEditingController _rentedStateController = TextEditingController();
  final TextEditingController _rentedPincodeController =
      TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  // Step 3 Controllers
  final TextEditingController _tenantNameController = TextEditingController();
  final TextEditingController _tenantAddressController =
      TextEditingController();
  final TextEditingController _tenantCityController = TextEditingController();
  final TextEditingController _tenantStateController = TextEditingController();
  final TextEditingController _tenantPincodeController =
      TextEditingController();
  final TextEditingController _tenantIdNumberController =
      TextEditingController();
  final TextEditingController _coResidentMaleController =
      TextEditingController();
  final TextEditingController _coResidentFemaleController =
      TextEditingController();
  final TextEditingController _coResidentChildrenController =
      TextEditingController();
  String? _tenantIdType;

  // Step 4 Controllers
  final TextEditingController _tenantWorkMobileController =
      TextEditingController();
  final TextEditingController _tenantWorkEmailController =
      TextEditingController();
  final TextEditingController _tenantOccupationController =
      TextEditingController();
  final TextEditingController _tenantWorkAddressController =
      TextEditingController();
  final TextEditingController _tenantWorkCityController =
      TextEditingController();
  final TextEditingController _tenantWorkStateController =
      TextEditingController();
  final TextEditingController _tenantWorkPincodeController =
      TextEditingController();

  // Step 5 Controllers
  final TextEditingController _person1NameController = TextEditingController();
  final TextEditingController _person1ContactController =
      TextEditingController();
  final TextEditingController _person2NameController = TextEditingController();
  final TextEditingController _person2ContactController =
      TextEditingController();
  final TextEditingController _agentNameController = TextEditingController();
  final TextEditingController _agentDetailsController = TextEditingController();

  void _nextStep() {
    if (_formKeys[_currentStep].currentState?.validate() ?? true) {
      if (_currentStep < _totalSteps - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildStepProgress(),
              const SizedBox(height: 24),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      _currentStep = index;
                    });
                  },
                  children: [
                    _OwnerDetailsStep(
                      formKey: _formKeys[0],
                      ownerNameController: _ownerNameController,
                      ownerMobileController: _ownerMobileController,
                      ownerEmailController: _ownerEmailController,
                      ownerAddressController: _ownerAddressController,
                      ownerPincodeController: _ownerPincodeController,
                      isForMumbai: _isForMumbai,
                      ownerCity: _ownerCity,
                      policeStation: _policeStation,
                      ownerState: _ownerState,
                      onMumbaiChanged: (val) =>
                          setState(() => _isForMumbai = val),
                      onCityChanged: (val) => setState(() => _ownerCity = val),
                      onPoliceChanged: (val) =>
                          setState(() => _policeStation = val),
                      onStateChanged: (val) =>
                          setState(() => _ownerState = val),
                    ),
                    _RentedPropertyStep(
                      formKey: _formKeys[1],
                      addressController: _rentedAddressController,
                      cityController: _rentedCityController,
                      stateController: _rentedStateController,
                      pincodeController: _rentedPincodeController,
                      startDateController: _startDateController,
                      endDateController: _endDateController,
                    ),
                    _TenantDetailsStep(
                      formKey: _formKeys[2],
                      nameController: _tenantNameController,
                      addressController: _tenantAddressController,
                      cityController: _tenantCityController,
                      stateController: _tenantStateController,
                      pincodeController: _tenantPincodeController,
                      idNumberController: _tenantIdNumberController,
                      idType: _tenantIdType,
                      onIdTypeChanged: (val) =>
                          setState(() => _tenantIdType = val),
                      maleController: _coResidentMaleController,
                      femaleController: _coResidentFemaleController,
                      childrenController: _coResidentChildrenController,
                    ),
                    _TenantWorkplaceStep(
                      formKey: _formKeys[3],
                      mobileController: _tenantWorkMobileController,
                      emailController: _tenantWorkEmailController,
                      occupationController: _tenantOccupationController,
                      addressController: _tenantWorkAddressController,
                      cityController: _tenantWorkCityController,
                      stateController: _tenantWorkStateController,
                      pincodeController: _tenantWorkPincodeController,
                    ),
                    _ReferencesStep(
                      formKey: _formKeys[4],
                      p1Name: _person1NameController,
                      p1Contact: _person1ContactController,
                      p2Name: _person2NameController,
                      p2Contact: _person2ContactController,
                      agentName: _agentNameController,
                      agentDetails: _agentDetailsController,
                    ),
                  ],
                ),
              ),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.serviceTitle ?? "Police Verification Mumbai",
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColorLight,
                ),
              ),
              Text(
                "Step ${_currentStep + 1} of $_totalSteps",
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        // const StatusChip(status: "PENDING"),
      ],
    );
  }

  Widget _buildStepProgress() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: List.generate(_totalSteps, (index) {
          bool isCompleted = index < _currentStep;
          bool isCurrent = index == _currentStep;
          bool isLast = index == _totalSteps - 1;

          return Expanded(
            flex: isLast ? 0 : 1,
            child: Row(
              children: [
                // Step Circle
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted || isCurrent
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade200,
                    border: Border.all(
                      color: isCurrent
                          ? Theme.of(context).primaryColorLight
                          : (isCompleted
                              ? Theme.of(context).primaryColor
                              : Colors.grey.shade300),
                      width: 2,
                    ),
                    boxShadow: isCurrent
                        ? [
                            BoxShadow(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            )
                          ]
                        : null,
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check, color: Colors.white, size: 18)
                        : Text(
                            "${index + 1}",
                            style: GoogleFonts.outfit(
                              color: isCompleted || isCurrent
                                  ? Colors.white
                                  : Colors.grey.shade600,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                  ),
                ),
                // Connecting Line
                if (!isLast)
                  Expanded(
                    child: Container(
                      height: 3,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? Theme.of(context).primaryColor
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          if (_currentStep > 0) ...[
            Expanded(
              child: CustomButton(
                text: "Back",
                onTap: _previousStep,
                gradientColors: const [Colors.white, Colors.white],
                textStyle: GoogleFonts.outfit(
                    color: Colors.grey.shade700, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            flex: 2,
            child: CustomButton(
              text: _currentStep == _totalSteps - 1
                  ? "Submit Verification"
                  : "Continue",
              prefixIcon: _currentStep == _totalSteps - 1
                  ? Icons.check_circle_outline
                  : Icons.arrow_forward_rounded,
              onTap: () {
                if (_currentStep == _totalSteps - 1) {
                  // Final submission logic
                } else {
                  _nextStep();
                }
              },
              gradientColors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColorLight
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Step 1: Owner Details ──────────────────────────────────────────
class _OwnerDetailsStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController ownerNameController;
  final TextEditingController ownerMobileController;
  final TextEditingController ownerEmailController;
  final TextEditingController ownerAddressController;
  final TextEditingController ownerPincodeController;
  final String? isForMumbai;
  final String? ownerCity;
  final String? policeStation;
  final String? ownerState;
  final Function(String?) onMumbaiChanged;
  final Function(String?) onCityChanged;
  final Function(String?) onPoliceChanged;
  final Function(String?) onStateChanged;

  const _OwnerDetailsStep({
    required this.formKey,
    required this.ownerNameController,
    required this.ownerMobileController,
    required this.ownerEmailController,
    required this.ownerAddressController,
    required this.ownerPincodeController,
    this.isForMumbai,
    this.ownerCity,
    this.policeStation,
    this.ownerState,
    required this.onMumbaiChanged,
    required this.onCityChanged,
    required this.onPoliceChanged,
    required this.onStateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(context, "Property Owner Information",
                Icons.person_pin_circle_outlined),
            FormDropdownWidget(
              titleText: "For Mumbai",
              hintText: "Select Yes/No",
              items: const ["Yes", "No"],
              value: isForMumbai,
              onChanged: onMumbaiChanged,
            ),
            FormDropdownWidget(
              titleText: "City",
              hintText: "Select City",
              items: const ["Mumbai", "Thane", "Navi Mumbai", "Pune"],
              value: ownerCity,
              onChanged: onCityChanged,
            ),
            FormDropdownWidget(
              titleText: "Police Station",
              hintText: "Select Police Station",
              items: const [
                "Wakad Police Station",
                "Andheri Police Station",
                "Borivali Police Station"
              ],
              value: policeStation,
              onChanged: onPoliceChanged,
            ),
            form_widget(
              controller: ownerNameController,
              titleText: "Full Name",
              hintText: "As per ID Proof",
              textInputType: TextInputType.name,
            ),
            form_widget(
              controller: ownerMobileController,
              titleText: "Mobile Number",
              hintText: "10-digit mobile number",
              textInputType: TextInputType.phone,
            ),
            form_widget(
              controller: ownerEmailController,
              titleText: "Email Address",
              hintText: "example@mail.com",
              textInputType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            _fileUploadLabel("Owner Photo"),
            BrowseFileButton(onFilePicked: (file) {}),
            form_widget(
              controller: ownerAddressController,
              titleText: "Address",
              hintText: "Permanent Address",
              textInputType: TextInputType.streetAddress,
            ),
            form_widget(
              controller: ownerPincodeController,
              titleText: "Pincode",
              hintText: "6-digit pincode",
              textInputType: TextInputType.number,
            ),
            FormDropdownWidget(
              titleText: "State",
              hintText: "Select State",
              items: const ["Maharashtra", "Gujarat", "Karnataka"],
              value: ownerState,
              onChanged: onStateChanged,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Step 2: Rented Property Details ──────────────────────────────────
class _RentedPropertyStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController addressController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController pincodeController;
  final TextEditingController startDateController;
  final TextEditingController endDateController;

  const _RentedPropertyStep({
    required this.formKey,
    required this.addressController,
    required this.cityController,
    required this.stateController,
    required this.pincodeController,
    required this.startDateController,
    required this.endDateController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(context, "Rented Property Information",
                Icons.home_work_outlined),
            form_widget(
              controller: addressController,
              titleText: "Property Address",
              hintText: "Full address of rented property",
              textInputType: TextInputType.streetAddress,
            ),
            form_widget(
              controller: cityController,
              titleText: "City / District",
              hintText: "City name",
              textInputType: TextInputType.text,
            ),
            form_widget(
              controller: stateController,
              titleText: "State",
              hintText: "State name",
              textInputType: TextInputType.text,
            ),
            form_widget(
              controller: pincodeController,
              titleText: "Pincode",
              hintText: "Area pincode",
              textInputType: TextInputType.number,
            ),
            FormDateWidget(
              titleText: "Agreement Start Date",
              hintText: "Select Date",
              controller: startDateController,
              onTap: () => _selectDate(context, startDateController),
            ),
            FormDateWidget(
              titleText: "Agreement End Date",
              hintText: "Select Date",
              controller: endDateController,
              onTap: () => _selectDate(context, endDateController),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Step 3: Tenant Details ──────────────────────────────────────────
class _TenantDetailsStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController addressController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController pincodeController;
  final TextEditingController idNumberController;
  final String? idType;
  final Function(String?) onIdTypeChanged;
  final TextEditingController maleController;
  final TextEditingController femaleController;
  final TextEditingController childrenController;

  const _TenantDetailsStep({
    required this.formKey,
    required this.nameController,
    required this.addressController,
    required this.cityController,
    required this.stateController,
    required this.pincodeController,
    required this.idNumberController,
    this.idType,
    required this.onIdTypeChanged,
    required this.maleController,
    required this.femaleController,
    required this.childrenController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(context, "Tenant Personal Information",
                Icons.person_outline_rounded),
            form_widget(
              controller: nameController,
              titleText: "Tenant Name",
              hintText: "Full Name",
              textInputType: TextInputType.name,
            ),
            form_widget(
              controller: addressController,
              titleText: "Permanent Address",
              hintText: "Native/Permanent Address",
              textInputType: TextInputType.streetAddress,
            ),
            form_widget(
              controller: cityController,
              titleText: "City",
              hintText: "City name",
              textInputType: TextInputType.text,
            ),
            form_widget(
              controller: stateController,
              titleText: "State",
              hintText: "State name",
              textInputType: TextInputType.text,
            ),
            form_widget(
              controller: pincodeController,
              titleText: "Postal Code",
              hintText: "Pincode",
              textInputType: TextInputType.number,
            ),
            FormDropdownWidget(
              titleText: "Identity Proof Type",
              hintText: "Select ID Document",
              items: const ["Aadhaar", "PAN Card", "Voter ID", "Passport"],
              value: idType,
              onChanged: onIdTypeChanged,
            ),
            form_widget(
              controller: idNumberController,
              titleText: "ID Number",
              hintText: "Document Number",
              textInputType: TextInputType.text,
            ),
            const SizedBox(height: 16),
            _fileUploadLabel("Tenant Photo"),
            BrowseFileButton(onFilePicked: (file) {}),
            const SizedBox(height: 16),
            _fileUploadLabel("ID Proof Document"),
            BrowseFileButton(onFilePicked: (file) {}),
            const SizedBox(height: 24),
            _sectionHeader(
                context, "Co-Resident Details", Icons.people_outline),
            Row(
              children: [
                Expanded(
                  child: form_widget(
                    controller: maleController,
                    titleText: "Male",
                    hintText: "Count",
                    textInputType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: form_widget(
                    controller: femaleController,
                    titleText: "Female",
                    hintText: "Count",
                    textInputType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: form_widget(
                    controller: childrenController,
                    titleText: "Children",
                    hintText: "Count",
                    textInputType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Step 4: Tenant Workplace ────────────────────────────────────────
class _TenantWorkplaceStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController mobileController;
  final TextEditingController emailController;
  final TextEditingController occupationController;
  final TextEditingController addressController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController pincodeController;

  const _TenantWorkplaceStep({
    required this.formKey,
    required this.mobileController,
    required this.emailController,
    required this.occupationController,
    required this.addressController,
    required this.cityController,
    required this.stateController,
    required this.pincodeController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(context, "Workplace Information",
                Icons.business_center_outlined),
            form_widget(
              controller: mobileController,
              titleText: "Work Mobile",
              hintText: "Work contact number",
              textInputType: TextInputType.phone,
            ),
            form_widget(
              controller: emailController,
              titleText: "Work Email",
              hintText: "Official email address",
              textInputType: TextInputType.emailAddress,
            ),
            form_widget(
              controller: occupationController,
              titleText: "Occupation",
              hintText: "Job title/Nature of work",
              textInputType: TextInputType.text,
            ),
            form_widget(
              controller: addressController,
              titleText: "Workplace Address",
              hintText: "Full office address",
              textInputType: TextInputType.streetAddress,
            ),
            form_widget(
              controller: cityController,
              titleText: "City",
              hintText: "Workplace city",
              textInputType: TextInputType.text,
            ),
            form_widget(
              controller: stateController,
              titleText: "State",
              hintText: "Workplace state",
              textInputType: TextInputType.text,
            ),
            form_widget(
              controller: pincodeController,
              titleText: "Postal Code",
              hintText: "Workplace pincode",
              textInputType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Step 5: References & Agent ──────────────────────────────────────
class _ReferencesStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController p1Name;
  final TextEditingController p1Contact;
  final TextEditingController p2Name;
  final TextEditingController p2Contact;
  final TextEditingController agentName;
  final TextEditingController agentDetails;

  const _ReferencesStep({
    required this.formKey,
    required this.p1Name,
    required this.p1Contact,
    required this.p2Name,
    required this.p2Contact,
    required this.agentName,
    required this.agentDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(
                context, "Reference 1", Icons.record_voice_over_outlined),
            form_widget(
              controller: p1Name,
              titleText: "Name",
              hintText: "Person who knows tenant",
              textInputType: TextInputType.name,
            ),
            form_widget(
              controller: p1Contact,
              titleText: "Contact Number",
              hintText: "10-digit number",
              textInputType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            _sectionHeader(
                context, "Reference 2", Icons.record_voice_over_outlined),
            form_widget(
              controller: p2Name,
              titleText: "Name",
              hintText: "Another person who knows tenant",
              textInputType: TextInputType.name,
            ),
            form_widget(
              controller: p2Contact,
              titleText: "Contact Number",
              hintText: "10-digit number",
              textInputType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            _sectionHeader(
                context, "Agent Information", Icons.support_agent_outlined),
            form_widget(
              controller: agentName,
              titleText: "Agent Name",
              hintText: "If any agent involved",
              textInputType: TextInputType.name,
            ),
            form_widget(
              controller: agentDetails,
              titleText: "Agent Details",
              hintText: "Agency name or ID",
              textInputType: TextInputType.text,
            ),
            const SizedBox(height: 20),
            _fileUploadLabel("Tenant Signature"),
            BrowseFileButton(onFilePicked: (file) {}),
          ],
        ),
      ),
    );
  }
}

// ── Common Helpers ──────────────────────────────────────────────────
Widget _sectionHeader(BuildContext context, String title, IconData icon) {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
    child: Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).primaryColorLight),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColorLight,
          ),
        ),
      ],
    ),
  );
}

Widget _fileUploadLabel(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: RichText(
      text: TextSpan(
        text: text,
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
  );
}

Future<void> _selectDate(
    BuildContext context, TextEditingController controller) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: Theme.of(context).primaryColor,
            onPrimary: Colors.white,
            onSurface: Colors.black,
          ),
        ),
        child: child!,
      );
    },
  );
  if (picked != null) {
    controller.text = "${picked.toLocal()}".split(' ')[0];
  }
}
