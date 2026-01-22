import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/NonMumbai/Document/Blocs/non_mumbai_document_show_details_bloc/non_mumbai_show_details_cubit.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/NonMumbai/Document/Blocs/non_mumbai_document_show_details_bloc/non_mumbai_show_details_state.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/NonMumbai/Document/Models/non_mumbai_show_details_model.dart';

import '../../../../../../commonComponent/bloc/shared_preferences_cubit.dart';
import '../../../../../../commonComponent/custom_button.dart';
import '../../../../../Add Signature/add_signature.dart';
import '../../../../common/id.dart';
import '../../../../common/pickphoto.dart';
import '../Blocs/non_mumbai_document_upload_bloc/non_mumbai_document_upload_cubit.dart';
import '../Blocs/non_mumbai_document_update_bloc/non_mumbai_document_update_cubit.dart';
import '../Blocs/non_mumbai_document_update_bloc/non_mumbai_document_update_state.dart';
import '../Models/non_mumbai_documents_update_model.dart';

class UpdateDocumentsNonMumbai extends StatefulWidget {
  String uid;

  UpdateDocumentsNonMumbai({super.key, required this.uid});

  @override
  State<UpdateDocumentsNonMumbai> createState() =>
      _UploadDocumentsNonMumbaiState();
}

class _UploadDocumentsNonMumbaiState extends State<UpdateDocumentsNonMumbai> {
  @override
  void initState() {
    nonMumbaiDocumentShowData();
    super.initState();
  }

  void pickImageClear() {
    context.read<UploadDocumentNonMumbaiTenantPhoto>().clearImage();
    context.read<UploadDocumentNonMumbaiTenantSignaturePhoto>().clearImage();
    context.read<UploadDocumentNonMumbaiTenantIdentityProof>().clearImage();
    context.read<UploadDocumentNonMumbaiTenantCompanyLetter>().clearImage();
    context.read<UploadDocumentNonMumbai>().clearImage();
  }

  void updateDocuments() {
    final String token = context.read<TokenCubit>().state;
    final String customerId = context.read<IdCubit>().state;

    context.read<UpdateDocumentsNonMumbaiCubit>().updateDocumentsNonMumbai(
        customer_id: customerId,
        token: token,
        updateDocumentsNonMumbaiModel: UpdateDocumentsNonMumbaiModel(
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

  void nonMumbaiDocumentShowData() {
    final String token = context.read<TokenCubit>().state;

    context
        .read<NonMumbaiDocShowDataCubit>()
        .nonMumbaiDocumentShowData(token: token, uid: widget.uid);
  }

  GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: SafeArea(
          child: SingleChildScrollView(child:
              BlocBuilder<NonMumbaiDocShowDataCubit, NonMumbaiDocShowDataState>(
                  builder: (context, showData) {
            if (showData is NonMumbaiDocShowDataLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (showData is NonMumbaiDocShowDataErrorState) {
              return Center(
                child: Text(showData.message),
              );
            } else if (showData is NonMumbaiDocShowDataSuccessState) {
              NonMumbaiDocShowDataModel data = showData.nonMumbaiDocShowDataModel;
              return Column(
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
                  Text(
                    "Non Mumbai Police Verification Remark:",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Colors.red),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    data.data!.reason!,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.red),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  BlocBuilder<UploadDocumentNonMumbai, File>(
                      builder: (context, tenantPhoto) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PickPhotoUpdate(
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
                          uploadImage: data.data!.dataDocument!,
                        )
                      ],
                    );
                  }),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                      "Note: Download sample pdf fill the data and upload."),
                  const SizedBox(
                    height: 16,
                  ),
                  BlocBuilder<UploadDocumentNonMumbaiTenantPhoto, File>(
                      builder: (context, tenantPhoto) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PickPhotoUpdate(
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
                          uploadImage: data.data!.tenantPhoto!,
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
                        PickPhotoUpdate(
                          isSign: true,
                          addSign: () {
                            context
                                .read<
                                    UploadDocumentNonMumbaiTenantSignaturePhoto>()
                                .addSignature(context, _signaturePadKey)
                                .then((_) {
                              try {
                                // Deleting the image file from local storage
                                File(signaturePhoto.path).delete().then((_) {});
                                // Show confirmation message
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Image deleted!')));
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
                                .read<
                                    UploadDocumentNonMumbaiTenantSignaturePhoto>()
                                .pickFile();
                          },
                          onPressedTakePhoto: () {
                            context.pop();
                            context
                                .read<
                                    UploadDocumentNonMumbaiTenantSignaturePhoto>()
                                .pickImageFromCamera();
                          },
                          image: signImage != null ? signImage! : signaturePhoto,
                          uploadImage: data.data!.tenantSignature!,
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
                    return PickPhotoUpdate(
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
                      uploadImage: data.data!.tenantIdentityProofDoc!,
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
                    return PickPhotoUpdate(
                      widthSize: double.infinity,
                      mainTitle: "Tenant's Company Letter",
                      title: "Tenant's Company Letter",
                      onPressedTakePhoto: () {
                        context.pop();
                        context
                            .read<UploadDocumentNonMumbaiTenantCompanyLetter>()
                            .pickImageFromCamera();
                      },
                      image: companyLetter,
                      uploadImage: data.data!.tenantLetterFromEmployer!,
                      onPressedPickImage: () {
                        context.pop();
                        context
                            .read<UploadDocumentNonMumbaiTenantCompanyLetter>()
                            .pickFile();
                      },
                    );
                  }),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text("Note: Upload Tenant's Company Letter"),
                  const SizedBox(
                    height: 24,
                  ),
                  BlocConsumer<UpdateDocumentsNonMumbaiCubit,
                          UpdateDocumentsNonMumbaiState>(
                      listener: (context, updateDocument) {
                    if (updateDocument is UpdateDocumentsNonMumbaiSuccessState) {
                      if (updateDocument.data["status"] == 200) {
                        context.pushNamed("bottomNav");
                        pickImageClear();
                      }
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(updateDocument.data["message"])));
                    } else if (updateDocument
                        is UpdateDocumentsNonMumbaiErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(updateDocument.message)));
                    }
                  }, builder: (context, uploadDocument) {
                    return CustomButton(
                      isLoading:
                          uploadDocument is UpdateDocumentsNonMumbaiLoadingState,
                      onTap: () {
                        updateDocuments();
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
              );
            }
            return const Center(
              child: Text("Error..."),
            );
          })),
        ),
      ),
    );
  }
}
