import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/screen/VerificationForms/courtVerification/Document/Blocs/court_verification_documents_upload_bloc/court_verification_documents_upload_cubit.dart';

import '../../../../../commonComponent/bloc/shared_preferences_cubit.dart';
import '../../../common/id.dart';
import '../../../common/pickphoto.dart';
import '../../Form/Blocs/court_verification_save_form_bloc/court_verification_save_form_cubit.dart';
import '../Blocs/court_verification_documents_upload_bloc/court_verification_documents_upload_state.dart';

class CourtDocumentUploadScreen extends StatefulWidget {
  const CourtDocumentUploadScreen({super.key});

  @override
  State<CourtDocumentUploadScreen> createState() => _CourtDocumentUploadScreenState();
}

class _CourtDocumentUploadScreenState extends State<CourtDocumentUploadScreen> {
  void courtUploadDoc() {
    String token = context.read<TokenCubit>().state;
    String customerId = context.read<IdCubit>().state;

    context.read<CourtDocUploadCubit>().courtVerificationDocumentUpload(
          customer_id: customerId,
          token: token,
          request_id: requestId!,
          serviceRequestId: serviceRequestId!,
          aadhaar_document: context.read<CourtAadhaarUpload>().state,
          pan_document: context.read<CourtPanUpload>().state,
        );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          context.read<CourtAadhaarUpload>().clearImage();
          context.read<CourtPanUpload>().clearImage();
          return true;
        },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 50, left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Court Legal Verification",
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
                create: (_) => FormUploadCourtCubit(),
                child: BlocBuilder<FormUploadCourtCubit, bool>(
                    builder: (context, frmUpload) {
                  return Column(
                    children: [
                      ListTile(
                        splashColor: Colors.transparent,
                        onTap: () {
                          context.pushReplacementNamed("CourtVerification");

                          context
                              .read<FormUploadCourtCubit>()
                              .formUploadYesNo(yesNo: true);

                          context
                              .read<FormUploadCourtCubit>()
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
                              .read<FormUploadCourtCubit>()
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
              BlocBuilder<CourtAadhaarUpload, File>(builder: (context, aadhaar) {
                return PickPhoto(
                  widthSize: double.infinity,
                  onPressedPickImage: () {
                    context.read<CourtAadhaarUpload>().pickFile().then((_) {
                      context.pop();
                    });
                  },
                  onPressedTakePhoto: () {
                    context
                        .read<CourtAadhaarUpload>()
                        .pickImageFromCamera()
                        .then((_) {
                      context.pop();
                    });
                  },
                  title: 'Upload Aadhaar Card',
                  image: aadhaar,
                  mainTitle: 'Upload Aadhaar Card',
                );
              }),
              const SizedBox(
                height: 8,
              ),
              const Text(
                  "Note : Upload Aadhaar card image/document"),
              const SizedBox(
                height: 16,
              ),
              BlocBuilder<CourtPanUpload, File>(builder: (context, pan) {
                return PickPhoto(
                  widthSize: double.infinity,
                  onPressedPickImage: () {
                    context.read<CourtPanUpload>().pickFile().then((_) {
                      context.pop();
                    });
                  },
                  onPressedTakePhoto: () {
                    context
                        .read<CourtPanUpload>()
                        .pickImageFromCamera()
                        .then((_) {
                      context.pop();
                    });
                  },
                  title: 'Upload PAN Card',
                  image: pan,
                  mainTitle: 'Upload Pan Card',
                );
              }),
              const SizedBox(
                height: 8,
              ),
              const Text(
                  "Note : Upload PAN card image/document"),
              const SizedBox(
                height: 24,
              ),
              BlocConsumer<CourtDocUploadCubit, CourtDocUploadState>(
                  listener: (context, upload) {
                if (upload is CourtDocUploadSuccessState) {
                  if (upload.data["status"] == 200) {
                    context.read<CourtAadhaarUpload>().clearImage();
                    context.read<CourtPanUpload>().clearImage();
                    context.pushReplacementNamed("bottomNav");
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(upload.data["message"])));
                } else if (upload is CourtDocUploadErrorState) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(upload.message)));
                }
              }, builder: (context, upload) {
                return CustomButton(
                  isLoading: upload is CourtDocUploadLoadingState,
                  onTap: () {
                    if (context.read<CourtAadhaarUpload>().state.path.isEmpty ||
                        context.read<CourtPanUpload>().state.path.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Please Upload Documents")));
                    } else {
                      courtUploadDoc();
                    }
                  },
                  text: "SUBMIT",
                  gradientColors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColorDark
                  ],
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
