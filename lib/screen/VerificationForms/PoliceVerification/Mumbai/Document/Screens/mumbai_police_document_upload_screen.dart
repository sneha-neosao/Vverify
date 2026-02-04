import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/commonComponent/screen_size.dart';
import 'package:v_verify/screen/VerificationForms/common/id.dart';
import 'package:v_verify/screen/VerificationForms/common/pickphoto.dart';

import '../../../../../../commonComponent/bloc/shared_preferences_cubit.dart';
import '../../Form/Blocs/mumbai_police_verification_save_bloc/mumbai_police_save_form_cubit.dart';
import '../Models/mumbai_upload_documents_model.dart';
import '../Blocs/mumbai_police_document_upload_bloc/mumbai_document_upload_cubit.dart';
import '../Blocs/mumbai_police_document_upload_bloc/mumbai_documents_upload_state.dart';

class UploadDocumentsMumbai extends StatefulWidget {
  const UploadDocumentsMumbai({super.key});

  @override
  State<UploadDocumentsMumbai> createState() =>
      _UploadDocumentsNonMumbaiState();
}

class _UploadDocumentsNonMumbaiState extends State<UploadDocumentsMumbai> {
  final Dio _dio = Dio();

  void pickImageClear() {
    context.read<UploadDocumentMumbaiOwnerPhoto>().clearImage();
    context.read<UploadDocumentMumbaiTenantPhoto>().clearImage();
    context.read<UploadDocumentMumbaiTenantIdentityProof>().clearImage();
    context.read<UploadDocumentMumbaiTenantSignature>().clearImage();
  }

  // Function to download file
  Future<void> downloadFile() async {
    try {
      String url =
          'https://morth.nic.in/sites/default/files/dd12-13_0.pdf'; // Replace with the URL of the file you want to download
      // Get the directory to save the file
      Directory? dir = await getExternalStorageDirectory();
      if (dir != null) {
        // Define the full path including file name
        String savePath =
            '${dir.path}/Download/Reference.pdf'; // Save to the "Download" folder
        // Make sure the directory exists
        final downloadDir = Directory('${dir.path}/Download');
        if (!await downloadDir.exists()) {
          await downloadDir.create(recursive: true);
        }
        // Download the file
        await _dio.download(url, savePath,
            onReceiveProgress: (received, total) {
          if (total != -1) {
            print((received / total * 100).toStringAsFixed(0) + "%");
          }
        });
        print("File downloaded successfully to: $savePath");
      }
    } catch (e) {
      print("Download failed: $e");
    }
  }

  void uploadDocuments() {
    final String token = context.read<TokenCubit>().state;
    final String customerId = context.read<IdCubit>().state;

    context.read<UploadDocumentsMumbaiCubit>().uploadDocumentsMumbai(
        customer_id: customerId,
        token: token,
        uploadDocumentsMumbaiModel: UploadDocumentsMumbaiModel(
            request_id: requestId!,
            service_request_id: serviceRequestId!,
            police_station_id: '1',
            tenant_photo: context.read<UploadDocumentMumbaiTenantPhoto>().state,
            tenant_signature:
                context.read<UploadDocumentMumbaiTenantSignature>().state,
            tenant_identity_proof_doc:
                context.read<UploadDocumentMumbaiTenantIdentityProof>().state,
            data_document: context.read<UploadDocumentMumbai>().state,
            owner_photo: context.read<UploadDocumentMumbaiOwnerPhoto>().state));
  }

  GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<UploadDocumentMumbaiTenantPhoto>().clearImage();
        context.read<UploadDocumentMumbaiTenantSignature>().clearImage();
        context.read<UploadDocumentMumbaiTenantIdentityProof>().clearImage();
        context.read<UploadDocumentMumbai>().clearImage();
        context.read<UploadDocumentMumbaiOwnerPhoto>().clearImage();
        return true;
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Police Verification For Mumbai",
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
                create: (_) => FormUploadMumbaiCubit(),
                child: BlocBuilder<FormUploadMumbaiCubit, bool>(
                    builder: (context, frmUpload) {
                  return Column(
                    children: [
                      ListTile(
                        splashColor: Colors.transparent,
                        onTap: () {
                          context.pushReplacementNamed("MumbaiPoliceSaveFormScreen1");

                          context
                              .read<FormUploadMumbaiCubit>()
                              .formUploadYesNo(yesNo: true);

                          context
                              .read<FormUploadMumbaiCubit>()
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
                              .read<FormUploadMumbaiCubit>()
                              .formUploadYesNo(yesNo: true);
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
                            "https://testadminvverify.neosao.co.in/Mumbai_Police_Verification.pdf",
                        name: "mumbai_form",
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
              BlocBuilder<UploadDocumentMumbai, File>(
                  builder: (context, documents) {
                return PickPhoto(
                    widthSize: double.infinity,
                    onPressedPickImage: () {
                      context.pop();
                      context.read<UploadDocumentMumbai>().pickFile();
                    },
                    onPressedTakePhoto: () {
                      context.pop();
                      context.read<UploadDocumentMumbai>().pickImageFromCamera();
                    },
                    title: "Documents Upload",
                    image: documents,
                    mainTitle: "Upload Documents");
              }),
              const SizedBox(
                height: 8,
              ),
              const Text("Note : Download sample pdf fill the data and upload."),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlocBuilder<UploadDocumentMumbaiOwnerPhoto, File>(
                      builder: (context, tenantPhoto) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PickPhoto(
                          mainTitle: "Property Owner Photo",
                          widthSize: ScreenSize.screenWidth / 2.5,
                          title: "Property Owner Photo",
                          onPressedPickImage: () {
                            context.pop();
                            context
                                .read<UploadDocumentMumbaiOwnerPhoto>()
                                .pickImageFromGallery();
                          },
                          onPressedTakePhoto: () {
                            context.pop();
                            context
                                .read<UploadDocumentMumbaiOwnerPhoto>()
                                .pickImageFromCamera();
                          },
                          image: tenantPhoto,
                        )
                      ],
                    );
                  }),
                  BlocBuilder<UploadDocumentMumbaiTenantPhoto, File>(
                      builder: (context, signaturePhoto) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PickPhoto(
                          mainTitle: "Tenant Photo",
                          widthSize: ScreenSize.screenWidth / 2.5,
                          title: "Tenant Photo",
                          onPressedPickImage: () {
                            context.pop();
                            context
                                .read<UploadDocumentMumbaiTenantPhoto>()
                                .pickImageFromGallery();
                          },
                          onPressedTakePhoto: () {
                            context.pop();
                            context
                                .read<UploadDocumentMumbaiTenantPhoto>()
                                .pickImageFromCamera();
                          },
                          image: signaturePhoto,
                        )
                      ],
                    );
                  }),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              BlocBuilder<UploadDocumentMumbaiTenantIdentityProof, File>(
                  builder: (context, identityProof) {
                return PickPhoto(
                  mainTitle: "Tenant's Identity Proof",
                  widthSize: double.infinity,
                  title: "Tenant's Identity Proof",
                  onPressedPickImage: () {
                    context.pop();
                    context
                        .read<UploadDocumentMumbaiTenantIdentityProof>()
                        .pickFile();
                  },
                  onPressedTakePhoto: () {
                    context.pop();
                    context
                        .read<UploadDocumentMumbaiTenantIdentityProof>()
                        .pickImageFromCamera();
                  },
                  image: identityProof,
                );
              }),
              const SizedBox(
                height: 8,
              ),
              const Text(
                  "Note : Upload Aadhaar Card, Pan Card, Passport, Voter Id"),
              const SizedBox(height: 16),
              BlocBuilder<UploadDocumentMumbaiTenantSignature, File>(
                  builder: (context, companyLetter) {
                return PickPhoto(
                  mainTitle: "Tenant Signature Photo",
                  widthSize: double.infinity,
                  title: "Tenant Signature Photo",
                  onPressedPickImage: () {
                    context.pop();
                    context
                        .read<UploadDocumentMumbaiTenantSignature>()
                        .pickFile();
                  },
                  isSign: true,
                  addSign: () {
                    context.pop();
                    context
                        .read<UploadDocumentMumbaiTenantSignature>()
                        .addSignature(context, _signaturePadKey)
                        .then((_) {
                      try {
                        // Deleting the image file from local storage
                        File(companyLetter.path).delete().then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Image deleted!')));
                        });
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Failed to delete image')));
                      }
                    });
                  },
                  image: companyLetter,
                  onPressedTakePhoto: () {},
                );
              }),
              const SizedBox(
                height: 8,
              ),
              const Text("Note : Upload tenant signature photo"),
              const SizedBox(
                height: 24,
              ),
              BlocConsumer<UploadDocumentsMumbaiCubit, UploadDocumentMumbaiState>(
                  listener: (context, uploadDocument) {
                if (uploadDocument is UploadDocumentMumbaiSuccessState) {
                  if (uploadDocument.data["status"] == 200) {
                    context.pushNamed("bottomNav");
                    pickImageClear();
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(uploadDocument.data["message"])));
                }
              }, builder: (context, uploadDocument) {
                return CustomButton(
                  isLoading: uploadDocument is UploadDocumentMumbaiLoadingState,
                  onTap: () {
                    if (context
                            .read<UploadDocumentMumbaiOwnerPhoto>()
                            .state
                            .path
                            .isEmpty ||
                        context
                            .read<UploadDocumentMumbaiTenantPhoto>()
                            .state
                            .path
                            .isEmpty ||
                        context
                            .read<UploadDocumentMumbaiTenantIdentityProof>()
                            .state
                            .path
                            .isEmpty ||
                        context
                            .read<UploadDocumentMumbaiTenantSignature>()
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
      ),
    );
  }
}
