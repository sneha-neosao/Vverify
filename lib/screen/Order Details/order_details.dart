import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'package:v_verify/screen/Order%20Details/bloc/order_details_cubit.dart';
import 'package:v_verify/screen/Order%20Details/bloc/order_details_state.dart';
import 'package:v_verify/screen/Order%20Details/model/order_details_model.dart';
import '../../commonComponent/bloc/shared_preferences_cubit.dart';

class OrderDetails extends StatefulWidget {
  String txnId;
  OrderDetails({super.key, required this.txnId});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String token = context.read<TokenCubit>().state;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocProvider(
            create: (_) => OrderDetailsCubit(ApiService())
              ..getOrderDetails(token: token, txnId: widget.txnId),
            child: BlocBuilder<OrderDetailsCubit, OrderDetailsState>(
              builder: (context, orderDetails) {
                if (orderDetails is OrderDetailsLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (orderDetails is OrderDetailsError) {
                  return Center(
                    child: Text(orderDetails.errorMessage),
                  );
                } else if (orderDetails is OrderDetailsSuccess) {
                  OrderDetailsModel data = orderDetails.orderDetailsModel;
                  DateTime dateTime =
                      DateTime.parse(data.data!.txnDate.toString());
                  String formattedDate =
                      DateFormat('yyyy-MM-dd').format(dateTime);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order Details",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontSize: 28),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Card(
                          color: Theme.of(context).cardColor,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      formattedDate,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(60),
                                          color: Theme.of(context)
                                              .primaryColorDark
                                              .withOpacity(0.2)),
                                      //  color: Theme.of(context).primaryColorDark.withOpacity(0.2),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          data.data!.txnStatus.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .primaryColorDark),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  data.data!.txnId.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(fontSize: 24),
                                )
                              ],
                            ),
                          )),
                      const SizedBox(height: 16),
                      Card(
                        color: Theme.of(context).cardColor,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Service Details",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontWeight: FontWeight.w700)),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text("User"),
                                      Text("Tenant",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text("No. of Tenant"),
                                      Text(data.data!.quantity.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              const Text("Services"),
                              GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: data.data!.items!.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          childAspectRatio: 4,
                                          crossAxisCount: 2),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Text(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      "${data.data!.items![index].service!.serviceTitle} |",
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Card(
                        color: Theme.of(context).cardColor,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Price Detail",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontWeight: FontWeight.w700)),
                              ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: data.data!.items!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ListTile(
                                      contentPadding: const EdgeInsets.all(0),
                                      visualDensity: const VisualDensity(
                                          horizontal: 0, vertical: -4),
                                      title: Text(
                                          data.data!.items![index].service!
                                              .serviceTitle
                                              .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall),
                                      subtitle: Text(
                                        "₹${double.parse(data.data!.items![index].price.toString()).toStringAsFixed(0)} X ${data.data!.items![index].quantity}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                      trailing: Text(
                                        "₹${double.parse(data.data!.items![index].amount.toString()).toStringAsFixed(0)}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    );
                                  }),
                              ListTile(
                                contentPadding: const EdgeInsets.all(0),
                                visualDensity: const VisualDensity(
                                    horizontal: 0, vertical: -4),
                                title: Text(
                                  "GST Charge 18%",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                trailing: Text(
                                  "₹${(double.parse(data.data!.taxTotal.toString())).toStringAsFixed(0)}",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                              ListTile(
                                contentPadding: const EdgeInsets.all(0),
                                visualDensity: const VisualDensity(
                                    horizontal: 0, vertical: -4),
                                title: Text(
                                  "Grand Total",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                trailing: Text(
                                  "₹${(double.parse(data.data!.finalTotal.toString())).toStringAsFixed(0)}",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                }
                return const Center(child: Text("Error..."));
              },
            ),
          ),
        ),
      ),
    );
  }
}
