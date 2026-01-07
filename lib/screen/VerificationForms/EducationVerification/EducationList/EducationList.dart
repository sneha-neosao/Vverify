import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/screen/VerificationForms/EducationVerification/EducationList/Bloc/education_list_state.dart';
import 'package:v_verify/screen/VerificationForms/common/id.dart';

import '../../../../commonComponent/dottedBorder.dart';
import '../../../Bottom/bottomNavbar.dart';
import 'Bloc/education_list_cubit.dart';
import 'Model/education_list_model.dart';

class EducationList extends StatefulWidget {
  String Case_uuid;

  EducationList({super.key, required this.Case_uuid,});

  @override
  State<EducationList> createState() => _EducationListState();
}

class _EducationListState extends State<EducationList> {
  @override
  void initState() {
    educationList();
    super.initState();
    print("case uuid on education list : ${widget.Case_uuid}");
  }

  void educationList() {
    String token = context.read<TokenCubit>().state;
    context.read<EducationListCubit>().educationList(
        token: token,
        request_id: int.parse(requestId!),
        service_request_id: int.parse(serviceRequestId!));
  }

  String? _fileName;
  File? filePath;

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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        selectedIndex = 0; // your bottom nav index
        context.go("/bottomNav"); // navigate to Home
        return false; // prevent default back
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
          child: Column(
            children: [
              Text(
                "Education Verification List",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Theme.of(context).primaryColorDark),
              ),
              const SizedBox(
                height: 16,
              ),
              BlocBuilder<EducationListCubit, EducationListState>(
                builder: (context, state) {
                  if (state is EducationListLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is EducationListEmptyState) {
                    return CustomButton(
                      onTap: () {
                        context.pushNamed(
                          "EducationSaveFormNew",
                          pathParameters: {'uid': widget.Case_uuid}, // must be non-empty
                        );
                      },
                      text: "Add Education Details",
                      gradientColors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColorDark,
                      ],
                    );
                  } else if (state is EducationListSuccessState) {
                    final data = state.educationListModel;
                    if (data.data == null || data.data!.isEmpty) {
                      return CustomButton(
                        onTap: () {
                          context.pushNamed(
                            "EducationSaveFormNew",
                            pathParameters: {'uid': widget.Case_uuid}, // must be non-empty
                          );
                        },
                        text: "Add Education Details",
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
                  context.pushNamed(
                    "EducationSaveFormNew",
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
              BlocBuilder<EducationListCubit, EducationListState>(
                  builder: (context, educationList) {
                if (educationList is EducationListLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (educationList is EducationListErrorState) {
                  return const Center(
                    child: Text("Not found education verification data...!"),
                  );
                } else if (educationList is EducationListSuccessState) {
                  EducationDocListModel data = educationList.educationListModel;
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
                                            Text(
                                                data.data![index].verification_remark!.toLowerCase() == ""
                                                    ? "Verification Pending"
                                                    : data.data![index].verification_remark!.toLowerCase() == "clear"
                                                    ? "Clear" : "discrepancy",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                    fontSize: 14,
                                                    color: data.data![index].verification_remark!.toLowerCase() == ""
                                                        ? Colors.orange
                                                        : data.data![index].verification_remark!.toLowerCase() == "clear"
                                                        ? Colors.green
                                                        : Colors.red
                                                )

                                            ),
                                            Column(
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
                                                      "University Name",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                              color: Colors.grey),
                                                    ),
                                                    Text(
                                                      data.data![index].university_name?.trim().isEmpty ?? true
                                                          ? "NA"
                                                          : data.data![index].university_name!,
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
                                                      "Institution Name",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                              color: Colors.grey),
                                                    ),
                                                    Text(
                                                      data.data![index].institution_name?.trim().isEmpty ?? true
                                                          ? "NA"
                                                          : data.data![index].institution_name!,
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
                                                      "Degree Name",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                              color: Colors.grey),
                                                    ),
                                                    Text(
                                                      data.data![index].degree_qualification_name?.trim().isEmpty ?? true
                                                          ? "NA"
                                                          : data.data![index].degree_qualification_name!,
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
                                                      "Year Of Passing",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                          color: Colors.grey),
                                                    ),
                                                    Text(
                                                      data.data![index].year_of_passing?.trim().isEmpty ?? true
                                                          ? "NA"
                                                          : data.data![index].year_of_passing!,
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
                                                      "Grades Type",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                          color: Colors.grey),
                                                    ),
                                                    Text(
                                                      data.data![index].grades_type?.trim().isEmpty ?? true
                                                          ? "NA"
                                                          : data.data![index].grades_type!,
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
                                                      "Grades Obtained",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                              color: Colors.grey),
                                                    ),
                                                    Text(
                                                      data.data![index].grades_obtained?.trim().isEmpty ?? true
                                                          ? "NA"
                                                          : data.data![index].grades_obtained!,
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
                                      TextButton(
                                          onPressed: () {
                                            if (data.data![index].created_at ==
                                                "pending") {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          "Please wait your application under process")));
                                            } else if (data.data![index].created_at ==
                                                "verified") {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          "Your application already verified")));
                                            } else {
                                              context.pushNamed(
                                                'EducationSaveFormUpdateNew',
                                                pathParameters: {
                                                  'uid': data.data![index].uid!,
                                                  'case_uuid': data.data![index].case_uuid!,
                                                  'education_uuid': data.data![index].education_uuid!
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
                                  )
                                : Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          data.data![index].verification_remark!.toLowerCase() == ""
                                              ? "Verification Pending"
                                              : data.data![index].verification_remark!.toLowerCase() == "clear"
                                              ? "Clear" : "discrepancy",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                              fontSize: 14,
                                              color: data.data![index].verification_remark!.toLowerCase() == ""
                                                  ? Colors.orange
                                                  : data.data![index].verification_remark!.toLowerCase() == "clear"
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
                                                                .document!
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
                                                                        .verification_remark!,
                                                                  ),
                                                                ],
                                                              )
                                                            : Image.network(data
                                                                .data![index]
                                                                .document!),
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
      ),
    );
  }
}
