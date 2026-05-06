import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'dart:convert';
import 'package:v_verify/screen/ServicesAndPrice/Blocs/chechout_status_checking_bloc/checkout_status_checking_cubit.dart';
import 'package:v_verify/screen/ServicesAndPrice/Blocs/chechout_status_checking_bloc/checkout_status_checking_state.dart';
import 'package:v_verify/screen/ServicesAndPrice/Blocs/checkout_bloc/checkout_cubit.dart';
import 'package:v_verify/screen/ServicesAndPrice/Blocs/checkout_bloc/checkout_state.dart';
import 'package:v_verify/services/phonepe_payment_gateway_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../commonComponent/bloc/shared_preferences_cubit.dart';
import '../../../commonComponent/custom_button.dart';
import '../../../commonComponent/screen_size.dart';
import '../../Home screen/bloc/home_screnn_cubit.dart';
import '../../VerificationPending/bloc/pendingDoc_cubit.dart';
import '../Blocs/service_prices_bloc/service_prices_cubit.dart';
import '../Blocs/service_prices_bloc/service_prices_state.dart';
import '../Models/service_prices_model.dart';

class ServicesAndPrice extends StatefulWidget {
  String entity_id;
  final bool isEdit;
  final String? cartItemId;
  ServicesAndPrice(
      {super.key,
      required this.entity_id,
      this.isEdit = false,
      this.cartItemId});

  @override
  State<ServicesAndPrice> createState() => _WhatToVerifyState();
}

class _WhatToVerifyState extends State<ServicesAndPrice> {
  double totalPrice = 0.0;
  List<Map<String, dynamic>> addList = [];
  List<Map<String, dynamic>> checkoutList = [];

  late PhonePeService phonePeService;

  List<int> addItem = [];

  // Add these variables for price calculations
  double subtotal = 0.0;
  double grandTotal = 0.0;
  Set<int> expandedIndices = {};

