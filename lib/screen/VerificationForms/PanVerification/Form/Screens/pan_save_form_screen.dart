import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/screen/VerificationForms/common/validator.dart';
import 'package:v_verify/widgets/custom_required_text_field.dart';
import '../../../../../commonComponent/bloc/shared_preferences_cubit.dart';
import '../../../common/id.dart';
import '../Blocs/pan_save_form_bloc/pan_save_form_cubit.dart';
import '../Blocs/pan_save_form_bloc/pan_save_form_state.dart';

class PanSaveFormScreen extends StatefulWidget {
  const PanSaveFormScreen({super.key});

  @override
  State<PanSaveFormScreen> createState() => _PanSaveFormScreenState();
}

class _PanSaveFormScreenState extends State<PanSaveFormScreen> {
  final panMaskFormatter = MaskTextInputFormatter(
    mask: 'AAAAA####A',
    filter: {"A": RegExp(r'[A-Za-z]'), "#": RegExp(r'[0-9]')},
  );

  TextEditingController panVerificationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? selectedType;
  List<String> typeValues = <String>['pan', 'passport', 'driving licence'];

  final Map<String, String> documentTypeMap = {
    'pan': 'pan',
    'passport': 'passport',
    'driving licence': 'drive',
  };

  late List<String> typeLabels;
  @override
  void initState() {
    super.initState();
    typeLabels = documentTypeMap.keys.toList();
  }

  @override
  Widget build(BuildContext context) {
    String token = context.read<TokenCubit>().state;
    String customerId = context.read<IdCubit>().state;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: Form(
          key: _formKey,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "KYC / Identity Verification",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Theme.of(context).primaryColorDark),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Note: * Indicates required fields.",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Identity Details",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).primaryColorDark, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Text("Choose an Option:",style: Theme.of(context).textTheme.bodySmall),
                  BlocProvider(
                    create: (_) => FormUploadPanCubit(),
                    child: BlocBuilder<FormUploadPanCubit, bool>(
                        builder: (context, frmUpload) {
                          return Column(
                            children: [
                              ListTile(
                                splashColor: Colors.transparent,
                                onTap: () {
                                  context
                                      .read<FormUploadPanCubit>()
                                      .formUploadYesNo(yesNo: false);
                                },
                                contentPadding: const EdgeInsets.all(0),
                                leading: Icon(Icons.radio_button_checked,
                                    color: !frmUpload
                                        ? Theme.of(context).primaryColorLight
                                        : Theme.of(context).iconTheme.color),
                                title: Text("Fill the Form Manually",
                                    style: Theme.of(context).textTheme.bodySmall),
                              ),
                              ListTile(
                                splashColor: Colors.transparent,
                                onTap: () {
                                  context.pushReplacementNamed("PanDocumentUpload");

                                  context
                                      .read<FormUploadPanCubit>()
                                      .formUploadYesNo(yesNo: false);

                                  context
                                      .read<FormUploadPanCubit>()
                                      .formUploadYesNo(yesNo: true);
                                },
                                contentPadding: const EdgeInsets.all(0),
                                leading: Icon(
                                  Icons.radio_button_checked,
                                  color: frmUpload
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
                    height: 8,
                  ),
                  RichText(
                      text: TextSpan(
                          text: "Verification Document Type",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontWeight: FontWeight.w700),
                          children: [
                            TextSpan(
                              text: " * ",
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                  fontWeight: FontWeight.w700, color: Colors.red),
                            ),
                          ])),
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 54,
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(highlightColor: Colors.black),
                      child: DropdownButtonFormField<String>(
                        value:
                        typeValues.contains(selectedType) ? selectedType : null,
                        hint: Text(
                          "Select Verification Document Type",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.grey),
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            selectedType = value;
                          });
                        },
                        items: typeValues.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value[0].toUpperCase() + value.substring(1),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          );
                        }).toList(),
                        dropdownColor:
                        Theme.of(context).scaffoldBackgroundColor,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 18.0, vertical: 14.0),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                            const BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                                color: Theme.of(context).canvasColor, width: 1.0),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                                color: Theme.of(context).canvasColor, width: 1.0),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).scaffoldBackgroundColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),

                  if (selectedType == "pan")
                    CustomRequiredTextField(
                      validator: validatePAN,
                      controller: panVerificationController,
                      titleText: "PAN Number",
                      hintText: "Enter PAN Number",
                      textInputType: TextInputType.text,
                    ),

                  if (selectedType == "passport")
                    CustomRequiredTextField(
                      validator: validatePassport,
                      controller: panVerificationController,
                      titleText: "Passport Number",
                      hintText: "Enter Passport Number",
                      textInputType: TextInputType.text,
                    ),

                  if (selectedType == "driving licence")
                    CustomRequiredTextField(
                      validator: validateDrivingLicence,
                      controller: panVerificationController,
                      titleText: "Driving Licence Number",
                      hintText: "Enter Driving Licence Number",
                      textInputType: TextInputType.text,
                    ),

                  const SizedBox(height: 24),

                  BlocProvider(
                    create: (_) => PanVerificationSaveBloc(ApiService()),
                    child: BlocConsumer<PanVerificationSaveBloc,
                        PanVerificationSaveState>(
                      listener: (context, panNumber) {
                        if (panNumber is PanVerificationSaveSuccessState) {
                          if (panNumber.data["status"] == 200) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(panNumber.data["message"])),
                            );
                            context.pushReplacementNamed("bottomNav");
                          }
                        } else if (panNumber is PanVerificationSaveErrorState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(panNumber.message)),
                          );
                        }
                      },
                      builder: (context, panNumber) {
                        return CustomButton(
                          isLoading: panNumber is PanVerificationSaveLoadingState,
                          onTap: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              if (selectedType == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Please select a document type"),
                                  ),
                                );
                                return;
                              }

                              final apiDocType =
                                  documentTypeMap[selectedType!] ?? "";
                              final docNumber =
                              panVerificationController.text.trim();

                              // 👇 Debug prints
                              print("customer_id: $customerId");
                              print("requestId: $requestId");
                              print("token: $token");
                              print("serviceRequestId: $serviceRequestId");
                              print("document_type: $apiDocType");
                              print("document_number: $docNumber");

                              context.read<PanVerificationSaveBloc>().panCardNumberSave(
                                customer_id: customerId,
                                requestId: requestId!,
                                token: token,
                                serviceRequestId: serviceRequestId!,
                                document_type: apiDocType,
                                document_number: docNumber,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please enter required fields"),
                                ),
                              );
                            }
                          },
                          text: "SUBMIT",
                          gradientColors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).primaryColorDark
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
