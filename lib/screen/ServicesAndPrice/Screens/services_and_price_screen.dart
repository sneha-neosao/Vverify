import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:v_verify/screen/ServicesAndPrice/Blocs/apply_coupon_bloc/apply_coupon_cubit.dart';
import 'package:v_verify/screen/ServicesAndPrice/Blocs/apply_coupon_bloc/apply_coupon_state.dart';
import 'package:v_verify/screen/ServicesAndPrice/Blocs/checkout_bloc/checkout_cubit.dart';
import 'package:v_verify/screen/ServicesAndPrice/Blocs/checkout_bloc/checkout_state.dart';
import 'package:v_verify/screen/ServicesAndPrice/coupon_text_field.dart';
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
  ServicesAndPrice({super.key, required this.entity_id});

  @override
  State<ServicesAndPrice> createState() => _WhatToVerifyState();
}

class _WhatToVerifyState extends State<ServicesAndPrice> {
  double totalPrice = 0.0;
  List<Map<String, dynamic>> addList = [];
  List<Map<String, dynamic>> checkoutList = [];
  final TextEditingController couponController = TextEditingController();

  bool isCouponApplied = false;
  bool isCouponSuccess = false;
  String discountAmount = "";
  String finalAmount = "";
  String couponCode = '';
  List<int> addItem = [];

  // Add these variables for price calculations
  double subtotal = 0.0;
  double gst = 0.0;
  double grandTotal = 0.0;
  double discountedSubtotal = 0.0;
  double actualDiscount = 0.0;

  @override
  void initState() {
    getServices();
    super.initState();
  }

  void getServices() {
    final String token = context.read<TokenCubit>().state;
    final String typeId = context.read<UserTypeId>().state;
    context.read<ServicePriceCubit>().getServicePrice(
        token: token, type_id: typeId, entity_id: widget.entity_id);
  }

  void checkoutTransaction({
    required String payment_gateway,
    required String payment_mode,
    required int quantity,
    required List<Map<String, dynamic>> items,
  }) {
    final String token = context.read<TokenCubit>().state;
    final String id = context.read<IdCubit>().state;
    context.read<CheckoutCubit>().checkout(
        token: token,
        customer_id: int.parse(id),
        entity_id: int.parse(widget.entity_id),
        payment_gateway: payment_gateway,
        payment_mode: payment_mode,
        quantity: quantity,
        items: items,
        coupon_code: couponController.text.trim()
    );

    context.read<PendingDocCubit>().getPendingDoc(
        token: token, customerId: int.parse(id), page: 1, limit: 100);
  }

  void calculatePrices(int tenantsCount) {
    // Calculate subtotal (price of all selected services * number of tenants)
    subtotal = totalPrice * tenantsCount;

    // Reset values
    actualDiscount = 0.0;
    discountedSubtotal = subtotal;

    // If coupon is applied, use the values from backend
    if (isCouponSuccess) {
      try {
        // Parse discount amount if available
        if (discountAmount.isNotEmpty && discountAmount != "null") {
          actualDiscount = double.parse(discountAmount);
        }

        // Use finalAmount if available, otherwise calculate from subtotal and discount
        if (finalAmount.isNotEmpty && finalAmount != "null") {
          discountedSubtotal = double.parse(finalAmount);
        } else if (actualDiscount > 0) {
          discountedSubtotal = subtotal - actualDiscount;
        }

        // Ensure discounted subtotal doesn't go negative
        if (discountedSubtotal < 0) {
          discountedSubtotal = 0.0;
        }

        // Calculate GST based on discounted subtotal
        gst = discountedSubtotal * 18 / 100;

        // Calculate grand total with GST
        grandTotal = discountedSubtotal + gst;
      } catch (e) {
        print("Error in calculatePrices: $e");
        // Fallback to regular calculation
        actualDiscount = 0.0;
        discountedSubtotal = subtotal;
        gst = subtotal * 18 / 100;
        grandTotal = subtotal + gst;
      }
    } else {
      // No coupon applied
      actualDiscount = 0.0;
      discountedSubtotal = subtotal;
      gst = subtotal * 18 / 100;
      grandTotal = subtotal + gst;
    }

    print("calculatePrices called:");
    print("  isCouponSuccess: $isCouponSuccess");
    print("  finalAmount: '$finalAmount'");
    print("  discountAmount: '$discountAmount'");
    print("  subtotal: $subtotal");
    print("  discountedSubtotal: $discountedSubtotal");
    print("  actualDiscount: $actualDiscount");
    print("  gst: $gst");
    print("  grandTotal: $grandTotal");
  }

