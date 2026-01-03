import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/screen/VerificationForms/common/id.dart';

import '../../../common/pickphoto.dart';
import '../../Save/Bloc/name_address_verification_cubit.dart';
import 'Bloc/name_address_doc_upload_cubit.dart';
import 'Bloc/name_address_doc_upload_state.dart';

class NameAddressDocUpload extends StatefulWidget {
  NameAddressDocUpload({
    super.key,
  });

  @override
  State<NameAddressDocUpload> createState() => _NameAddressDocUploadState();
}

class _NameAddressDocUploadState extends State<NameAddressDocUpload> {
  void nameAddressDocUpload() {
    String token = context.read<TokenCubit>().state;
    String customerId = context.read<IdCubit>().state;

    context.read<NameAddressDocUploadCubit>().nameAddressDocUpload(
        customer_id: customerId,
        token: token,
        requestId: requestId!,
        serviceRequestId: serviceRequestId!,
        aadhaar_front_side:
            context.read<NameAddressAadhaarFrontSideCubit>().state.path.isEmpty
                ? File("")
                : context.read<NameAddressAadhaarFrontSideCubit>().state,
        aadhaar_back_side:
            context.read<NameAddressAadhaarBackSideCubit>().state.path.isEmpty
                ? File("")
                : context.read<NameAddressAadhaarBackSideCubit>().state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Full Name & Address Verification ",
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
                          context.pushReplacementNamed(
                              "NameAddressVerificationForm");

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
              const SizedBox(
                height: 16,
              ),

              // Text(
              //   "Person's Details",
              //   style: Theme.of(context).textTheme.titleMedium!.copyWith(
              //       color: Theme.of(context).primaryColorDark, fontSize: 16),
              // ),
              const SizedBox(
                height: 16,
              ),
              BlocBuilder<NameAddressAadhaarFrontSideCubit, File>(
                  builder: (context, aadhaarFront) {
                //  return SizedBox();
                return PickPhoto(
                  starRemove: "remove",
                  mainTitle: "Upload Document Proof Front Side",
                  widthSize: double.infinity,
                  onPressedPickImage: () {
                    context
                        .read<NameAddressAadhaarFrontSideCubit>()
                        .pickFile()
                        .then((_) {
                      context.pop();
                    });
                  },
                  onPressedTakePhoto: () {
                    context
                        .read<NameAddressAadhaarFrontSideCubit>()
                        .pickImageFromCamera()
                        .then((_) {
                      context.pop();
                    });
                  },
                  title: 'Document Front Side',
                  image: aadhaarFront,
                );
              }),

              const SizedBox(
                height: 8,
              ),
              const Text("Note : Upload documents proof "),
              const SizedBox(
                height: 16,
              ),
              BlocBuilder<NameAddressAadhaarBackSideCubit, File>(
                  builder: (context, aadhaarBack) {
                //return SizedBox();
                return PickPhoto(
                  starRemove: "remove",
                  mainTitle: "Upload Document Proof Back Side",
                  widthSize: double.infinity,
                  onPressedPickImage: () {
                    context
                        .read<NameAddressAadhaarBackSideCubit>()
                        .pickFile()
                        .then((_) {
                      context.pop();
                    });
                  },
                  onPressedTakePhoto: () {
                    context
                        .read<NameAddressAadhaarBackSideCubit>()
                        .pickImageFromCamera()
                        .then((_) {
                      context.pop();
                    });
                  },
                  title: 'Document Back Side',
                  image: aadhaarBack,
                );
              }),
              const SizedBox(
                height: 8,
              ),
              const Text("Note : Upload documents proof "),
              const SizedBox(
                height: 24,
              ),
              BlocConsumer<NameAddressDocUploadCubit,
                  NameAddressDocUploadState>(listener: (context, upload) {
                if (upload is NameAddressDocUploadSuccessState) {
                  if (upload.data["status"] == 200) {
                    context
                        .read<NameAddressAadhaarFrontSideCubit>()
                        .clearImage();
                    context
                        .read<NameAddressAadhaarBackSideCubit>()
                        .clearImage();
                    context.pushReplacementNamed("bottomNav");
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(upload.data["message"])));
                } else if (upload is NameAddressDocUploadErrorState) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(upload.message)));
                }
              }, builder: (context, upload) {
                return CustomButton(
                  isLoading: upload is NameAddressDocUploadLoadingState,
                  onTap: () {
                    if (context
                            .read<NameAddressAadhaarFrontSideCubit>()
                            .state
                            .path
                            .isEmpty ||
                        context
                            .read<NameAddressAadhaarBackSideCubit>()
                            .state
                            .path
                            .isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Please upload documents")));
                    } else {
                      nameAddressDocUpload();
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
                height: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
