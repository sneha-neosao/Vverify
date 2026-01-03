import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/commonComponent/dottedBorder.dart';
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
String? _fileName;
File? filePath;

  @override
  void initState() {
    employmentListDataLoad();
    super.initState();
  }

Future<void> pickFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();

  if (result != null) {
    File file = File(result.files.single.path!);

    // You can access the file path and name like this
    setState(() {
      _fileName = result.files.single.name;
      filePath = file;
      print("pdfFile${result.files.single.name}");
      print("pdfFile${result.files.single.path!}");
    });
  } else {
    //User canceled the picker
  }
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
            BlocBuilder<EmployDataListCubit, EmployDataListState>(
              builder: (context, state) {
                if (state is EmployDataListLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is EmployDataListEmptyState) {
                  return CustomButton(
                    onTap: () {
                      context.pushReplacement("/EmploymentSaveFormNew");
                    },
                    text: "Add Employment Details",
                    gradientColors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColorDark,
                    ],
                  );
                } else if (state is EmployDataListSuccessState) {
                  final data = state.employListDataModel;
                  if (data.data == null || data.data!.isEmpty) {
                    return CustomButton(
                      onTap: () {
                        context.pushReplacement("/EmploymentSaveFormNew");
                      },
                      text: "Add Employment Details",
                      gradientColors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColorDark,
                      ],
                    );
                  }
                  // render list
                }
                return const SizedBox();
              },
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
                print("employment list error");
                return Center(
                  child: Text(employList.message),
                );
              } else if (employList is EmployDataListSuccessState) {
                print("employment list success");
                EmployListDataModel data = employList.employListDataModel;
                return Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.data!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: data.data![index].data_preference == "form"
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
                                                  data.data![index].v_status!.toLowerCase() == ""
                                                      ? "Verification Pending"
                                                      : data.data![index].v_status!.toLowerCase() == "clear"
                                                      ? "Clear" : "discrepancy",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                      fontSize: 14,
                                                      color: data.data![index].v_status!.toLowerCase() == ""
                                                          ? Colors.orange
                                                          : data.data![index].v_status!.toLowerCase() == "clear"
                                                          ? Colors.green
                                                          : Colors.red
                                                  )

                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Employer Name",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                            color: Colors.grey),
                                                  ),
                                                  Text(
                                                    data.data![index].employer_name?.trim().isEmpty ?? true
                                                        ? "NA"
                                                        : data.data![index].employed_from!,
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
                                                    "From Date (Joining)",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                            color: Colors.grey),
                                                  ),
                                                  Text(
                                                    data.data![index].employed_from?.trim().isEmpty ?? true
                                                        ? "NA"
                                                        : data.data![index].employed_from!,
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
                                                    "To Date (Leaving)",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                            color: Colors.grey),
                                                  ),
                                                  Text(
                                                    data.data![index].employed_to?.trim().isEmpty ?? true
                                                        ? "NA"
                                                        : data.data![index].employed_to!,
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
                                                    "Designation",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                            color: Colors.grey),
                                                  ),
                                                  Text(
                                                    data.data![index].designation?.trim().isEmpty ?? true
                                                        ? "NA"
                                                        : data.data![index].designation!,
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
                                                    data.data![index].department?.trim().isEmpty ?? true
                                                        ? "NA"
                                                        : data.data![index].department!,
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
                                                    "Renumeration",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                        color: Colors.grey),
                                                  ),
                                                  Text(
                                                    data.data![index].remunaration?.trim().isEmpty ?? true
                                                        ? "NA"
                                                        : data.data![index].remunaration!,
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
                                          if (data.data![index].v_status ==
                                              "pending") {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        "Please wait your application under process")));
                                          } else if (data.data![index].v_status ==
                                              "verified") {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        "Your application already verified")));
                                          } else {
                                            context.pushNamed(
                                                "EmploymentUpdateFormNew",
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
                                ):
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  data.data![index].v_status!.toLowerCase() == ""
                                      ? "Verification Pending"
                                      : data.data![index].v_status!.toLowerCase() == "clear"
                                      ? "Clear" : "discrepancy",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                      fontSize: 14,
                                      color: data.data![index].v_status!.toLowerCase() == ""
                                          ? Colors.orange
                                          : data.data![index].v_status!.toLowerCase() == "clear"
                                          ? Colors.green
                                          : Colors.red
                                  )

                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomPaint(
                                    painter: DottedBorderPainter(
                                        context: context),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .primaryColorDark
                                            .withOpacity(0.2),
                                        borderRadius:
                                        BorderRadius.circular(8),
                                        // border: Border.all(color: Colors.black)
                                      ),
                                      width: double.infinity,
                                      height: 150,
                                      child: _fileName == null
                                          ? Center(
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.all(
                                              8.0),
                                          child: data.data![index]
                                              .employment_supporting_doc!
                                              .contains("pdf")
                                              ? Column(
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
                                                    .v_status!,
                                              ),
                                            ],
                                          )
                                              : Image.network(data
                                              .data![index]
                                              .employment_supporting_doc!),
                                        ),
                                      )
                                          : Center(
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.all(
                                                8.0),
                                            child: Text(
                                                textAlign:
                                                TextAlign.center,
                                                _fileName!),
                                          )),
                                    )),
                              ),
                              Center(
                                child: TextButton(
                                    onPressed: () {
                                      if (data.data![index].v_status == "pending") {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                            content: Text(
                                                "Please wait your application under process")));
                                      } else if (data.data![index].v_status == "clear") {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                            content: Text(
                                                "Your application already verified")));
                                      } else {
                                        context.pushReplacementNamed(
                                            "EducationDocUpdate",
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
                                          .bodyMedium,
                                    )),
                              )
                            ],
                          ),
                        );
                      }),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}
