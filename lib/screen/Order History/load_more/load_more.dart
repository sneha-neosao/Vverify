import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';

import '../../../commonComponent/screen_size.dart';
import 'models/post.dart';

class OrderHistory extends StatefulWidget {
  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  ApiService apiClient = ApiService();
  List<history> data = [];
  bool isLoading = false;
  bool hasMore = true;
  int currentPage = 1;
  int limit = 15;

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    fetchData();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> fetchData() async {
    if (isLoading || !hasMore) return;

    setState(() {
      isLoading = true;
    });

    try {
      String token = context.read<TokenCubit>().state;
      String id = context.read<IdCubit>().state;

      final newItems = await apiClient.tranFetchData(
          token: token,
          customer_id: int.parse(id),
          page: currentPage,
          limit: limit);

      setState(() {
        data.addAll(newItems);
        isLoading = false;

        if (newItems.length < limit) {
          hasMore = false;
        } else {
          currentPage++;
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching data: $e");
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        hasMore &&
        !isLoading) {
      fetchData();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildListItem(history item) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        context.pushNamed("orderDetails",
            pathParameters: {'txnId': item.txnId.toString()});
      },
      child: Card(
        color: Theme.of(context).cardColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.txnId.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        color: Theme.of(context)
                            .primaryColorDark
                            .withOpacity(0.2)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Text(
                        item.txnStatus.toString(),
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).primaryColorDark),
                      ),
                    ),
                  ),
                ],
              ),
              ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  visualDensity:
                      const VisualDensity(horizontal: 0, vertical: -4),
                  leading: Image.asset("assets/images/key.png", width: 40),
                  title: Text("Tenant",
                      style: Theme.of(context).textTheme.bodyLarge!),
                  subtitle: Text(
                    item.services!.length > 1
                        ? "${item.services![0].serviceTitle} | ${item.services![1].serviceTitle}"
                        : "${item.services![0].serviceTitle}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontSize: 12),
                  )),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(DateFormat('yyyy-MM-dd')
                      .format(DateTime.parse(item.txnDate.toString()))),
                  Text(
                    "₹${item.finalTotal}",
                    style: Theme.of(context).textTheme.bodyLarge,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order History')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: data.isEmpty && isLoading
            ? ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[400]!,
                      highlightColor: Colors.grey[50]!,
                      child: Container(
                          height: ScreenSize.screenHeight / 5,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12))),
                    ),
                  );
                })
            : data.isEmpty
                ? const Center(child: Text("No data found Order history."))
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: data.length + (hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < data.length) {
                        return _buildListItem(data[index]);
                      } else {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                    },
                  ),
      ),
    );
  }
}
