// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:intl/intl.dart';
// import 'package:v_verify/screen/Order%20History/bloc/order_history_cubit.dart';
// import 'package:v_verify/screen/Order%20History/bloc/order_history_state.dart';
// import 'package:v_verify/screen/Order%20History/model/order_history_model.dart';
// import '../../commonComponent/bloc/shared_preferences_cubit.dart';
//
// class OrderHistory extends StatefulWidget {
//   const OrderHistory({super.key});
//
//   @override
//   State<OrderHistory> createState() => _OrderHistoryState();
// }
//
// class _OrderHistoryState extends State<OrderHistory> {
//   @override
//   void initState() {
//     loadTransactionHistory();
//     super.initState();
//   }
//
//   void loadTransactionHistory() {
//     final String token = context.read<TokenCubit>().state;
//     final String id = context.read<IdCubit>().state;
//
//     context.read<OrderHistoryCubit>().getOrderHistory(
//         token: token, customerID: int.parse(id), page: 1, limit: 100);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Order History",
//               style: Theme.of(context)
//                   .textTheme
//                   .titleLarge!
//                   .copyWith(fontSize: 28),
//             ),
//             const SizedBox(
//               height: 16,
//             ),
//             Expanded(
//               child: BlocBuilder<OrderHistoryCubit, OrderHistoryState>(
//                 builder: (context, orderHistory) {
//                   if (orderHistory is OrderHistoryLoading) {
//                     return const Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   } else if (orderHistory is OrderHistoryError) {
//                     return  Center(
//                       child: Text(orderHistory.errorMessage),
//                     );
//                   } else if (orderHistory is OrderHistorySuccess) {
//                     OrderHistoryModel data = orderHistory.orderHistoryModel;
//                     return  ListView.builder(
//                         shrinkWrap: true,
//                         itemCount: data.data!.length,
//                         itemBuilder: (context, index) {
//                           DateTime dateTime = DateTime.parse(data.data![index].txnDate.toString());
//                           String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
//                           return Padding(
//                             padding: const EdgeInsets.only(bottom: 8),
//                             child: InkWell(
//                               borderRadius: BorderRadius.circular(12),
//                               onTap: () {
//                                 context.pushNamed("orderDetails",
//                                     pathParameters: {'txnId':data.data![index].txnId.toString()});
//                               },
//                               child: Card(
//                                 color: Theme.of(context).cardColor,
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(12.0),
//                                   child: Column(
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             data.data![index].txnId.toString(),
//                                             style: Theme.of(context)
//                                                 .textTheme
//                                                 .bodySmall!
//                                                 .copyWith(
//                                                     fontSize: 14,
//                                                     fontWeight:
//                                                         FontWeight.w600),
//                                           ),
//                                           Container(
//                                             decoration: BoxDecoration(
//                                                 borderRadius:
//                                                     BorderRadius.circular(60),
//                                                 color: Theme.of(context)
//                                                     .primaryColorDark
//                                                     .withOpacity(0.2)),
//                                             //  color: Theme.of(context).primaryColorDark.withOpacity(0.2),
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       horizontal: 12,
//                                                       vertical: 8),
//                                               child: Text(
//                                                 data.data![index].txnStatus
//                                                     .toString(),
//                                                 style: Theme.of(context)
//                                                     .textTheme
//                                                     .bodySmall!
//                                                     .copyWith(
//                                                         color: Theme.of(context)
//                                                             .primaryColorDark),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       ListTile(
//                                           contentPadding:
//                                               const EdgeInsets.all(0),
//                                           visualDensity: const VisualDensity(
//                                               horizontal: 0, vertical: -4),
//                                           leading: Image.asset(
//                                               "assets/images/key.png",
//                                               width: 40),
//                                           title: Text(
//                                             "Tenant",
//                                             style: Theme.of(context)
//                                                 .textTheme
//                                                 .bodyLarge!,
//                                           ),
//                                           subtitle: Text(
//                                             maxLines: 1,
//                                             overflow: TextOverflow.ellipsis,
//                                             data.data![index].services!.length >
//                                                     1
//                                                 ? "${data.data![index].services![0].serviceTitle} | ${data.data![index].services![1].serviceTitle}"
//                                                 : "${data.data![index].services![0].serviceTitle}",
//                                             style: Theme.of(context)
//                                                 .textTheme
//                                                 .bodySmall!
//                                                 .copyWith(fontSize: 12),
//                                           )),
//                                       const Divider(),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                            Text(formattedDate),
//                                           Text(
//                                             "₹${data.data![index].finalTotal}",
//                                             style: Theme.of(context)
//                                                 .textTheme
//                                                 .bodyLarge,
//                                           )
//                                         ],
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         });
//                   }
//                   return const Center(
//                     child: Text("Error..."),
//                   );
//                 },
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
//
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// //
// // import 'bloc/order_history_cubit.dart';
// // import 'bloc/order_history_state.dart';
// //
// // class PaginationScreen extends StatefulWidget {
// //   @override
// //   _PaginationScreenState createState() => _PaginationScreenState();
// // }
// //
// // class _PaginationScreenState extends State<PaginationScreen> {
// //   ScrollController _scrollController = ScrollController();
// //   int currentPage = 1;
// //
// //   List<dynamic> dataList = [];
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     // Initialize pagination by fetching the first page of data
// //     context.read<PaginationCubit>().fetchData(page: currentPage);
// //
// //     // Add scroll listener to detect when the user scrolls to the bottom
// //     _scrollController.addListener(_scrollListener);
// //   }
// //
// //   void _scrollListener() {
// //     if (_scrollController.position.pixels ==
// //         _scrollController.position.maxScrollExtent) {
// //       // When the user reaches the bottom, load the next page
// //       currentPage++;
// //       context.read<PaginationCubit>().fetchData(page: currentPage);
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Pagination Example'),
// //       ),
// //       body: BlocConsumer<PaginationCubit, PaginationState>(
// //         listener: (context, state) {
// //           if (state is PaginationError) {
// //             ScaffoldMessenger.of(context)
// //                 .showSnackBar(SnackBar(content: Text(state.message)));
// //           }
// //         },
// //         builder: (context, state) {
// //           if (state is PaginationLoading) {
// //             return const Center(child: CircularProgressIndicator());
// //           } else if (state is PaginationLoaded) {
// //             print("enter load page");
// //             dataList.add(state.data);
// //             return ListView.builder(
// //               controller: _scrollController,
// //               itemCount: state.data.length,
// //               itemBuilder: (context, index) {
// //                 print("dataList $dataList");
// //                 return ListTile(
// //                   title: Text(
// //                     "${index}",
// //                     style: const TextStyle(color: Colors.white),
// //                   ),
// //                 );
// //               },
// //             );
// //           } else if (state is PaginationNoMoreData) {
// //             return const Center(child: Text('No more data available.'));
// //           } else if (state is PaginationError) {
// //             return Center(child: Text('Error: ${state.message}'));
// //           } else {
// //             return Container();
// //           }
// //         },
// //       ),
// //     );
// //   }
// //
// //   @override
// //   void dispose() {
// //     _scrollController.dispose();
// //     super.dispose();
// //   }
// // }
