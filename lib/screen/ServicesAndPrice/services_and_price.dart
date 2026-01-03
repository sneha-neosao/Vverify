import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:v_verify/screen/ServicesAndPrice/bloc_checkout/checkout_cubit.dart';
import 'package:v_verify/screen/ServicesAndPrice/bloc_checkout/checkout_state.dart';
import '../../commonComponent/bloc/shared_preferences_cubit.dart';
import '../../commonComponent/custom_button.dart';
import '../../commonComponent/screen_size.dart';
import '../Home screen/bloc/home_screnn_cubit.dart';
import '../VerificationPending/bloc/pendingDoc_cubit.dart';
import 'bloc/servicePrice_cubit.dart';
import 'bloc/servicePrice_state.dart';
import 'model/servicePrice_model.dart';

class ServicesAndPrice extends StatefulWidget {
  String entity_id;
  ServicesAndPrice({super.key,required this.entity_id});

  @override
  State<ServicesAndPrice> createState() => _WhatToVerifyState();
}

class _WhatToVerifyState extends State<ServicesAndPrice> {
  double totalPrice = 0.0;
  List<Map<String, dynamic>> addList = [];
  List<Map<String, dynamic>> checkoutList = [];

  List<int> addItem = [];

  @override
  void initState() {
    getServices();
    super.initState();
  }

  void getServices() {
    final String token = context.read<TokenCubit>().state;
    final String typeId = context.read<UserTypeId>().state;
    context
        .read<ServicePriceCubit>()
        .getServicePrice(token: token, type_id: typeId, entity_id: widget.entity_id);
  }

  void checkoutTransaction({
    required String payment_gateway,
    required String payment_mode,
    required int quantity,
    required List<Map<String, dynamic>> items,
  }) {
    final String token = context.read<TokenCubit>().state;
    final String id = context.read<IdCubit>().state;
    //final String typeId = context.read<UserTypeId>().state;
    context.read<CheckoutCubit>().checkout(
        token: token,
        customer_id: int.parse(id),
        entity_id: int.parse(widget.entity_id),
        payment_gateway: payment_gateway,
        payment_mode: payment_mode,
        quantity: quantity,
        items: items);

    context.read<PendingDocCubit>().getPendingDoc(
        token: token, customerId: int.parse(id), page: 1, limit: 100);
  }

