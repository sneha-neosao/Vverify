import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/screen/VerificationPending/Pagination/entities_drawer.dart';
import 'package:v_verify/screen/VerificationPending/Pagination/DashBoard/bloc/dashboard_count_bloc.dart';
import 'package:v_verify/screen/VerificationPending/Pagination/DashBoard/bloc/dashboard_count_state.dart';
import 'package:v_verify/screen/VerificationPending/Pagination/DashBoard/bloc/dashboard_entities_cubit.dart';
import 'package:v_verify/screen/VerificationPending/Pagination/DashBoard/bloc/dashboard_entities_state.dart';
import 'package:v_verify/screen/VerificationPending/Pagination/DashBoard/bloc/entity_services_cubit.dart';
import 'package:v_verify/screen/VerificationPending/Pagination/DashBoard/bloc/entity_services_state.dart';
import 'package:v_verify/screen/VerificationPending/Pagination/DashBoard/Model/dashboard_entities_model.dart';
import 'package:v_verify/screen/VerificationPending/Pagination/DashBoard/Model/entity_data_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int? _selectedEntityId;
  String? _selectedEntityName;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final tokenCubit = context.read<TokenCubit>();
      final idCubit = context.read<IdCubit>();
      final dashboardCountBloc = context.read<DashboardCountBloc>();
      final dashboardEntitiesCubit = context.read<DashboardEntitiesCubit>();

      await tokenCubit.getToken();
      await idCubit.getId();

      if (!mounted) return;

      final token = tokenCubit.state;
      String customerId = idCubit.state;
      if (customerId.isEmpty) {
        customerId = "49"; // Default requested customer ID
      }

      // Load overall count metrics
      dashboardCountBloc.getDashboardCount(
        token: token,
        customerId: customerId,
      );

      // Load all entities for the sidebar
      dashboardEntitiesCubit.getDashboardEntities(
        token: token,
        customerId: customerId,
      );
    });
  }

  void _fetchEntityServices(String entityId) {
    final token = context.read<TokenCubit>().state;
    String customerId = context.read<IdCubit>().state;
    if (customerId.isEmpty) {
      customerId = "49";
    }
    context.read<EntityServicesCubit>().getEntityServices(
          token: token,
          customerId: customerId,
          entityId: entityId,
        );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DashboardEntitiesCubit, DashboardEntitiesState>(
          listener: (context, state) {
            if (state is DashboardEntitiesSuccessState) {
              final list = state.model.data ?? [];
              if (list.isNotEmpty && _selectedEntityId == null) {
                final firstEntity = list.first;
                setState(() {
                  _selectedEntityId = firstEntity.id;
                  _selectedEntityName = firstEntity.entityName;
                });
                _fetchEntityServices(firstEntity.id.toString());
              }
            }
          },
        ),
      ],
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor:
            const Color(0xFFF8FAFC), // Ultra soft slate-light background
        drawer: const EntitiesDrawer(
          currentEntityId: 'dashboard',
          navigateToPendingDoc: false,
        ),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF0F172A), size: 24),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header Area ──
                Text(
                  "Dashboard Overview",
                  style: GoogleFonts.outfit(
                    color: const Color(0xFF0F172A),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Monitor your verification requests and system metrics.",
                  style: GoogleFonts.outfit(
                    color: const Color(0xFF64748B),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 32),

                // ── Overview Counts State handling ──
                BlocBuilder<DashboardCountBloc, DashboardCountState>(
                  builder: (context, state) {
                    if (state is DashboardCountLoadingState) {
                      return Skeletonizer(
                        enabled: true,
                        child: _buildMetricsGrid(
                          total: 100,
                          completed: 30,
                          inProgress: 30,
                          pending: 30,
                          rejected: 10,
                        ),
                      );
                    } else if (state is DashboardCountErrorState) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Column(
                            children: [
                              const Icon(Icons.error_outline_rounded,
                                  color: Colors.redAccent, size: 36),
                              const SizedBox(height: 8),
                              Text(
                                "Failed to load metrics summary.",
                                style: GoogleFonts.outfit(
                                  color: const Color(0xFF64748B),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (state is DashboardCountSuccessState) {
                      final data = state.model?.data;
                      return _buildMetricsGrid(
                        total: data?.totalEntitiesPurchased ?? 0,
                        completed: data?.completed ?? 0,
                        inProgress: data?.inProgress ?? 0,
                        pending: data?.pending ?? 0,
                        rejected: data?.rejected ?? 0,
                      );
                    }
                    return const SizedBox();
                  },
                ),
                const SizedBox(height: 32),

                // ── Entities & Services Interactive Workspace Matrix Card ──
                // ── Entities & Services Interactive Workspace ──
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isDesktop = constraints.maxWidth > 768;

                    if (isDesktop) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left Sidebar Column
                          SizedBox(
                            width: 260,
                            child: _buildSidebarContent(),
                          ),
                          const SizedBox(width: 32),
                          // Right Details Grid Column
                          Expanded(
                            child: _buildMainContent(),
                          ),
                        ],
                      );
                    } else {
                      // Adaptive Stack layout for mobile viewports
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Verification Entities",
                            style: GoogleFonts.outfit(
                              color: const Color(0xFF0F172A),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 52,
                            child: _buildMobileHorizontalSidebar(),
                          ),
                          const SizedBox(height: 16),
                          const Divider(color: Color(0xFFE2E8F0), height: 1),
                          const SizedBox(height: 24),
                          _buildMainContent(),
                        ],
                      );
                    }
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSidebarContent() {
    return BlocBuilder<DashboardEntitiesCubit, DashboardEntitiesState>(
      builder: (context, state) {
        if (state is DashboardEntitiesLoadingState) {
          return Skeletonizer(
            enabled: true,
            child: Column(
              children: List.generate(
                6,
                (index) => Container(
                  height: 48,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          );
        } else if (state is DashboardEntitiesErrorState) {
          return const Center(child: Text("Error loading entities sidebar"));
        } else if (state is DashboardEntitiesSuccessState) {
          final list = state.model.data ?? [];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: list.map((item) {
              final isSelected = _selectedEntityId == item.id;
              return _buildEntitySidebarItem(
                item: item,
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    _selectedEntityId = item.id;
                    _selectedEntityName = item.entityName;
                  });
                  _fetchEntityServices(item.id.toString());
                },
              );
            }).toList(),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildMobileHorizontalSidebar() {
    return BlocBuilder<DashboardEntitiesCubit, DashboardEntitiesState>(
      builder: (context, state) {
        if (state is DashboardEntitiesLoadingState) {
          return Skeletonizer(
            enabled: true,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (context, index) => Container(
                width: 130,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          );
        } else if (state is DashboardEntitiesSuccessState) {
          final list = state.model.data ?? [];
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              final isSelected = _selectedEntityId == item.id;
              return Container(
                margin: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(item.entityName ?? ""),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedEntityId = item.id;
                        _selectedEntityName = item.entityName;
                      });
                      _fetchEntityServices(item.id.toString());
                    }
                  },
                  selectedColor: const Color(0xFFFFF8F2),
                  backgroundColor: Colors.white,
                  elevation: 0,
                  pressElevation: 0,
                  labelStyle: GoogleFonts.outfit(
                    color: isSelected
                        ? const Color(0xFFFF5200)
                        : const Color(0xFF64748B),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    fontSize: 13,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isSelected
                          ? const Color(0xFFFFE0D3)
                          : const Color(0xFFE2E8F0),
                      width: 1.0,
                    ),
                  ),
                ),
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildMainContent() {
    if (_selectedEntityId == null) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _selectedEntityName ?? "",
          style: GoogleFonts.outfit(
            color: const Color(0xFF0F172A),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Available verification services for this entity.",
          style: GoogleFonts.outfit(
            color: const Color(0xFF64748B),
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 16),
        const Divider(color: Color(0xFFE2E8F0), height: 1),
        const SizedBox(height: 24),
        BlocBuilder<EntityServicesCubit, EntityServicesState>(
          builder: (context, state) {
            if (state is EntityServicesLoadingState) {
              return Skeletonizer(
                enabled: true,
                child: _buildServicesGrid(
                  List.generate(
                    6,
                    (index) => ServiceCountItem(
                      serviceId: index,
                      serviceTitle: "Loading Service Option Title...",
                      completeCount: 0,
                      pendingCount: 0,
                    ),
                  ),
                ),
              );
            } else if (state is EntityServicesErrorState) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: Column(
                    children: [
                      const Icon(Icons.error_outline_rounded,
                          color: Colors.redAccent, size: 36),
                      const SizedBox(height: 12),
                      Text(
                        "Failed to load services metrics.",
                        style: GoogleFonts.outfit(
                          color: const Color(0xFF64748B),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is EntityServicesSuccessState) {
              final list = state.model.data?.serviceCounts ?? [];
              if (list.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    child: Text(
                      "No verification services configured.",
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF64748B),
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              }
              return _buildServicesGrid(list);
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }

  Widget _buildServicesGrid(List<ServiceCountItem> list) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final panelWidth = constraints.maxWidth;

        int crossAxisCount = 1;
        if (panelWidth > 800) {
          crossAxisCount = 3;
        } else if (panelWidth > 450) {
          crossAxisCount = 2;
        }

        // Dynamically compute childAspectRatio to enforce a stable, premium card height
        // that completely prevents bottom layout overflow across all screen sizes.
        const double spacing = 16.0;
        final double itemWidth =
            (panelWidth - (crossAxisCount - 1) * spacing) / crossAxisCount;
        const double itemHeight = 116.0;
        final double childAspectRatio = itemWidth / itemHeight;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: list.length,
          itemBuilder: (context, index) {
            return _buildServiceGridItem(item: list[index]);
          },
        );
      },
    );
  }

  Widget _buildEntitySidebarItem({
    required DashboardEntityItem item,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFFFFF8F2)
            : Colors.transparent, // Beautiful brand cream orange
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? const Color(0xFFFFE0D3)
              : Colors.transparent, // Soft border active
          width: 1.0,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              // Premium active left indicator bar
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color:
                      isSelected ? const Color(0xFFFF5200) : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.entityName ?? "N/A",
                  style: GoogleFonts.outfit(
                    color: isSelected
                        ? const Color(0xFFFF5200)
                        : const Color(
                            0xFF475569), // Orange active, Slate dark inactive
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceGridItem({
    required ServiceCountItem item,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.01),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item.serviceTitle ?? "Service Title",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              color: const Color(0xFF0F172A),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              // Completed Chip
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF10B981).withOpacity(0.1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle_outline_rounded,
                        color: Color(0xFF10B981),
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          "Completed: ${item.completeCount ?? 0}",
                          style: GoogleFonts.outfit(
                            color: const Color(0xFF065F46),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Pending Chip
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFF59E0B).withOpacity(0.1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.watch_later_outlined,
                        color: Color(0xFFD97706),
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          "Pending: ${item.pendingCount ?? 0}",
                          style: GoogleFonts.outfit(
                            color: const Color(0xFF92400E),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid({
    required int total,
    required int completed,
    required int inProgress,
    required int pending,
    required int rejected,
  }) {
    final cards = [
      _MetricData(
        title: "Total Entities",
        value: total.toString(),
        icon: Icons.assignment_outlined,
        iconColor: const Color(0xFF3B82F6),
        iconBg: const Color(0xFFEFF6FF),
      ),
      _MetricData(
        title: "Completed",
        value: completed.toString(),
        icon: Icons.check_circle_outline_rounded,
        iconColor: const Color(0xFF10B981),
        iconBg: const Color(0xFFECFDF5),
      ),
      _MetricData(
        title: "In Progress",
        value: inProgress.toString(),
        icon: Icons.timeline_rounded,
        iconColor: const Color(0xFF6366F1),
        iconBg: const Color(0xFFEEF2FF),
      ),
      _MetricData(
        title: "Pending",
        value: pending.toString(),
        icon: Icons.watch_later_outlined,
        iconColor: const Color(0xFFF59E0B),
        iconBg: const Color(0xFFFFFBEB),
      ),
      _MetricData(
        title: "Rejected",
        value: rejected.toString(),
        icon: Icons.cancel_outlined,
        iconColor: const Color(0xFFEF4444),
        iconBg: const Color(0xFFFEF2F2),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // Show exactly 2 cards per row on mobile/tablet.
        // Show 5 cards per row on larger desktop viewports.
        int crossAxisCount = 2;
        if (width > 1024) {
          crossAxisCount = 5;
        } else if (width > 768) {
          crossAxisCount = 3;
        }

        // Dynamically compute childAspectRatio to enforce a stable card height
        // that completely prevents bottom layout overflow across all screen sizes.
        const double spacing = 16.0;
        final double itemWidth =
            (width - (crossAxisCount - 1) * spacing) / crossAxisCount;
        const double itemHeight = 110.0;
        final double childAspectRatio = itemWidth / itemHeight;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: cards.length,
          itemBuilder: (context, index) {
            final card = cards[index];
            return _buildMetricCard(
              title: card.title,
              value: card.value,
              icon: card.icon,
              iconColor: card.iconColor,
              iconBg: card.iconBg,
            );
          },
        );
      },
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 18,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.outfit(
                  color: const Color(0xFF0F172A),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              color: const Color(0xFF64748B),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricData {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;

  _MetricData({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
  });
}
