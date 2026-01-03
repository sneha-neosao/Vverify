import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/screen/VerificationForms/common/pickphoto.dart';

import '../../common/id.dart';
import '../../common/url.dart';
import '../EducationDocUpload/Bloc/education_doc_upload_cubit.dart';
import '../SaveForm/Bloc/education_save_form_bloc.dart';
import 'Bloc/education_doc_update_cubit.dart';
import 'Bloc/education_doc_update_state.dart';
import 'ShowData/Bloc/education_doc_show_data_cubit.dart';
import 'ShowData/Bloc/education_doc_show_data_state.dart';
import 'ShowData/Model/education_show_doc_model.dart';

class EducationDocUpdate extends StatefulWidget {
  String uid;

  EducationDocUpdate({super.key, required this.uid});

  @override
  State<EducationDocUpdate> createState() => _EducationDocUpdateState();
}

class _EducationDocUpdateState extends State<EducationDocUpdate> {
  @override
  void initState() {
    educationShowDataLoad();
    super.initState();
  }

  void educationUploadDocData() async {
    String token = context.read<TokenCubit>().state;
    String customerId = context.read<IdCubit>().state;
    context.read<EducationDocUpdateCubit>().educationDocUpdate(
        customer_id: customerId,
        token: token,
        request_id: requestId!,
        service_request_id: serviceRequestId!,
        document: context.read<EducationDocFileCubit>().state,
        uid: widget.uid);
  }

  void educationShowDataLoad() {
    String token = context.read<TokenCubit>().state;

    context
        .read<EducationDocShowDataCubit>()
        .educationDocShowData(token: token, uid: widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
        child:
            BlocBuilder<EducationDocShowDataCubit, EducationDocShowDataState>(
          builder: (context, educationShowData) {
            if (educationShowData is EducationDocShowDataLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (educationShowData is EducationDocShowDataErrorState) {
              return Center(
                child: Text(educationShowData.message),
              );
            } else if (educationShowData is EducationDocShowDataSuccessState) {
              EducationShowDocModel data =
                  educationShowData.educationShowDocModel;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Education Verification",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Theme.of(context).primaryColorDark),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Rejected Reason",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Colors.red),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    data.data!.verificationRemark ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.red),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  BlocBuilder<EducationDocFileCubit, File>(
                      builder: (context, uploadDoc) {
                    return PickPhotoUpdate(
                      widthSize: double.infinity,
                      title: 'Select Documents',
                      mainTitle: 'Update Documents',
                      onPressedPickImage: () {
                        context.pop();
                        context.read<EducationDocFileCubit>().pickFile();
                      },
                      onPressedTakePhoto: () {
                        context
                            .read<EducationDocFileCubit>()
                            .pickImageFromCamera();
                      },
                      image: uploadDoc,
                      uploadImage: data.data!.document!.startsWith("http")
                          ? data.data!.document!
                          : "$imageUrl${data.data!.document!}",
                    );
                  }),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                      "Note : Upload one combined PDF if you have multiple documents."),
                  const SizedBox(
                    height: 24,
                  ),
                  BlocConsumer<EducationDocUpdateCubit,
                          EducationDocUpdateState>(
                      listener: (context, educationDoc) {
                    if (educationDoc is EducationDocUpdateSuccessState) {
                      if (educationDoc.data["status"] == 200) {
                        context.pushReplacementNamed("EducationList");
                        context
                            .read<EducationCertificateDocuments>()
                            .clearImage();
                      }
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(educationDoc.data["message"])));
                    } else if (educationDoc is EducationDocUpdateErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(educationDoc.message)));
                      print("uploadMessage ${educationDoc.message}");
                    }
                  }, builder: (context, educationDoc) {
                    return CustomButton(
                      isLoading: educationDoc is EducationDocUpdateLoadingState,
                      onTap: () {
                        educationUploadDocData();
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
          },
        ),
      ),
    );
  }
}
