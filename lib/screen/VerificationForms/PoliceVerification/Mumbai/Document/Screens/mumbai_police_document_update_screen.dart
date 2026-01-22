import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/commonComponent/screen_size.dart';
import 'package:v_verify/screen/VerificationForms/common/id.dart';
import 'package:v_verify/screen/VerificationForms/common/pickphoto.dart';

import '../../../../../../commonComponent/bloc/shared_preferences_cubit.dart';
import '../../../../../../commonComponent/dottedBorder.dart';
import '../../../../../Add Signature/add_signature.dart';
import '../Blocs/mumbai_police_document_upload_bloc/mumbai_document_upload_cubit.dart';
import '../Blocs/mumbai_police_document_update_bloc/mumbai_documnet_update_cubit.dart';
import '../Blocs/mumbai_police_document_update_bloc/mumbai_document_update_state.dart';
import '../Models/mumbai_document_update_model.dart';
import '../Models/mumbai_document_show_details_model.dart';
import '../Blocs/mumbai_police_document_show_details_bloc/mumbai_document_show_details_cubit.dart';
import '../Blocs/mumbai_police_document_show_details_bloc/mumbai_document_show_details_state.dart';

class MumbaiDocUpdate extends StatefulWidget {
  String uid;

  MumbaiDocUpdate({super.key, required this.uid});

  @override
  State<MumbaiDocUpdate> createState() => _MumbaiDocUpdateState();
}

class _MumbaiDocUpdateState extends State<MumbaiDocUpdate> {
  @override
  void initState() {
    mumbaiDocDataLoad();
    super.initState();
  }

  void pickImageClear() {
    context.read<UploadDocumentMumbaiOwnerPhoto>().clearImage();
    context.read<UploadDocumentMumbaiTenantPhoto>().clearImage();
    context.read<UploadDocumentMumbaiTenantIdentityProof>().clearImage();
    context.read<UploadDocumentMumbaiTenantSignature>().clearImage();
  }

