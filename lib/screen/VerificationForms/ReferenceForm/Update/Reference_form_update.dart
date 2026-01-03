import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/screen/VerificationForms/common/id.dart';
import 'package:v_verify/screen/VerificationForms/common/validator.dart';

import '../../common/form_widget.dart';
import '../ShowDetails/Bloc/reference_check_deatils_state.dart';
import '../ShowDetails/Bloc/reference_check_details_cubit.dart';
import '../ShowDetails/Model/reference_check_details_model.dart';
import 'Bloc/Reference_update_cubit.dart';
import 'Bloc/Reference_update_state.dart';
import 'Model/Reference_model.dart';

class ReferenceFormUpdate extends StatefulWidget {
  String uid;

  ReferenceFormUpdate({super.key, required this.uid});

  @override
  State<ReferenceFormUpdate> createState() => _ReferenceFormUpdateState();
}

class _ReferenceFormUpdateState extends State<ReferenceFormUpdate> {
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
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
                    Text(
                      "Person One Details",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const Divider(),
                    form_widget(
                      maskFormatter: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                      ],
                      textInputType: TextInputType.text,
                      controller: person1NameController
                        ..text = data.data!.personName1.toString(),
                      titleText: "Person One Name",
                      hintText: "Enter Person One Name",
                    ),
                    form_widget(
                      maskFormatter: [mobileMaskFormatter],
                      validator: validateMobile,
                      textInputType: TextInputType.number,
                      controller: person1MobileController
                        ..text = data.data!.personMobileNumber1.toString(),
                      titleText: "Person One Mobile",
                      hintText: "Enter Person One Mobile",
                    ),
                    form_widget(
                      maskFormatter: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                      ],
                      textInputType: TextInputType.text,
                      controller: person1RelationController
                        ..text = data.data!.personRelation1.toString(),
                      titleText: "Person One Relation",
                      hintText: "Enter Person One Relation",
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Person Two Details",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const Divider(),
                    form_widget(
                      maskFormatter: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                      ],
                      textInputType: TextInputType.text,
                      controller: person2NameController
                        ..text = data.data!.personName2.toString(),
                      titleText: "Person Two Name",
                      hintText: "Enter Person Two Name",
                    ),
                    form_widget(
                      maskFormatter: [mobileMaskFormatter],
                      validator: validateMobile,
                      textInputType: TextInputType.number,
                      controller: person2MobileController
                        ..text = data.data!.personMobileNumber2.toString(),
                      titleText: "Person Two Mobile",
                      hintText: "Enter Person Two Mobile",
                    ),
                    form_widget(
                      maskFormatter: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                      ],
                      textInputType: TextInputType.text,
                      controller: person2RelationController
                        ..text = data.data!.personRelation2.toString(),
                      titleText: "Person Two Relation",
                      hintText: "Enter Person Two Relation",
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
    );
  }
}
