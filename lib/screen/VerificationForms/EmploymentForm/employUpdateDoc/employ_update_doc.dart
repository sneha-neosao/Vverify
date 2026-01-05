import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/screen/VerificationForms/common/url.dart';

import '../../common/id.dart';
import '../../common/pickphoto.dart';
import '../Save/Bloc/EmploymentSaveForm.dart';
import '../Update/showData/Bloc/employ_show_data_cubit.dart';
import '../Update/showData/Bloc/employ_show_data_state.dart';
import '../Update/showData/Model/employ_show_data_model.dart';
import 'Bloc/employ_doc_update_cubit.dart';
import 'Bloc/employ_doc_update_state.dart';

class EmployUpdateDoc extends StatefulWidget {
  String uid;

  EmployUpdateDoc({super.key, required this.uid});

  @override
  State<EmployUpdateDoc> createState() => _EmployUpdateDocState();
}

class _EmployUpdateDocState extends State<EmployUpdateDoc> {
  void employmentUpdateDoc() {
    String token = context.read<TokenCubit>().state;
    String customerId = context.read<IdCubit>().state;
    context.read<EmployDocUpdateCubit>().employmentUpdateDoc(
        token: token,
        customer_id: customerId,
        uid: widget.uid,
        request_id: requestId!,
        service_request_id: serviceRequestId!,
        // employment_letter_doc: context.read<EmploymentSupportDocument>().state,
        employment_supporting_doc: context.read<EmploymentSupportDocument>().state);
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    print("Uid : ${widget.uid}");
    employShowData();
    super.initState();
  }

  void employShowData() {
    String token = context.read<TokenCubit>().state;
    print("Uid : ${widget.uid}");
    context
        .read<EmployShowDataCubit>()
        .employShowData(token: token, uid: widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
        child: Form(
          key: _formKey,
          child: BlocBuilder<EmployShowDataCubit, EmployShowDataState>(
              builder: (context, employData) {
            if (employData is EmployShowDataLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (employData is EmployShowDataErrorState) {
              return Center(
                child: Text(employData.message),
              );
            } else if (employData is EmployShowDataSuccessState) {
              EmploymentShowDataModel data = employData.employmentShowDataModel;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Employment Verification Document Update Form",
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
                    data.data!.verification_remark ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.red),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  BlocBuilder<EmploymentSupportDocument, File>(
                      builder: (context, uploadDoc) {
                    return PickPhotoUpdate(
                      widthSize: double.infinity,
                      mainTitle: "Upload Employment Company Letter",
                      title: 'Upload Employment Letter',
                      onPressedPickImage: () {
                        context
                            .read<EmploymentSupportDocument>()
                            .pickFile()
                            .then((_) {
                          context.pop();
                        });
                      },
                      onPressedTakePhoto: () {
                        context
                            .read<EmploymentSupportDocument>()
                            .pickImageFromCamera()
                            .then((_) {
                          context.pop();
                        });
                      },
                      image: uploadDoc,
                      uploadImage: data.data!.employment_supporting_doc!.startsWith("http")
                          ? data.data!.employment_supporting_doc!
                          : "$imageUrl${data.data!.employment_supporting_doc!}",
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
                  BlocConsumer<EmployDocUpdateCubit, EmployDocUpdateState>(
                      listener: (context, employDoc) {
                    if (employDoc is EmployDocUpdateSuccessState) {
                      if (employDoc.data["status"] == 200) {
                        context.pushReplacementNamed("EmployDataList");
                        context.read<EmploymentSupportDocument>().clearImage();
                        // context
                        //     .read<EmploymentMarkSheetDocument>()
                        //     .clearImage();
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(employDoc.data["message"])));
                    } else if (employDoc is EmployDocUpdateErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(employDoc.message)));
                    }
                  }, builder: (context, employDoc) {
                    return CustomButton(
                      isLoading: employDoc is EmployDocUpdateLoadingState,
                      onTap: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          employmentUpdateDoc();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Please fill all fields")));
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
