import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../commonComponent/custom_button.dart';
import '../../../../VerificationForms/common/form_widget.dart';
import '../common_widgets.dart';
import 'bloc/credit_history_cubit.dart';
import 'bloc/credit_history_state.dart';
import 'bloc/credit_history_show_cubit.dart';
import 'bloc/credit_history_show_state.dart';
import 'model/credit_report_show_model.dart';
import '../../../../../apiServices/api_services.dart';
import '../../../../../commonComponent/bloc/shared_preferences_cubit.dart';
import '../../../../VerificationPending/bloc/pendingDoc_cubit.dart';
import '../../../../VerificationPending/Pagination/DashBoard/bloc/pending_doc_navigation_cubit.dart';

class CreditHistoryCard extends StatefulWidget {
  final String? serviceTitle;
  final Map<String, dynamic>? serviceData;
  final Map<String, dynamic>? applicantData;

  const CreditHistoryCard({
    super.key,
    this.serviceTitle,
    this.serviceData,
    this.applicantData,
  });

  @override
  State<CreditHistoryCard> createState() => _CreditHistoryCardState();
}

class _CreditHistoryCardState extends State<CreditHistoryCard> {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  late final CreditHistoryCubit _creditCubit;
  late final CreditHistoryShowCubit _showDetailsCubit;

  bool _otpSent = false;
  final bool _isSubmitting = false;
  bool _isReadOnly = false;
  bool _isFormValid = false;

  Timer? _timer;
  int _secondsRemaining = 0;

