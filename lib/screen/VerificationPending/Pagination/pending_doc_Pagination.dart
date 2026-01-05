import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';

import '../../../commonComponent/screen_size.dart';
import '../../VerificationForms/EmploymentForm/TextController/EmploymentSaveFormController.dart';
import '../../VerificationForms/NameAddressVerificationForm/Save/name_address_verification_form.dart';
import '../../VerificationForms/common/id.dart';
import '../../VerificationForms/common/url.dart';
import '../bloc/pendingDoc_cubit.dart';
import '../model/pendingDoc_model.dart';

class PendingDocPagination extends StatefulWidget {
  @override
  _PendingDocPaginationState createState() => _PendingDocPaginationState();
}

class _PendingDocPaginationState extends State<PendingDocPagination> {
  ApiService apiClient = ApiService();
  List<verifyRequest> data = [];
  bool isLoading = false;
  bool hasMore = true;
  int currentPage = 1;
  int limit = 15;

  // Initialize the ScrollController
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    // Instantiate ScrollController
    _scrollController = ScrollController();
    // Fetch initial data
    fetchData();

    // Add a listener for scrolling
    _scrollController.addListener(_scrollListener);
  }

  // Fetch data method
  Future<void> fetchData() async {
    context.read<TokenCubit>().getToken();
    context.read<IdCubit>().getId().then((value) async {
      String token = context.read<TokenCubit>().state;
      String id = context.read<IdCubit>().state;
      if (isLoading) return;

      setState(() {
        isLoading = true;
      });

      try {
        final newItems = await apiClient.verifyRequestListPagination(
            token: token, customer_id: id, page: currentPage, limit: limit);

        setState(() {
          data.addAll(newItems);

          isLoading = false;
          if (newItems.length < limit) {
            hasMore = false; // No more data to load
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
    });
  }

  // ScrollListener for triggering pagination
  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        hasMore &&
        !isLoading) {
      fetchData();
    }
  }

  @override
  void dispose() {
    // Don't forget to dispose the ScrollController when done
    _scrollController.dispose();
    super.dispose();
  }

  void checkCase({required String title, required BuildContext context}) {
    switch (title) {
      case "police-verification":
        context.pushNamed("nonMumbaiForm");
        break;
      case "pan-card-verification":
        context.pushNamed("PanVerificationSave");
        break;
      case "reference-check-verification":
        context.pushNamed("ReferenceForm");
        break;
      case "name-address-verifcation":
        // context.pushNamed("NameAddressVerificationForm");
        context.pushNamed("NameAddressVerificationFormNew");
        break;
      case "employment-verification-list":
        context.pushNamed("EmployDataList");
        break;
      case "education-verification-list":
        context.pushNamed("EducationList");
        break;
      case "driving-licence-verification":
        context.pushNamed("DrivingLicence");
        break;
      case "gst-cin-pan-verification":
        context.pushNamed("GstPanCinScreen");
        break;
      case "court-legal-verification":
        context.pushNamed("CourtVerification");
        break;
    }
  }

  void secondCheckCase(
      {required List<verifyRequest> data,
      required BuildContext context,
      required int index,
      required int servicesIndex}) {
    switch (data[index].services![servicesIndex].serviceNavigate) {
      case "police-verification":
        data[index].services![servicesIndex].policeEntryType == 1
            ? data[index].services![servicesIndex].dataPreference == "form"
                ? context.pushNamed("MumbaiPoliceVerificationUpdateForm1",
                    pathParameters: {
                        'uid':
                            data[index].services![servicesIndex].uid.toString()
                      })
                : context.pushNamed("MumbaiDocUpdate", pathParameters: {
                    'uid': data[index].services![servicesIndex].uid.toString()
                  })
            : data[index].services![servicesIndex].dataPreference == "form"
                ? context.pushNamed("NonMumbaiPoliceVerificationForm1Update",
                    pathParameters: {
                        'uid':
                            data[index].services![servicesIndex].uid.toString()
                      })
                : context
                    .pushNamed("UpdateDocumentsNonMumbai", pathParameters: {
                    'uid': data[index].services![servicesIndex].uid.toString()
                  });
        break;
      case "pan-card-verification":
        context.pushNamed("PanVerificationUpdate", pathParameters: {
          'uid': data[index].services![servicesIndex].uid.toString()
        });
        break;
      case "reference-check-verification":
        data[index].services![servicesIndex].dataPreference == "form"
            ? context.pushNamed("ReferenceFormUpdate", pathParameters: {
                'uid': data[index].services![servicesIndex].uid.toString()
              })
            : context.pushNamed("ReferenceUpdateDoc", pathParameters: {
                'uid': data[index].services![servicesIndex].uid.toString()
              });
        break;
      case "name-address-verifcation":
        data[index].services![servicesIndex].dataPreference == "form"
            ? context.pushNamed("NameAddressVerificationUpdateNew",
                pathParameters: {
                    'uid': data[index].services![servicesIndex].uid.toString()
                  })
            : context.pushNamed("NameAddressDocUpdate", pathParameters: {
                'uid': data[index].services![servicesIndex].uid.toString()
              });
        break;
      // case "Employment Verification":
      //   context.pushNamed("EmployDataList");
      //   break;
      // case "Education Verification":
      //   context.pushNamed("EducationList");
      //   break;
      case "driving-licence-verification":
        data[index].services![servicesIndex].dataPreference == "form"
            ? context.pushNamed("DrivingLicenceUpdate", pathParameters: {
                "uid": data[index].services![servicesIndex].uid.toString()
              })
            : context.pushNamed("DrivingDocUpdate", pathParameters: {
                "uid": data[index].services![servicesIndex].uid.toString()
              });
        break;
      case "gst-cin-pan-verification":
        data[index].services![servicesIndex].dataPreference == "form"
            ? context.pushNamed("GstPanCinUpdateScreen", pathParameters: {
                "uid": data[index].services![servicesIndex].uid.toString()
              })
            : context.pushNamed("GstPanCinDocUpdate", pathParameters: {
                "uid": data[index].services![servicesIndex].uid.toString()
              });
        break;

      case "court-legal-verification":
        data[index].services![servicesIndex].dataPreference == "form"
            ? context.pushNamed("CourtVerificationUpdate", pathParameters: {
                "uid": data[index].services![servicesIndex].uid.toString()
              })
            : context.pushNamed("CourtDocUpdate", pathParameters: {
                "uid": data[index].services![servicesIndex].uid.toString()
              });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _scrollController.position.jumpTo(0);
          data.clear();
          isLoading = false;
          currentPage = 1;
          hasMore = true;
          fetchData();
        });
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 50, left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("VVerification Pending",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 28)),
              isLoading && data.isEmpty
                  ? Expanded(
                      child: ListView.builder(
                          itemCount: 15,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey[400]!,
                                highlightColor: Colors.grey[50]!,
                                child: Container(
                                    height: ScreenSize.screenHeight / 7,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(12))),
                              ),
                            );
                          }),
                    )
                  : data.isEmpty
                      ? const Expanded(
                          child: Center(
                              child: Text("No data found verification list.")),
                        )
                      : Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            controller: _scrollController,
                            // Attach ScrollController to ListView
                            itemCount: data.length + (isLoading ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == data.length) {
                                // Show a loading indicator while fetching data
                                return const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                );
                              }
                              return BlocBuilder<IsPressedCubit, int>(
                                  builder: (context, isPressed) {
                                return Card(
                                  color: Theme.of(context).cardColor,
                                  child: Column(
                                    children: [
                                      ListTile(
                                        onTap: () {
                                          context
                                              .read<IsPressedCubit>()
                                              .isPressed(index);
                                        },
                                        tileColor:
                                            Theme.of(context).primaryColorDark,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                topRight: Radius.circular(8))),
                                        title: data[index].first_name != null
                                            ? Text(
                                                "${data[index].first_name} ${data[index].middle_name} ${data[index].last_name!}"
                                                    .toString())
                                            : Text(data[index]
                                                .entity!
                                                .entityName
                                                .toString()),
                                        trailing: Icon(isPressed == index
                                            ? Icons.keyboard_arrow_up
                                            : Icons.keyboard_arrow_down),
                                      ),
                                      isPressed == index
                                          ? ListView.builder(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount:
                                                  data[index].services!.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int servicesIndex) {
                                                return Column(
                                                  children: [
                                                    ListTile(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 8,
                                                                vertical: 4),
                                                        onTap: () {
                                                          // employmentTextController.employmentNameController
                                                          //         .text =
                                                          //     "${data[index].first_name} ${data[index].middle_name} ${data[index].last_name}";
                                                          // personNameController
                                                          //         .text =
                                                          //     "${data[index].first_name} ${data[index].middle_name} ${data[index].last_name}";

                                                          serviceRequestId = data[
                                                                  index]
                                                              .services![
                                                                  servicesIndex]
                                                              .serviceRequestId
                                                              .toString();

                                                          requestId =
                                                              data[index]
                                                                  .requestId
                                                                  .toString();

                                                          if (data[index]
                                                                  .detailsUpdated ==
                                                              0) {
                                                            // context.pushNamed(
                                                            //     "verifyRequestUpdate",
                                                            //     pathParameters: {
                                                            //       'uuid': data[
                                                            //               index]
                                                            //           .uuid
                                                            //           .toString()
                                                            //     });
                                                            context.pushNamed(
                                                                "verifyRequestUpdateNew",
                                                                pathParameters: {
                                                                  'uuid': data[
                                                                  index]
                                                                      .uuid
                                                                      .toString()
                                                                });
                                                          } else if (data[index]
                                                                  .detailsUpdated ==
                                                              1) {
                                                            if (data[index]
                                                                    .services![
                                                                        servicesIndex]
                                                                    .status ==
                                                                "pending") {
                                                              if (data[index]
                                                                      .services![
                                                                          servicesIndex]
                                                                      .serviceTitle ==
                                                                  "Employment Verification") {
                                                                context.pushNamed(
                                                                    "EmployDataList");
                                                              } else if (data[
                                                                          index]
                                                                      .services![
                                                                          servicesIndex]
                                                                      .serviceTitle ==
                                                                  "Education Verification") {
                                                                context.pushNamed(
                                                                    "EducationList");
                                                              } else {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(const SnackBar(
                                                                        content:
                                                                            Text("Please wait your application under process")));
                                                              }
                                                            } else if (data[
                                                                        index]
                                                                    .services![
                                                                        servicesIndex]
                                                                    .status ==
                                                                "verified") {
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      const SnackBar(
                                                                          content:
                                                                              Text("Your application already verified")));
                                                            } else if (data[
                                                                        index]
                                                                    .services![
                                                                        servicesIndex]
                                                                    .status ==
                                                                "rejected") {
                                                              secondCheckCase(
                                                                  data: data,
                                                                  context:
                                                                      context,
                                                                  index: index,
                                                                  servicesIndex:
                                                                      servicesIndex);
                                                            } else if (data[
                                                                        index]
                                                                    .services![
                                                                        servicesIndex]
                                                                    .status ==
                                                                "failed") {
                                                              secondCheckCase(
                                                                  data: data,
                                                                  context:
                                                                      context,
                                                                  index: index,
                                                                  servicesIndex:
                                                                      servicesIndex);
                                                            } else {
                                                              checkCase(
                                                                  title: data[
                                                                          index]
                                                                      .services![
                                                                          servicesIndex]
                                                                      .serviceNavigate
                                                                      .toString(),
                                                                  context:
                                                                      context);
                                                            }
                                                          }
                                                        },
                                                        leading: Image.network(
                                                          "$imageUrl${data[index].services![servicesIndex].serviceIcon}",
                                                          width: 30,
                                                        ),
                                                        title: Text(
                                                          data[index]
                                                              .services![
                                                                  servicesIndex]
                                                              .serviceTitle!
                                                              .toUpperCase(),
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodySmall,
                                                        ),
                                                        subtitle: Row(
                                                          children: [
                                                            data[index].services![servicesIndex].status ==
                                                                        "failed" ||
                                                                    data[index]
                                                                            .services![
                                                                                servicesIndex]
                                                                            .status ==
                                                                        "rejected"
                                                                ? const Icon(
                                                                    Icons.info,
                                                                    color: Colors
                                                                        .red,
                                                                    size: 18,
                                                                  )
                                                                : data[index]
                                                                            .services![
                                                                                servicesIndex]
                                                                            .status ==
                                                                        "verified"
                                                                    ? const Icon(
                                                                        Icons
                                                                            .verified,
                                                                        color: Colors
                                                                            .green,
                                                                        size:
                                                                            18,
                                                                      )
                                                                    : data[index].services![servicesIndex].status ==
                                                                            "NA"
                                                                        ? Icon(
                                                                            Icons.person_add,
                                                                            color:
                                                                                Theme.of(context).primaryColorDark,
                                                                            size:
                                                                                18,
                                                                          )
                                                                        : Icon(
                                                                            Icons.schedule,
                                                                            color:
                                                                                Theme.of(context).primaryColorDark,
                                                                            size:
                                                                                18,
                                                                          ),
                                                            const SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                                '${data[index].services![servicesIndex].status}',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodySmall!
                                                                    .copyWith(
                                                                        fontSize:
                                                                            14,
                                                                        color: data[index].services![servicesIndex].status == "failed" ||
                                                                                data[index].services![servicesIndex].status == "rejected"
                                                                            ? Colors.red
                                                                            : data[index].services![servicesIndex].status == "verified"
                                                                                ? Colors.green
                                                                                : Theme.of(context).primaryColorDark))
                                                          ],
                                                        ),
                                                        trailing: data[index]
                                                                        .services![
                                                                            servicesIndex]
                                                                        .status ==
                                                                    "failed" ||
                                                                data[index]
                                                                        .services![
                                                                            servicesIndex]
                                                                        .status ==
                                                                    "rejected"
                                                            ? TextButton(
                                                                onPressed: null,
                                                                child: Text(
                                                                  "Update",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodySmall,
                                                                ))
                                                            :
                                                            // data[index]
                                                            //                 .services![servicesIndex]
                                                            //                 .status ==
                                                            //             "pending"
                                                            //         ? TextButton(
                                                            //             onPressed:
                                                            //                 null,
                                                            //             child: Text(
                                                            //               "Wait For Verified >",
                                                            //               style: Theme.of(
                                                            //                       context)
                                                            //                   .textTheme
                                                            //                   .bodySmall,
                                                            //             ))
                                                            //         :
                                                            data[index]
                                                                        .services![
                                                                            servicesIndex]
                                                                        .status ==
                                                                    "pending"
                                                                ? const SizedBox()
                                                                : TextButton(
                                                                    onPressed:
                                                                        null,
                                                                    child: Text(
                                                                      "ADD DETAILS >",
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodySmall,
                                                                    ))),
                                                    data[index]
                                                                .services!
                                                                .length ==
                                                            1
                                                        ? const SizedBox()
                                                        : const Divider(),
                                                  ],
                                                );
                                              })
                                          : const SizedBox()
                                    ],
                                  ),
                                );
                              });
                            },
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
