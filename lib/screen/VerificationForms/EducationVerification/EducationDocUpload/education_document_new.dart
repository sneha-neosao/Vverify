import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/screen/VerificationForms/EducationVerification/EducationDocUpload/Bloc/education_docs_upload_state_new.dart';
import 'package:v_verify/screen/VerificationForms/common/pick_multiple_photos.dart';
import 'package:v_verify/screen/VerificationForms/common/pickphoto.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/id.dart';
import '../EducationDocList/bloc/education_doc_list_cubit.dart';
import '../EducationDocList/bloc/education_doc_list_state.dart';
import '../EducationList/Bloc/education_list_cubit.dart';
import '../EducationList/Bloc/education_list_state.dart';
import 'Bloc/education_doc_upload_cubit.dart';
import 'Bloc/education_doc_upload_state.dart';
import 'Bloc/education_docs_upload_cubit_new.dart';

class EducationUploadDocumentNew extends StatefulWidget {
  String Case_uuid;

  EducationUploadDocumentNew({super.key,required this.Case_uuid});

  @override
  State<EducationUploadDocumentNew> createState() => _EducationUploadDocumentNewState();
}

class _EducationUploadDocumentNewState extends State<EducationUploadDocumentNew> {

  @override
  void initState() {
    // TODO: implement initState
    educationList();
    super.initState();
  }

  void educationList() {
    String token = context.read<TokenCubit>().state;
    context.read<EducationDocumentListCubit>().loadEducationDocumentList(
        token: token,
        caseUuid: widget.Case_uuid,
        type: "education"
    );
  }

  void educationUploadDocData() async {
    String token = context.read<TokenCubit>().state;
    context.read<EducationDocsUploadCubitNew>().uploadEducationDocs(
        token: token,
        caseUuid: widget.Case_uuid,
        documents: context.read<EducationDocsFileCubit>().state,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Education Verification",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Theme.of(context).primaryColorDark),
                ),
                const SizedBox(height: 16,),
                BlocBuilder<EducationDocsFileCubit, List<File>>(
                  builder: (context, uploadDocs) {
                    return PickMultiplePhoto(
                      widthSize: double.infinity,
                      title: "Select Documents",
                      mainTitle: "Upload Certificate/Marksheet/Document",
                      onPressedPickImage: () {
                        context.read<EducationDocsFileCubit>().pickMultipleFiles().then((_) {
                          context.pop();
                        });
                      },
                      onPressedTakePhoto: () {
                        context.read<EducationDocsFileCubit>().pickImageFromCamera().then((_) {
                          context.pop();
                        });
                      },
                      // Pass the list of files instead of a single File
                      files: uploadDocs,
                    );
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                    "Note : Upload one combined PDF if you have multiple documents."),
                const SizedBox(
                  height: 24,
                ),
                BlocConsumer<EducationDocsUploadCubitNew, EducationDocUploadStateNew>(
                    listener: (context, educationDoc) {
                      if (educationDoc is EducationDocUploadSuccessStateNew) {
                        if (educationDoc.data["status"] == 200) {
                          context.pushNamed("EducationList",pathParameters: {
                            'uid': widget.Case_uuid
                          });
                          context.read<EducationDocsFileCubit>().clearFiles();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                educationDoc.data["message"],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              )));
                        }
                      } else if (educationDoc is EducationDocUploadErrorStateNew) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              educationDoc.message,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            )));
                        print("uploadMessage ${educationDoc.message}");
                      }
                    }, builder: (context, educationDoc) {
                  return CustomButton(
                    isLoading: educationDoc is EducationDocUploadLoadingStateNew,
                    onTap: () {
                      if (context.read<EducationDocsFileCubit>().state.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                "Please Upload Certificate/Marksheet/Document")));
                      } else {
                        educationUploadDocData();
                      }
                    },
                    text: "SUBMIT",
                    gradientColors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColorDark
                    ],
                  );
                }),
                const SizedBox(height: 16),
                Text(
                  "Education Document List",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Theme.of(context).primaryColorDark),
                ),
                const SizedBox(
                  height: 16,
                ),
                BlocBuilder<EducationDocumentListCubit, EducationDocumentListState>(
                  builder: (context, state) {
                    if (state is EducationDocumentListLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is EducationDocumentListEmptyState) {
                      return const Text("No related data found");
                    } else if (state is EducationDocumentListSuccessState) {
                      final data = state.educationDocuments;

                      // If no documents, show button
                      if (data.data.documents.isEmpty) {
                        return const Text("No related data found");
                      }
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.data.documents.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final doc = data.data.documents[index];
                          final url = doc.documentUrl;

                          // Helper to launch URL
                          Future<void> _openUrl(String url) async {
                            final uri = Uri.parse(url);
                            if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Could not open document")),
                              );
                            }
                          }

                          String fileNameFromUrl(String url) {
                            try {
                              final uri = Uri.parse(url);

                              // Get the value of `path` query parameter
                              final pathParam = uri.queryParameters['path'];

                              if (pathParam == null || pathParam.isEmpty) {
                                return 'Document';
                              }

                              // Extract filename from that path
                              return pathParam.split('/').last;
                            } catch (e) {
                              return 'Document';
                            }
                          }
                          // String fileNameFromUrl(String url) {
                          //   try {
                          //     final uri = Uri.parse(url);
                          //     final pathParam = uri.queryParameters['path'];
                          //
                          //     if (pathParam == null || pathParam.isEmpty) {
                          //       return 'Document';
                          //     }
                          //
                          //     final fullName = pathParam.split('/').last;
                          //
                          //     // Extract only date-time + extension
                          //     final match = RegExp(r'\d{8}-\d{6}\.\w+$').firstMatch(fullName);
                          //
                          //     return match?.group(0) ?? fullName;
                          //   } catch (_) {
                          //     return 'Document';
                          //   }
                          // }


                          return ListTile(
                            leading: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: url.toLowerCase().endsWith(".png") ||
                                  url.toLowerCase().endsWith(".jpg") ||
                                  url.toLowerCase().endsWith(".jpeg")
                                  ? ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(
                                  url,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.attach_file, color: Colors.red);
                                  },
                                ),
                              )
                                  : const Icon(Icons.picture_as_pdf, color: Colors.red),
                            ),
                            title: Text(fileNameFromUrl(url),style: TextStyle(fontSize: 10),),
                            // subtitle: Text(url),
                            trailing: InkWell(
                              onTap: () => _openUrl(url),
                              child: Container(
                                height: 35,
                                width: 65,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  gradient: LinearGradient(
                                    colors: [
                                      Theme.of(context).primaryColor,
                                      Theme.of(context).primaryColorDark,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Center(
                                  child: Text("View",style: TextStyle(color: Colors.white),
                                )
                                ),
                              ),
                            )
                          );
                        },
                      );
                    } else if (state is EducationDocumentListErrorState) {
                      return Text("Error: ${state.message}");
                    }
                    return const SizedBox();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