  void updateDocuments() {
    final String token = context.read<TokenCubit>().state;
    String customerId = context.read<IdCubit>().state;

    context.read<MumbaiDocUpdateCubit>().uploadDocumentsMumbai(
        customer_id: customerId,
        token: token,
        updateDocumentsMumbaiModel: UpdateDocumentsMumbaiModel(
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

  void mumbaiDocDataLoad() {
    final String token = context.read<TokenCubit>().state;
    context
        .read<MumbaiDocShowDataCubit>()
        .mumbaiDocumentShowData(token: token, uid: widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
        child: SingleChildScrollView(child:
            BlocBuilder<MumbaiDocShowDataCubit, MumbaiDocShowDataState>(
                builder: (context, mumbaiDocData) {
          if (mumbaiDocData is MumbaiDocShowDataLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (mumbaiDocData is MumbaiDocShowDataErrorState) {
            return Center(
              child: Text(mumbaiDocData.message),
            );
          } else if (mumbaiDocData is MumbaiDocShowDataSuccessState) {
            MumbaiDocShowDataModel data = mumbaiDocData.mumbaiDocShowDataModel;
            return Column(
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
                Text(
                  "Mumbai Police Verification Remark:",
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
                  height: 8,
                ),
                BlocBuilder<UploadDocumentMumbai, File>(
                    builder: (context, documents) {
                  return PickPhotoUpdate(
                    widthSize: double.infinity,
                    onPressedPickImage: () {
                      context.pop();
                      context.read<UploadDocumentMumbai>().pickFile();
                    },
                    onPressedTakePhoto: () {
                      context.pop();
                      context
                          .read<UploadDocumentMumbai>()
                          .pickImageFromCamera();
                    },
                    title: "Documents Upload",
                    image: documents,
                    mainTitle: "Upload Documents",
                    uploadImage: data.data!.dataDocument!,
                  );
                }),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                    "Note : Download sample pdf fill the data and upload."),
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
                          PickPhotoUpdate(
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
                            uploadImage: data.data!.ownerPhoto!,
                          )
                        ],
                      );
                    }),
                    BlocBuilder<UploadDocumentMumbaiTenantPhoto, File>(
                        builder: (context, signaturePhoto) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PickPhotoUpdate(
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
                            uploadImage: data.data!.tenantPhoto!,
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
                  return PickPhotoUpdate(
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
                    uploadImage: data.data!.tenantIdentityProofDoc!,
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
                  return PickPhotoUpdate(
                    isSign: true,
                    addSign: () {
                      context.pop();
                      context.pushNamed("SignatureScreen");
                    },
                    mainTitle: "Tenant Signature Photo",
                    widthSize: double.infinity,
                    title: "Tenant Signature Photo",
                    onPressedPickImage: () {
                      context.pop();
                      context
                          .read<UploadDocumentMumbaiTenantSignature>()
                          .pickFile();
                    },
                    onPressedTakePhoto: () {
                      context.pop();
                      context
                          .read<UploadDocumentMumbaiTenantSignature>()
                          .pickImageFromCamera();
                    },
                    image: signImage != null ? signImage! : companyLetter,
                    uploadImage: data.data!.tenantSignature!,
                  );
                }),
                const SizedBox(
                  height: 8,
                ),
                const Text("Note : Upload tenant signature photo"),
                const SizedBox(
                  height: 24,
                ),
                BlocConsumer<MumbaiDocUpdateCubit, MumbaiDocUpdateState>(
                    listener: (context, updateDoc) {
                  if (updateDoc is MumbaiDocUpdateSuccessState) {
                    if (updateDoc.data["status"] == 200) {
                      context.pushNamed("bottomNav");
                      pickImageClear();
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(updateDoc.data["message"])));
                  } else if (updateDoc is MumbaiDocUpdateErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(updateDoc.message)));
                  }
                }, builder: (context, uploadDocument) {
                  return CustomButton(
                    isLoading: uploadDocument is MumbaiDocUpdateLoadingState,
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
    );
  }
}

class CompanyLetter extends StatelessWidget {
  void Function()? onPressedPickImage;
  void Function()? onPressedTakePhoto;
  String title;
  double? widthSize;
  File image;

  CompanyLetter(
      {super.key,
      required this.onPressedPickImage,
      required this.onPressedTakePhoto,
      required this.title,
      this.widthSize,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DottedBorderPainter(context: context),
      child: InkWell(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              backgroundColor: Theme.of(context).primaryColorLight,
              title: Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.white),
              ),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 100,
                    child: Column(
                      children: [
                        IconButton(
                            onPressed: onPressedPickImage,
                            icon: const Icon(
                              Icons.photo,
                              size: 40,
                              color: Colors.white,
                            )),
                        Text("Pick image",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: Colors.white))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    child: Column(
                      children: [
                        IconButton(
                            onPressed: onPressedTakePhoto,
                            icon: const Icon(
                              Icons.camera_alt_outlined,
                              size: 40,
                              color: Colors.white,
                            )),
                        Text("Take Photo",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: Colors.white))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorDark.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
            // border: Border.all(color: Colors.black)
          ),
          width: widthSize,
          height: 150,
          child: image.path.isEmpty
              ? Center(
                  child: Icon(
                    Icons.add,
                    size: 36,
                    color: Theme.of(context).primaryColorDark,
                  ),
                )
              : Image.file(
                  image,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );

    //   CustomPaint(
    //   painter: DottedBorderPainter(context: context),
    //   child: InkWell(
    //     onTap: () {
    //       FocusManager.instance.primaryFocus?.unfocus();
    //       showDialog<String>(
    //         context: context,
    //         builder: (BuildContext context) => AlertDialog(
    //           backgroundColor: Theme.of(context).primaryColorLight,
    //           title: Text(
    //             title,
    //             style: Theme.of(context)
    //                 .textTheme
    //                 .bodyLarge!
    //                 .copyWith(color: Colors.white),
    //           ),
    //           content: Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceAround,
    //             children: [
    //               SizedBox(
    //                 height: 100,
    //                 child: Column(
    //                   children: [
    //                     IconButton(
    //                         onPressed: onPressedPickImage,
    //                         icon: const Icon(
    //                           Icons.photo,
    //                           size: 40,
    //                           color: Colors.white,
    //                         )),
    //                     Text("Pick image",
    //                         style: Theme.of(context)
    //                             .textTheme
    //                             .bodySmall!
    //                             .copyWith(color: Colors.white))
    //                   ],
    //                 ),
    //               ),
    //               SizedBox(
    //                 height: 100,
    //                 child: Column(
    //                   children: [
    //                     IconButton(
    //                         onPressed: onPressedTakePhoto,
    //                         icon: const Icon(
    //                           Icons.camera_alt_outlined,
    //                           size: 40,
    //                           color: Colors.white,
    //                         )),
    //                     Text("Take Photo",
    //                         style: Theme.of(context)
    //                             .textTheme
    //                             .bodySmall!
    //                             .copyWith(color: Colors.white))
    //                   ],
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       );
    //     },
    //     child: Expanded(
    //       child: Container(
    //         decoration: BoxDecoration(
    //           color: Theme.of(context).primaryColorDark.withOpacity(0.2),
    //           borderRadius: BorderRadius.circular(8),
    //           // border: Border.all(color: Colors.black)
    //         ),
    //         width: widthSize,
    //         height: 150,
    //         child: image.path.isEmpty
    //             ? Center(
    //                 child: Icon(
    //                   Icons.add,
    //                   size: 36,
    //                   color: Theme.of(context).primaryColorDark,
    //                 ),
    //               )
    //             : Image.file(
    //                 image,
    //                 fit: BoxFit.cover,
    //               ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
