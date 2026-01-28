import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/screen/VerificationForms/common/id.dart';
import 'package:v_verify/screen/VerificationForms/common/validator.dart';
import 'package:v_verify/widgets/custom_not_required_text_field.dart';
import 'package:v_verify/widgets/custom_required_text_field.dart';

import '../../../common/form_widget.dart';
import '../Blocs/reference_show_details_bloc/reference_show_details_state.dart';
import '../Blocs/reference_show_details_bloc/reference_show_details_cubit.dart';
import '../Models/reference_show_details_model.dart';
import '../Blocs/reference_update_form_bloc/Reference_update_form_cubit.dart';
import '../Blocs/reference_update_form_bloc/Reference_update_form_state.dart';
import '../Models/Reference_update_form_model.dart';

class ReferenceUpdateFormScreen extends StatefulWidget {
  String uid;

  ReferenceUpdateFormScreen({super.key, required this.uid});

  @override
  State<ReferenceUpdateFormScreen> createState() => _ReferenceUpdateFormScreenState();
}

class _ReferenceUpdateFormScreenState extends State<ReferenceUpdateFormScreen> {
  TextEditingController person1NameController = TextEditingController();
  TextEditingController person1MobileController = TextEditingController();
  TextEditingController person1AddressController = TextEditingController();
  TextEditingController person1RelationController = TextEditingController();
  TextEditingController person2NameController = TextEditingController();
  TextEditingController person2MobileController = TextEditingController();
  TextEditingController person2AddressController = TextEditingController();
  TextEditingController person2RelationController = TextEditingController();

  void referenceFormUpdate() {
    String token = context.read<TokenCubit>().state;
    String customerId = context.read<IdCubit>().state;
    context.read<ReferenceUpdateFormCubit>().referenceUpdateForm(
        token: token,
        customer_id: customerId,
        referenceUpdateModel: ReferenceUpdateModel(
            request_id: requestId!,
            service_request_id: serviceRequestId!,
            person_name_one: person1NameController.text,
            person_mobile_number_one: person1MobileController.text,
            person_relation_one: person1RelationController.text,
            person_name_two: person2NameController.text,
            person_mobile_number_two: person2MobileController.text,
            person_relation_two: person2RelationController.text));
  }

  final _formKey = GlobalKey<FormState>();

  void referenceFormClear() {
    person1NameController.clear();
    person1AddressController.clear();
    person1MobileController.clear();
    person1RelationController.clear();
    person2NameController.clear();
    person2AddressController.clear();
    person2MobileController.clear();
    person2RelationController.clear();
  }

  @override
  void initState() {
    referenceDetailsData();
    super.initState();
  }

  @override
  void dispose() {
    referenceFormClear();
    super.dispose();
  }

  void referenceDetailsData() {
    String token = context.read<TokenCubit>().state;
    context
        .read<ReferenceCheckDetailsCubit>()
        .referenceDetails(token: token, uid: widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
            child: Form(
              key: _formKey,
              child: BlocBuilder<ReferenceCheckDetailsCubit,
                  ReferenceCheckDetailsState>(builder: (context, detailsView) {
                if (detailsView is ReferenceCheckDetailsLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (detailsView is ReferenceCheckDetailsErrorState) {
                  return Center(
                    child: Text(textAlign: TextAlign.center, detailsView.message),
                  );
                } else if (detailsView is ReferenceCheckDetailsSuccessState) {
                  ReferenceCheckDetailsModel data =
                      detailsView.referenceCheckDetailsModel;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Reference Check Verification",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Theme.of(context).primaryColorDark),
                      ),
                      Text(
                        "Reference Check Verification Remark:",
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
                      Text(
                        "Person One Details",
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).primaryColorDark, fontSize: 16),
                      ),
                      CustomRequiredTextField(
                          controller: person1NameController..text = data.data!.personName1.toString(),
                          titleText: "Person One Name",
                          hintText: "Enter Person One Name",
                          textInputType: TextInputType.text
                      ),
                      CustomRequiredTextField(
                          maskFormatter: [mobileMaskFormatter],
                          validator: validateMobile,
                          controller: person1MobileController..text = data.data!.personMobileNumber1.toString(),
                          titleText: "Person One Mobile No",
                          hintText: "Enter Person One Mobile No",
                          textInputType: TextInputType.text
                      ),
                      CustomRequiredTextField(
                          controller: person1RelationController..text = data.data!.personRelation1.toString(),
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
                      CustomNotRequiredTextField(
                          controller: person2NameController..text = data.data!.personName2.toString(),
                          titleText: "Person Two Name",
                          hintText: "Enter Person Two Name",
                          textInputType: TextInputType.text
                      ),
                      CustomNotRequiredTextField(
                          maskFormatter: [mobileMaskFormatter],
                          validator: validateMobileNotRequired,
                          controller: person2MobileController..text = data.data!.personMobileNumber2.toString(),
                          titleText: "Person Two Mobile No",
                          hintText: "Enter Person Two Mobile No",
                          textInputType: TextInputType.text
                      ),
                      CustomNotRequiredTextField(
                          controller: person2RelationController..text = data.data!.personRelation2.toString(),
                          titleText: "Person Two Relation",
                          hintText: "Enter Person Two Relation",
                          textInputType: TextInputType.text
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      BlocConsumer<ReferenceUpdateFormCubit,
                              ReferenceUpdateState>(
                          listener: (context, referenceUpdate) {
                        if (referenceUpdate is ReferenceUpdateSuccessState) {
                          if (referenceUpdate.data["status"] == 200) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    referenceUpdate.data["message"].toString())));
                            context.pushReplacementNamed("bottomNav");
                            referenceFormClear();
                          } else if (referenceUpdate
                              is ReferenceUpdateErrorState) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    referenceUpdate.data["message"].toString())));
                          }
                        }
                      }, builder: (context, referenceUpdate) {
                        return CustomButton(
                          isLoading:
                              referenceUpdate is ReferenceUpdateLoadingState,
                          onTap: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              referenceFormUpdate();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Please fill all fields")));
                            }
                          },
                          text: "Update",
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
                return const Center(
                  child: Text("Error..."),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
