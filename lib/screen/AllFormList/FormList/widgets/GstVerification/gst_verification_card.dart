import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../commonComponent/custom_button.dart';
import '../../../../VerificationForms/common/form_widget.dart';
import '../common_widgets.dart';
import 'bloc/gst_verification_cubit.dart';
import 'bloc/gst_verification_state.dart';
import 'bloc/gst_verification_show_cubit.dart';
import 'bloc/gst_verification_show_state.dart';
import '../../../../../apiServices/api_services.dart';
import '../../../../VerificationPending/bloc/pendingDoc_cubit.dart';
import '../../../../VerificationPending/Pagination/DashBoard/bloc/pending_doc_navigation_cubit.dart';
import '../../../../../commonComponent/bloc/shared_preferences_cubit.dart';

class GstVerificationCard extends StatefulWidget {
  final String? serviceTitle;
  final Map<String, dynamic>? serviceData;
  final Map<String, dynamic>? applicantData;

  const GstVerificationCard({
    super.key,
    this.serviceTitle,
    this.serviceData,
    this.applicantData,
  });

  @override
  State<GstVerificationCard> createState() => _GstVerificationCardState();
}

class _GstVerificationCardState extends State<GstVerificationCard> {
  final TextEditingController _gstController = TextEditingController();
  late final GstVerificationCubit _gstCubit;
  late final GstVerificationShowCubit _showDetailsCubit;

  final bool _isSubmitting = false;
  bool _isReadOnly = false;

  @override
  void initState() {
    super.initState();
    _gstCubit = GstVerificationCubit(ApiService());
    _showDetailsCubit = GstVerificationShowCubit(ApiService());
    _checkAndFetchDetails();
  }

  @override
  void dispose() {
    _gstController.dispose();
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
        _showDetailsCubit.fetchGstDetails(token: token, uid: uid);
        setState(() {
          _isReadOnly = true;
        });
      }
    }
  }

  void _populateData(Map<String, dynamic> responseData) {
    final docNum = responseData['data']?['document_number']?.toString();
    if (docNum != null && docNum.isNotEmpty) {
      _gstController.text = docNum;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => _gstCubit),
        BlocProvider(create: (context) => _showDetailsCubit),
      ],
      child: BlocListener<GstVerificationCubit, GstVerificationState>(
        listener: (context, state) {
          if (state is GstVerificationSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("GST Verification Submitted Successfully!"),
                backgroundColor: Colors.green,
              ),
            );
            _checkAndFetchDetails(force: true, uidFromResponse: state.uid);

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
          } else if (state is GstVerificationFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: Colors.red),
            );
          }
        },
        child: BlocConsumer<GstVerificationShowCubit, GstVerificationShowState>(
          listener: (context, showState) {
            if (showState is GstVerificationShowSuccessState) {
              _populateData(showState.responseData);
            }
          },
          builder: (context, showState) {
            if (showState is GstVerificationShowLoadingState) {
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
            if (showState is GstVerificationShowSuccessState) {
              currentStatus =
                  showState.responseData['data']?['status']?.toString() ??
                      currentStatus;
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
                          const Icon(Icons.business_outlined,
                              color: Color(0xFFFFB74D), size: 28),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              widget.serviceTitle ?? "GST Verification",
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
                if (showState is GstVerificationShowSuccessState &&
                    showState.responseData['data']?['reason'] != null &&
                    showState.responseData['data']!['reason']!
                        .toString()
                        .isNotEmpty)
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
                          "${showState.responseData['data']!['reason']}",
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
                const SizedBox(height: 24),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final double width = constraints.maxWidth;
                    final bool isTablet = width > 600;

                    return Row(
                      children: [
                        SizedBox(
                          width: isTablet ? width * 0.33 : width,
                          child: form_widget(
                            controller: _gstController,
                            titleText: "GST Number",
                            hintText: "e.g. 22AAAAA0000A1Z5",
                            textInputType: TextInputType.text,
                            isReadOnly: isVerified || _isReadOnly,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter GST Number";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
                if (!isVerified) ...[
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerRight,
                    child:
                        BlocBuilder<GstVerificationCubit, GstVerificationState>(
                      builder: (context, actionState) {
                        if (actionState is GstVerificationLoadingState) {
                          return const SizedBox(
                            width: 140,
                            height: 48,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFFF4511E),
                              ),
                            ),
                          );
                        }

                        return CustomButton(
                          text: "Submit",
                          width: 140,
                          height: 48,
                          prefixIcon: Icons.send,
                          iconSize: 18,
                          gradientColors: const [
                            Color(0xFFF4511E),
                            Color(0xFFFFB74D),
                          ],
                          onTap: () async {
                            final gst = _gstController.text.trim();
                            if (gst.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please enter GST number"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            final prefs = await SharedPreferences.getInstance();
                            final token = prefs.getString('token') ?? "";

                            final requestIdStr = widget
                                    .applicantData?['request_id']
                                    ?.toString() ??
                                "";
                            final serviceRequestIdStr = widget
                                    .serviceData?['service_request_id']
                                    ?.toString() ??
                                widget.serviceData?['id']?.toString() ??
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
                              context.read<GstVerificationCubit>().storeGst(
                                    token: token,
                                    requestId: int.tryParse(requestIdStr) ?? 0,
                                    serviceRequestId:
                                        int.tryParse(serviceRequestIdStr) ?? 0,
                                    customerId:
                                        int.tryParse(customerIdStr) ?? 0,
                                    gstNumber: gst,
                                  );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "Missing configuration parameters. Please login again."),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
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
