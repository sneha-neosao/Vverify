import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/screen/VerificationForms/ReferenceForm/Form/Models/Reference_save_form_model.dart';
import 'package:v_verify/screen/VerificationForms/common/validator.dart';
import 'package:v_verify/widgets/custom_required_text_field.dart';

import '../../../common/form_widget.dart';
import '../../../common/id.dart';
import '../Blocs/reference_save_form_bloc/reference_save_form_cubit.dart';
import '../Blocs/reference_save_form_bloc/reference_save_form_state.dart';

class ReferenceSaveFormScreen extends StatefulWidget {
  const ReferenceSaveFormScreen({super.key});

  @override
  State<ReferenceSaveFormScreen> createState() => _ReferenceSaveFormScreenState();
}

class _ReferenceSaveFormScreenState extends State<ReferenceSaveFormScreen> {
  TextEditingController person1NameController = TextEditingController();
  TextEditingController person1AddressController = TextEditingController();
  TextEditingController person1MobileNoController = TextEditingController();
  TextEditingController person1RelationController = TextEditingController();
  TextEditingController person2NameController = TextEditingController();
  TextEditingController person2AddressController = TextEditingController();
  TextEditingController person2MobileNoController = TextEditingController();
  TextEditingController person2RelationController = TextEditingController();

  void referenceFormClear() {
    person1NameController.dispose();
    person1AddressController.dispose();
    person1MobileNoController.dispose();
    person1RelationController.dispose();
    person2NameController.dispose();
    person2AddressController.dispose();
    person2MobileNoController.dispose();
    person2RelationController.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    referenceFormClear();
    super.dispose();
  }

  void referenceSaveData() {
    String token = context.read<TokenCubit>().state;
    String customerId = context.read<IdCubit>().state;

    context.read<ReferenceFormCubit>().referenceForm(
        token: token,
        customer_id: customerId,
        referenceModel: ReferenceModel(
            request_id: requestId!,
            service_request_id: serviceRequestId!,
            person_name_one: person1NameController.text,
            person_mobile_number_one: person1MobileNoController.text,
            person_relation_one: person1RelationController.text,
            person_name_two: person2NameController.text,
            person_mobile_number_two: person2MobileNoController.text,
            person_relation_two: person2RelationController.text));
  }

  var mobileMaskFormatter = MaskTextInputFormatter(
      mask: '##########', filter: {"#": RegExp(r'[0-9]')});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Reference Check Verification",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Theme.of(context).primaryColorDark),
                  ),
                  const SizedBox(height: 16,),
                  Text("Choose an Option:",style: Theme.of(context).textTheme.bodySmall),
                  BlocProvider(
                    create: (_) => FormUploadReferenceCubit(),
                    child: BlocBuilder<FormUploadReferenceCubit, bool>(
                        builder: (context, frmUpload) {
                      return Column(
                        children: [
                          ListTile(
                            splashColor: Colors.transparent,
                            onTap: () {
                              context
                                  .read<FormUploadReferenceCubit>()
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
                              context.pushReplacementNamed("ReferenceUploadDoc");
        
                              context
                                  .read<FormUploadReferenceCubit>()
                                  .formUploadYesNo(yesNo: false);
        
                              context
                                  .read<FormUploadReferenceCubit>()
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
                    height: 16,
                  ),
                  Text(
                    "Person One Details",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).primaryColorDark, fontSize: 16),
                  ),
                  CustomRequiredTextField(
                      controller: person1NameController,
                      titleText: "Person One Name",
                      hintText: "Enter Person One Name",
                      textInputType: TextInputType.text
                  ),
                  CustomRequiredTextField(
                      maskFormatter: [mobileMaskFormatter],
                      validator: validateMobile,
                      controller: person1MobileNoController,
                      titleText: "Person One Mobile No",
                      hintText: "Enter Person One Mobile No",
                      textInputType: TextInputType.text
                  ),
                  CustomRequiredTextField(
                      controller: person1RelationController,
                      titleText: "Person One Relation",
                      hintText: "Enter Person One Relation",
                      textInputType: TextInputType.text
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    "Person Two Details",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).primaryColorDark, fontSize: 16),
                  ),
                  CustomRequiredTextField(
                      controller: person2NameController,
                      titleText: "Person Two Name",
                      hintText: "Enter Person Two Name",
                      textInputType: TextInputType.text
                  ),
                  CustomRequiredTextField(
                      maskFormatter: [mobileMaskFormatter],
                      validator: validateMobile,
                      controller: person2MobileNoController,
                      titleText: "Person Two Mobile No",
                      hintText: "Enter Person Two Mobile No",
                      textInputType: TextInputType.text
                  ),
                  CustomRequiredTextField(
                      controller: person2RelationController,
                      titleText: "Person Two Relation",
                      hintText: "Enter Person Two Relation",
                      textInputType: TextInputType.text
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  BlocConsumer<ReferenceFormCubit, ReferenceVerificationState>(
                      listener: (context, referenceForm) {
                    if (referenceForm is ReferenceVerificationSuccessState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(referenceForm.data["message"])));
                      if (referenceForm.data["status"] == 200) {
                        context.pushReplacementNamed("bottomNav");
                      }
                    } else if (referenceForm is ReferenceVerificationErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(referenceForm.message)));
                    }
                  }, builder: (context, referenceForm) {
                    return CustomButton(
                      onTap: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          referenceSaveData();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Please fill all fields")));
                        }
                      },
                      isLoading:
                          referenceForm is ReferenceVerificationLoadingState,
                      text: "SUBMIT",
                      gradientColors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColorDark,
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
        ),
      ),
    );
  }
}
