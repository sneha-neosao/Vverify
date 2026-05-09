import 'dart:async';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/screen/VerificationForms/common/form_widget.dart';
import 'package:v_verify/screen/VerificationPending/bloc/pendingDoc_cubit.dart';
import 'package:v_verify/screen/VerificationPending/bloc/pendingDoc_state.dart';
import 'package:v_verify/screen/VerificationPending/model/pendingDoc_model.dart';
import 'package:v_verify/screen/VerificationPending/bloc/verify_report_bloc/verify_request_report_cubit.dart';
import 'package:v_verify/screen/VerificationPending/bloc/verify_report_bloc/verify_request_report_state.dart';
import 'package:v_verify/screen/VerificationPending/verifyRequestUpdate/Bloc/verify_request_update_cubit.dart';
import 'package:v_verify/screen/VerificationPending/verifyRequestUpdate/Bloc/verify_request_update_state.dart';
import '../../../commonComponent/custom_button.dart';

class PendingDocPagination extends StatefulWidget {
  const PendingDocPagination({super.key});

  @override
  State<PendingDocPagination> createState() => _PendingDocPaginationState();
}

class _PendingDocPaginationState extends State<PendingDocPagination> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedGroup = "Select Group";
  final List<String> _groups = [
    "Select Group",
    "Company Check",
    "Personal Check"
  ];
  int _expandedIndex = -1;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        _fetchData();
      }
    });
    setState(() {});
  }

  Future<void> _fetchData({bool isLoading = true}) async {
    await context.read<TokenCubit>().getToken();
    await context.read<IdCubit>().getId();

    final token = context.read<TokenCubit>().state;
    final customerIdStr = context.read<IdCubit>().state;
    final customerId = int.tryParse(customerIdStr) ?? 0;

    int? groupId;
    if (_selectedGroup == "Company Check") {
      groupId = 1;
    } else if (_selectedGroup == "Personal Check") {
      groupId = 2;
    }

    if (mounted) {
      await context.read<PendingDocCubit>().getPendingDoc(
            token: token,
            customerId: customerId,
            page: 1,
            limit: 100,
            groupId: groupId,
            search: _searchController.text.isNotEmpty
                ? _searchController.text
                : null,
            isLoading: isLoading,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: BlocListener<VerifyRequestReportCubit, VerifyRequestReportState>(
          listener: (context, state) {
            if (state is VerifyRequestReportLoadingState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Downloading Report...")),
              );
            } else if (state is VerifyRequestReportDownloadedState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text("Report downloaded to: ${state.filePath}")),
              );
            } else if (state is VerifyRequestReportErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error: ${state.message}")),
              );
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Verification List",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Theme.of(context).primaryColorLight)),
              ),
              // ── Search and Filter Header ──
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _searchController,
                        textAlign: TextAlign.center,
                        onSubmitted: (value) => _fetchData(),
                        decoration: InputDecoration(
                          hintText: "Search Service...",
                          hintStyle: GoogleFonts.outfit(
                              fontSize: 14, color: Colors.grey.shade400),
                          prefixIcon: Icon(Icons.search,
                              size: 20, color: Colors.grey.shade400),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 45,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          border: Border.all(
                              color: Theme.of(context)
                                  .dividerColor
                                  .withOpacity(0.1)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedGroup,
                            isExpanded: true,
                            icon: Icon(Icons.keyboard_arrow_down,
                                color: Theme.of(context).iconTheme.color),
                            dropdownColor: Theme.of(context).cardColor,
                            style: GoogleFonts.outfit(
                                fontSize: 14,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedGroup = newValue!;
                              });
                              _fetchData();
                            },
                            items: _groups
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Main List ──
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => _fetchData(),
                  child: BlocBuilder<PendingDocCubit, PendingDocState>(
                    builder: (context, state) {
                      if (state is PendingDocLoadingState) {
                        return Skeletonizer(
                          enabled: true,
                          child: ListView.builder(
                            itemCount: 5,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemBuilder: (context, index) => Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const ListTile(
                                leading: CircleAvatar(),
                                title: Text("Loading Verification..."),
                                subtitle: Text("Please wait a moment"),
                              ),
                            ),
                          ),
                        );
                      } else if (state is PendingDocErrorState) {
                        return Center(child: Text(state.message));
                      } else if (state is PendingDocSuccessState) {
                        final data = state.pendingDocModel.data ?? [];

                        if (data.isEmpty) {
                          return const Center(child: Text("No data found"));
                        }
                        return ListView.builder(
                          itemCount: data.length,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemBuilder: (context, index) {
                            final item = data[index];
                            final isExpanded = _expandedIndex == index;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  // Card Header
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _expandedIndex =
                                            isExpanded ? -1 : index;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? const Color(0xFFF0F2F5)
                                            : Colors.grey.shade900,
                                        borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(12),
                                          topRight: const Radius.circular(12),
                                          bottomLeft: isExpanded
                                              ? Radius.zero
                                              : const Radius.circular(12),
                                          bottomRight: isExpanded
                                              ? Radius.zero
                                              : const Radius.circular(12),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              (item.companyName != null &&
                                                      item.companyName!
                                                          .isNotEmpty)
                                                  ? item.companyName!
                                                  : ((item.first_name != null &&
                                                              item.first_name!
                                                                  .isNotEmpty) ||
                                                          (item.last_name !=
                                                                  null &&
                                                              item.last_name!
                                                                  .isNotEmpty))
                                                      ? "${item.first_name ?? ""} ${item.last_name ?? ""}"
                                                          .trim()
                                                      : item.entity
                                                              ?.entityName ??
                                                          "N/A",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  final token = context
                                                      .read<TokenCubit>()
                                                      .state;
                                                  context
                                                      .read<
                                                          VerifyRequestReportCubit>()
                                                      .verifyRequestReport(
                                                        token: token,
                                                        case_uuid:
                                                            item.uuid ?? "",
                                                      );
                                                },
                                                child: _buildHeaderIcon(
                                                    Icons.download,
                                                    const Color(0xFF3F51B5)),
                                              ),
                                              const SizedBox(width: 8),
                                              _buildHeaderIcon(
                                                Icons.info_outline_rounded,
                                                const Color(0xFFFFA000),
                                                tooltip: (item.status == null ||
                                                        item.status == "-")
                                                    ? "Pending"
                                                    : item.status!,
                                              ),
                                              const SizedBox(width: 8),
                                              Icon(
                                                isExpanded
                                                    ? Icons.keyboard_arrow_up
                                                    : Icons.keyboard_arrow_down,
                                                color: Theme.of(context)
                                                    .iconTheme
                                                    .color,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // Expandable Content
                                  if (isExpanded)
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Action Button
                                          Align(
                                              alignment: Alignment.centerRight,
                                              child: CustomButton(
                                                  onTap: () {
                                                    if (item.detailsUpdated ==
                                                        1) {
                                                      context.pushNamed(
                                                        'formList',
                                                        extra: {
                                                          'applicantData':
                                                              item.toJson(),
                                                          'serviceNavigate': item
                                                                  .services
                                                                  ?.first
                                                                  .serviceNavigate ??
                                                              "",
                                                          'serviceTitle': item
                                                                  .services
                                                                  ?.first
                                                                  .serviceTitle ??
                                                              "Verification",
                                                        },
                                                      );
                                                    } else {
                                                      _showFormDialog(item,
                                                          item.services?.first);
                                                    }
                                                  },
                                                  text: item.detailsUpdated == 1
                                                      ? "VIEW ${item.services?.first.serviceTitle?.toUpperCase() ?? "DOCUMENTS"}"
                                                      : "+ ADD ${item.entity?.entityName?.toUpperCase()}",
                                                  width: 200,
                                                  height: 40,
                                                  gradientColors: const [
                                                    Color(0xFFFF7043),
                                                    Color(0xFFFB8C00),
                                                  ],
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                          color: Colors.white,
                                                          fontSize: 12))),
                                          const SizedBox(height: 24),

                                          // Services Grid
                                          GridView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount:
                                                (item.services ?? []).length,
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              crossAxisSpacing: 10,
                                              mainAxisSpacing: 20,
                                              childAspectRatio: 0.65,
                                            ),
                                            itemBuilder: (context, sIndex) {
                                              final service =
                                                  item.services![sIndex];
                                              return InkWell(
                                                onTap: () {
                                                  if (item.detailsUpdated ==
                                                      1) {
                                                    context.pushNamed(
                                                      'formList',
                                                      extra: {
                                                        'applicantData':
                                                            item.toJson(),
                                                        'serviceNavigate':
                                                            service
                                                                .serviceNavigate,
                                                        'serviceTitle': service
                                                            .serviceTitle,
                                                      },
                                                    );
                                                  } else {
                                                    _showFormDialog(
                                                        item, service);
                                                  }
                                                },
                                                child: Column(
                                                  children: [
                                                    Stack(
                                                      children: [
                                                        Container(
                                                          height: 70,
                                                          width: 70,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(12),
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: Theme.of(
                                                                    context)
                                                                .cardColor,
                                                            border: Border.all(
                                                                color: Theme.of(
                                                                        context)
                                                                    .dividerColor),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.05),
                                                                blurRadius: 10,
                                                              ),
                                                            ],
                                                          ),
                                                          child: Image.network(
                                                            service.serviceIcon ??
                                                                "",
                                                            errorBuilder: (c, e,
                                                                    s) =>
                                                                const Icon(
                                                                    Icons
                                                                        .description,
                                                                    color: Colors
                                                                        .grey),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          right: 0,
                                                          top: 0,
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4),
                                                            decoration:
                                                                const BoxDecoration(
                                                              color: Color(
                                                                  0xFFFF5722),
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            child: const Icon(
                                                                Icons
                                                                    .priority_high,
                                                                color: Colors
                                                                    .white,
                                                                size: 10),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 8),
                                                    SizedBox(
                                                      height: 32,
                                                      child: Text(
                                                        service.serviceTitle
                                                                ?.toUpperCase() ??
                                                            "",
                                                        textAlign:
                                                            TextAlign.center,
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            GoogleFonts.outfit(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium
                                                                  ?.color,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10,
                                                          vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xFFFFF3E0),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        border: Border.all(
                                                            color: const Color(
                                                                0xFFFFE0B2)),
                                                      ),
                                                      child: Text(
                                                        "Pending",
                                                        style:
                                                            GoogleFonts.outfit(
                                                          fontSize: 10,
                                                          color: const Color(
                                                              0xFFE65100),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget _buildHeaderIcon(IconData icon, Color color, {String? tooltip}) {
    Widget iconWidget = Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
          ),
        ],
      ),
      child: Icon(icon, size: 16, color: color),
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip,
        triggerMode: TooltipTriggerMode.tap,
        preferBelow: false,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: GoogleFonts.outfit(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        child: iconWidget,
      );
    }

    return iconWidget;
  }

  void _showFormDialog(verifyRequest item, Service? service) {
    debugPrint('firstName: ${item.customer!.firstName.toString()}');
    final groupId = item.entity?.groupId ?? 1;
    final entityName =
        item.entity?.entityName ?? (groupId == 1 ? "Company" : "Personal");

    // Split contact person name if needed
    String hrName = item.customer?.contactPersonHrName ?? "";
    List<String> nameParts = hrName.trim().split(RegExp(r'\s+'));
    String fallbackFirst = nameParts.isNotEmpty ? nameParts[0] : "";
    String fallbackLast =
        nameParts.length > 1 ? nameParts.sublist(1).join(" ") : "";

    TextEditingController companyNameController =
        TextEditingController(text: item.companyName);
    TextEditingController firstNameController = TextEditingController(
        text: (item.first_name == null || item.first_name!.isEmpty)
            ? fallbackFirst
            : item.first_name);
    TextEditingController lastNameController = TextEditingController(
        text: (item.last_name == null || item.last_name!.isEmpty)
            ? fallbackLast
            : item.last_name);
    TextEditingController phoneController =
        TextEditingController(text: item.phone);
    TextEditingController emailController =
        TextEditingController(text: item.email);

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => groupId == 1
          ? _buildFormDialog(
              title: "Fill $entityName Info",
              icon: Icons.business_rounded,
              formKey: formKey,
              onSave: () {
                final token = context.read<TokenCubit>().state;
                context.read<VerifyRequestUpdateCubit>().verifyRequestUpdate(
                      token: token,
                      uuid: item.uuid ?? "",
                      group_id: 1,
                      company_name: companyNameController.text,
                      firstName: firstNameController.text,
                      middleName: "",
                      lastName: lastNameController.text,
                      phone: phoneController.text,
                      dob: "",
                      email: emailController.text,
                      employee_code: "",
                      date_of_joining: "",
                      gender: "",
                    );
              },
              onSuccess: () {
                // Update local state only on success
                item.companyName = companyNameController.text;
                item.first_name = firstNameController.text;
                item.last_name = lastNameController.text;
                item.detailsUpdated = 1;
                setState(() {});

                // Navigate to Form List after success if a service was selected
                if (service != null) {
                  context.pushNamed(
                    'formList',
                    extra: {
                      'applicantData': item.toJson(),
                      'serviceNavigate': service.serviceNavigate,
                      'serviceTitle': service.serviceTitle,
                    },
                  );
                }
              },
              fields: [
                form_widget(
                  controller: companyNameController,
                  titleText: 'Company Name',
                  hintText: "Enter Company Name",
                  textInputType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter company name';
                    }
                    return null;
                  },
                ),
                FormFieldNotRequired(
                  controller: phoneController,
                  titleText: 'Mobile Number',
                  hintText: "Enter Mobile Number",
                  textInputType: TextInputType.number,
                ),
                FormFieldNotRequired(
                  controller: emailController,
                  titleText: 'Email Address',
                  hintText: "Enter Email Address",
                  textInputType: TextInputType.emailAddress,
                ),
              ],
            )
          : _buildFormDialog(
              title: "Fill $entityName Info",
              icon: Icons.person_rounded,
              formKey: formKey,
              onSave: () {
                final token = context.read<TokenCubit>().state;
                context.read<VerifyRequestUpdateCubit>().verifyRequestUpdate(
                      token: token,
                      uuid: item.uuid ?? "",
                      group_id: 2,
                      company_name: "",
                      firstName: firstNameController.text,
                      middleName: "",
                      lastName: lastNameController.text,
                      phone: phoneController.text,
                      dob: "",
                      email: emailController.text,
                      employee_code: "",
                      date_of_joining: "",
                      gender: "",
                    );
              },
              onSuccess: () {
                // Update local state only on success
                item.first_name = firstNameController.text;
                item.last_name = lastNameController.text;
                item.detailsUpdated = 1; // Mark as updated
                setState(() {});

                // Navigate to Form List after success if a service was selected
                if (service != null) {
                  context.pushNamed(
                    'formList',
                    extra: {
                      'applicantData': item.toJson(),
                      'serviceNavigate': service.serviceNavigate,
                      'serviceTitle': service.serviceTitle,
                    },
                  );
                }
              },
              fields: [
                form_widget(
                  controller: firstNameController,
                  titleText: 'First Name',
                  hintText: "Enter First Name",
                  textInputType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter first name';
                    }
                    return null;
                  },
                ),
                form_widget(
                  controller: lastNameController,
                  titleText: 'Last Name',
                  hintText: "Enter Last Name",
                  textInputType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter last name';
                    }
                    return null;
                  },
                ),
                FormFieldNotRequired(
                  controller: phoneController,
                  titleText: 'Phone Number',
                  hintText: "Enter Phone Number",
                  textInputType: TextInputType.number,
                ),
                FormFieldNotRequired(
                  controller: emailController,
                  titleText: 'Email Address',
                  hintText: "Enter Email Address",
                  textInputType: TextInputType.emailAddress,
                ),
              ],
            ),
    );
  }

  Widget _buildFormDialog({
    required String title,
    required IconData icon,
    required List<Widget> fields,
    required GlobalKey<FormState> formKey,
    required VoidCallback onSave,
    required VoidCallback onSuccess,
  }) {
    return Dialog(
        insetPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Theme.of(context).cardColor,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon,
                          color: Theme.of(context).primaryColor, size: 32),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(title,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  color: Theme.of(context).primaryColorLight)),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2), // Very light red
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFEE2E2)),
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.outfit(
                              color: const Color(0xFF64748B),
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                          children: [
                            const TextSpan(text: "Note : "),
                            TextSpan(
                              text: "* ",
                              style: GoogleFonts.outfit(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                            const TextSpan(text: "Indicates mandatory fields"),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...fields,
                    const SizedBox(height: 24),
                    BlocConsumer<VerifyRequestUpdateCubit,
                        VerifyRequestUpdateState>(
                      listener: (context, state) {
                        if (state is VerifyRequestUpdateSuccessState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Updated successfully!")),
                          );
                          onSuccess();
                          Navigator.pop(context);
                          _fetchData(
                              isLoading: false); // Silent background refresh
                        } else if (state is VerifyRequestUpdateErrorState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        }
                      },
                      builder: (context, state) {
                        return SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFFFF5722),
                                  const Color(0xFFFF9800),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xFFFF5722).withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: state
                                      is VerifyRequestUpdateLoadingState
                                  ? null
                                  : () {
                                      if (formKey.currentState!.validate()) {
                                        onSave();
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              child: state is VerifyRequestUpdateLoadingState
                                  ? SizedBox(
                                      width: 25,
                                      height: 25,
                                      child: const CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      "SAVE",
                                      style: GoogleFonts.outfit(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancel",
                          style: GoogleFonts.outfit(color: Colors.grey)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
