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
  int? _expandedEntityId;

  @override
  void initState() {
    super.initState();
    _expandedEntityId = int.tryParse(widget.currentEntityId);

    // Only fetch if data is not already loaded.
    // PaymentSuccessful re-fetches after a purchase, so no need to re-call here.
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
                  _buildDashboardTile(
                      widget.currentEntityId == 'dashboard'),
                  const SizedBox(height: 8),

                  BlocBuilder<AllEntitiesCubit, AllEntitiesState>(
                    builder: (context, state) {
                      if (state is AllEntitiesLoadingState) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 24.0),
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Color(0xFFE28A17)),
                            ),
                          ),
                        );
                      } else if (state is AllEntitiesErrorState) {
                        if (state.message.toLowerCase().contains("no data found")) {
                          return const SizedBox();
                        }
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 24.0, horizontal: 16.0),
                            child: Text(
                              "Failed to load: ${state.message}",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.outfit(color: Colors.redAccent),
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
                            final isExpanded = _expandedEntityId == entity.id;

                            return _buildEntityItem(
                                entity, isCurrent, isExpanded);
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

  Widget _buildEntityItem(
      AllEntityData entity, bool isCurrent, bool isExpanded) {
    if (isCurrent) {
      // Active Expanded Highlight Card style
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
        child: Column(
          children: [
            ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              leading: Container(
                width: 40,
                height: 40,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: const Color(0xFFFF7E3E), width: 1.5),
                ),
                child: entity.entityIcon != null &&
                        entity.entityIcon!.isNotEmpty
                    ? ClipOval(
                        child: Image.network(
                          entity.entityIcon!,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => const Icon(Icons.business,
                              color: Color(0xFFFF7E3E)),
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
              // subtitle: entity.entityDescription != null &&
              //         entity.entityDescription!.isNotEmpty
              //     ? Padding(
              //         padding: const EdgeInsets.only(top: 4.0),
              //         child: Text(
              //           entity.entityDescription!,
              //           maxLines: 2,
              //           overflow: TextOverflow.ellipsis,
              //           style: GoogleFonts.outfit(
              //             color: const Color(0xFFFF7E3E).withOpacity(0.8),
              //             fontSize: 12,
              //             fontWeight: FontWeight.w400,
              //           ),
              //         ),
              //       )
              //     : null,
              trailing: Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: const Color(0xFFFF5200),
                size: 22,
              ),
              onTap: () {
                setState(() {
                  _expandedEntityId = isExpanded ? null : entity.id;
                });
              },
            ),
            if (isExpanded) ...[
              const SizedBox(height: 4),
              _buildSubStatusTile(
                label: "In-Progress",
                dotColor: const Color(0xFF6366F1),
                textColor: const Color(0xFF6366F1),
                onTap: () {
                  Navigator.of(context).pop();
                  context.read<PendingDocNavigationCubit>().selectCategory(
                        status: 'Pending',
                        entityId: entity.id,
                        groupId: entity.groupId,
                      );
                },
              ),
              _buildSubStatusTile(
                label: "Completed",
                dotColor: const Color(0xFF10B981),
                textColor: const Color(0xFF10B981),
                onTap: () {
                  Navigator.of(context).pop();
                  context.read<PendingDocNavigationCubit>().selectCategory(
                        status: 'Verified',
                        entityId: entity.id,
                        groupId: entity.groupId,
                      );
                },
              ),
              const SizedBox(height: 12),
            ]
          ],
        ),
      );
    } else {
      // Standard Unselected Item — expands on tap
      return Container(
        margin: const EdgeInsets.only(bottom: 8.0),
        decoration: BoxDecoration(
          color: isExpanded ? const Color(0xFFF8FAFC) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isExpanded ? const Color(0xFFE2E8F0) : Colors.transparent,
            width: 1.0,
          ),
        ),
        child: Column(
          children: [
            ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              leading: Container(
                width: 40,
                height: 40,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: isExpanded
                      ? const Color(0xFFE2E8F0)
                      : const Color(0xFFF1F5F9),
                  shape: BoxShape.circle,
                ),
                child: entity.entityIcon != null &&
                        entity.entityIcon!.isNotEmpty
                    ? ClipOval(
                        child: Image.network(
                          entity.entityIcon!,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => const Icon(Icons.business,
                              color: Color(0xFF64748B)),
                        ),
                      )
                    : const Icon(Icons.business, color: Color(0xFF64748B)),
              ),
              title: Text(
                entity.entityName ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  color: isExpanded
                      ? const Color(0xFF0F172A)
                      : const Color(0xFF475569),
                  fontSize: 15,
                  fontWeight: isExpanded ? FontWeight.bold : FontWeight.w600,
                ),
              ),
              // subtitle: entity.entityDescription != null &&
              //         entity.entityDescription!.isNotEmpty
              //     ? Padding(
              //         padding: const EdgeInsets.only(top: 4.0),
              //         child: Text(
              //           entity.entityDescription!,
              //           maxLines: 2,
              //           overflow: TextOverflow.ellipsis,
              //           style: GoogleFonts.outfit(
              //             color: const Color(0xFF64748B),
              //             fontSize: 12,
              //             fontWeight: FontWeight.w400,
              //           ),
              //         ),
              //       )
              //     : null,
              trailing: Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: isExpanded
                    ? const Color(0xFF64748B)
                    : const Color(0xFF94A3B8),
                size: 22,
              ),
              onTap: () {
                setState(() {
                  _expandedEntityId = isExpanded ? null : entity.id;
                });
              },
            ),

            // Expanded Status Sub-Items: In-Progress & Completed
            if (isExpanded) ...[
              const SizedBox(height: 4),
              _buildSubStatusTile(
                label: "In-Progress",
                dotColor: const Color(0xFF6366F1),
                textColor: const Color(0xFF6366F1),
                onTap: () {
                  Navigator.of(context).pop();
                  context.read<PendingDocNavigationCubit>().selectCategory(
                        status: 'Pending',
                        entityId: entity.id,
                        groupId: entity.groupId,
                      );
                },
              ),
              _buildSubStatusTile(
                label: "Completed",
                dotColor: const Color(0xFF10B981),
                textColor: const Color(0xFF10B981),
                onTap: () {
                  Navigator.of(context).pop();
                  context.read<PendingDocNavigationCubit>().selectCategory(
                        status: 'Verified',
                        entityId: entity.id,
                        groupId: entity.groupId,
                      );
                },
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      );
    }
  }

  Widget _buildSubStatusTile({
    required String label,
    required Color dotColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 64.0, right: 16.0, top: 4.0, bottom: 4.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: GoogleFonts.outfit(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
