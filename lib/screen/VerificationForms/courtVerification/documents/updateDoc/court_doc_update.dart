import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/screen/VerificationForms/courtVerification/documents/uploadDoc/Bloc/court_doc_upload_cubit.dart';

import '../../../../../commonComponent/bloc/shared_preferences_cubit.dart';
import '../../../common/id.dart';
import '../../../common/pickphoto.dart';
import '../../update/ShowData/Model/show_court_data_model.dart';
import '../../update/ShowData/bloc/show_court_data_cubit.dart';
import '../../update/ShowData/bloc/show_court_data_state.dart';
import 'bloc/court_doc_update_cubit.dart';
import 'bloc/court_doc_update_state.dart';

class CourtDocUpdate extends StatefulWidget {
  String uid;

  CourtDocUpdate({super.key, required this.uid});

  @override
  State<CourtDocUpdate> createState() => _CourtDocUpdateState();
}

class _CourtDocUpdateState extends State<CourtDocUpdate> {
  @override
  void initState() {
    courtDocumentsShowData();
    super.initState();
  }

  void courtUploadDoc() {
    String token = context.read<TokenCubit>().state;
    String customerId = context.read<IdCubit>().state;

    context.read<CourtDocUpdateCubit>().courtVerificationDocumentUpdate(
          customer_id: customerId,
          token: token,
          request_id: requestId!,
          serviceRequestId: serviceRequestId!,
          aadhaar_document:
              context.read<CourtAadhaarUpload>().state.path.isEmpty
                  ? File("")
                  : context.read<CourtAadhaarUpload>().state,
          pan_document: context.read<CourtPanUpload>().state.path.isEmpty
              ? File("")
              : context.read<CourtPanUpload>().state,
        );
  }

  void courtDocumentsShowData() {
    String token = context.read<TokenCubit>().state;
    context
        .read<ShowCourtDataCubit>()
        .courtVerificationShowData(token: token, uid: widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 16, right: 16),
        child: BlocBuilder<ShowCourtDataCubit, ShowCourtDataState>(
            builder: (context, showData) {
          if (showData is ShowCourtDataLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (showData is ShowCourtDataErrorState) {
            return Center(
              child: Text(showData.message),
            );
          } else if (showData is ShowCourtDataSuccessState) {
            ShowCourtDataModel data = showData.showCourtDataModel;
            return Column(
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
                  data.data!.reason!,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.red),
                ),
                const SizedBox(
                  height: 16,
                ),
                BlocBuilder<CourtAadhaarUpload, File>(
                    builder: (context, aadhaar) {
                  return PickPhotoUpdate(
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
                    uploadImage: data.data!.aadhaarDocument!,
                  );
                }),
                const SizedBox(
                  height: 8,
                ),
                const Text("Note : Upload Aadhaar card image/document"),
                const SizedBox(
                  height: 16,
                ),
                BlocBuilder<CourtPanUpload, File>(builder: (context, pan) {
                  return PickPhotoUpdate(
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
                    mainTitle: 'Upload PAN Card',
                    uploadImage: data.data!.panDocument!,
                  );
                }),
                const SizedBox(
                  height: 8,
                ),
                const Text("Note : Upload PAN card image/document"),
                const SizedBox(
                  height: 24,
                ),
                BlocConsumer<CourtDocUpdateCubit, CourtDocUpdateState>(
                    listener: (context, upload) {
                  if (upload is CourtDocUpdateSuccessState) {
                    if (upload.data["status"] == 200) {
                      context.read<CourtAadhaarUpload>().clearImage();
                      context.read<CourtPanUpload>().clearImage();
                      context.pushReplacementNamed("bottomNav");
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(upload.data["message"])));
                  } else if (upload is CourtDocUpdateErrorState) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(upload.message)));
                  }
                }, builder: (context, upload) {
                  return CustomButton(
                    isLoading: upload is CourtDocUpdateLoadingState,
                    onTap: () {
                      courtUploadDoc();
                    },
                    text: "Update",
                    gradientColors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColorDark
                    ],
                  );
                })
              ],
            );
          }
          return const Center(
            child: Text("Error..."),
          );
        }),
      ),
    );
  }
}
