import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../apiServices/api_services.dart';
import '../../../../commonComponent/bloc/shared_preferences_cubit.dart';
import '../../../../commonComponent/custom_button.dart';
import '../../Blocs/apply_coupon_bloc/apply_coupon_cubit.dart';
import '../../Blocs/apply_coupon_bloc/apply_coupon_state.dart';
import '../../Blocs/checkout_bloc/checkout_cubit.dart';
import '../../Blocs/checkout_bloc/checkout_state.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  List<Map<String, dynamic>> cartItems = [];
  double subtotal = 0.0;
  double gst = 0.0;
  double discount = 0.0;
  double grandTotal = 0.0;
  String? appliedCouponCode;
  final TextEditingController couponController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCartData();
  }

  Future<void> _loadCartData() async {
    final prefs = await SharedPreferences.getInstance();
    final cartDataStr = prefs.getString('checkout_cart');
    if (cartDataStr != null) {
      final List<dynamic> decoded = jsonDecode(cartDataStr);
      setState(() {
        cartItems = List<Map<String, dynamic>>.from(decoded);
      });
      _calculateLocalTotals();
      //  _calculateBackendTotals();
    }
  }

  void _calculateLocalTotals() {
    double localSubtotal = 0.0;
    for (var item in cartItems) {
      localSubtotal += double.tryParse(item['subtotal'].toString()) ?? 0.0;
    }
    setState(() {
      subtotal = localSubtotal;
      gst = localSubtotal * 0.18;
      grandTotal = localSubtotal + gst;
    });
  }

  void _calculateBackendTotals({String? couponCode}) {
    if (cartItems.isEmpty) return;

    final String token = context.read<TokenCubit>().state;

    // Transform cartItems to API format
    List<Map<String, dynamic>> apiItems = cartItems.map((item) {
      return {
        "entity_id": int.tryParse(item['entity_id'].toString()) ?? 0,
        "quantity": item['tenants_count'],
        "services": (item['checkout_list'] as List).map((s) {
          return {
            "service_id": int.tryParse(s['service_id'].toString()) ?? 0,
            "price": double.tryParse(s['price'].toString()) ?? 0.0,
          };
        }).toList(),
      };
    }).toList();

    context.read<ApplyCouponCubit>().applyCoupon(
          token: token,
          coupon_code: couponCode,
          items: apiItems,
        );
  }

  Future<void> _removeItem(int index) async {
    setState(() {
      cartItems.removeAt(index);
    });
    _calculateLocalTotals();
    //_calculateBackendTotals();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('checkout_cart', jsonEncode(cartItems));
  }

  void _handleCheckout() {
    final token = context.read<TokenCubit>().state;
    final customerIdStr = context.read<IdCubit>().state;
    final customerId = int.tryParse(customerIdStr) ?? 0;

    // Transform cartItems to the required format
    List<Map<String, dynamic>> apiItems = cartItems.map((item) {
      return {
        "entity_id": int.tryParse(item['entity_id'].toString()) ?? 0,
        "quantity": item['tenants_count'],
        "services": (item['checkout_list'] as List).map((s) {
          return {
            "service_id": int.tryParse(s['service_id'].toString()) ?? 0,
            "price": double.tryParse(s['price'].toString()) ?? 0.0,
          };
        }).toList(),
      };
    }).toList();

    context.read<CheckoutCubit>().checkout(
          token: token,
          customer_id: customerId,
          payment_gateway: "Zwitch",
          payment_mode: "Credit Card",
          coupon_code: appliedCouponCode,
          items: apiItems,
        );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<CheckoutCubit, CheckOutState>(
            listener: (context, checkoutState) {
              if (checkoutState is CheckOutSuccessState) {
                context.pushReplacementNamed("payment_success");
              } else if (checkoutState is CheckOutErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(checkoutState.errorMessage),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
        child: BlocConsumer<ApplyCouponCubit, ApplyCouponState>(
          listener: (context, state) {
            if (state is ApplyCouponSuccessState) {
              final result = state.applyCouponModel.result;
              if (result != null) {
                setState(() {
                  subtotal = double.tryParse(result.subtotal.toString()) ?? 0.0;
                  gst = double.tryParse(result.taxTotal.toString()) ?? 0.0;
                  grandTotal =
                      double.tryParse(result.finalAmount.toString()) ?? 0.0;
                  discount = double.tryParse(
                          result.discountApplied?.toString() ?? '0.0') ??
                      0.0;
                  appliedCouponCode = result.couponDetails?.couponCode;
                });
                if (result.couponDetails != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Coupon applied successfully!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              }
            } else if (state is ApplyCouponErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return Scaffold(
              backgroundColor: Colors.grey.shade50,
              appBar: AppBar(
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.transparent,
                scrolledUnderElevation: 0,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                  onPressed: () => context.pop(),
                ),
                title: Text(
                  "Checkout",
                  style: GoogleFonts.outfit(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
              ),
              body: Column(
                children: [
                  // ── Cart list ──
                  Expanded(
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, top: 16, bottom: 8),
                      children: [
                        Text(
                          "Review Services",
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...cartItems.asMap().entries.map((entry) {
                          int index = entry.key;
                          var item = entry.value;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['entity_name'] ?? 'Entity',
                                        style: GoogleFonts.outfit(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${item['tenants_count']} person(s) • ${item['services_count']} services",
                                        style: GoogleFonts.outfit(
                                          color: Colors.grey.shade600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Row(
                                  children: [
                                    CustomButton(
                                      onTap: () async {
                                        final entityId =
                                            item['entity_id']?.toString() ?? '';
                                        if (entityId.isNotEmpty) {
                                          final cartItemId =
                                              item['cart_item_id']
                                                      ?.toString() ??
                                                  '';
                                          await context.pushNamed(
                                            'servicesAndPrice',
                                            pathParameters: {'id': entityId},
                                            queryParameters: {
                                              'isEdit': 'true',
                                              'cartItemId': cartItemId
                                            },
                                          );
                                          _loadCartData();
                                        }
                                      },
                                      prefixIcon: Icons.edit,
                                      iconColor: Colors.orange,
                                      iconSize: 14,
                                      text: "Edit",
                                      width: 80,
                                      height: 32,
                                      borderColor: Colors.orange.shade300,
                                      borderWidth: 1,
                                      gradientColors: const [
                                        Colors.transparent,
                                        Colors.transparent,
                                      ],
                                      textStyle: GoogleFonts.outfit(
                                        fontSize: 14,
                                        color: Colors.orange,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    CustomButton(
                                      onTap: () => _removeItem(index),
                                      prefixIcon: Icons.delete,
                                      iconColor: Colors.red,
                                      iconSize: 14,
                                      text: "Delete",
                                      width: 90,
                                      height: 32,
                                      borderColor: Colors.red.shade300,
                                      borderWidth: 1,
                                      gradientColors: const [
                                        Colors.transparent,
                                        Colors.transparent,
                                      ],
                                      textStyle: GoogleFonts.outfit(
                                        fontSize: 14,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        }).toList(),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: CustomButton(
                            onTap: () => context.go('/bottomNav'),
                            text: "+ Add More",
                            width: 140,
                            height: 40,
                            gradientColors: [
                              Theme.of(context).primaryColor,
                              Theme.of(context).primaryColorLight,
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: // ── Fixed price summary panel ──
                  Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 12,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Price Breakdown",
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Subtotal",
                            style: GoogleFonts.outfit(
                                fontSize: 16, color: Colors.grey.shade600)),
                        Text("₹${subtotal.toStringAsFixed(2)}",
                            style: GoogleFonts.outfit(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (appliedCouponCode != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green.shade100),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Applied: $appliedCouponCode",
                              style: GoogleFonts.outfit(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  appliedCouponCode = null;
                                  discount = 0;
                                  couponController.clear();
                                });
                                _calculateLocalTotals();
                              },
                              child: Text(
                                "Remove",
                                style: GoogleFonts.outfit(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Discount",
                            style: GoogleFonts.outfit(
                                fontSize: 16, color: Colors.green)),
                        Text("- ₹${discount.toStringAsFixed(2)}",
                            style: GoogleFonts.outfit(
                                fontSize: 16,
                                color: Colors.green,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("GST (18%)",
                            style: GoogleFonts.outfit(
                                fontSize: 16, color: Colors.grey.shade600)),
                        Text("₹${gst.toStringAsFixed(2)}",
                            style: GoogleFonts.outfit(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(thickness: 1.5),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total",
                            style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColorLight)),
                        Text("₹${grandTotal.toStringAsFixed(2)}",
                            style: GoogleFonts.outfit(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColorLight)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (appliedCouponCode == null) ...[
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: couponController,
                              decoration: InputDecoration(
                                hintText: "Enter Coupon Code",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          CustomButton(
                            onTap: () {
                              if (couponController.text.isNotEmpty) {
                                _calculateBackendTotals(
                                    couponCode: couponController.text);
                              }
                            },
                            text: state is ApplyCouponLoadingState
                                ? "..."
                                : "Apply",
                            width: 100,
                            height: 48,
                            gradientColors: [
                              Theme.of(context).primaryColor,
                              Theme.of(context).primaryColorLight,
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                    BlocBuilder<CheckoutCubit, CheckOutState>(
                      builder: (context, checkoutState) {
                        return CustomButton(
                          onTap: () {
                            if (checkoutState is! CheckOutLoadingState) {
                              _handleCheckout();
                            }
                          },
                          text: checkoutState is CheckOutLoadingState
                              ? "Processing..."
                              : "Checkout ₹${grandTotal.toStringAsFixed(2)}",
                          width: double.infinity,
                          height: 54,
                          gradientColors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).primaryColorLight,
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }
}
