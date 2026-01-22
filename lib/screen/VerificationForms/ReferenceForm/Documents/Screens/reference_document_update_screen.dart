import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/screen/VerificationForms/ReferenceForm/Documents/Models/reference_doc_show_data_model.dart';
import 'package:v_verify/screen/VerificationForms/common/id.dart';

import '../../../common/pickphoto.dart';
import '../Blocs/reference_document_upload_bloc/reference_upload_doc_cubit.dart';
import '../Blocs/reference_document_update_bloc/reference_doc_update_cubit.dart';
import '../Blocs/reference_document_update_bloc/reference_doc_update_state.dart';
import '../Blocs/reference_document_show_details_bloc/reference_doc_show_data_cubit.dart';
import '../Blocs/reference_document_show_details_bloc/reference_doc_show_data_state.dart';

class ReferenceUpdateDoc extends StatefulWidget {
  String uid;

  ReferenceUpdateDoc({super.key, required this.uid});

  @override
  State<ReferenceUpdateDoc> createState() => _ReferenceUpdateDocState();
}

class _ReferenceUpdateDocState extends State<ReferenceUpdateDoc> {
  @override
  void initState() {
    referenceCheckShowData();
    super.initState();
  }

  void referenceCheckShowData() {
    String token = context.read<TokenCubit>().state;
    context
        .read<ReferenceDocShowDataCubit>()
        .referenceUploadDoc(token: token, uid: widget.uid);
  }

  void referenceCheckDocUpdate() {
    String token = context.read<TokenCubit>().state;
    String customerId = context.read<IdCubit>().state;
    context.read<ReferenceDocUpdateCubit>().referenceDocUpdate(
        customer_id: customerId,
        token: token,
        requestId: requestId!,
        serviceRequestId: serviceRequestId!,
        dataDocument: context.read<ReferenceCheckUploadDoc>().state.path.isEmpty
            ? File("")
            : context.read<ReferenceCheckUploadDoc>().state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
        child:
            BlocBuilder<ReferenceDocShowDataCubit, ReferenceDocShowDataState>(
          builder: (context, showData) {
            if (showData is ReferenceDocShowDataLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (showData is ReferenceDocShowDataErrorState) {
              return Center(
                child: Text(showData.message),
              );
            } else if (showData is ReferenceDocShowDataSuccessState) {
              ReferenceDocShowDataModel data =
                  showData.referenceDocShowDataModel;
              return Column(
                children: [
                  Text(
                    "Reference Check Verification",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Theme.of(context).primaryColorDark),
                  ),
                  Text(
                    "Reference Check Verification Remark:",
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
                  const SizedBox(
                    height: 16,
                  ),
                  BlocBuilder<ReferenceCheckUploadDoc, File>(
                      builder: (context, identityProof) {
                    return PickPhotoUpdate(
                      widthSize: double.infinity,
                      mainTitle: "Upload Documents",
                      title: "Upload Documents",
                      onPressedPickImage: () {
                        context.pop();
                        context.read<ReferenceCheckUploadDoc>().pickFile();
                      },
                      onPressedTakePhoto: () {
                        context.pop();
                        context
                            .read<ReferenceCheckUploadDoc>()
                            .pickImageFromCamera();
                      },
                      image: identityProof,
                      uploadImage: data.data!.dataDocument!,
                    );
                  }),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                      "Note : Download sample pdf fill the data and upload."),
                  const SizedBox(
                    height: 24,
                  ),
                  BlocConsumer<ReferenceDocUpdateCubit,
                      ReferenceDocUpdateState>(listener: (context, upload) {
                    if (upload is ReferenceDocUpdateSuccessState) {
                      if (upload.data["status"] == 200) {
                        context.read<ReferenceCheckUploadDoc>().clearImage();
                        context.pushReplacementNamed("bottomNav");
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(upload.data["message"])));
                    } else if (upload is ReferenceDocUpdateErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(upload.message)));
                    }
                  }, builder: (context, upload) {
                    return CustomButton(
                      onTap: () {
                        referenceCheckDocUpdate();
                      },
                      isLoading: upload is ReferenceDocUpdateLoadingState,
                      text: "SUBMIT",
                      gradientColors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColorDark,
                      ],
                    );
                  }),
                ],
              );
            }

            return const Center(
              child: Text("Error..."),
            );
          },
        ),
      ),
    );
  }
}
