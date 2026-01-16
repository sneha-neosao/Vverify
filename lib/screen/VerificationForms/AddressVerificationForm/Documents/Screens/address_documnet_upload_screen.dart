import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/screen/VerificationForms/AddressVerificationForm/Documents/Blocs/address_document_list_bloc/address_doc_list_cubit.dart';
import 'package:v_verify/screen/VerificationForms/AddressVerificationForm/Documents/Blocs/address_document_list_bloc/address_doc_list_state.dart';
import 'package:v_verify/screen/VerificationForms/AddressVerificationForm/Documents/Blocs/address_document_upload_bloc/address_document_upload_cubit.dart';
import 'package:v_verify/screen/VerificationForms/AddressVerificationForm/Documents/Blocs/address_document_upload_bloc/address_document_upload_state.dart';
import 'package:v_verify/screen/VerificationForms/common/pick_multiple_photos.dart';
import 'package:url_launcher/url_launcher.dart';

class AddressDocumentUpload extends StatefulWidget {
  String Case_uuid;

  AddressDocumentUpload({super.key,required this.Case_uuid});

  @override
  State<AddressDocumentUpload> createState() => _AddressDocumentUploadState();
}

class _AddressDocumentUploadState extends State<AddressDocumentUpload> {

  @override
  void initState() {
    // TODO: implement initState
    educationList();
    super.initState();
  }

  void educationList() {
    String token = context.read<TokenCubit>().state;
    context.read<AddressDocumentListCubit>().loadAddressDocumentList(
        token: token,
        caseUuid: widget.Case_uuid,
        type: "all"
    );
  }

  void educationUploadDocData() async {
    String token = context.read<TokenCubit>().state;
    context.read<AddressDocsUploadCubitNew>().uploadAddressDocs(
        token: token,
        caseUuid: widget.Case_uuid,
        documents: context.read<AddressDocsFileCubit>().state,
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
                  "Address Verification",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Theme.of(context).primaryColorDark),
                ),
                const SizedBox(height: 16,),
                BlocBuilder<AddressDocsFileCubit, List<File>>(
                  builder: (context, uploadDocs) {
                    return PickMultiplePhoto(
                      widthSize: double.infinity,
                      title: "Select Documents",
                      mainTitle: "Upload Certificate/Marksheet/Document",
                      onPressedPickImage: () {
                        context.read<AddressDocsFileCubit>().pickMultipleFiles().then((_) {
                          context.pop();
                        });
                      },
                      onPressedTakePhoto: () {
                        context.read<AddressDocsFileCubit>().pickImageFromCamera().then((_) {
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
                Text(
                    "Note : Uploaded documents must not exceed 2 MB.",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(
                  height: 24,
                ),
                BlocConsumer<AddressDocsUploadCubitNew, AddressDocUploadStateNew>(
                    listener: (context, addressDoc) {
                      if (addressDoc is AddressDocUploadSuccessStateNew) {
                        if (addressDoc.data["status"] == 200) {
                          context.pushNamed("AddressList",pathParameters: {
                            'uid': widget.Case_uuid
                          });
                          context.read<AddressDocsFileCubit>().clearFiles();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                addressDoc.data["message"],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              )));
                        }
                      } else if (addressDoc is AddressDocUploadErrorStateNew) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              addressDoc.message,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            )));
                        print("uploadMessage ${addressDoc.message}");
                      }
                    }, builder: (context, addressDoc) {
                  return CustomButton(
                    isLoading: addressDoc is AddressDocUploadLoadingStateNew,
                    onTap: () {
                      if (context.read<AddressDocsFileCubit>().state.isEmpty) {
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
                  "Address Document List",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Theme.of(context).primaryColorDark),
                ),
                const SizedBox(
                  height: 16,
                ),
                BlocBuilder<AddressDocumentListCubit, AddressDocumentListState>(
                  builder: (context, state) {
                    if (state is AddressDocumentListLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is AddressDocumentListErrorState) {
                      return const Text("No related data found");
                    } else if (state is AddressDocumentListSuccessState) {
                      final data = state.addressDocuments;

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
                    } else if (state is AddressDocumentListErrorState) {
                      return SizedBox.shrink();
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