  @override
  Widget build(BuildContext context) {
    int tenantsCount = context.read<CountCubit>().state;

    // Calculate prices whenever build is called
    calculatePrices(tenantsCount);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: Column(
          children: [
            // Title Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Select WHAT you want to verify",
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  letterSpacing: 0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            // Verification Options List
            BlocBuilder<ServicePriceCubit, ServicePriceState>(
                builder: (context, servicePrice) {
                  if (servicePrice is ServicePriceLoading) {
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                bottom: 16, left: 16, right: 16),
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey[400]!,
                              highlightColor: Colors.grey[50]!,
                              child: Container(
                                height: ScreenSize.screenHeight / 4.5,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
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
                        shrinkWrap: true,
                        itemCount: data.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: addItem.contains(index)
                                          ? Colors.green
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  color: Theme.of(context).cardColor,
                                  margin: const EdgeInsets.all(10),
                                  child: SizedBox(
                                    height: ScreenSize.screenHeight / 4.5,
                                    child: ListTile(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          if (addItem.contains(index)) {
                                            addItem.remove(index);
                                            addList.removeWhere(
                                                    (map) => map.containsValue(index));
                                            checkoutList.removeWhere((map) =>
                                                map.containsValue(
                                                    data.data![index].id));
                                            totalPrice = totalPrice -
                                                double.parse(data
                                                    .data![index].servicePrice
                                                    .toString());
                                          } else {
                                            addItem.add(index);
                                            addList.add({'index': index});
                                            checkoutList.add({
                                              'service_id': data.data![index].id,
                                              "price": data.data![index].servicePrice
                                            });
                                            totalPrice = totalPrice +
                                                double.parse(data
                                                    .data![index].servicePrice
                                                    .toString());
                                          }
                                        });
                                      },
                                      title: Container(
                                        width: ScreenSize.blockSizeHorizontal * 80,
                                        margin: const EdgeInsets.only(top: 50),
                                        child: Text(
                                          data.data![index].serviceTitle.toString(),
                                          textAlign: TextAlign.left,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                      ),
                                      subtitle: Text(
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        data.data![index].serviceDescription
                                            .toString(),
                                        style:
                                        Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: -5,
                                  left: 30,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFFFFF),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    width: ScreenSize.blockSizeHorizontal * 15,
                                    height: ScreenSize.blockSizeHorizontal * 15,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        data.data![index].serviceIcon.toString(),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 30,
                                  right: 30,
                                  child: Text(
                                    data.data![index].servicePrice.toString(),
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                                Positioned(
                                  top: 50,
                                  right: 30,
                                  child: Text(
                                    "Per Person",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(fontSize: 12),
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
            SizedBox(
              height: ScreenSize.screenHeight / 6.5,
            ),
          ],
        ),
      ),
      bottomSheet: BlocBuilder<ServicePriceCubit, ServicePriceState>(
        builder: (context, servicePrice) {
          if (servicePrice is ServicePriceLoading) {
            return const SizedBox();
          } else if (servicePrice is ServicePriceError) {
            return const Center(
              child: Text("error..."),
            );
          } else if (servicePrice is ServicePriceSuccess) {
            ServicePriceModel data = servicePrice.servicePriceModel;

            return BlocConsumer<CheckoutCubit, CheckOutState>(
              listener: (context, checkout) {
                if (checkout is CheckOutSuccessState) {
                  context.pushReplacementNamed("payment_success");
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("payment successfully done")));
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
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 3,
                        )
                      ],
                    ),
                    height: ScreenSize.screenHeight / 7,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 22.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'No. of Tenants: $tenantsCount',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                TextButton(
                                  onPressed: () {
                                    showModalBottomSheet<void>(
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(
                                          builder: (BuildContext context,
                                              StateSetter setStateSheet) {
                                            // Calculate initial height
                                            double calculateHeight() {
                                              if (addList.length == 1)
                                                return ScreenSize.screenHeight / 2;
                                              if (addList.length == 2)
                                                return ScreenSize.screenHeight /
                                                    1.8;
                                              if (addList.length == 3)
                                                return ScreenSize.screenHeight /
                                                    1.6;
                                              if (addList.length > 3)
                                                return ScreenSize.screenHeight /
                                                    1.5;
                                              return ScreenSize.screenHeight / 2.3;
                                            }
                            
                                            return Container(
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              height: calculateHeight(),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  bottom:
                                                  MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom,
                                                ),
                                                child: SingleChildScrollView(
                                                  physics:
                                                  const AlwaysScrollableScrollPhysics(),
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets.all(16.0),
                                                    child: SafeArea(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Center(
                                                            child: Container(
                                                              width: 60,
                                                              height: 6,
                                                              decoration:
                                                              BoxDecoration(
                                                                color: Colors.grey,
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    16),
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            "Price Breakup",
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .titleLarge!
                                                                .copyWith(
                                                              fontWeight:
                                                              FontWeight
                                                                  .w700,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 16),
                                                          Container(
                                                            padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                            decoration:
                                                            BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  12),
                                                              color: Theme.of(
                                                                  context)
                                                                  .cardColor,
                                                            ),
                                                            child: Column(
                                                              children: [
                                                                SizedBox(
                                                                  height:
                                                                  addList.length >
                                                                      3
                                                                      ? ScreenSize
                                                                      .screenHeight /
                                                                      4
                                                                      : null,
                                                                  child: ListView
                                                                      .builder(
                                                                    itemCount:
                                                                    addList
                                                                        .length,
                                                                    shrinkWrap:
                                                                    true,
                                                                    physics:
                                                                    const NeverScrollableScrollPhysics(),
                                                                    itemBuilder:
                                                                        (BuildContext
                                                                    context,
                                                                        int
                                                                        index) {
                                                                      return ListTile(
                                                                        contentPadding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            0),
                                                                        visualDensity:
                                                                        const VisualDensity(
                                                                          horizontal:
                                                                          0,
                                                                          vertical:
                                                                          -4,
                                                                        ),
                                                                        title: Text(
                                                                          "${data.data![addList[index]["index"]].serviceTitle}",
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .bodySmall,
                                                                        ),
                                                                        subtitle:
                                                                        Text(
                                                                          "₹${double.parse(data.data![addList[index]["index"]].servicePrice.toString()).toStringAsFixed(0)} X $tenantsCount",
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .bodySmall,
                                                                        ),
                                                                        trailing:
                                                                        Text(
                                                                          "₹${(double.parse(data.data![addList[index]["index"]].servicePrice!) * tenantsCount).toStringAsFixed(0)}",
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .bodySmall,
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                                // Coupon UI Section
                                                                _buildCouponUI(
                                                                  context,
                                                                  setStateSheet,
                                                                  data,
                                                                  tenantsCount,
                                                                ),
                                                                // Show original subtotal and discount separately for clarity
                                                                if (isCouponSuccess && actualDiscount > 0)
                                                                  Column(
                                                                    children: [
                                                                      // Original Subtotal
                                                                      ListTile(
                                                                        contentPadding: const EdgeInsets.all(0),
                                                                        visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                                                                        title: Text(
                                                                          "Original Sub Total",
                                                                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                                                            fontSize: 14,
                                                                            decoration: TextDecoration.lineThrough,
                                                                            color: Colors.grey,
                                                                          ),
                                                                        ),
                                                                        trailing: Text(
                                                                          "₹${subtotal.toStringAsFixed(2)}",
                                                                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                                                            fontSize: 14,
                                                                            decoration: TextDecoration.lineThrough,
                                                                            color: Colors.grey,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      // Discount Applied
                                                                      ListTile(
                                                                        contentPadding: const EdgeInsets.all(0),
                                                                        visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                                                                        title: Text(
                                                                          "Discount Applied",
                                                                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                                                            fontSize: 14,
                                                                            color: Colors.green.shade700,
                                                                          ),
                                                                        ),
                                                                        trailing: Text(
                                                                          "-₹${actualDiscount.toStringAsFixed(2)}",
                                                                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                                                            fontSize: 14,
                                                                            color: Colors.green.shade700,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                // Subtotal (with discount applied if any)
                                                                ListTile(
                                                                  contentPadding:
                                                                  const EdgeInsets
                                                                      .all(0),
                                                                  visualDensity:
                                                                  const VisualDensity(
                                                                    horizontal: 0,
                                                                    vertical: -4,
                                                                  ),
                                                                  title: Text(
                                                                    isCouponSuccess ? "Discounted Sub Total" : "Sub Total",
                                                                    style: Theme.of(
                                                                        context)
                                                                        .textTheme
                                                                        .bodyLarge!
                                                                        .copyWith(
                                                                        fontSize:
                                                                        14),
                                                                  ),
                                                                  trailing: Text(
                                                                    "₹${discountedSubtotal.toStringAsFixed(2)}",
                                                                    style: Theme.of(
                                                                        context)
                                                                        .textTheme
                                                                        .bodyLarge!
                                                                        .copyWith(
                                                                        fontSize:
                                                                        14),
                                                                  ),
                                                                ),
                                                                // GST
                                                                ListTile(
                                                                  contentPadding:
                                                                  const EdgeInsets
                                                                      .all(0),
                                                                  visualDensity:
                                                                  const VisualDensity(
                                                                    horizontal: 0,
                                                                    vertical: -4,
                                                                  ),
                                                                  title: Text(
                                                                    "GST Charge 18%",
                                                                    style: Theme.of(
                                                                        context)
                                                                        .textTheme
                                                                        .bodyLarge!
                                                                        .copyWith(
                                                                        fontSize:
                                                                        14),
                                                                  ),
                                                                  trailing: Text(
                                                                    "₹${gst.toStringAsFixed(2)}",
                                                                    style: Theme.of(
                                                                        context)
                                                                        .textTheme
                                                                        .bodyLarge!
                                                                        .copyWith(
                                                                        fontSize:
                                                                        14),
                                                                  ),
                                                                ),
                                                                // Grand Total
                                                                ListTile(
                                                                  contentPadding:
                                                                  const EdgeInsets
                                                                      .all(0),
                                                                  visualDensity:
                                                                  const VisualDensity(
                                                                    horizontal: 0,
                                                                    vertical: -4,
                                                                  ),
                                                                  title: Text(
                                                                    "Grand Total",
                                                                    style: Theme.of(
                                                                        context)
                                                                        .textTheme
                                                                        .bodyLarge,
                                                                  ),
                                                                  trailing: Text(
                                                                    "₹${grandTotal.toStringAsFixed(2)}",
                                                                    style: Theme.of(
                                                                        context)
                                                                        .textTheme
                                                                        .bodyLarge,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 16),
                                                          CustomButton(
                                                            isLoading: checkout
                                                            is CheckOutLoadingState,
                                                            onTap: () {
                                                              if (checkoutList
                                                                  .isEmpty) {
                                                                ScaffoldMessenger
                                                                    .of(context)
                                                                    .showSnackBar(
                                                                  const SnackBar(
                                                                    content: Text(
                                                                        "Please select services"),
                                                                  ),
                                                                );
                                                              } else {
                                                                checkoutTransaction(
                                                                  payment_gateway:
                                                                  "Stripe",
                                                                  payment_mode:
                                                                  "Credit Card",
                                                                  quantity:
                                                                  tenantsCount,
                                                                  items:
                                                                  checkoutList,
                                                                );
                                                              }
                                                            },
                                                            text:
                                                            "Pay ₹${grandTotal.toStringAsFixed(0)} /",
                                                            gradientColors: [
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                              Theme.of(context)
                                                                  .primaryColorLight,
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 16),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                  child: Text(
                                    'See price breakout',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color:
                                      Theme.of(context).primaryColorDark,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CustomButton(
                            isLoading: checkout is CheckOutLoadingState,
                            width: ScreenSize.screenWidth / 2.5,
                            text:
                            "Pay ₹${grandTotal.toStringAsFixed(0)} /-",
                            onTap: () {
                              if (checkoutList.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                        Text("Please select services")));
                              } else {
                                checkoutTransaction(
                                  payment_gateway: "Stripe",
                                  payment_mode: "Credit Card",
                                  quantity: tenantsCount,
                                  items: checkoutList,
                                );
                              }
                            },
                            gradientColors: [
                              Theme.of(context).primaryColor,
                              Theme.of(context).primaryColorLight,
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(
            child: Text("Error..."),
          );
        },
      ),
    );
  }

  Widget _buildCouponUI(
      BuildContext context,
      StateSetter setStateSheet,
      ServicePriceModel data,
      int tenantsCount,
      ) {
    // Helper function to update both parent and bottom sheet state
    void updateCouponState({
      bool? applied,
      bool? success,
      String? discount,
      String? finalAmt,
      String? code,
    }) {
      setState(() {
        if (applied != null) isCouponApplied = applied;
        if (success != null) isCouponSuccess = success;
        if (discount != null) discountAmount = discount ?? "";
        if (finalAmt != null) finalAmount = finalAmt ?? "";
        if (code != null) couponCode = code ?? "";
      });
      setStateSheet(() {
        if (applied != null) isCouponApplied = applied;
        if (success != null) isCouponSuccess = success;
        if (discount != null) discountAmount = discount ?? "";
        if (finalAmt != null) finalAmount = finalAmt ?? "";
        if (code != null) couponCode = code ?? "";
      });

      // Always recalculate prices when coupon state changes
      calculatePrices(tenantsCount);
    }

    return BlocConsumer<ApplyCouponCubit, ApplyCouponState>(
      listener: (context, couponState) {
        if (couponState is ApplyCouponSuccessState) {
          // Log the entire response
          print("Full ApplyCouponSuccessState response:");
          print("Model: ${couponState.applyCouponModel.toJson()}");

          // Extract data from the model
          String? discountValue = couponState.applyCouponModel.result?.discountApplied;
          String? finalAmountValue = couponState.applyCouponModel.result?.finalAmount;

          print("Extracted values:");
          print("  discountApplied: $discountValue");
          print("  finalAmount: $finalAmountValue");

          updateCouponState(
            success: true,
            discount: discountValue ?? "",
            finalAmt: finalAmountValue ?? "",
            code: couponController.text,
            applied: false, // Hide the text field
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(couponState.applyCouponModel.message ?? "Coupon applied successfully"),
            ),
          );
        } else if (couponState is ApplyCouponErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(couponState.message)),
          );
        }
      },
      builder: (context, couponState) {
        // Loading state
        if (couponState is ApplyCouponLoadingState) {
          return Container(
            height: 60,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              strokeWidth: 3,
            ),
          );
        }

        // SUCCESS STATE - Coupon Applied UI
        if (isCouponSuccess) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Coupon applied success message
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle,
                        color: Colors.green.shade600, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Coupon ($couponCode) Applied!",
                        style: TextStyle(
                          color: Colors.green.shade800,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Remove coupon and reset to initial state
                        couponController.clear();
                        updateCouponState(
                          applied: false,
                          success: false,
                          discount: "",
                          finalAmt: "",
                          code: '',
                        );
                      },
                      icon: Icon(Icons.close,
                          color: Colors.green.shade600, size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          );
        }

        // INPUT STATE - Text field for coupon code
        if (isCouponApplied) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 14.0),
                  child: CouponTextField(
                    controller: couponController,
                    titleText: "Coupon Code",
                    hintText: "Enter Coupon Code",
                    textInputType: TextInputType.text,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Apply Button
              SizedBox(
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (couponController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Please enter coupon code")),
                      );
                    } else {
                      applyCoupon(couponController.text, tenantsCount);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Apply"),
                ),
              ),
              const SizedBox(width: 8),
              // Cancel Button
              SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: () {
                    couponController.clear();
                    updateCouponState(applied: false);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.orange,
                    side: const BorderSide(color: Colors.orange),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Cancel"),
                ),
              ),
            ],
          );
        }

        // DEFAULT STATE - Dotted border with "Have a coupon" text
        return DottedBorder(
          borderType: BorderType.RRect,
          radius: const Radius.circular(12),
          dashPattern: const [2, 2],
          color: Colors.orange,
          strokeWidth: 1,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.orangeAccent.shade100.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 22.0, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 26,
                    width: 26,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColorLight,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.local_activity_outlined,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Have a coupon code ?",
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      updateCouponState(applied: true);
                    },
                    child: const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Apply",
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_circle_right_outlined,
                          color: Colors.orange,
                          size: 22,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void applyCoupon(String couponCode, int tenantsCount) {
    // Calculate subtotal (total price * number of tenants)
    double subtotalAmount = totalPrice * tenantsCount;
    String subtotalStr = subtotalAmount.toStringAsFixed(2);

    final String customerId = context.read<IdCubit>().state;
    String token = context.read<TokenCubit>().state;

    print("applyCoupon called:");
    print("  subtotal: $subtotalStr");
    print("  couponCode: $couponCode");

    context.read<ApplyCouponCubit>().applyCoupon(
      token: token,
      customer_id: customerId,
      subtotal: subtotalStr,
      coupon_code: couponCode,
    );
  }
}