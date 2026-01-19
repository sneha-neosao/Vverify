import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/commonComponent/dottedBorder.dart';
import 'package:v_verify/screen/VerificationForms/common/id.dart';

import '../../../../Bottom/bottomNavbar.dart';
import '../Blocs/employment_list_cubit.dart';
import '../Blocs/employment_list_state.dart';
import '../Models/employment_list_model.dart';

class EmployDataList extends StatefulWidget {
  String Case_uuid;

   EmployDataList({super.key, required this.Case_uuid});

  @override
  State<EmployDataList> createState() => _EmployDataListState();
}

class _EmployDataListState extends State<EmployDataList> {
String? _fileName;
File? filePath;

  @override
  void initState() {
    print("employment case uuid at employment data list : ${widget.Case_uuid}");
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
            CustomButton(
              onTap: () {
                context.pushNamed(
                  "EmploymentSaveFormScreen",
                  pathParameters: {'case_uid': widget.Case_uuid}, // must be non-empty
                );
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
                context.pushNamed(
                  "EmploymentDocumentUpload",
                  pathParameters: {'uid': widget.Case_uuid}, // must be non-empty
                );
              },
              text: "Add Documents",
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
                        final rawStatus = data.data![index].v_status ?? "";
                        String status;

                        if (rawStatus.isEmpty || rawStatus == "-" || rawStatus == "") {
                          status = "pending";
                        } else if (rawStatus == "discrepancy") {
                          status = "discrepancy";
                        } else if (rawStatus == "verified" || rawStatus == "clear") {
                          status = "verified";
                        } else {
                          status = rawStatus; // fallback for other values
                        }

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
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
                                                  status.toLowerCase() == "verified"
                                                      ? "Verified"
                                                      : status.toLowerCase() == "discrepancy"
                                                      ? "Discrepancy" : "Verification Pending",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                      fontSize: 14,
                                                      color: status.toLowerCase() == "verified"
                                                          ? Colors.green
                                                          :status.toLowerCase() == "discrepancy"
                                                          ? Colors.red
                                                          : Colors.orange
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
                                                        : data.data![index].employer_name!,
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
                                                    "Remuneration",
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
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Reporting Manager",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                        color: Colors.grey),
                                                  ),
                                                  Text(
                                                    data.data![index].reporting_manager?.trim().isEmpty ?? true
                                                        ? "NA"
                                                        : data.data![index].reporting_manager!,
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
                                                    "Reason For Leaving",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                        color: Colors.grey),
                                                  ),
                                                  Text(
                                                    data.data![index].reason_for_leaving?.trim().isEmpty ?? true
                                                        ? "NA"
                                                        : data.data![index].reason_for_leaving!,
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
                                              "") {
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
                                              'EmploymentUpdateFormScreen',
                                              pathParameters: {
                                                'uid': data.data![index].uid!,
                                                'case_uuid': data.data![index].case_uuid!,
                                                'employment_uuid': data.data![index].employment_uuid!
                                              },
                                            );
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
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}
