import 'dart:async';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/screen/ServicesAndPrice/Blocs/all_entities_bloc/all_entities_state.dart';
import 'package:v_verify/screen/VerificationForms/common/form_widget.dart';
import 'package:v_verify/screen/VerificationPending/bloc/pendingDoc_cubit.dart';
import 'package:v_verify/screen/VerificationPending/bloc/pendingDoc_state.dart';
import 'package:v_verify/screen/VerificationPending/model/pendingDoc_model.dart';
import 'package:v_verify/screen/VerificationPending/bloc/verify_report_bloc/verify_request_report_cubit.dart';
import 'package:v_verify/screen/VerificationPending/bloc/verify_report_bloc/verify_request_report_state.dart';
import 'package:v_verify/screen/VerificationPending/verifyRequestUpdate/Bloc/verify_request_update_cubit.dart';
import 'package:v_verify/screen/VerificationPending/verifyRequestUpdate/Bloc/verify_request_update_state.dart';
import '../../../commonComponent/custom_button.dart';
import 'package:v_verify/screen/ServicesAndPrice/Blocs/all_entities_bloc/all_entities_cubit.dart';
import 'package:v_verify/screen/ServicesAndPrice/Models/all_entities_model.dart';
import 'package:v_verify/screen/VerificationPending/Pagination/entities_drawer.dart';
import 'package:v_verify/screen/VerificationPending/Pagination/DashBoard/dashboard.dart';
import 'package:v_verify/screen/VerificationPending/Pagination/DashBoard/bloc/pending_doc_navigation_cubit.dart';

class PendingDocPagination extends StatefulWidget {
  final String? initialStatus;
  final int? initialGroupId;
  final int? initialEntityId;

  const PendingDocPagination({
    super.key,
    this.initialStatus,
    this.initialGroupId,
    this.initialEntityId,
  });

  @override
  State<PendingDocPagination> createState() => _PendingDocPaginationState();
}

