import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:v_verify/screen/ServicesAndPrice/Blocs/all_entities_bloc/all_entities_cubit.dart';
import 'dart:convert';
import 'package:v_verify/screen/ServicesAndPrice/Blocs/chechout_status_checking_bloc/checkout_status_checking_cubit.dart';
import 'package:v_verify/screen/ServicesAndPrice/Blocs/chechout_status_checking_bloc/checkout_status_checking_state.dart';
import 'package:v_verify/screen/ServicesAndPrice/Blocs/checkout_bloc/checkout_cubit.dart';
import 'package:v_verify/screen/ServicesAndPrice/Blocs/checkout_bloc/checkout_state.dart';
import 'package:v_verify/screen/VerificationPending/Pagination/DashBoard/bloc/dashboard_count_bloc.dart';
import 'package:v_verify/screen/VerificationPending/Pagination/DashBoard/bloc/dashboard_entities_cubit.dart';
import 'package:v_verify/services/phonepe_payment_gateway_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../commonComponent/bloc/shared_preferences_cubit.dart';
import '../../../commonComponent/custom_button.dart';
import '../../Home screen/bloc/home_screnn_cubit.dart';
import 'package:v_verify/screen/ServicesAndPrice/Blocs/service_prices_bloc/service_prices_cubit.dart';
import 'package:v_verify/screen/ServicesAndPrice/Blocs/service_prices_bloc/service_prices_state.dart';
import 'package:v_verify/screen/ServicesAndPrice/Models/service_prices_model.dart';

class ServicesAndPrice extends StatefulWidget {
  final String entity_id;
  final bool isEdit;
  final String? cartItemId;
  ServicesAndPrice({
    super.key,
    required this.entity_id,
    this.isEdit = false,
    this.cartItemId,
  });

  @override
  State<ServicesAndPrice> createState() => _WhatToVerifyState();
}

class _WhatToVerifyState extends State<ServicesAndPrice> {
  bool isDarkMode = false;

