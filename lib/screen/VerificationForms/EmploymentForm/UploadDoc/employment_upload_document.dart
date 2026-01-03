import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentForm/UploadDoc/Bloc/employment_upload_state.dart';

import '../../common/id.dart';
import '../../common/pickphoto.dart';
import '../Save/Bloc/EmploymentSaveForm.dart';
import 'Bloc/employment_upload_cubit.dart';

class EmploymentUploadDocument extends StatefulWidget {
  const EmploymentUploadDocument({super.key});

  @override
  State<EmploymentUploadDocument> createState() =>
      _EmploymentUploadDocumentState();
}

class _EmploymentUploadDocumentState extends State<EmploymentUploadDocument> {
  void employmentUploadDoc() {
    String token = context.read<TokenCubit>().state;
    String customerId = context.read<IdCubit>().state;
    context.read<EmploymentUploadCubit>().employmentUpload(
        customer_id: customerId,
        token: token,
        request_id: requestId!,
        service_request_id: serviceRequestId!,
        employment_supporting_doc:
            context.read<EmploymentSupportDocument>().state);
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Employment Verification Documents Form",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Theme.of(context).primaryColorDark),
                ),
                const SizedBox(height: 16,),
                Text("Choose an Option:",style: Theme.of(context).textTheme.bodySmall),
                BlocProvider(
                  create: (_) => FormUploadEmploymentCubit(),
                  child: BlocBuilder<FormUploadEmploymentCubit, bool>(
                      builder: (context, frmUpload) {
                    return Column(
                      children: [
                        ListTile(
                          splashColor: Colors.transparent,
                          onTap: () {
                            // context.pushReplacementNamed("EmploymentSaveForm");
                            context.pushReplacementNamed("EmploymentSaveFormNew");
                            // context
                            //     .read<FormUploadEmploymentCubit>()
                            //     .formUploadYesNo(yesNo: true);
                            //
                            // context
                            //     .read<FormUploadEmploymentCubit>()
                            //     .formUploadYesNo(yesNo: false);
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
                                .read<FormUploadEmploymentCubit>()
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
                BlocBuilder<EmploymentSupportDocument, File>(
                    builder: (context, uploadDoc) {
                  return PickPhoto(
                    widthSize: double.infinity,
                    mainTitle: "Upload Employment Support Documents",
                    title: 'Select Employment Support Document',
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
                BlocConsumer<EmploymentUploadCubit, EmploymentUploadState>(
                    listener: (context, employDoc) {
                  if (employDoc is EmploymentUploadSuccessState) {
                    if (employDoc.data["status"] == 200) {
                      context.pushReplacementNamed("EmployDataList");
                      context.read<EmploymentSupportDocument>().clearImage();
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(employDoc.data["message"])));
                  } else if (employDoc is EmploymentUploadErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(employDoc.message)));
                  }
                }, builder: (context, employDoc) {
                  return CustomButton(
                    isLoading: employDoc is EmploymentUploadLoadingState,
                    onTap: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        if (context
                                .read<EmploymentSupportDocument>()
                                .state
                                .path
                                .isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Please upload documents")));
                        } else {
                          employmentUploadDoc();
                        }
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
            ),
          ),
        ),
      ),
    );
  }
}
