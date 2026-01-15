import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/screen/VerificationForms/AddressVerificationForm/Save/Bloc/name_address_verification_cubit.dart';
import 'package:v_verify/screen/VerificationForms/GST_TIN_CIN/Documents/upload/bloc/gst_pan_cin_doc_upload_cubit.dart';
import 'package:v_verify/screen/VerificationForms/common/id.dart';
import 'package:v_verify/screen/VerificationForms/common/pickphoto.dart';
import 'bloc/gst_pan_cin_doc_upload_state.dart';

class GstPanCinDocUpload extends StatefulWidget {
  const GstPanCinDocUpload({super.key});

  @override
  State<GstPanCinDocUpload> createState() => _GstPanCinDocUploadState();
}

class _GstPanCinDocUploadState extends State<GstPanCinDocUpload> {
  void gstPanCinUploadDoc() {
    String token = context.read<TokenCubit>().state;
    String customerId = context.read<IdCubit>().state;
    context.read<GstPanCinDocUploadCubit>().gstPanCinDocUpload(
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              Text("Choose an Option:",
                  style: Theme.of(context).textTheme.bodySmall),
              BlocProvider(
                create: (_) => FormUploadNameAddressCubit(),
                child: BlocBuilder<FormUploadNameAddressCubit, bool>(
                    builder: (context, frmUpload) {
                  return Column(
                    children: [
                      ListTile(
                        splashColor: Colors.transparent,
                        onTap: () {
                          context.pushReplacementNamed("GstPanCinScreen");

                          context
                              .read<FormUploadNameAddressCubit>()
                              .formUploadYesNo(yesNo: true);

                          context
                              .read<FormUploadNameAddressCubit>()
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
                              .read<FormUploadNameAddressCubit>()
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
              const Text("Note : At least one of GST, PAN or CIN is required"),
              const SizedBox(
                height: 8,
              ),
              BlocBuilder<PanDocUpload, File>(builder: (context, pan) {
                return PickPhoto(
                    starRemove: "remove",
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
                    mainTitle: "Upload GST Document");
              }),
              const SizedBox(
                height: 8,
              ),
              const Text("Note : Upload GST image/document"),
              const SizedBox(
                height: 16,
              ),
              BlocBuilder<GstDocUpload, File>(builder: (context, gst) {
                return PickPhoto(
                    starRemove: "remove",
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
                    mainTitle: "Upload PAN Document");
              }),
              const SizedBox(
                height: 8,
              ),
              const Text("Note : Upload PAN card image/document"),
              const SizedBox(
                height: 16,
              ),
              BlocBuilder<CinDocUpload, File>(builder: (context, cin) {
                return PickPhoto(
                    starRemove: "remove",
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
                    mainTitle: "Upload CIN Document");
              }),
              const SizedBox(
                height: 8,
              ),
              const Text("Note : Note : Upload CIN image/document"),
              const SizedBox(
                height: 24,
              ),
              BlocConsumer<GstPanCinDocUploadCubit, GstPanCinDocUploadState>(
                  listener: (context, upload) {
                if (upload is GstPanCinDocUploadSuccessState) {
                  if (upload.data["status"] == 200) {
                    context.read<PanDocUpload>().clearImage();
                    context.read<GstDocUpload>().clearImage();
                    context.read<CinDocUpload>().clearImage();
                    context.pushReplacementNamed("bottomNav");
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(upload.data["message"])));
                } else if (upload is GstPanCinDocUploadErrorState) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(upload.message)));
                }
              }, builder: (context, upload) {
                return CustomButton(
                  isLoading: upload is GstPanCinDocUploadLoadingState,
                  onTap: () {
                    if (context.read<PanDocUpload>().state.path.isEmpty &&
                        context.read<GstDocUpload>().state.path.isEmpty &&
                        context.read<CinDocUpload>().state.path.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              "Please upload any one and more documents")));
                    } else {
                      gstPanCinUploadDoc();
                    }
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
          ),
        ),
      ),
    );
  }
}
