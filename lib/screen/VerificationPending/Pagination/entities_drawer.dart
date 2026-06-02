import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:v_verify/screen/VerificationPending/Pagination/DashBoard/bloc/pending_doc_navigation_cubit.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/screen/ServicesAndPrice/Blocs/all_entities_bloc/all_entities_cubit.dart';
import 'package:v_verify/screen/ServicesAndPrice/Blocs/all_entities_bloc/all_entities_state.dart';
import 'package:v_verify/screen/ServicesAndPrice/Models/all_entities_model.dart';

class EntitiesDrawer extends StatefulWidget {
  final String currentEntityId;
  final bool navigateToPendingDoc;

  const EntitiesDrawer({
    super.key,
    required this.currentEntityId,
    this.navigateToPendingDoc = false,
  });

  @override
  State<EntitiesDrawer> createState() => _EntitiesDrawerState();
}

class _EntitiesDrawerState extends State<EntitiesDrawer> {
  @override
  void initState() {
    super.initState();

    // Only fetch if data is not already loaded.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentState = context.read<AllEntitiesCubit>().state;
      if (currentState is! AllEntitiesSuccessState) {
        final token = context.read<TokenCubit>().state;
        final customerId = context.read<IdCubit>().state;
        context
            .read<AllEntitiesCubit>()
            .getAllEntities(token: token, customer_id: customerId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white, // Pure premium white sidebar background
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drawer Header / Brand Row
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE28A17).withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shield_rounded,
                      color: Color(0xFFE28A17),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "pehchaan360",
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF0F172A), // Slate black
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
                color: Color(0xFFE2E8F0), height: 1), // Light border divider
            const SizedBox(height: 16),

            // Scrollable Navigation List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  // Dashboard Tile
                  _buildDashboardTile(widget.currentEntityId == 'dashboard'),
                  const SizedBox(height: 8),

                  BlocBuilder<AllEntitiesCubit, AllEntitiesState>(
                    builder: (context, state) {
                      if (state is AllEntitiesLoadingState) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 24.0),
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFFE28A17)),
                            ),
                          ),
                        );
                      } else if (state is AllEntitiesErrorState) {
                        if (state.message
                            .toLowerCase()
                            .contains("no data found")) {
                          return const SizedBox();
                        }
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 24.0, horizontal: 16.0),
                            child: Text(
                              "Failed to load: ${state.message}",
                              textAlign: TextAlign.center,
                              style:
                                  GoogleFonts.outfit(color: Colors.redAccent),
                            ),
                          ),
                        );
                      } else if (state is AllEntitiesSuccessState) {
                        final dataList = state.allEntitiesModel.data ?? [];
                        final activeEntities = dataList
                            .where((e) => e.isActive == null || e.isActive == 1)
                            .toList();

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: activeEntities.map((entity) {
                            final isCurrent =
                                widget.currentEntityId == entity.id.toString();

                            return _buildEntityItem(entity, isCurrent);
                          }).toList(),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardTile(bool isActive) {
    if (isActive) {
      return Container(
        margin: const EdgeInsets.only(bottom: 8.0),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8F2), // Premium cream-orange card
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFFFE0D3),
            width: 1.0,
          ),
        ),
        child: ListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          leading: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.dashboard_rounded,
              color: Color(0xFFFF5200),
              size: 20,
            ),
          ),
          title: Text(
            "Dashboard",
            style: GoogleFonts.outfit(
              color: const Color(0xFFFF5200),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {
            Navigator.of(context).pop(); // Close drawer
          },
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.only(bottom: 8.0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          leading: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFF1F5F9), // Soft slate background
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.dashboard_rounded,
              color: Color(0xFF64748B),
              size: 20,
            ),
          ),
          title: Text(
            "Dashboard",
            style: GoogleFonts.outfit(
              color: const Color(0xFF334155), // Slate dark text
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          onTap: () {
            Navigator.of(context).pop(); // Close drawer
            context.read<PendingDocNavigationCubit>().clear();
          },
        ),
      );
    }
  }

  Widget _buildEntityItem(AllEntityData entity, bool isCurrent) {
    if (isCurrent) {
      return Container(
        margin: const EdgeInsets.only(bottom: 8.0),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8F2), // Premium cream-orange card
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFFFE0D3),
            width: 1.0,
          ),
        ),
        child: ListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          leading: Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFFF7E3E), width: 1.5),
            ),
            child: entity.entityIcon != null && entity.entityIcon!.isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      entity.entityIcon!,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) =>
                          const Icon(Icons.business, color: Color(0xFFFF7E3E)),
                    ),
                  )
                : const Icon(Icons.business, color: Color(0xFFFF7E3E)),
          ),
          title: Text(
            entity.entityName ?? "",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              color: const Color(0xFFFF5200),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {
            Navigator.of(context).pop(); // Close drawer
            final currentFilter =
                context.read<PendingDocNavigationCubit>().state;
            context.read<PendingDocNavigationCubit>().selectCategory(
                  status: currentFilter.status,
                  entityId: entity.id,
                  groupId: entity.groupId,
                );
          },
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.only(bottom: 8.0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          leading: Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: entity.entityIcon != null && entity.entityIcon!.isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      entity.entityIcon!,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) =>
                          const Icon(Icons.business, color: Color(0xFF64748B)),
                    ),
                  )
                : const Icon(Icons.business, color: Color(0xFF64748B)),
          ),
          title: Text(
            entity.entityName ?? "",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              color: const Color(0xFF475569),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          onTap: () {
            Navigator.of(context).pop(); // Close drawer
            final currentFilter =
                context.read<PendingDocNavigationCubit>().state;
            context.read<PendingDocNavigationCubit>().selectCategory(
                  status: currentFilter.status,
                  entityId: entity.id,
                  groupId: entity.groupId,
                );
          },
        ),
      );
    }
  }
}
