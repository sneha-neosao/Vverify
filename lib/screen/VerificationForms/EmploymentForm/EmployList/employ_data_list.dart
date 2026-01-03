import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/screen/VerificationForms/common/id.dart';

import '../../../Bottom/bottomNavbar.dart';
import 'Bloc/employ_data_list_cubit.dart';
import 'Bloc/employ_data_list_state.dart';
import 'Model/employ_data_list_model.dart';

class EmployDataList extends StatefulWidget {
  const EmployDataList({super.key});

  @override
  State<EmployDataList> createState() => _EmployDataListState();
}

class _EmployDataListState extends State<EmployDataList> {
  @override
  void initState() {
    // employmentListDataLoad();
    super.initState();
  }

  void employmentListDataLoad() {
    String token = context.read<TokenCubit>().state;

    context.read<EmployDataListCubit>().employmentList(
        token: token,
        requestId: int.parse(requestId!),
        serviceRequestId: int.parse(serviceRequestId!));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
        child: Column(
          children: [
            Text(
              "Employment Verification List",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Theme.of(context).primaryColorDark),
            ),
            const SizedBox(
              height: 16,
            ),
            CustomButton(
              onTap: () {
                context.pushReplacement("/EmploymentSaveFormNew");
              },
              text: "Add Employment Details",
              gradientColors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColorDark,
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            CustomButton(
              onTap: () {
                selectedIndex = 0;
                context.go("/bottomNav");
              },
              text: "Home Page",
              gradientColors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColorDark,
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            BlocBuilder<EmployDataListCubit, EmployDataListState>(
                builder: (context, employList) {
              if (employList is EmployDataListLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (employList is EmployDataListErrorState) {
                return Center(
                  child: Text(employList.message),
                );
              } else if (employList is EmployDataListSuccessState) {
                EmployListDataModel data = employList.employListDataModel;
                return Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.data!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: data.data![index].dataPreference == "form"
                              ? Column(
                                  children: [
                                    ListTile(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      tileColor: Theme.of(context).cardColor,
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  '${data.data![index].status}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                          fontSize: 14,
                                                          color: data
                                                                          .data![
                                                                              index]
                                                                          .status ==
                                                                      "failed" ||
                                                                  data
                                                                          .data![
                                                                              index]
                                                                          .status ==
                                                                      "rejected"
                                                              ? Colors.red
                                                              : data
                                                                          .data![
                                                                              index]
                                                                          .status ==
                                                                      "verified"
                                                                  ? Colors.green
                                                                  : Theme.of(
                                                                          context)
                                                                      .primaryColorDark)),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Person Name",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                            color: Colors.grey),
                                                  ),
                                                  Text(
                                                    data.data![index].fullName!,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Company Name",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                            color: Colors.grey),
                                                  ),
                                                  Text(
                                                    data.data![index]
                                                        .companyName!,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Job Title",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                            color: Colors.grey),
                                                  ),
                                                  Text(
                                                    data.data![index].jobTitle!,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Department",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                            color: Colors.grey),
                                                  ),
                                                  Text(
                                                    data.data![index]
                                                                .department ==
                                                            null
                                                        ? ""
                                                        : data.data![index]
                                                            .department!,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          if (data.data![index].status ==
                                              "pending") {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        "Please wait your application under process")));
                                          } else if (data.data![index].status ==
                                              "verified") {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        "Your application already verified")));
                                          } else {
                                            context.pushNamed(
                                                "EmploymentUpdateForm1",
                                                pathParameters: {
                                                  'uid': data.data![index].uid
                                                      .toString()
                                                });
                                          }
                                        },
                                        child: Text(
                                          "Update",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ))
                                  ],
                                )
                              : Column(
                                  children: [
                                    Card(
                                      color: Theme.of(context).cardColor,
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('${data.data![index].status}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                        fontSize: 14,
                                                        color: data.data![index]
                                                                        .status ==
                                                                    "failed" ||
                                                                data
                                                                        .data![
                                                                            index]
                                                                        .status ==
                                                                    "rejected"
                                                            ? Colors.red
                                                            : data.data![index]
                                                                        .status ==
                                                                    "verified"
                                                                ? Colors.green
                                                                : Theme.of(
                                                                        context)
                                                                    .primaryColorDark)),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              children: [
                                                data.data![index]
                                                        .employmentSupportingDoc!
                                                        .contains("pdf")
                                                    ? Expanded(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Image.asset(
                                                              "assets/images/pdf_logo.png",
                                                              width: 80,
                                                              height: 80,
                                                            ),
                                                            Text(
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                data
                                                                    .data![
                                                                        index]
                                                                    .employmentSupportingDoc!)
                                                          ],
                                                        ),
                                                      )
                                                    : Expanded(
                                                        child: Image.network(data
                                                            .data![index]
                                                            .employmentSupportingDoc!)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          if (data.data![index].status ==
                                              "pending") {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        "Please wait your application under process")));
                                          } else if (data.data![index].status ==
                                              "verified") {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        "Your application already verified")));
                                          } else {
                                            context.pushNamed("EmployUpdateDoc",
                                                pathParameters: {
                                                  'uid': data.data![index].uid
                                                      .toString()
                                                });
                                          }
                                        },
                                        child: Text(
                                          "Update",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ))
                                  ],
                                ),
                        );
                      }),
                );
              }
              return const Center(
                child: Text("Error..."),
              );
            }),
          ],
        ),
      ),
    );
  }
}
