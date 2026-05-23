import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/screen/VerificationForms/common/id.dart';

import '../../../common/pickphoto.dart';
import '../../../../AllFormList/FormList/widgets/DrivingLicense/Bloc/driving_licence_save_form_bloc/driving_licence_save_form_bloc.dart';
import '../Blocs/driving_licence_document_upload_bloc/driver_document_upload_cubit.dart';
import '../Blocs/driving_licence_document_upload_bloc/driver_document_upload_state.dart';

class DriverDocUpload extends StatefulWidget {
  const DriverDocUpload({super.key});

  @override
  State<DriverDocUpload> createState() => _DriverDocUploadState();
}

class _DriverDocUploadState extends State<DriverDocUpload> {
  void driverDocFileUpload() {
    String token = context.read<TokenCubit>().state;
    String customerId = context.read<IdCubit>().state;
    context.read<DriverDocUploadCubit>().drivingLicenceDocUploadData(
        customer_id: customerId,
        token: token,
        request_id: requestId!,
        service_request_id: serviceRequestId!,
        data_document: context.read<DriverDocFileUpload>().state);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<DriverDocFileUpload>().clearImage();
        return true;
      },
      child: Scaffold(
        body: Padding(
            padding: const EdgeInsets.only(top: 50, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Driving Licence Verification",
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
                  create: (_) => FormUploadDrivingCubit(),
                  child: BlocBuilder<FormUploadDrivingCubit, bool>(
                      builder: (context, frmUpload) {
                    return Column(
                      children: [
                        ListTile(
                          splashColor: Colors.transparent,
                          onTap: () {
                            context.pushReplacementNamed("DrivingLicence");

                            context
                                .read<FormUploadDrivingCubit>()
                                .formUploadYesNo(yesNo: true);

                            context
                                .read<FormUploadDrivingCubit>()
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
                                .read<FormUploadDrivingCubit>()
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
                BlocBuilder<DriverDocFileUpload, File>(
                    builder: (context, docUpload) {
                  return PickPhoto(
                    widthSize: double.infinity,
                    onPressedPickImage: () {
                      context.read<DriverDocFileUpload>().pickFile().then((_) {
                        context.pop();
                      });
                    },
                    onPressedTakePhoto: () {
                      context
                          .read<DriverDocFileUpload>()
                          .pickImageFromCamera()
                          .then((_) {
                        context.pop();
                      });
                    },
                    title: 'Upload Licence Documents',
                    image: docUpload,
                    mainTitle: "Driving Licence Documents",
                  );
                }),
                const SizedBox(
                  height: 8,
                ),
                const Text("Note : Upload Driving Licence Image/Documents"),
                const SizedBox(
                  height: 24,
                ),
                BlocConsumer<DriverDocUploadCubit, DriverDocUploadState>(
                  listener: (context, upload) {
                    if (upload is DriverDocUploadErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(upload.message)));
                    } else if (upload is DriverDocUploadSuccessState) {
                      if (upload.data["status"] == 200) {
                        context.pushReplacementNamed("bottomNav");
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(upload.data["message"])));
                    }
                  },
                  builder: (BuildContext context, DriverDocUploadState upload) {
                    return CustomButton(
                        isLoading: upload is DriverDocUploadLoadingState,
                        gradientColors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColorDark
                        ],
                        onTap: () {
                          if (context
                              .read<DriverDocFileUpload>()
                              .state
                              .path
                              .isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Please Upload Documents")));
                          } else {
                            driverDocFileUpload();
                          }
                        },
                        text: "SUBMIT");
                  },
                ),
              ],
            )),
      ),
    );
  }
}
