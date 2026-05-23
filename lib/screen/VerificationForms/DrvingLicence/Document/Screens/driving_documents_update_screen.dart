import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/screen/VerificationForms/common/id.dart';

import '../../../common/pickphoto.dart';
import '../../../../AllFormList/FormList/widgets/DrivingLicense/Bloc/driving_licence_show_details_bloc/driving_licence_show_details_state.dart';
import '../../../../AllFormList/FormList/widgets/DrivingLicense/Bloc/driving_licence_show_details_bloc/driving_licence_show_details_cubit.dart';
import '../../../../AllFormList/FormList/widgets/DrivingLicense/Models/driving_licence_show_details_model.dart';
import '../Blocs/driving_licence_document_upload_bloc/driver_document_upload_cubit.dart';
import '../Blocs/driving_licence_document_update_bloc;/driving_document_update_cubit.dart';
import '../Blocs/driving_licence_document_update_bloc;/driving_document_update_state.dart';

class DrivingDocUpdate extends StatefulWidget {
  String uid;

  DrivingDocUpdate({super.key, required this.uid});

  @override
  State<DrivingDocUpdate> createState() => _DrivingDocUpdateState();
}

class _DrivingDocUpdateState extends State<DrivingDocUpdate> {
  @override
  void initState() {
    drivingLicenceShowDataLoad();
    super.initState();
  }

  void driverDocFileUpdate() {
    String token = context.read<TokenCubit>().state;
    String customerId = context.read<IdCubit>().state;
    context.read<DrivingDocUpdateCubit>().drivingLicenceDocUpdateData(
        customer_id: customerId,
        token: token,
        request_id: requestId!,
        service_request_id: serviceRequestId!,
        data_document: context.read<DriverDocFileUpload>().state.path.isEmpty
            ? File("")
            : context.read<DriverDocFileUpload>().state);
  }

  void drivingLicenceShowDataLoad() {
    String token = context.read<TokenCubit>().state;
    context
        .read<DrivingLicenceShowDataCubit>()
        .drivingLicenceShowDataLoad(token: token, uid: widget.uid);
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
          child: BlocBuilder<DrivingLicenceShowDataCubit,
              DrivingLicenceShowDataState>(builder: (context, showData) {
            if (showData is DrivingLicenceShowDataLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (showData is DrivingLicenceShowDataErrorState) {
              return Center(
                child: Text(showData.message),
              );
            } else if (showData is DrivingLicenceShowDataSuccessState) {
              DrivingLicenceShowDataModel data =
                  showData.drivingLicenceShowDataModel;
              return Column(
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
                  Text(
                    "Driving Licence Verification Remark:",
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
                  BlocBuilder<DriverDocFileUpload, File>(
                      builder: (context, docUpload) {
                    return PickPhotoUpdate(
                      widthSize: double.infinity,
                      onPressedPickImage: () {
                        context
                            .read<DriverDocFileUpload>()
                            .pickFile()
                            .then((_) {
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
                      title: 'Driving Licence Documents',
                      image: docUpload,
                      mainTitle: "Driving Licence Documents",
                      uploadImage: data.data!.dataDocument!,
                    );
                  }),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text("Note : Upload Driving Licence Image/Documents"),
                  const SizedBox(
                    height: 24,
                  ),
                  BlocConsumer<DrivingDocUpdateCubit, DrivingDocUpdateState>(
                    listener: (context, upload) {
                      if (upload is DrivingDocUpdateErrorState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(upload.message)));
                      } else if (upload is DrivingDocUpdateSuccessState) {
                        if (upload.data["status"] == 200) {
                          context.pushReplacementNamed("bottomNav");
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(upload.data["message"])));
                      }
                    },
                    builder: (context, upload) {
                      return CustomButton(
                          isLoading: upload is DrivingDocUpdateLoadingState,
                          gradientColors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).primaryColorDark
                          ],
                          onTap: () {
                            driverDocFileUpdate();
                          },
                          text: "SUBMIT");
                    },
                  ),
                ],
              );
            }
            return const Center(
              child: Text("Error..."),
            );
          }),
        ),
      ),
    );
  }
}