class _PendingDocPaginationState extends State<PendingDocPagination> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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

    // Sync initial routing parameters to navigation Cubit on startup
    final navCubit = context.read<PendingDocNavigationCubit>();
    if (widget.initialEntityId != null) {
      navCubit.selectCategory(
        status: widget.initialStatus,
        entityId: widget.initialEntityId,
        groupId: widget.initialGroupId,
      );
    } else {
      if (navCubit.state.entityId == null) {
        navCubit.clear();
      }
    }

    final int? activeGroupId = widget.initialGroupId ?? navCubit.state.groupId;
    if (activeGroupId == 1) {
      _selectedGroup = "Company Check";
    } else if (activeGroupId == 2) {
      _selectedGroup = "Personal Check";
    }

    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = context.read<TokenCubit>().state;
      final customerId = context.read<IdCubit>().state;
      context
          .read<AllEntitiesCubit>()
          .getAllEntities(token: token, customer_id: customerId);

      final filterState = context.read<PendingDocNavigationCubit>().state;
      if (filterState.entityId != null) {
        _fetchDataWithFilters(
          status: filterState.status,
          entityId: filterState.entityId,
          groupId: filterState.groupId,
        );
      }
    });
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
    final filterState = context.read<PendingDocNavigationCubit>().state;
    await _fetchDataWithFilters(
      status: filterState.status,
      entityId: filterState.entityId,
      groupId: filterState.groupId,
      isLoading: isLoading,
    );
  }

  Future<void> _fetchDataWithFilters({
    required String? status,
    required int? entityId,
    required int? groupId,
    bool isLoading = true,
  }) async {
    await context.read<TokenCubit>().getToken();
    await context.read<IdCubit>().getId();

    final token = context.read<TokenCubit>().state;
    final customerIdStr = context.read<IdCubit>().state;
    final customerId = int.tryParse(customerIdStr) ?? 0;

    // Derive v_status: 'Verified' → 'completed', 'Pending' or null → no filter
    final String? vStatus = (status == 'Verified') ? 'completed' : null;

    if (mounted) {
      await context.read<PendingDocCubit>().getPendingDoc(
            token: token,
            customerId: customerId,
            page: 1,
            limit: 100,
            entityId: entityId,
            vStatus: vStatus,
            search: _searchController.text.isNotEmpty
                ? _searchController.text
                : null,
            isLoading: isLoading,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PendingDocNavigationCubit, PendingDocFilterState>(
      listener: (context, filterState) {
        if (filterState.entityId != null) {
          _fetchDataWithFilters(
            status: filterState.status,
            entityId: filterState.entityId,
            groupId: filterState.groupId,
          );
        }
      },
      builder: (context, filterState) {
        if (filterState.entityId == null) {
          return const DashboardScreen();
        }

        return Scaffold(
            key: _scaffoldKey,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            drawer: EntitiesDrawer(
              currentEntityId: filterState.entityId?.toString() ?? "",
              navigateToPendingDoc: true,
            ),
            body: BlocListener<VerifyRequestReportCubit,
                VerifyRequestReportState>(
              listener: (context, state) {
                if (state is VerifyRequestReportLoadingState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Downloading Report..."),
                      duration: Duration(seconds: 1),
                    ),
                  );
                } else if (state is VerifyRequestReportDownloadedState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Report downloaded to: ${state.filePath}"),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                  // ── Show in app review ──
                  context.pushNamed(
                    'fileView',
                    extra: {
                      'filePath': state.filePath,
                      'fileName': state.filePath.split('/').last,
                    },
                  );
                } else if (state is VerifyRequestReportErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Error: ${state.message}"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 4.0, top: 16.0, right: 16.0, bottom: 16.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.menu,
                            color: Theme.of(context).primaryColorLight,
                          ),
                          onPressed: () =>
                              _scaffoldKey.currentState?.openDrawer(),
                        ),
                        const SizedBox(width: 8),
                        Text("Verification ",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    color:
                                        Theme.of(context).primaryColorLight)),
                      ],
                    ),
                  ),
                  // ── Search and Filter Header ──
                  // Padding(
                  //   padding: const EdgeInsets.all(16.0),
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         flex: 2,
                  //         child: TextField(
                  //           controller: _searchController,
                  //           textAlign: TextAlign.center,
                  //           onSubmitted: (value) => _fetchData(),
                  //           decoration: InputDecoration(
                  //             hintText: "Search Service...",
                  //             hintStyle: GoogleFonts.outfit(
                  //                 fontSize: 14, color: Colors.grey.shade400),
                  //             // prefixIcon: Icon(Icons.search,
                  //             //     size: 20, color: Colors.grey.shade400),
                  //             border: OutlineInputBorder(
                  //                 borderRadius: BorderRadius.circular(12)),
                  //             contentPadding:
                  //                 const EdgeInsets.symmetric(vertical: 12),
                  //           ),
                  //         ),
                  //       ),
                  //       const SizedBox(width: 12),
                  //       Expanded(
                  //         child: Container(
                  //           height: 45,
                  //           padding: const EdgeInsets.symmetric(horizontal: 12),
                  //           decoration: BoxDecoration(
                  //             color: Theme.of(context).cardColor,
                  //             borderRadius: BorderRadius.circular(12),
                  //             boxShadow: [
                  //               BoxShadow(
                  //                 color: Colors.black.withOpacity(0.04),
                  //                 blurRadius: 10,
                  //                 offset: const Offset(0, 4),
                  //               ),
                  //             ],
                  //             border: Border.all(
                  //                 color: Theme.of(context)
                  //                     .dividerColor
                  //                     .withOpacity(0.1)),
                  //           ),
                  //           child: DropdownButtonHideUnderline(
                  //             child: DropdownButton<String>(
                  //               value: _selectedGroup,
                  //               isExpanded: true,
                  //               icon: Icon(Icons.keyboard_arrow_down,
                  //                   color: Theme.of(context).iconTheme.color),
                  //               dropdownColor: Theme.of(context).cardColor,
                  //               style: GoogleFonts.outfit(
                  //                   fontSize: 14,
                  //                   color: Theme.of(context)
                  //                       .textTheme
                  //                       .bodyMedium
                  //                       ?.color),
                  //               onChanged: (String? newValue) {
                  //                 setState(() {
                  //                   _selectedGroup = newValue!;
                  //                 });
                  //                 _fetchData();
                  //               },
                  //               items: _groups.map<DropdownMenuItem<String>>(
                  //                   (String value) {
                  //                 return DropdownMenuItem<String>(
                  //                   value: value,
                  //                   child: Text(value),
                  //                 );
                  //               }).toList(),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  // ── Buy Service Navigation Button ──
                  BlocBuilder<AllEntitiesCubit, AllEntitiesState>(
                    builder: (context, state) {
                      String entityName = "Service";
                      if (state is AllEntitiesSuccessState) {
                        final list = state.allEntitiesModel.data ?? [];
                        final match = list.firstWhere(
                          (e) => e.id == filterState.entityId,
                          orElse: () => AllEntityData(entityName: "Service"),
                        );
                        if (match.entityName != null &&
                            match.entityName!.isNotEmpty) {
                          entityName = match.entityName!;
                        }
                      }

                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, bottom: 16.0),
                        child: InkWell(
                          onTap: () {
                            context.pushNamed(
                              "servicesAndPrice",
                              pathParameters: {
                                "id": filterState.entityId!.toString(),
                              },
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 8),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF5200), Color(0xFFFF7E3E)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xFFFF5200).withOpacity(0.15),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    "Buy $entityName Services",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: GoogleFonts.outfit(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  // ── In-Progress and Completed Horizontal Scroll Tabs ──
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 12.0, right: 12.0, bottom: 16.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          _buildTabChip(
                            context,
                            label: "In-Progress",
                            isActive: filterState.status == 'Pending' ||
                                filterState.status == null,
                            activeBgColor: Theme.of(context).brightness ==
                                    Brightness.light
                                ? const Color(0xFFFEF9C3)
                                : const Color(
                                    0xFF3A341E), // Light warm yellow / Dark warm amber
                            activeTextColor: Theme.of(context).brightness ==
                                    Brightness.light
                                ? const Color(0xFF854D0E)
                                : const Color(
                                    0xFFFDE047), // Dark brown text / Light yellow text
                            onTap: () {
                              context
                                  .read<PendingDocNavigationCubit>()
                                  .selectCategory(
                                    status: 'Pending',
                                    entityId: filterState.entityId,
                                    groupId: filterState.groupId,
                                  );
                            },
                          ),
                          const SizedBox(width: 8),
                          _buildTabChip(
                            context,
                            label: "Completed",
                            isActive: filterState.status == 'Verified',
                            activeBgColor: Theme.of(context).brightness ==
                                    Brightness.light
                                ? const Color(0xFFDCFCE7)
                                : const Color(
                                    0xFF143A24), // Light fresh green / Deep forest green
                            activeTextColor: Theme.of(context).brightness ==
                                    Brightness.light
                                ? const Color(0xFF166534)
                                : const Color(
                                    0xFF4ADE80), // Dark green text / Fresh green text
                            onTap: () {
                              context
                                  .read<PendingDocNavigationCubit>()
                                  .selectCategory(
                                    status: 'Verified',
                                    entityId: filterState.entityId,
                                    groupId: filterState.groupId,
                                  );
                            },
                          ),
                        ],
                      ),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                itemBuilder: (context, index) => Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
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
                            return Center(
                              child: Text(
                                state.message,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color),
                              ),
                            );
                          } else if (state is PendingDocSuccessState) {
                            final data = state.pendingDocModel.data ?? [];

                            if (data.isEmpty) {
                              return Center(
                                child: Text(
                                  "No data found",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.color),
                                ),
                              );
                            }
                            return ListView.builder(
                              itemCount: data.length,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              itemBuilder: (context, index) {
                                final item = data[index];
                                final isExpanded = _expandedIndex == index;

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.grey.shade200
                                            : Colors.grey.shade800),
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
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            borderRadius: BorderRadius.only(
                                              topLeft:
                                                  const Radius.circular(12),
                                              topRight:
                                                  const Radius.circular(12),
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
                                                      : ((item.first_name !=
                                                                      null &&
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                                        Theme.of(context)
                                                            .primaryColorLight),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  if (item.detailsUpdated ==
                                                      1) ...[
                                                    GestureDetector(
                                                      onTap: () {
                                                        _showFormDialog(
                                                            item, null);
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(right: 6),
                                                        child: _buildHeaderIcon(
                                                            Icons.edit,
                                                            Theme.of(context)
                                                                .primaryColorLight),
                                                      ),
                                                    ),
                                                  ],
                                                  _buildStatusIcon(item),
                                                  const SizedBox(width: 8),
                                                  Icon(
                                                    isExpanded
                                                        ? Icons
                                                            .keyboard_arrow_up
                                                        : Icons
                                                            .keyboard_arrow_down,
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
                                                  alignment: Alignment
                                                      .centerRight,
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
                                                          ).then((_) {
                                                            if (context
                                                                .mounted) {
                                                              _fetchData(
                                                                  isLoading:
                                                                      false);
                                                            }
                                                          });
                                                        } else {
                                                          _showFormDialog(
                                                              item,
                                                              item.services
                                                                  ?.first);
                                                        }
                                                      },
                                                      text: item.detailsUpdated ==
                                                              1
                                                          ? "VIEW ${item.services?.first.serviceTitle?.toUpperCase() ?? "DOCUMENTS"}"
                                                          : "+ ADD ${item.entity?.entityName?.toUpperCase()}",
                                                      width: 200,
                                                      height: 40,
                                                      gradientColors: const [
                                                        Color(0xFFFF7043),
                                                        Color(0xFFFB8C00),
                                                      ],
                                                      textStyle: Theme.of(
                                                              context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12))),
                                              const SizedBox(height: 24),

                                              // Services Grid
                                              GridView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount: (item.services ?? [])
                                                    .length,
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
                                                  // Resolve the single source-of-truth status
                                                  final effectiveStatus =
                                                      _effectiveStatus(
                                                          service.status,
                                                          item.caseStatus);
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
                                                            'serviceTitle':
                                                                service
                                                                    .serviceTitle,
                                                          },
                                                        ).then((_) {
                                                          if (context.mounted) {
                                                            _fetchData(
                                                                isLoading:
                                                                    false);
                                                          }
                                                        });
                                                      } else {
                                                        _showFormDialog(
                                                            item, service);
                                                      }
                                                    },
                                                    child: Column(
                                                      children: [
                                                        Stack(
                                                          clipBehavior:
                                                              Clip.none,
                                                          children: [
                                                            Container(
                                                              height: 70,
                                                              width: 70,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(12),
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
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
                                                                    blurRadius:
                                                                        10,
                                                                  ),
                                                                ],
                                                              ),
                                                              child:
                                                                  Image.network(
                                                                service.serviceIcon ??
                                                                    "",
                                                                errorBuilder: (c,
                                                                        e, s) =>
                                                                    const Icon(
                                                                        Icons
                                                                            .description,
                                                                        color: Colors
                                                                            .grey),
                                                              ),
                                                            ),
                                                            // ── Status Dot Badge (top-right) ──
                                                            Positioned(
                                                              right: 0,
                                                              top: 0,
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(4),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: _statusDotColor(
                                                                      effectiveStatus),
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                child: Icon(
                                                                  _statusDotIcon(
                                                                      effectiveStatus),
                                                                  color: Colors
                                                                      .white,
                                                                  size: 10,
                                                                ),
                                                              ),
                                                            ),
                                                            // ── Download Button (bottom-right) ──
                                                            if (_showDownloadBtn(
                                                                service.status,
                                                                item.caseStatus))
                                                              Positioned(
                                                                right: -2,
                                                                bottom: -2,
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    final token = context
                                                                        .read<
                                                                            TokenCubit>()
                                                                        .state;
                                                                    context
                                                                        .read<
                                                                            VerifyRequestReportCubit>()
                                                                        .verifyServiceReport(
                                                                          token:
                                                                              token,
                                                                          uuid: item.uuid ??
                                                                              "",
                                                                          service_id:
                                                                              service.serviceRequestId ?? 0,
                                                                          service_name:
                                                                              service.serviceTitle ?? "Service",
                                                                        );
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            6),
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      color: Colors
                                                                          .blue,
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color:
                                                                              Colors.black12,
                                                                          blurRadius:
                                                                              4,
                                                                          offset: Offset(
                                                                              0,
                                                                              2),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    child:
                                                                        const Icon(
                                                                      Icons
                                                                          .file_download,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 14,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 8),
                                                        // ── Service Title ──
                                                        SizedBox(
                                                          height: 32,
                                                          child: Text(
                                                            service.serviceTitle
                                                                    ?.toUpperCase() ??
                                                                "",
                                                            textAlign: TextAlign
                                                                .center,
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: GoogleFonts
                                                                .outfit(
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyMedium
                                                                  ?.color,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 4),
                                                        // ── Status Chip ──
                                                        Builder(builder: (_) {
                                                          final chips =
                                                              _statusChipColors(
                                                                  effectiveStatus);
                                                          return Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical:
                                                                        4),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: chips[1],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                              border: Border.all(
                                                                  color:
                                                                      chips[2]),
                                                            ),
                                                            child: Text(
                                                              _statusLabel(
                                                                  effectiveStatus),
                                                              style: GoogleFonts
                                                                  .outfit(
                                                                fontSize: 10,
                                                                color: chips[0],
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          );
                                                        }),
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
      },
    );
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

  Widget _buildStatusIcon(verifyRequest item) {
    // Use effective status: item.status → fallback to item.caseStatus
    final effective = _effectiveStatus(item.status, item.caseStatus);

    debugPrint(
        'card status: $effective (raw: ${item.status}, case: ${item.caseStatus})');

    if (item.services == null || item.services!.isEmpty) {
      return _buildHeaderIcon(
        Icons.info_outline_rounded,
        const Color.fromRGBO(255, 160, 0, 1),
        tooltip: 'Pending',
      );
    }

    final IconData iconData;
    final Color iconColor;
    final String label;

    if (_isVerified(effective)) {
      iconData = Icons.check_circle_rounded;
      iconColor = Colors.green;
      label = 'Clear';
    } else if (_isRejected(effective)) {
      iconData = Icons.gpp_maybe_rounded;
      iconColor = Colors.red;
      label =
          (effective?.toLowerCase() == 'reject') ? 'Rejected' : 'Discrepancy';
    } else {
      // pending / "-" / null
      iconData = Icons.info_outline_rounded;
      iconColor = const Color.fromRGBO(255, 160, 0, 1);
      label = 'Pending';
    }

    return _buildHeaderIcon(iconData, iconColor, tooltip: label);
  }

  // ─── Status Helpers ───────────────────────────────────────────────────────

  /// Resolves the effective display status for a service tile.
  ///
  /// Priority:
  ///   1. service.status  — if it's a real value (not null / "" / "-")
  ///   2. item.case_status — fallback when service hasn't been processed yet
  ///   3. null             — treated as "pending" by all helpers below
  static String? _effectiveStatus(String? serviceStatus, String? caseStatus) {
    final s = serviceStatus?.trim();
    if (s != null && s.isNotEmpty && s != '-') return s;
    final c = caseStatus?.trim();
    if (c != null && c.isNotEmpty && c != '-') return c;
    return null; // pending
  }

  /// Returns true if the resolved status means "verified / done / clear"
  static bool _isVerified(String? status) {
    final s = status?.toLowerCase() ?? '';
    return s.contains('verified') || s.contains('done') || s.contains('clear');
  }

  /// Returns true if the resolved status means "pending" (null, empty, or "-")
  static bool _isPending(String? status) {
    if (status == null) return true;
    final s = status.trim().toLowerCase();
    return s.isEmpty || s == '-' || s.contains('pending');
  }

  /// Returns true if the resolved status means "rejected / discrepancy"
  static bool _isRejected(String? status) {
    final s = status?.toLowerCase() ?? '';
    return s.contains('reject') || s.contains('discrepancy');
  }

  /// Background dot color for the service status badge
  static Color _statusDotColor(String? status) {
    if (_isVerified(status)) return Colors.green;
    if (_isRejected(status)) return Colors.red;
    return const Color(0xFFFF5722); // pending
  }

  /// Icon inside the status dot badge
  static IconData _statusDotIcon(String? status) {
    if (_isVerified(status)) return Icons.check;
    if (_isRejected(status)) return Icons.gpp_maybe_rounded;
    return Icons.priority_high; // pending
  }

  /// Status chip colors: [textColor, bgColor, borderColor]
  static List<Color> _statusChipColors(String? status) {
    if (_isVerified(status)) {
      return [
        const Color(0xFF388E3C),
        const Color(0xFFE8F5E9),
        const Color(0xFFA5D6A7),
      ];
    }
    if (_isRejected(status)) {
      return [
        const Color(0xFFD32F2F),
        const Color(0xFFFFEBEE),
        const Color(0xFFEF9A9A),
      ];
    }
    // pending (default)
    return [
      const Color(0xFFF57C00),
      const Color(0xFFFFFDE7),
      const Color(0xFFFFF59D),
    ];
  }

  /// Display label for the status chip
  static String _statusLabel(String? status) {
    if (_isPending(status)) return 'Pending';
    if (status!.toLowerCase() == 'clear') return 'Verified';
    if (status.toLowerCase() == 'discrepancy') return 'Discrepancy';
    return '${status[0].toUpperCase()}${status.substring(1).toLowerCase()}';
  }

  /// Whether the download button should appear on a service tile
  static bool _showDownloadBtn(String? serviceStatus, String? caseStatus) {
    final effective = _effectiveStatus(serviceStatus, caseStatus);
    return _isVerified(effective) || _isRejected(effective);
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

    final verifyRequestUpdateCubit = context.read<VerifyRequestUpdateCubit>();
    final tokenCubit = context.read<TokenCubit>();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => BlocProvider<VerifyRequestUpdateCubit>.value(
        value: verifyRequestUpdateCubit,
        child: groupId == 1
            ? _buildFormDialog(
                title: item.detailsUpdated == 1
                    ? "Update $entityName Info"
                    : "Fill $entityName Info",
                icon: Icons.business_rounded,
                formKey: formKey,
                onSave: () {
                  final token = tokenCubit.state;
                  verifyRequestUpdateCubit.verifyRequestUpdate(
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
                    ).then((_) {
                      if (mounted) {
                        _fetchData(isLoading: false);
                      }
                    });
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
                title: item.detailsUpdated == 1
                    ? "Update $entityName Info"
                    : "Fill $entityName Info",
                icon: Icons.person_rounded,
                formKey: formKey,
                onSave: () {
                  final token = tokenCubit.state;
                  verifyRequestUpdateCubit.verifyRequestUpdate(
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
                    ).then((_) {
                      if (mounted) {
                        _fetchData(isLoading: false);
                      }
                    });
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
                        color: Theme.of(context).primaryColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Theme.of(context)
                                .primaryColor
                                .withOpacity(0.2)),
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.outfit(
                              color:
                                  Theme.of(context).textTheme.bodyMedium?.color,
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
                        return CustomButton(
                          text: "SAVE",
                          height: 45,
                          isLoading: state is VerifyRequestUpdateLoadingState,
                          gradientColors: const [
                            Color(0xFFFF5722),
                            Color(0xFFFF9800),
                          ],
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              onSave();
                            }
                          },
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

Widget _buildTabChip(
  BuildContext context, {
  required String label,
  required bool isActive,
  required Color activeBgColor,
  required Color activeTextColor,
  required VoidCallback onTap,
}) {
  final Color bgColor =
      isActive ? activeBgColor : Theme.of(context).scaffoldBackgroundColor;
  final Color textColor = isActive
      ? activeTextColor
      : (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey);
  final Color borderColor = isActive
      ? activeTextColor.withOpacity(0.3)
      : Theme.of(context).dividerColor;

  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(20),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: borderColor,
          width: 1.5,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: activeTextColor.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: Text(
        label,
        style: GoogleFonts.outfit(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    ),
  );
}