  Color get slateBg =>
      isDarkMode ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC);
  Color get slateCard => isDarkMode ? const Color(0xFF131B2E) : Colors.white;
  Color get amberOrange => const Color(0xFFE28A17);
  Color get unselectedOutline =>
      isDarkMode ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0);
  Color get primaryText => isDarkMode ? Colors.white : const Color(0xFF0F172A);
  Color get secondaryText =>
      isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF64748B);
  Color get currentCloseBg =>
      isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
  Color get currentQtyBorder =>
      isDarkMode ? const Color(0xFF334155) : const Color(0xFFCBD5E1);

  double totalPrice = 0.0;
  List<Map<String, dynamic>> addList = [];
  List<Map<String, dynamic>> checkoutList = [];
  List<int> addItem = [];

  double subtotal = 0.0;
  double grandTotal = 0.0;
  Set<int> expandedIndices = {};
  bool isComboSelected = false;
  bool _initializedSelections = false;

  late PhonePeService phonePeService;

  @override
  void initState() {
    getServices();
    if (widget.isEdit) {
      _loadExistingCartItem();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<CountCubit>().setCount(1);
      });
    }
    super.initState();
    phonePeService = PhonePeService();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await phonePeService.initializeSDK();
    });
  }

  void getServices() {
    final String token = context.read<TokenCubit>().state;
    final String typeId = context.read<UserTypeId>().state;
    context.read<ServicePriceCubit>().getServicePrice(
          token: token,
          type_id: typeId,
          entity_id: widget.entity_id,
        );
  }

  void _recalculatePrices(ServicePriceModel model, int tenantsCount) {
    if (isComboSelected) {
      double baseComboPrice =
          double.tryParse(model.discountPrice ?? "90.0") ?? 90.0;
      final comboIds = model.suggestionCombos?.map((c) => c.id).toSet() ?? {};
      double extraPrice = 0.0;
      for (var item in checkoutList) {
        final id = int.tryParse(item['service_id'].toString());
        if (id != null && !comboIds.contains(id)) {
          extraPrice += double.tryParse(item['price'].toString()) ?? 0.0;
        }
      }
      totalPrice = baseComboPrice + extraPrice;
    } else {
      totalPrice = 0.0;
      for (var item in checkoutList) {
        totalPrice += double.tryParse(item['price'].toString()) ?? 0.0;
      }
    }
    subtotal = totalPrice * tenantsCount;
    grandTotal = subtotal;
  }

  void _initializeDefaultSelections(ServicePriceModel model) {
    if (_initializedSelections) return;
    _initializedSelections = true;

    if (widget.isEdit) {
      final comboIds = model.suggestionCombos?.map((c) => c.id).toSet() ?? {};
      final selectedIds = checkoutList
          .map((e) => int.tryParse(e['service_id'].toString()))
          .toSet();
      isComboSelected = comboIds.isNotEmpty &&
          selectedIds.length == comboIds.length &&
          selectedIds.every((id) => comboIds.contains(id));
      _recalculatePrices(model, context.read<CountCubit>().state);
      return;
    }

    isComboSelected = false;
    checkoutList.clear();
    _recalculatePrices(model, context.read<CountCubit>().state);
  }

  Future<void> _loadExistingCartItem() async {
    if (widget.cartItemId == null) return;

    final prefs = await SharedPreferences.getInstance();
    final cartStr = prefs.getString('checkout_cart');
    if (cartStr != null) {
      final List<dynamic> decoded = jsonDecode(cartStr);
      final currentCart = List<Map<String, dynamic>>.from(decoded);

      final index = currentCart
          .indexWhere((item) => item['cart_item_id'] == widget.cartItemId);
      if (index != -1) {
        final existingItem = currentCart[index];
        final List<dynamic> savedCheckoutList =
            existingItem['checkout_list'] ?? [];

        setState(() {
          checkoutList = List<Map<String, dynamic>>.from(savedCheckoutList);
          addItem = checkoutList
              .map((e) => int.parse(e['service_id'].toString()))
              .toList();
        });

        if (mounted) {
          final count = existingItem['tenants_count'] ?? 1;
          context.read<CountCubit>().setCount(count);
          setState(() {});
        }
      }
    }
  }

  Future<void> _addToCartAndNavigate(String entityName) async {
    final tenantsCount = context.read<CountCubit>().state;
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> currentCart = [];
    final cartStr = prefs.getString('checkout_cart');
    if (cartStr != null) {
      currentCart = List<Map<String, dynamic>>.from(jsonDecode(cartStr));
    }

    final newItem = {
      'cart_item_id': widget.isEdit && widget.cartItemId != null
          ? widget.cartItemId
          : DateTime.now().millisecondsSinceEpoch.toString(),
      'entity_id': widget.entity_id,
      'entity_name': entityName,
      'tenants_count': tenantsCount,
      'services_count': checkoutList.length,
      'subtotal': subtotal,
      'checkout_list': checkoutList,
    };

    if (widget.isEdit && widget.cartItemId != null) {
      final index = currentCart
          .indexWhere((item) => item['cart_item_id'] == widget.cartItemId);
      if (index != -1) {
        currentCart[index] = newItem;
      } else {
        currentCart.add(newItem);
      }
    } else {
      currentCart.add(newItem);
    }
    await prefs.setString('checkout_cart', jsonEncode(currentCart));

    if (mounted) {
      if (widget.isEdit) {
        context.pop();
      } else {
        context.pushNamed("checkOut");
      }
    }
  }

  void _showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 20.0,
                  offset: Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.construction_rounded,
                    color: Colors.orange.shade600,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "Coming Soon",
                  style: GoogleFonts.outfit(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "This service is currently under development and will be available soon. Thank you for your patience.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    text: "Got it",
                    gradientColors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColorLight,
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAadhaarConsentDialog(BuildContext context, VoidCallback onAgree) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(28),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 20.0,
                  offset: Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFEBD8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.fingerprint,
                    color: Color(0xFFFF7043),
                    size: 48,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "CONSENT REQUIRED",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF101828),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "AADHAAR VERIFICATION ACCESS",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFF79009),
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 24),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      color: const Color(0xFF475467),
                      height: 1.5,
                    ),
                    children: const [
                      TextSpan(
                          text:
                              "To proceed with secure Aadhaar verification via "),
                      TextSpan(
                        text: "DigiLocker",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(text: ", you will be required to provide the "),
                      TextSpan(
                        text: "Aadhaar number",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(text: ", the "),
                      TextSpan(
                        text: "OTP",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(
                          text:
                              " sent to the registered mobile number, and the "),
                      TextSpan(
                        text: "6-digit security MPIN",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(text: "."),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    onTap: () {
                      Navigator.of(context).pop();
                      onAgree();
                    },
                    text: "YES, I AGREE",
                    gradientColors: const [
                      Color(0xFFFF4D2D),
                      Color(0xFFFF9D42),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _toggleComboCard(
      bool select, ServicePriceModel model, int tenantsCount) {
    setState(() {
      isComboSelected = select;
      checkoutList.clear();
      if (select) {
        if (model.suggestionCombos != null) {
          for (var item in model.suggestionCombos!) {
            checkoutList.add({
              'service_id': item.id,
              'price': item.servicePrice,
            });
          }
        }
      }
      _recalculatePrices(model, tenantsCount);
    });
  }

  void _toggleServiceSelection(
      Datum item, ServicePriceModel model, int tenantsCount) {
    setState(() {
      final isSelected = checkoutList.any((e) => e['service_id'] == item.id);
      final comboIds = model.suggestionCombos?.map((c) => c.id).toSet() ?? {};

      if (isSelected) {
        checkoutList.removeWhere((e) => e['service_id'] == item.id);
      } else {
        if (isComboSelected) {
          isComboSelected = false;
        }

        checkoutList.add({
          'service_id': item.id,
          'price': item.servicePrice,
        });
      }

      final selectedIds = checkoutList
          .map((e) => int.tryParse(e['service_id'].toString()))
          .toSet();
      if (comboIds.isNotEmpty &&
          selectedIds.length == comboIds.length &&
          comboIds.every((id) => selectedIds.contains(id))) {
        isComboSelected = true;
      } else {
        isComboSelected = false;
      }
      _recalculatePrices(model, tenantsCount);
    });
  }

  Widget _buildCustomCheckbox({required bool isChecked, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: isChecked ? amberOrange : Colors.transparent,
          border: Border.all(
            color: isChecked
                ? amberOrange
                : (isDarkMode
                    ? const Color(0xFF475569)
                    : const Color(0xFFCBD5E1)),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: isChecked
            ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 16,
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CountCubit, int>(
      builder: (context, tenantsCount) {
        return BlocBuilder<ServicePriceCubit, ServicePriceState>(
          builder: (context, servicePrice) {
            ServicePriceModel? modelData;
            if (servicePrice is ServicePriceSuccess) {
              modelData = servicePrice.servicePriceModel;
              _initializeDefaultSelections(modelData);
            }

            return Scaffold(
              backgroundColor: slateBg,
              appBar: AppBar(
                backgroundColor: slateBg,
                elevation: 0,
                scrolledUnderElevation: 0,
                automaticallyImplyLeading: false,
                leading: IconButton(
                  onPressed: () => context.pop(),
                  icon: Icon(
                    Icons.arrow_back,
                    color: primaryText,
                  ),
                ),
                titleSpacing: 0,
                title: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Pick Checks",
                        style: GoogleFonts.outfit(
                          color: primaryText,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Quantity Selector Container
                      Container(
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: currentQtyBorder, width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              constraints: const BoxConstraints(),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              onPressed: () {
                                context.read<CountCubit>().countRemove();
                                if (modelData != null) {
                                  setState(() {
                                    _recalculatePrices(modelData!,
                                        context.read<CountCubit>().state);
                                  });
                                }
                              },
                              icon: Icon(Icons.remove,
                                  size: 16, color: primaryText),
                            ),
                            Text(
                              tenantsCount.toString(),
                              style: GoogleFonts.outfit(
                                color: primaryText,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              constraints: const BoxConstraints(),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              onPressed: () {
                                context.read<CountCubit>().countAdd();
                                if (modelData != null) {
                                  setState(() {
                                    _recalculatePrices(modelData!,
                                        context.read<CountCubit>().state);
                                  });
                                }
                              },
                              icon:
                                  Icon(Icons.add, size: 16, color: primaryText),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    if (servicePrice is ServicePriceLoading)
                      Expanded(
                        child: Skeletonizer(
                          enabled: true,
                          child: ListView.builder(
                            itemCount: 4,
                            itemBuilder: (context, index) {
                              return Container(
                                height: 80,
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: slateCard,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    else if (servicePrice is ServicePriceError)
                      const Expanded(
                        child: Center(
                          child: Text(
                            "Failed to load services. Please try again.",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      )
                    else if (servicePrice is ServicePriceSuccess &&
                        modelData != null)
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.only(bottom: 100),
                          children: [
                            // Suggested Combo Title
                            Text(
                              "Suggested Combo",
                              style: GoogleFonts.outfit(
                                color: secondaryText,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Suggested Combo Card
                            GestureDetector(
                              onTap: () => _toggleComboCard(
                                  !isComboSelected, modelData!, tenantsCount),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: slateCard,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isComboSelected
                                        ? amberOrange
                                        : unselectedOutline,
                                    width: 1.5,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              _buildCustomCheckbox(
                                                isChecked: isComboSelected,
                                                onTap: () => _toggleComboCard(
                                                    !isComboSelected,
                                                    modelData!,
                                                    tenantsCount),
                                              ),
                                              const SizedBox(width: 12),
                                              Text(
                                                "Suggested Combo",
                                                style: GoogleFonts.outfit(
                                                  color: primaryText,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          // Prices Display
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: currentCloseBg,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "₹${modelData.actualPrice ?? '100'}",
                                                  style: GoogleFonts.outfit(
                                                    color:
                                                        const Color(0xFF64748B),
                                                    fontSize: 13,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  "₹${modelData.discountPrice ?? '90'}",
                                                  style: GoogleFonts.outfit(
                                                    color:
                                                        const Color(0xFF10B981),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        modelData.suggestionCombos
                                                ?.map((c) => c.serviceTitle)
                                                .join(", ") ??
                                            "",
                                        style: GoogleFonts.outfit(
                                          color: secondaryText,
                                          fontSize: 13,
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Select Required Services Title
                            Text(
                              "Select Required Services",
                              style: GoogleFonts.outfit(
                                color: secondaryText,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Scrollable list of individual services
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: modelData.data?.length ?? 0,
                              itemBuilder: (context, index) {
                                final item = modelData!.data![index];
                                final isSelected = checkoutList
                                    .any((e) => e['service_id'] == item.id);
                                final isExpanded =
                                    expandedIndices.contains(index);

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    color: slateCard,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isSelected
                                          ? amberOrange
                                          : unselectedOutline,
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (item.isDeveloped == 0) {
                                            _showComingSoonDialog(context);
                                            return;
                                          }
                                          _toggleServiceSelection(
                                              item, modelData!, tenantsCount);
                                        },
                                        borderRadius: BorderRadius.circular(16),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0, vertical: 12.0),
                                          child: Row(
                                            children: [
                                              _buildCustomCheckbox(
                                                isChecked: isSelected,
                                                onTap: () {
                                                  if (item.isDeveloped == 0) {
                                                    _showComingSoonDialog(
                                                        context);
                                                    return;
                                                  }
                                                  _toggleServiceSelection(item,
                                                      modelData!, tenantsCount);
                                                },
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Text(
                                                  item.serviceTitle ?? "",
                                                  style: GoogleFonts.outfit(
                                                    color: item.isDeveloped == 0
                                                        ? const Color(
                                                            0xFF64748B)
                                                        : primaryText,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              if (item.isDeveloped == 0)
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: isDarkMode
                                                        ? const Color(
                                                            0xFF292524)
                                                        : const Color(
                                                            0xFFFEF3C7),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    border: Border.all(
                                                        color: isDarkMode
                                                            ? const Color(
                                                                0xFF44403C)
                                                            : const Color(
                                                                0xFFFDE68A)),
                                                  ),
                                                  child: Text(
                                                    "Coming Soon",
                                                    style: GoogleFonts.outfit(
                                                      color: Colors.amber,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                )
                                              else
                                                Text(
                                                  "₹${item.servicePrice}",
                                                  style: GoogleFonts.outfit(
                                                    color: primaryText,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              const SizedBox(width: 4),
                                              IconButton(
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(),
                                                onPressed: () {
                                                  setState(() {
                                                    if (isExpanded) {
                                                      expandedIndices
                                                          .remove(index);
                                                    } else {
                                                      expandedIndices
                                                          .add(index);
                                                    }
                                                  });
                                                },
                                                icon: Icon(
                                                  isExpanded
                                                      ? Icons.keyboard_arrow_up
                                                      : Icons
                                                          .keyboard_arrow_down,
                                                  color: secondaryText,
                                                  size: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      if (isExpanded)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 52, right: 16, bottom: 12),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              item.serviceDescription ?? "",
                                              style: GoogleFonts.outfit(
                                                color: secondaryText,
                                                fontSize: 13,
                                                height: 1.4,
                                              ),
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
              ),
              bottomSheet: (servicePrice is ServicePriceSuccess &&
                      modelData != null)
                  ? BlocListener<CheckOutStatusCheckingCubit,
                      CheckoutStatusCheckingState>(
                      listener: (context, statusState) {
                        if (statusState is CheckoutStatusCheckingErrorState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(statusState.message),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                        if (statusState is CheckoutStatusCheckingSuccessState) {
                          SharedPreferences.getInstance().then((prefs) {
                            prefs.remove('checkout_cart');
                          });

                          // Refresh all entities and dashboard metrics on payment success
                          final token = context.read<TokenCubit>().state;
                          final customerId = context.read<IdCubit>().state;
                          context.read<AllEntitiesCubit>().getAllEntities(
                              token: token, customer_id: customerId);
                          context
                              .read<DashboardEntitiesCubit>()
                              .getDashboardEntities(
                                  token: token, customerId: customerId);
                          context.read<DashboardCountBloc>().getDashboardCount(
                              token: token, customerId: customerId);

                          context.pushReplacementNamed("payment_success");
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Payment successful"),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                      child: BlocBuilder<CheckoutCubit, CheckOutState>(
                        builder: (context, checkout) {
                          return SafeArea(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: slateBg,
                                border: Border(
                                  top: BorderSide(
                                      color: unselectedOutline, width: 1),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: SizedBox(
                                      height: 52,
                                      child: CustomButton(
                                        isLoading:
                                            checkout is CheckOutLoadingState,
                                        onTap: () {
                                          if (checkoutList.isEmpty) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    "Please select services"),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          } else {
                                            bool hasAadhaarSelected = false;
                                            if (modelData?.data != null) {
                                              for (var item
                                                  in modelData!.data!) {
                                                final isSelected =
                                                    checkoutList.any((e) =>
                                                        e['service_id'] ==
                                                        item.id);
                                                if (isSelected &&
                                                    item.serviceTitle != null &&
                                                    item.serviceTitle!
                                                        .toLowerCase()
                                                        .contains("aadhaar")) {
                                                  hasAadhaarSelected = true;
                                                  break;
                                                }
                                              }
                                            }

                                            if (hasAadhaarSelected) {
                                              _showAadhaarConsentDialog(context,
                                                  () {
                                                _addToCartAndNavigate(
                                                  modelData!
                                                      .data![0].serviceTitle
                                                      .toString(),
                                                );
                                              });
                                            } else {
                                              _addToCartAndNavigate(
                                                modelData!.data![0].serviceTitle
                                                    .toString(),
                                              );
                                            }
                                          }
                                        },
                                        text:
                                            "Confirm  ($tenantsCount × ₹${totalPrice.toStringAsFixed(0)} = ₹${grandTotal.toStringAsFixed(0)})",
                                        gradientColors: [
                                          Theme.of(context).primaryColor,
                                          Theme.of(context).primaryColorDark,
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(
                                      height: 52,
                                      child: OutlinedButton(
                                        onPressed: () => context.pop(),
                                        style: OutlinedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          side: BorderSide(
                                              color: isDarkMode
                                                  ? const Color(0xFF475569)
                                                  : const Color(0xFFCBD5E1),
                                              width: 1),
                                          backgroundColor: Colors.transparent,
                                        ),
                                        child: Text(
                                          "Cancel",
                                          style: GoogleFonts.outfit(
                                            color: primaryText,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : null,
            );
          },
        );
      },
    );
  }
}
