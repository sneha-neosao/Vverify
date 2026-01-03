import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/screen/VerificationForms/GST_TIN_CIN/Documents/upload/bloc/gst_pan_cin_doc_upload_cubit.dart';
import 'package:v_verify/screen/VerificationForms/common/id.dart';
import 'package:v_verify/screen/VerificationForms/common/pickphoto.dart';

import '../../Update/ShowData/Bloc/GstPanCin_show_data_cubit.dart';
import '../../Update/ShowData/Bloc/GstPanCin_show_data_state.dart';
import '../../Update/ShowData/Model/GstPanCin_show_data_model.dart';
import 'bloc/gst_pan_cin_doc_update_cubit.dart';
import 'bloc/gst_pan_cin_doc_update_state.dart';

class GstPanCinDocUpdate extends StatefulWidget {
  String uid;

  GstPanCinDocUpdate({super.key, required this.uid});

  @override
  State<GstPanCinDocUpdate> createState() => _GstPanCinDocUpdateState();
}

class _GstPanCinDocUpdateState extends State<GstPanCinDocUpdate> {
  void gstPanCinUpdateDoc() {
    String token = context.read<TokenCubit>().state;
    String customerId = context.read<IdCubit>().state;

    context.read<GstPanCinDocUpdateCubit>().gstPanCinDocUpdate(
          customer_id: customerId,
          token: token,
          request_id: requestId!,
          service_request_id: serviceRequestId!,
          gst_document: context.read<GstDocUpload>().state.path.isEmpty
              ? File("")
              : context.read<GstDocUpload>().state,
          pan_document: context.read<PanDocUpload>().state.path.isEmpty
              ? File("")
              : context.read<PanDocUpload>().state,
          cin_document: context.read<CinDocUpload>().state.path.isEmpty
              ? File("")
              : context.read<CinDocUpload>().state,
        );
  }

  @override
  void initState() {
    gstPanCinDocShowData();
    super.initState();
  }

  void gstPanCinDocShowData() {
    String token = context.read<TokenCubit>().state;

    context
        .read<GstPanCinShowDataCubit>()
        .gstPanCinShowData(token: token, uid: widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
          child: BlocBuilder<GstPanCinShowDataCubit, GstPanCinShowDataState>(
            builder: (context, showData) {
              if (showData is GstPanCinShowDataLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (showData is GstPanCinShowDataErrorState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (showData is GstPanCinShowDataSuccessState) {
                GstPanCinShowDataModel data = showData.gstPanCinShowDataModel;
                return Column(
                  children: [
                    Text(
                      "GST PAN CIN Verification",
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
                    const Text(
                        "Note : At least one of GST, PAN or CIN is required"),
                    const SizedBox(
                      height: 8,
                    ),
                    BlocBuilder<PanDocUpload, File>(builder: (context, pan) {
                      return PickPhotoUpdate(
                        widthSize: double.infinity,
                        onPressedPickImage: () {
                          context.read<PanDocUpload>().pickFile().then((_) {
                            context.pop();
                          });
                        },
                        onPressedTakePhoto: () {
                          context
                              .read<PanDocUpload>()
                              .pickImageFromCamera()
                              .then((_) {
                            context.pop();
                          });
                        },
                        title: "Upload GST Document",
                        image: pan,
                        mainTitle: "Upload GST Document",
                        uploadImage: data.data!.gstDocument!,
                      );
                    }),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text("Note : Upload GST image/document"),
                    const SizedBox(
                      height: 16,
                    ),
                    BlocBuilder<GstDocUpload, File>(builder: (context, gst) {
                      return PickPhotoUpdate(
                        widthSize: double.infinity,
                        onPressedPickImage: () {
                          context.read<GstDocUpload>().pickFile().then((_) {
                            context.pop();
                          });
                        },
                        onPressedTakePhoto: () {
                          context
                              .read<GstDocUpload>()
                              .pickImageFromCamera()
                              .then((_) {
                            context.pop();
                          });
                        },
                        title: "Upload PAN Document",
                        image: gst,
                        mainTitle: "Upload PAN Document",
                        uploadImage: data.data!.panDocument!,
                      );
                    }),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text("Note : Upload PAN card image/document"),
                    const SizedBox(
                      height: 16,
                    ),
                    BlocBuilder<CinDocUpload, File>(builder: (context, cin) {
                      return PickPhotoUpdate(
                        widthSize: double.infinity,
                        onPressedPickImage: () {
                          context.read<CinDocUpload>().pickFile().then((_) {
                            context.pop();
                          });
                        },
                        onPressedTakePhoto: () {
                          context
                              .read<CinDocUpload>()
                              .pickImageFromCamera()
                              .then((_) {
                            context.pop();
                          });
                        },
                        title: "Upload CIN Document",
                        image: cin,
                        mainTitle: "Upload CIN Document",
                        uploadImage: data.data!.cinDocument!,
                      );
                    }),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text("Note : Note : Upload CIN image/document"),
                    const SizedBox(
                      height: 24,
                    ),
                    BlocConsumer<GstPanCinDocUpdateCubit,
                        GstPanCinDocUpdateState>(listener: (context, upload) {
                      if (upload is GstPanCinDocUpdateSuccessState) {
                        if (upload.data["status"] == 200) {
                          context.read<PanDocUpload>().clearImage();
                          context.read<GstDocUpload>().clearImage();
                          context.read<CinDocUpload>().clearImage();
                          context.pushReplacementNamed("bottomNav");
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(upload.data["message"])));
                      } else if (upload is GstPanCinDocUpdateErrorState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(upload.message)));
                      }
                    }, builder: (context, upload) {
                      return CustomButton(
                        isLoading: upload is GstPanCinDocUpdateLoadingState,
                        onTap: () {
                          gstPanCinUpdateDoc();
                        },
                        text: "SUBMIT",
                        gradientColors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColorDark
                        ],
                      );
                    }),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                );
              }
              return const Center(child: Text("Error..."));
            },
          ),
        ),
      ),
    );
  }
}