  @override
  Widget build(BuildContext context) {
    int TenantsCount = context.read<CountCubit>().state;
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(),
        body: Padding(
          //padding: EdgeInsets.only(bottom: ScreenSize.screenHeight / 6),
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
                                    borderRadius: BorderRadius.circular(12))),
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
                                          width: 2),
                                      borderRadius: BorderRadius.circular(12)),
                                  color: Theme.of(context).cardColor,
                                  margin: const EdgeInsets.all(10),
                                  child: SizedBox(
                                    height: ScreenSize.screenHeight / 4.5,
                                    child: ListTile(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      onTap: () {
                                        setState(() {


                                          addItem.contains(index)
                                              ? addItem.remove(index)
                                              : addItem.add(index);

                                          addItem.contains(index)
                                              ? addList.add({'index': index})
                                              : addList.removeWhere((map) =>
                                                  map.containsValue(index));

                                          addItem.contains(index)
                                              ? checkoutList.add({
                                                  'service_id':
                                                      data.data![index].id,
                                                  "price": data
                                                      .data![index].servicePrice
                                                })
                                              : checkoutList.removeWhere(
                                                  (map) => map.containsValue(
                                                      data.data![index].id));

                                          addItem.contains(index)
                                              ? totalPrice = totalPrice +
                                                  double.parse(data
                                                      .data![index].servicePrice
                                                      .toString())
                                              : totalPrice = totalPrice -
                                                  double.parse(data
                                                      .data![index].servicePrice
                                                      .toString());
                                        });

                                      },
                                      title: Container(
                                        width:
                                            ScreenSize.blockSizeHorizontal * 80,
                                        margin: const EdgeInsets.only(top: 50),
                                        child: Text(
                                            data.data![index].serviceTitle
                                                .toString(),
                                            textAlign: TextAlign.left,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge),
                                      ),
                                      subtitle: Text(
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        data.data![index].serviceDescription
                                            .toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
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
                                        data.data![index].serviceIcon
                                            .toString(),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 30,
                                  // Adjust this value as needed
                                  right: 30,
                                  // Adjust this value to position it correctly
                                  child: Text(
                                    data.data![index].servicePrice.toString(),
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                                Positioned(
                                  top: 50,
                                  // Adjust this value as needed
                                  right: 30,
                                  // Adjust this value to position it correctly
                                  child: Text("Per Person",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(fontSize: 12)),
                                ),
                              ],
                            ),
                          );
                        }),
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
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("payment successfully done")));
              } else if (checkout is CheckOutErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(checkout.errorMessage)));
              }
            }, builder: (context, checkout) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 3,
                      )
                    ]),
                height: ScreenSize.screenHeight / 7,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No. of Tenants: $TenantsCount',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        TextButton(
                          onPressed: () {
                            showModalBottomSheet<void>(
                                isScrollControlled: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,

                                    height: addList.length == 1
                                        ? ScreenSize.screenHeight / 2.4
                                        : addList.length == 2
                                            ? ScreenSize.screenHeight / 2
                                            : addList.length == 3
                                                ? ScreenSize.screenHeight / 1.8
                                                : addList.length > 3
                                                    ? ScreenSize.screenHeight / 1.7
                                                    : ScreenSize.screenHeight /
                                                        2.8,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Container(
                                                width: 60,
                                                height: 6,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16))),
                                          ),
                                          Text("Price Breakup",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 16)),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: Theme.of(context)
                                                    .cardColor),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: addList.length > 3
                                                      ? ScreenSize
                                                              .screenHeight /
                                                          4
                                                      : null,
                                                  child: ListView.builder(
                                                      itemCount: addList.length,
                                                      shrinkWrap: true,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return ListTile(
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .all(0),
                                                          visualDensity:
                                                              const VisualDensity(
                                                                  horizontal: 0,
                                                                  vertical: -4),
                                                          title: Text(
                                                              "${data.data![addList[index]["index"]].serviceTitle}",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodySmall),
                                                          subtitle: Text(
                                                            "₹${double.parse(data.data![addList[index]["index"]].servicePrice.toString()).toStringAsFixed(0)} X $TenantsCount",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodySmall,
                                                          ),
                                                          trailing: Text(
                                                            "₹${(double.parse(data.data![addList[index]["index"]].servicePrice!) * double.parse(TenantsCount.toString())).toStringAsFixed(0)}",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodySmall,
                                                          ),
                                                        );
                                                      }),
                                                ),

                                                ListTile(
                                                  contentPadding:
                                                      const EdgeInsets.all(0),
                                                  visualDensity:
                                                      const VisualDensity(
                                                          horizontal: 0,
                                                          vertical: -4),
                                                  title: Text(
                                                    "GST Charge 18%",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .copyWith(fontSize: 14),
                                                  ),
                                                  trailing: Text(
                                                    "₹${(totalPrice * TenantsCount * 18 / 100).toStringAsFixed(0)}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .copyWith(fontSize: 14),
                                                  ),
                                                ),
                                                ListTile(
                                                  contentPadding:
                                                      const EdgeInsets.all(0),
                                                  visualDensity:
                                                      const VisualDensity(
                                                          horizontal: 0,
                                                          vertical: -4),
                                                  title: Text(
                                                    "Grand Total",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge,
                                                  ),
                                                  trailing: Text(
                                                    "₹${((totalPrice * TenantsCount) + (totalPrice * TenantsCount) * 18 / 100).toStringAsFixed(0)}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          CustomButton(
                                            isLoading: checkout
                                                is CheckOutLoadingState,
                                            onTap: () {
                                              if (checkoutList.isEmpty) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            "Please select services")));
                                              } else {
                                                checkoutTransaction(
                                                    payment_gateway: "Stripe",
                                                    payment_mode: "Credit Card",
                                                    quantity: TenantsCount,
                                                    items: checkoutList);
                                              }
                                            },
                                            text:
                                                "Pay ₹${((totalPrice * TenantsCount) + (totalPrice * TenantsCount) * 18 / 100).toStringAsFixed(0)} /",
                                            gradientColors: [
                                              Theme.of(context).primaryColor,
                                              Theme.of(context)
                                                  .primaryColorLight
                                            ],
                                          ),
                                          const SizedBox(height: 16,),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: Text(
                            'See price breakout',
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Theme.of(context).primaryColorDark),
                          ),
                        ),
                      ],
                    ),
                    CustomButton(
                      isLoading: checkout is CheckOutLoadingState,
                      width: ScreenSize.screenWidth / 2.5,
                      text:
                          "Pay ₹${((totalPrice * TenantsCount) + (totalPrice * TenantsCount) * 18 / 100).toStringAsFixed(0)} /-",
                      onTap: () {
                        if (checkoutList.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Please select services")));
                        } else {
                          checkoutTransaction(
                              payment_gateway: "Stripe",
                              payment_mode: "Credit Card",
                              quantity: TenantsCount,
                              items: checkoutList);
                        }
                      },
                      gradientColors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColorLight,
                      ],
                    ),
                  ],
                ),
              );
            });
          }
          return const Center(
            child: Text("Error..."),
          );
        }));
  }
}