  @override
  void initState() {
    getServices();
    if (widget.isEdit) {
      _loadExistingCartItem();
    } else {
      // Reset count to 1 for fresh selection
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<CountCubit>().setCount(1);
      });
    }
    super.initState();
    // Initialize PhonePeService
    phonePeService = PhonePeService();

    // Initialize SDK
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await phonePeService.initializeSDK();
    });
  }

  void getServices() {
    final String token = context.read<TokenCubit>().state;
    final String typeId = context.read<UserTypeId>().state;
    context.read<ServicePriceCubit>().getServicePrice(
        token: token, type_id: typeId, entity_id: widget.entity_id);
  }

  void calculatePrices(int tenantsCount) {
    // Calculate subtotal (price of all selected services * number of tenants)
    subtotal = totalPrice * tenantsCount;
    grandTotal = subtotal;
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

          totalPrice = 0.0;
          for (var item in checkoutList) {
            totalPrice += double.parse(item['price'].toString());
          }
        });

        if (mounted) {
          final count = existingItem['tenants_count'] ?? 1;
          context.read<CountCubit>().setCount(count);
          calculatePrices(count);
          setState(() {});
        }
      }
    }
  }

  Future<void> _addToCartAndNavigate(String entityName) async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> currentCart = [];
    final cartStr = prefs.getString('checkout_cart');
    if (cartStr != null) {
      currentCart = List<Map<String, dynamic>>.from(jsonDecode(cartStr));
    }

    // Add the current selection
    final newItem = {
      'cart_item_id': widget.isEdit && widget.cartItemId != null
          ? widget.cartItemId
          : DateTime.now().millisecondsSinceEpoch.toString(),
      'entity_id': widget.entity_id,
      'entity_name': entityName,
      'tenants_count': context.read<CountCubit>().state,
      'services_count': checkoutList.length,
      'subtotal': subtotal,
      'checkout_list': checkoutList,
    };

    if (widget.isEdit && widget.cartItemId != null) {
      // Replace only the specific item being edited
      final index = currentCart
          .indexWhere((item) => item['cart_item_id'] == widget.cartItemId);
      if (index != -1) {
        currentCart[index] = newItem;
      } else {
        currentCart.add(newItem);
      }
    } else {
      // Always add as a new item when coming from Home (or fresh selection)
      currentCart.add(newItem);
    }
    await prefs.setString('checkout_cart', jsonEncode(currentCart));

    if (mounted) {
      context.pushNamed("checkOut");
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

  @override
  Widget build(BuildContext context) {
    int tenantsCount = context.read<CountCubit>().state;

    // Calculate prices whenever build is called
    calculatePrices(tenantsCount);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Quantity Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text("Configure Verification",
                  style: Theme.of(context).textTheme.titleMedium),
            ),
            BlocBuilder<CountCubit, int>(
              builder: (context, count) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Verification Details",
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Quantity",
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                context.read<CountCubit>().countRemove();
                                setState(() {
                                  calculatePrices(
                                      context.read<CountCubit>().state);
                                });
                              },
                              icon: const Icon(Icons.remove, size: 20),
                            ),
                            Text(
                              count.toString(),
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                context.read<CountCubit>().countAdd();
                                setState(() {
                                  calculatePrices(
                                      context.read<CountCubit>().state);
                                });
                              },
                              icon: const Icon(Icons.add, size: 20),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Select Required Services",
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Verification Options List
            BlocBuilder<ServicePriceCubit, ServicePriceState>(
                builder: (context, servicePrice) {
              if (servicePrice is ServicePriceLoading) {
                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 20),
                    shrinkWrap: true,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        child: Skeletonizer(
                          enabled: true,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Container(
                                      height: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    width: 40,
                                    height: 15,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    width: 24,
                                    height: 24,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else if (servicePrice is ServicePriceError) {
                return const Center(
                  child: Text("error..."),
                );
              } else if (servicePrice is ServicePriceSuccess) {
                ServicePriceModel data = servicePrice.servicePriceModel;

                return Expanded(
                  child: ListView.builder(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 20),
                    itemCount: data.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = data.data![index];
                      final isSelected =
                          checkoutList.any((e) => e['service_id'] == item.id);
                      final isExpanded = expandedIndices.contains(index);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.grey.shade200,
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
                                setState(() {
                                  if (isSelected) {
                                    addItem.remove(index);
                                    addList.removeWhere(
                                        (map) => map.containsValue(index));
                                    checkoutList.removeWhere(
                                        (map) => map.containsValue(item.id));
                                    totalPrice -= double.parse(
                                        item.servicePrice.toString());
                                  } else {
                                    addItem.add(index);
                                    addList.add({'index': index});
                                    checkoutList.add({
                                      'service_id': item.id,
                                      "price": item.servicePrice
                                    });
                                    totalPrice += double.parse(
                                        item.servicePrice.toString());
                                  }
                                  calculatePrices(tenantsCount);
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: Checkbox(
                                        value: isSelected,
                                        onChanged: (value) {
                                          if (item.isDeveloped == 0) {
                                            _showComingSoonDialog(context);
                                            return;
                                          }
                                          // Toggle logic same as onTap
                                          setState(() {
                                            if (isSelected) {
                                              addItem.remove(index);
                                              addList.removeWhere((map) =>
                                                  map.containsValue(index));
                                              checkoutList.removeWhere((map) =>
                                                  map.containsValue(item.id));
                                              totalPrice -= double.parse(
                                                  item.servicePrice.toString());
                                            } else {
                                              addItem.add(index);
                                              addList.add({'index': index});
                                              checkoutList.add({
                                                'service_id': item.id,
                                                "price": item.servicePrice
                                              });
                                              totalPrice += double.parse(
                                                  item.servicePrice.toString());
                                            }
                                            calculatePrices(tenantsCount);
                                          });
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        activeColor:
                                            Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        item.serviceTitle ?? "",
                                        style: GoogleFonts.outfit(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: item.isDeveloped == 0
                                              ? Colors.grey
                                              : Colors.black87,
                                        ),
                                      ),
                                    ),
                                    if (item.isDeveloped == 0)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.orange.shade50,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: Border.all(
                                              color: Colors.orange.shade200),
                                        ),
                                        child: Text(
                                          "Coming Soon",
                                          style: GoogleFonts.outfit(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.orange.shade800,
                                          ),
                                        ),
                                      )
                                    else
                                      Text(
                                        "₹${item.servicePrice}",
                                        style: GoogleFonts.outfit(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          if (isExpanded) {
                                            expandedIndices.remove(index);
                                          } else {
                                            expandedIndices.add(index);
                                          }
                                        });
                                      },
                                      icon: Icon(
                                        isExpanded
                                            ? Icons.keyboard_arrow_up
                                            : Icons.keyboard_arrow_down,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (isExpanded)
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 48, right: 16, bottom: 12),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    item.serviceDescription ?? "",
                                    style: GoogleFonts.outfit(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
              return const Center(
                child: Text("Error"),
              );
            }),
            const SizedBox(height: 160),
          ],
        ),
      ),
      bottomSheet: BlocBuilder<ServicePriceCubit, ServicePriceState>(
        builder: (context, servicePrice) {
          if (servicePrice is ServicePriceLoading) {
            return Skeletonizer(
              enabled: true,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                width: 100, height: 18, color: Colors.white),
                            const SizedBox(height: 4),
                            Container(
                                width: 60, height: 14, color: Colors.white),
                          ],
                        ),
                        Container(width: 80, height: 24, color: Colors.white),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Container(height: 50, color: Colors.white)),
                        const SizedBox(width: 12),
                        Expanded(
                            flex: 1,
                            child: Container(height: 50, color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else if (servicePrice is ServicePriceError) {
            return const Center(
              child: Text("error..."),
            );
          } else if (servicePrice is ServicePriceSuccess) {
            ServicePriceModel data = servicePrice.servicePriceModel;

            return BlocListener<CheckOutStatusCheckingCubit,
                CheckoutStatusCheckingState>(
              listener: (context, statusState) {
                if (statusState is CheckoutStatusCheckingErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(statusState.message)));
                }
                if (statusState is CheckoutStatusCheckingSuccessState) {
                  // Navigate to success screen
                  context.pushReplacementNamed("payment_success");
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Payment successful")));
                }
              },
              child: BlocConsumer<CheckoutCubit, CheckOutState>(
                listener: (context, checkout) async {
                  if (checkout is CheckOutSuccessState) {
                    final paymentOrderId =
                        checkout.checkoutModel.transaction!.txnId!;
                    final orderId = checkout
                        .checkoutModel.transaction!.paymentData!.orderId!;
                    final token =
                        checkout.checkoutModel.transaction!.paymentData!.token!;
                    final amount = checkout.checkoutModel.finalTotal;

                    // Convert amount from int? to double
                    final doubleAmount = amount?.toDouble();

                    print('Starting PhonePe Payment:');
                    print('Order ID: $orderId');
                    print('Token: ${token}');
                    print('Amount: ₹$doubleAmount');

                    // Call instance method (not static)
                    final response = await phonePeService.startTransaction(
                      orderId: orderId,
                      token: token,
                      appSchema: 'vverify', // Your app URL scheme
                      // amount: doubleAmount ?? 0.0, // Pass as double
                    );

                    // Handle the response
                    phonePeService.handlePaymentResponse(
                      response,
                      context,
                      (isSuccess) {
                        if (isSuccess) {
                          final String token = context.read<TokenCubit>().state;
                          context
                              .read<CheckOutStatusCheckingCubit>()
                              .checkoutStatusChecking(
                                  token: token,
                                  payment_order_id: paymentOrderId);
                        } else {
                          // Handle payment failure
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "Payment failed. Please try again.")));
                        }
                      },
                    );
                  } else if (checkout is CheckOutErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(checkout.errorMessage)));
                  }
                },
                builder: (context, checkout) {
                  return SafeArea(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, -5),
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Total Amount",
                                    style: GoogleFonts.outfit(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    "$tenantsCount x ₹${totalPrice.toStringAsFixed(0)}",
                                    style: GoogleFonts.outfit(
                                      fontSize: 14,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "₹${grandTotal.toStringAsFixed(0)}",
                                style: GoogleFonts.outfit(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange.shade800,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: CustomButton(
                                  isLoading: checkout is CheckOutLoadingState,
                                  onTap: () {
                                    if (checkoutList.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text("Please select services"),
                                        ),
                                      );
                                    } else {
                                      _addToCartAndNavigate(data
                                          .data![0].serviceTitle
                                          .toString());
                                    }
                                  },
                                  text: "Confirm",
                                  gradientColors: [
                                    Theme.of(context).primaryColor,
                                    Theme.of(context).primaryColorLight,
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 1,
                                child: SizedBox(
                                  height: 50,
                                  child: OutlinedButton(
                                    onPressed: () => context.pop(),
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      side: BorderSide(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    child: Text(
                                      "Cancel",
                                      style: GoogleFonts.outfit(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return const Center(
            child: Text("Error..."),
          );
        },
      ),
    );
  }
}
