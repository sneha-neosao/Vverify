import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/screen/VerificationForms/common/pickphoto.dart';

import '../../common/id.dart';
import '../SaveForm/Bloc/education_save_form_bloc.dart';
import 'Bloc/education_doc_upload_cubit.dart';
import 'Bloc/education_doc_upload_state.dart';

class EducationDocUpload extends StatefulWidget {
  const EducationDocUpload({super.key});

  @override
  State<EducationDocUpload> createState() => _EducationDocUploadState();
}

class _EducationDocUploadState extends State<EducationDocUpload> {
  void educationUploadDocData() async {
    String token = context.read<TokenCubit>().state;
    String customerId = context.read<IdCubit>().state;
    context.read<EducationDocUploadCubit>().educationDocUpload(
        customer_id: customerId,
        token: token,
        request_id: requestId!,
        service_request_id: serviceRequestId!,
        document: context.read<EducationDocFileCubit>().state);
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
              "Education Verification",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Theme.of(context).primaryColorDark),
            ),
            const SizedBox(height: 16,),
            Text("Choose an Option:",style: Theme.of(context).textTheme.bodySmall),
            BlocProvider(
              create: (_) => FormUploadEducationtCubit(),
              child: BlocBuilder<FormUploadEducationtCubit, bool>(
                  builder: (context, frmUpload) {
                return Column(
                  children: [
                    ListTile(
                      splashColor: Colors.transparent,
                      onTap: () {
                        // context.pushReplacementNamed("EducationSaveForm");
                        context.pushNamed(
                          "EducationSaveFormNew",
                          pathParameters: {'uid': ""}, // must be non-empty
                        );
                        context
                            .read<FormUploadEducationtCubit>()
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
                            .read<FormUploadEducationtCubit>()
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
            BlocBuilder<EducationDocFileCubit, File>(
                builder: (context, uploadDoc) {
              return PickPhoto(
                widthSize: double.infinity,
                title: "Select Documents",
                mainTitle: "Upload Certificate/Marksheet/Document",
                onPressedPickImage: () {
                  context.read<EducationDocFileCubit>().pickFile().then((_) {
                    context.pop();
                  });
                },
                onPressedTakePhoto: () {
                  context
                      .read<EducationDocFileCubit>()
                      .pickImageFromCamera()
                      .then((_) {
                    context.pop();
                  });
                },
                image: uploadDoc,
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
            BlocConsumer<EducationDocUploadCubit, EducationDocUploadState>(
                listener: (context, educationDoc) {
              if (educationDoc is EducationDocUploadSuccessState) {
                if (educationDoc.data["status"] == 200) {
                  context.pushReplacementNamed("EducationList");
                  context.read<EducationDocFileCubit>().clearImage();
                }
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                  educationDoc.data["message"],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )));
              } else if (educationDoc is EducationDocUploadErrorState) {
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
                isLoading: educationDoc is EducationDocUploadLoadingState,
                onTap: () {
                  if (context
                      .read<EducationDocFileCubit>()
                      .state
                      .path
                      .isEmpty) {
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
            const SizedBox(height: 16)
          ],
        ),
      ),
    );
  }
}
