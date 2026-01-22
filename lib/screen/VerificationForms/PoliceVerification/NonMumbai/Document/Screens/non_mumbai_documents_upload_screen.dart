import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/screen/VerificationForms/common/id.dart';

import '../../../../../../commonComponent/bloc/shared_preferences_cubit.dart';
import '../../../../../Add Signature/add_signature.dart';
import '../../../../common/pickphoto.dart';
import '../../Form/Blocs/non_mumbai_save_form_bloc/non_mumbai_save_form_cubit.dart';
import '../Models/non_mumbai_documents_upload_model.dart';
import '../Blocs/non_mumbai_document_upload_bloc/non_mumbai_document_upload_cubit.dart';
import '../Blocs/non_mumbai_document_upload_bloc/non_mumbai_document_upload_state.dart';

class UploadDocumentsNonMumbai extends StatefulWidget {
  const UploadDocumentsNonMumbai({super.key});

  @override
  State<UploadDocumentsNonMumbai> createState() =>
      _UploadDocumentsNonMumbaiState();
}

class _UploadDocumentsNonMumbaiState extends State<UploadDocumentsNonMumbai> {
  void pickImageClear() {
    context.read<UploadDocumentNonMumbaiTenantPhoto>().clearImage();
    context.read<UploadDocumentNonMumbaiTenantSignaturePhoto>().clearImage();
    context.read<UploadDocumentNonMumbaiTenantIdentityProof>().clearImage();
    context.read<UploadDocumentNonMumbaiTenantCompanyLetter>().clearImage();
    context.read<UploadDocumentNonMumbai>().clearImage();
  }

  void uploadDocuments() {
    final String token = context.read<TokenCubit>().state;
    final String customerId = context.read<IdCubit>().state;

    context.read<UploadDocumentsNonMumbaiCubit>().uploadDocumentsNonMumbai(
        customer_id: customerId,
        token: token,
        uploadDocumentsNonMumbaiModel: UploadDocumentsNonMumbaiModel(
            request_id: requestId!,
            service_request_id: serviceRequestId!,
            tenant_photo:
                context.read<UploadDocumentNonMumbaiTenantPhoto>().state,
            tenant_signature: context
                .read<UploadDocumentNonMumbaiTenantSignaturePhoto>()
                .state,
            tenant_identity_proof_doc: context
                .read<UploadDocumentNonMumbaiTenantIdentityProof>()
                .state,
            tenant_letter_from_employer: context
                .read<UploadDocumentNonMumbaiTenantCompanyLetter>()
                .state,
            data_document: context.read<UploadDocumentNonMumbai>().state));
  }

  GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Police Verification For Non-Mumbai",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).primaryColorDark,
                  ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text("Choose an Option:",
                style: Theme.of(context).textTheme.bodySmall),
            BlocProvider(
              create: (_) => FormUploadCubit(),
              child: BlocBuilder<FormUploadCubit, bool>(
                  builder: (context, frmUpload) {
                return Column(
                  children: [
                    ListTile(
                      splashColor: Colors.transparent,
                      onTap: () {
                        context.pushReplacementNamed("NonMumbaiPoliceSaveFormScreen1");

                        context
                            .read<FormUploadCubit>()
                            .formUploadYesNo(yesNo: true);

                        context
                            .read<FormUploadCubit>()
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
                            .read<FormUploadCubit>()
                            .formUploadYesNo(yesNo: false);
                      },
                      contentPadding: const EdgeInsets.all(0),
                      leading: Icon(
                        Icons.radio_button_checked,
                        color: !frmUpload
                            ? Theme.of(context).primaryColorLight
                            : Theme.of(context).iconTheme.color,
                      ),
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
            const Text("Download this PDF file, fill form and upload"),
            const SizedBox(
              height: 8,
            ),
            CustomButton(
                onTap: () {
                  FileDownloader.downloadFile(
                      notificationType: NotificationType.completionOnly,
                      url:
                          "https://testadminvverify.neosao.co.in/Non_Mumbai_Police_Verification.pdf",
                      name: "nonMumbai_form",
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
            BlocBuilder<UploadDocumentNonMumbai, File>(
                builder: (context, tenantPhoto) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PickPhoto(
                    mainTitle: "Upload Documents",
                    widthSize: double.infinity,
                    title: "Upload Documents",
                    onPressedPickImage: () {
                      context.pop();
                      context.read<UploadDocumentNonMumbai>().pickFile();
                    },
                    onPressedTakePhoto: () {
                      context.pop();
                      context
                          .read<UploadDocumentNonMumbai>()
                          .pickImageFromCamera();
                    },
                    image: tenantPhoto,
                  )
                ],
              );
            }),
            const SizedBox(
              height: 8,
            ),
            const Text(
                "Note: Note : Download sample pdf fill the data and upload."),
            const SizedBox(
              height: 16,
            ),
            BlocBuilder<UploadDocumentNonMumbaiTenantPhoto, File>(
                builder: (context, tenantPhoto) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PickPhoto(
                    mainTitle: "Tenant Photo",
                    title: "Tenant Photo",
                    onPressedPickImage: () {
                      context.pop();
                      context
                          .read<UploadDocumentNonMumbaiTenantPhoto>()
                          .pickImageFromGallery();
                    },
                    onPressedTakePhoto: () {
                      context.pop();
                      context
                          .read<UploadDocumentNonMumbaiTenantPhoto>()
                          .pickImageFromCamera();
                    },
                    image: tenantPhoto,
                  )
                ],
              );
            }),
            const SizedBox(
              height: 8,
            ),
            const Text("Note : Upload tenant profile photo"),
            const SizedBox(
              height: 16,
            ),
            BlocBuilder<UploadDocumentNonMumbaiTenantSignaturePhoto, File>(
                builder: (context, signaturePhoto) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PickPhoto(
                    isSign: true,
                    addSign: () {
                      context
                          .read<UploadDocumentNonMumbaiTenantSignaturePhoto>()
                          .addSignature(context, _signaturePadKey)
                          .then((_) {
                        try {
                          // Deleting the image file from local storage
                          File(signaturePhoto.path).delete().then((_) {});
                          // Show confirmation message
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Image deleted!')));
                          // Pop the screen after deletion
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Failed to delete image')));
                        }
                      });
                    },
                    mainTitle: "Signature Photo",
                    title: "Tenant's Signature Photo",
                    onPressedPickImage: () {
                      context.pop();
                      context
                          .read<UploadDocumentNonMumbaiTenantSignaturePhoto>()
                          .pickFile();
                    },
                    onPressedTakePhoto: () {
                      context.pop();
                      context
                          .read<UploadDocumentNonMumbaiTenantSignaturePhoto>()
                          .pickImageFromCamera();
                    },
                    image: signImage != null ? signImage! : signaturePhoto,
                  )
                ],
              );
            }),
            const SizedBox(
              height: 8,
            ),
            const Text("Note : Upload tenant signature photo"),
            const SizedBox(
              height: 16,
            ),
            BlocBuilder<UploadDocumentNonMumbaiTenantIdentityProof, File>(
                builder: (context, identityProof) {
              return PickPhoto(
                widthSize: double.infinity,
                mainTitle: "Tenant's Identity Proof",
                title: "Tenant's Identity Proof",
                onPressedPickImage: () {
                  context.pop();
                  context
                      .read<UploadDocumentNonMumbaiTenantIdentityProof>()
                      .pickFile();
                },
                onPressedTakePhoto: () {
                  context.pop();
                  context
                      .read<UploadDocumentNonMumbaiTenantIdentityProof>()
                      .pickImageFromCamera();
                },
                image: identityProof,
              );
            }),
            const SizedBox(
              height: 8,
            ),
            const Text(
                "Note: Upload Aadhaar Card, Pan Card, Passport, Voter Id"),
            const SizedBox(height: 16),
            BlocBuilder<UploadDocumentNonMumbaiTenantCompanyLetter, File>(
                builder: (context, companyLetter) {
              return PickPhoto(
                widthSize: double.infinity,
                mainTitle: "Tenant's Company Letter",
                title: "Tenant's  Company Letter ",
                onPressedPickImage: () {
                  context
                      .read<UploadDocumentNonMumbaiTenantCompanyLetter>()
                      .pickFile()
                      .then((_) {
                    context.pop();
                  });
                },
                onPressedTakePhoto: () {
                  context
                      .read<UploadDocumentNonMumbaiTenantCompanyLetter>()
                      .pickImageFromCamera()
                      .then((_) {
                    context.pop();
                  });
                },
                image: companyLetter,
              );
            }),
            const SizedBox(
              height: 8,
            ),
            const Text("Note: Upload Tenant's Company Letter"),
            const SizedBox(
              height: 24,
            ),
            BlocConsumer<UploadDocumentsNonMumbaiCubit,
                    UploadDocumentNonMumbaiState>(
                listener: (context, uploadDocument) {
              if (uploadDocument is UploadDocumentNonMumbaiSuccessState) {
                if (uploadDocument.data["status"] == 200) {
                  context.pushNamed("bottomNav");
                  pickImageClear();
                }
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(uploadDocument.data["message"])));
              }
            }, builder: (context, uploadDocument) {
              return CustomButton(
                isLoading:
                    uploadDocument is UploadDocumentNonMumbaiLoadingState,
                onTap: () {
                  if (context
                          .read<UploadDocumentNonMumbaiTenantPhoto>()
                          .state
                          .path
                          .isEmpty ||
                      context
                          .read<UploadDocumentNonMumbaiTenantSignaturePhoto>()
                          .state
                          .path
                          .isEmpty ||
                      context
                          .read<UploadDocumentNonMumbaiTenantIdentityProof>()
                          .state
                          .path
                          .isEmpty ||
                      context
                          .read<UploadDocumentNonMumbaiTenantCompanyLetter>()
                          .state
                          .path
                          .isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Please Upload Documents")));
                  } else {
                    uploadDocuments();
                  }
                },
                text: "SUBMIT",
                gradientColors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColorDark
                ],
              );
            }),
            const SizedBox(height: 16)
          ],
        )),
      ),
    );
  }
}