  @override
  void initState() {
    super.initState();
    _creditCubit = CreditHistoryCubit(ApiService());
    _showDetailsCubit = CreditHistoryShowCubit(ApiService());

    // Pre-populate mobile number if available in applicant details
    final appMobile = widget.applicantData?['phone']?.toString();
    if (appMobile != null && appMobile.isNotEmpty) {
      _mobileController.text = appMobile;
    }

    _mobileController.addListener(_validateFields);
    _firstNameController.addListener(_validateFields);
    _lastNameController.addListener(_validateFields);
    _otpController.addListener(_validateFields);

    _checkAndFetchDetails();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _mobileController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _checkAndFetchDetails(
      {bool force = false, String? uidFromResponse}) async {
    final uid = uidFromResponse ?? widget.serviceData?['uid']?.toString() ?? "";

    if (force ||
        widget.applicantData?['details_updated'] == 1 ||
        widget.serviceData?['status'] == "verified" ||
        widget.serviceData?['status'] == "DONE" ||
        uid.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? "";

      if (uid.isNotEmpty && token.isNotEmpty) {
        _showDetailsCubit.fetchCreditDetails(token: token, uid: uid);
        setState(() {
          _isReadOnly = true;
        });
      }
    }
  }

  void _populateData(CreditReportShowModel model) {
    final data = model.data;
    if (data != null) {
      _mobileController.text = data.documentNumber ?? _mobileController.text;
    }
  }

  void _validateFields() {
    final isValid = _mobileController.text.trim().isNotEmpty &&
        _firstNameController.text.trim().isNotEmpty &&
        _lastNameController.text.trim().isNotEmpty &&
        _otpController.text.trim().length == 6;
    if (isValid != _isFormValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _secondsRemaining = 600; // 10 minutes countdown
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSecs = seconds % 60;
    return "$minutes:${remainingSecs.toString().padLeft(2, '0')}";
  }

  Widget _buildTimerBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEF9A9A).withOpacity(0.5)),
      ),
      child: Row(
        children: [
          const Text("⌛", style: TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.outfit(
                  color: const Color(0xFFC62828),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  const TextSpan(
                      text:
                          "You cannot try new OTP within 10 mins of previous OTP. Please wait "),
                  TextSpan(
                    text: _formatTime(_secondsRemaining),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => _creditCubit),
        BlocProvider(create: (context) => _showDetailsCubit),
      ],
      child: BlocListener<CreditHistoryCubit, CreditHistoryState>(
        listener: (context, state) {
          if (state is CreditHistoryOtpSuccessState) {
            setState(() {
              _otpSent = true;
            });
            _startTimer();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message), backgroundColor: Colors.green),
            );
          } else if (state is CreditHistoryOtpFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: Colors.red),
            );
          } else if (state is CreditHistoryStoreSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Credit Report Stored Successfully!"),
                backgroundColor: Colors.green,
              ),
            );
            _checkAndFetchDetails(force: true, uidFromResponse: state.uid);

            // Trigger SharedPreferences & Pending list refresh
            try {
              final token = context.read<TokenCubit>().state;
              final customerId = context.read<IdCubit>().state;
              final navState = context.read<PendingDocNavigationCubit>().state;

              context.read<PendingDocCubit>().getPendingDoc(
                    token: token,
                    customerId: int.tryParse(customerId) ?? 0,
                    page: 1,
                    limit: 100,
                    entityId: navState.entityId,
                    isLoading: false,
                  );
            } catch (e) {
              // Handle safely if parent cubes aren't loaded in test environments
            }
          } else if (state is CreditHistoryStoreFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: Colors.red),
            );
          }
        },
        child: BlocConsumer<CreditHistoryShowCubit, CreditHistoryShowState>(
          listener: (context, showState) {
            if (showState is CreditHistoryShowSuccessState) {
              _populateData(showState.model);
            }
          },
          builder: (context, showState) {
            if (showState is CreditHistoryShowLoadingState) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(
                    color: Color(0xFFF4511E),
                  ),
                ),
              );
            }

            String currentStatus =
                widget.serviceData?['status']?.toString() ?? "PENDING";
            if (showState is CreditHistoryShowSuccessState) {
              currentStatus = showState.model.data?.status ?? currentStatus;
            }

            if (currentStatus.trim().isEmpty || currentStatus == "-") {
              currentStatus = "PENDING";
            }

            final bool isVerified = currentStatus.toLowerCase() == "verified" ||
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
                          const Icon(Icons.fingerprint,
                              color: Color(0xFFFFB74D), size: 28),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              widget.serviceTitle ?? "Credit History",
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
                    if (isVerified)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFC8E6C9)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Color(0xFF2E7D32),
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "Verified",
                              style: GoogleFonts.outfit(
                                color: const Color(0xFF2E7D32),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      StatusChip(status: currentStatus),
                  ],
                ),
                if (showState is CreditHistoryShowSuccessState &&
                    showState.model.data?.reason != null &&
                    showState.model.data!.reason!.isNotEmpty)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 12),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: const Color(0xFFEF9A9A).withOpacity(0.5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.info_outline,
                                color: Color(0xFFD32F2F), size: 18),
                            const SizedBox(width: 8),
                            Text(
                              "Verification Remark",
                              style: GoogleFonts.outfit(
                                color: const Color(0xFFB71C1C),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${showState.model.data!.reason}",
                          style: GoogleFonts.outfit(
                            color: const Color(0xFFD32F2F).withOpacity(0.9),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (isVerified) ...[
                  const SizedBox(height: 24),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final double width = constraints.maxWidth;
                      final bool isTablet = width > 600;
                      final String mobileValue =
                          showState is CreditHistoryShowSuccessState
                              ? (showState.model.data?.documentNumber ??
                                  _mobileController.text)
                              : _mobileController.text;

                      return Row(
                        children: [
                          SizedBox(
                            width: isTablet ? width * 0.33 : width,
                            child: form_widget(
                              controller:
                                  TextEditingController(text: mobileValue),
                              titleText: "Mobile Number",
                              hintText: "8421007927",
                              textInputType: TextInputType.phone,
                              isReadOnly: true,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ] else ...[
                  const SizedBox(height: 24),
                  if (_secondsRemaining > 0) ...[
                    _buildTimerBanner(),
                    const SizedBox(height: 20),
                  ],
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final double width = constraints.maxWidth;
                      final bool isTablet = width > 600;

                      if (isTablet) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: form_widget(
                                    controller: _mobileController,
                                    titleText: "Mobile Number",
                                    hintText: "8421007927",
                                    textInputType: TextInputType.phone,
                                    isReadOnly: _otpSent || _isReadOnly,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Enter mobile number";
                                      }
                                      if (value.length != 10) {
                                        return "Mobile number must be 10 digits";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                if (_otpSent) ...[
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: form_widget(
                                      controller: _firstNameController,
                                      titleText: "First Name",
                                      hintText: "Enter First Name",
                                      textInputType: TextInputType.name,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Enter first name";
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: form_widget(
                                      controller: _lastNameController,
                                      titleText: "Last Name",
                                      hintText: "Enter Last Name",
                                      textInputType: TextInputType.name,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Enter last name";
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            if (_otpSent) ...[
                              const SizedBox(height: 20),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: form_widget(
                                      controller: _otpController,
                                      titleText: "OTP",
                                      hintText: "Enter 6-digit OTP",
                                      textInputType: TextInputType.number,
                                      maskFormatter: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(6),
                                      ],
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Enter OTP";
                                        }
                                        if (value.length != 6) {
                                          return "OTP must be 6 digits";
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const Spacer(flex: 2),
                                ],
                              ),
                            ],
                          ],
                        );
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            form_widget(
                              controller: _mobileController,
                              titleText: "Mobile Number",
                              hintText: "8421007927",
                              textInputType: TextInputType.phone,
                              isReadOnly: _otpSent || _isReadOnly,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter mobile number";
                                }
                                if (value.length != 10) {
                                  return "Mobile number must be 10 digits";
                                }
                                return null;
                              },
                            ),
                            if (_otpSent) ...[
                              const SizedBox(height: 16),
                              form_widget(
                                controller: _firstNameController,
                                titleText: "First Name",
                                hintText: "Enter First Name",
                                textInputType: TextInputType.name,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Enter first name";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              form_widget(
                                controller: _lastNameController,
                                titleText: "Last Name",
                                hintText: "Enter Last Name",
                                textInputType: TextInputType.name,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Enter last name";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              form_widget(
                                controller: _otpController,
                                titleText: "OTP",
                                hintText: "Enter 6-digit OTP",
                                textInputType: TextInputType.number,
                                maskFormatter: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(6),
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Enter OTP";
                                  }
                                  if (value.length != 6) {
                                    return "OTP must be 6 digits";
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ],
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "* OTP will be sent to the registered mobile number",
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<CreditHistoryCubit, CreditHistoryState>(
                    builder: (context, actionState) {
                      final bool isOtpLoading =
                          actionState is CreditHistoryOtpLoadingState;
                      final bool isStoreLoading =
                          actionState is CreditHistoryStoreLoadingState;

                      if (isOtpLoading || isStoreLoading) {
                        return const Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: 140,
                            height: 48,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFFF4511E),
                              ),
                            ),
                          ),
                        );
                      }

                      if (_otpSent) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Resend OTP button
                            InkWell(
                              onTap: _secondsRemaining == 0
                                  ? () async {
                                      final mobile =
                                          _mobileController.text.trim();
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      final token =
                                          prefs.getString('token') ?? "";
                                      if (mobile.length == 10 &&
                                          token.isNotEmpty) {
                                        context
                                            .read<CreditHistoryCubit>()
                                            .sendOtp(
                                              token: token,
                                              mobileNumber: mobile,
                                            );
                                      }
                                    }
                                  : null,
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                height: 48,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  color: _secondsRemaining == 0
                                      ? Colors.white
                                      : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: _secondsRemaining == 0
                                        ? const Color(0xFFF4511E)
                                        : Colors.grey.shade300,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.send,
                                      color: _secondsRemaining == 0
                                          ? const Color(0xFFF4511E)
                                          : Colors.grey.shade400,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Resend OTP",
                                      style: GoogleFonts.outfit(
                                        color: _secondsRemaining == 0
                                            ? const Color(0xFFF4511E)
                                            : Colors.grey.shade400,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Verify & Submit Button
                            CustomButton(
                              text: "Verify & Submit",
                              width: 160,
                              height: 48,
                              prefixIcon: Icons.check_circle_outline,
                              iconSize: 18,
                              gradientColors: _isFormValid
                                  ? const [
                                      Color(0xFFF4511E),
                                      Color(0xFFFFB74D),
                                    ]
                                  : const [
                                      Color(0xFFB0BEC5),
                                      Color(0xFFCFD8DC),
                                    ],
                              onTap: _isFormValid
                                  ? () async {
                                      final mobile =
                                          _mobileController.text.trim();
                                      final firstName =
                                          _firstNameController.text.trim();
                                      final lastName =
                                          _lastNameController.text.trim();
                                      final otp = _otpController.text.trim();

                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      final token =
                                          prefs.getString('token') ?? "";

                                      final requestIdStr = widget
                                              .applicantData?['request_id']
                                              ?.toString() ??
                                          "";
                                      final serviceRequestIdStr = widget
                                              .serviceData?[
                                                  'service_request_id']
                                              ?.toString() ??
                                          widget.serviceData?['id']
                                              ?.toString() ??
                                          "";
                                      final customerIdStr = widget
                                              .applicantData?['customer_id']
                                              ?.toString() ??
                                          prefs.getString('customer_id') ??
                                          "";

                                      if (token.isNotEmpty &&
                                          requestIdStr.isNotEmpty &&
                                          serviceRequestIdStr.isNotEmpty &&
                                          customerIdStr.isNotEmpty) {
                                        context
                                            .read<CreditHistoryCubit>()
                                            .storeReport(
                                              token: token,
                                              requestId:
                                                  int.tryParse(requestIdStr) ??
                                                      0,
                                              serviceRequestId: int.tryParse(
                                                      serviceRequestIdStr) ??
                                                  0,
                                              customerId:
                                                  int.tryParse(customerIdStr) ??
                                                      0,
                                              firstName: firstName,
                                              lastName: lastName,
                                              mobileNumber: mobile,
                                              otp: otp,
                                            );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "Missing configuration parameters. Please login again."),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
                                  : () {},
                            ),
                          ],
                        );
                      }

                      return Align(
                        alignment: Alignment.centerRight,
                        child: CustomButton(
                          text: "Send OTP",
                          width: 140,
                          height: 48,
                          prefixIcon: Icons.send,
                          iconSize: 18,
                          gradientColors: const [
                            Color(0xFFF4511E),
                            Color(0xFFFFB74D),
                          ],
                          onTap: () async {
                            final mobile = _mobileController.text.trim();
                            if (mobile.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please enter mobile number"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            if (mobile.length != 10) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text("Mobile number must be 10 digits"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            final prefs = await SharedPreferences.getInstance();
                            final token = prefs.getString('token') ?? "";

                            if (token.isNotEmpty) {
                              context.read<CreditHistoryCubit>().sendOtp(
                                    token: token,
                                    mobileNumber: mobile,
                                  );
                            }
                          },
                        ),
                      );
                    },
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
