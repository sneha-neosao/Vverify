import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/screen/VerificationForms/common/id.dart';

import '../../../common/pickphoto.dart';
import '../../Form/Blocs/reference_save_form_bloc/reference_save_form_cubit.dart';
import '../Blocs/reference_document_upload_bloc/reference_upload_doc_cubit.dart';
import '../Blocs/reference_document_upload_bloc/reference_upload_doc_state.dart';

class ReferenceUploadDoc extends StatefulWidget {
  const ReferenceUploadDoc({super.key});

  @override
  State<ReferenceUploadDoc> createState() => _ReferenceUploadDocState();
}

class _ReferenceUploadDocState extends State<ReferenceUploadDoc> {
  void referenceCheckUploadDoc() {
    String token = context.read<TokenCubit>().state;
    String customerId = context.read<IdCubit>().state;
    context.read<ReferenceUploadDocCubit>().referenceUploadDoc(
        customer_id: customerId,
        token: token,
        requestId: requestId!,
        serviceRequestId: serviceRequestId!,
        dataDocument: context.read<ReferenceCheckUploadDoc>().state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Reference Check Verification",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Theme.of(context).primaryColorDark),
            ),
            const SizedBox(
              height: 16,
            ),
            Text("Choose an Option:",
                style: Theme.of(context).textTheme.bodySmall),
            BlocProvider(
              create: (_) => FormUploadReferenceCubit(),
              child: BlocBuilder<FormUploadReferenceCubit, bool>(
                  builder: (context, frmUpload) {
                return Column(
                  children: [
                    ListTile(
                      splashColor: Colors.transparent,
                      onTap: () {
                        context.pushReplacementNamed("ReferenceSaveFormScreen");

                        context
                            .read<FormUploadReferenceCubit>()
                            .formUploadYesNo(yesNo: true);

                        context
                            .read<FormUploadReferenceCubit>()
                            .formUploadYesNo(yesNo: false);
                      },
                      contentPadding: const EdgeInsets.all(0),
                      leading: Icon(Icons.radio_button_checked,
                          color: frmUpload
                              ? Theme.of(context).primaryColorLight
                              : Theme.of(context).iconTheme.color),
                      title: Text("Fill the Form Manually",
                          style: Theme.of(context).textTheme.bodySmall),
                    ),
                    ListTile(
                      splashColor: Colors.transparent,
                      onTap: () {
                        context
                            .read<FormUploadReferenceCubit>()
                            .formUploadYesNo(yesNo: false);
                      },
                      contentPadding: const EdgeInsets.all(0),
                      leading: Icon(Icons.radio_button_checked,
                          color: !frmUpload
                              ? Theme.of(context).primaryColorLight
                              : Theme.of(context).iconTheme.color),
                      title: Text("Upload Documents",
                          style: Theme.of(context).textTheme.bodySmall),
                    ),
                  ],
                );
              }),
            ),
            const SizedBox(
              height: 16,
            ),
            CustomButton(
                onTap: () {
                  // downloadFile();
                  FileDownloader.downloadFile(
                      notificationType: NotificationType.completionOnly,
                      url:
                          "https://testadminvverify.neosao.co.in/person_details_form.pdf",
                      name: "reference_form",
                      onDownloadCompleted: (path) {
                        final File file = File(path);
                        //This will be the path of the downloaded file
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text("Download Successfully ${file.path}")));
                      });
                },
                width: 200,
                gradientColors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColorDark
                ],
                text: "Sample PDF"),
            const SizedBox(
              height: 16,
            ),
            BlocBuilder<ReferenceCheckUploadDoc, File>(
                builder: (context, identityProof) {
              return PickPhoto(
                widthSize: double.infinity,
                mainTitle: "Upload Documents",
                title: "Upload Documents",
                onPressedPickImage: () {
                  context.pop();
                  context.read<ReferenceCheckUploadDoc>().pickFile();
                },
                onPressedTakePhoto: () {
                  context.pop();
                  context.read<ReferenceCheckUploadDoc>().pickImageFromCamera();
                },
                image: identityProof,
              );
            }),
            const SizedBox(
              height: 8,
            ),
            const Text("Note : Download sample pdf fill the data and upload."),
            const SizedBox(
              height: 24,
            ),
            BlocConsumer<ReferenceUploadDocCubit, ReferenceUploadDocState>(
                listener: (context, upload) {
              if (upload is ReferenceUploadDocSuccessState) {
                if (upload.data["status"] == 200) {
                  context.read<ReferenceCheckUploadDoc>().clearImage();
                  context.pushReplacementNamed("bottomNav");
                }
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(upload.data["message"])));
              } else if (upload is ReferenceUploadDocErrorState) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(upload.message)));
              }
            }, builder: (context, upload) {
              return CustomButton(
                onTap: () {
                  if (context
                      .read<ReferenceCheckUploadDoc>()
                      .state
                      .path
                      .isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Please Select Documents")));
                  } else {
                    referenceCheckUploadDoc();
                  }
                },
                isLoading: upload is ReferenceUploadDocLoadingState,
                text: "SUBMIT",
                gradientColors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColorDark,
                ],
              );
            })
          ],
        ),
      ),
    );
  }
}
