import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/screen/VerificationForms/AddressVerificationForm/Form/Models/address_update_model.dart';
import 'package:v_verify/screen/VerificationForms/common/id.dart';
import 'package:v_verify/widgets/custom_not_required_text_field.dart';
import 'package:v_verify/widgets/custom_required_text_field.dart';
import '../Blocs/address_update_form_bloc/name_address_verification_cubit.dart';
import '../Blocs/address_update_form_bloc/name_address_verification_state.dart';
import '../Blocs/address_show_details_bloc/address_show_details_bloc.dart';
import '../Blocs/address_show_details_bloc/address_show_details_state.dart';
import '../Models/address_show_details_model.dart';

class AddressUpdateFormScreen extends StatefulWidget {
  final String uid;
  final String case_uuid;
  final String address_uuid;

  AddressUpdateFormScreen({super.key,  required this.uid, required this.case_uuid, required this.address_uuid});

  @override
  State<AddressUpdateFormScreen> createState() =>
      _AddressUpdateFormScreenState();
}

class _AddressUpdateFormScreenState extends State<AddressUpdateFormScreen> {
  bool isSameAddress = false;
  bool isChecked = false;

  TextEditingController currentLine1AddressController = TextEditingController();
  TextEditingController currentLine2AddressController = TextEditingController();
  TextEditingController currentCityAddressController = TextEditingController();
  TextEditingController currentStateAddressController = TextEditingController();
  TextEditingController currentPinCodeController = TextEditingController();
  TextEditingController permanentLine1AddressController = TextEditingController();
  TextEditingController permanentLine2AddressController = TextEditingController();
  TextEditingController permanentCityAddressController = TextEditingController();
  TextEditingController permanentStateAddressController = TextEditingController();
  TextEditingController permanentPinCodeController = TextEditingController();
  TextEditingController residenceFromDateController = TextEditingController();
  TextEditingController residenceToDateController = TextEditingController();

  @override
  void initState() {
    showDataLoad();
    super.initState();
  }

  @override
  void dispose() {
    currentLine1AddressController.dispose();
    currentLine2AddressController.dispose();
    currentStateAddressController.dispose();
    currentPinCodeController.dispose();
    permanentLine1AddressController.dispose();
    permanentLine2AddressController.dispose();
    permanentCityAddressController.dispose();
    permanentStateAddressController.dispose();
    permanentPinCodeController.dispose();
    super.dispose();
  }

  void nameAddressUpdate() {
    print(requestId);
    print(serviceRequestId);
    String token = context.read<TokenCubit>().state;
    String customerId = context.read<IdCubit>().state;

    print('AddressUpdateFormModel:');
    print('request_id: $requestId');
    print('service_request_id: $serviceRequestId');
    print('current_address_line_1: ${currentLine1AddressController.text}');
    print('current_address_line_2: ${currentLine2AddressController.text}');
    print('current_city_id: ${currentCityAddressController.text}');
    print('current_state: ${currentStateAddressController.text}');
    print('current_pinCode: ${currentPinCodeController.text}');
    print('permanent_address_line_1: ${isSameAddress ? currentLine1AddressController.text : permanentLine1AddressController.text}');
    print('permanent_address_line_2: ${isSameAddress ? currentLine2AddressController.text : permanentLine2AddressController.text}');
    print('permanent_city_id: ${isSameAddress ? currentCityAddressController.text : permanentCityAddressController.text}');
    print('permanent_state: ${isSameAddress ? currentStateAddressController.text : permanentStateAddressController.text}');
    print('permanent_pinCode: ${isSameAddress ? currentPinCodeController.text : permanentPinCodeController.text}');
    print('residing_from_date: ${residenceFromDateController.text}');
    print('residing_to_date: ${residenceToDateController.text}');
    print('data_preference: form');
    print('case_uuid: ${widget.case_uuid}');
    print('till_date: ${isChecked == true ? 1 : null}');

    context.read<NameAddressVerificationUpdateFormCubit>()
        .nameAddressUpdateForm(
        customer_id: customerId,
        token: token,
        nameAddressVerificationUpdateModel:
        NameAddressVerificationUpdateModel(
            request_id: requestId!,
            service_request_id: serviceRequestId!,
            current_address_line_1: currentLine1AddressController.text,
            current_address_line_2: currentLine2AddressController.text,
            current_city_id: currentCityAddressController.text,
            current_state: currentStateAddressController.text,
            current_pinCode: currentPinCodeController.text,
            permanent_address_line_1: isSameAddress ? currentLine1AddressController.text : permanentLine1AddressController.text,
            permanent_address_line_2: isSameAddress ? currentLine2AddressController.text : permanentLine2AddressController.text,
            permanent_city_id: isSameAddress ? currentCityAddressController.text : permanentCityAddressController.text,
            permanent_state: isSameAddress ? currentStateAddressController.text : permanentStateAddressController.text,
            permanent_pinCode: isSameAddress ? currentPinCodeController.text : permanentPinCodeController.text,
            case_uuid: widget.case_uuid,
            address_uuid: widget.address_uuid,
            data_preference: "form",
            residing_from_date: residenceFromDateController.text,
            residing_to_date: residenceToDateController.text,
            till_date: isChecked == true ? 1 : null,
            uid: widget.uid
        )
    );
  }

  void showDataLoad() {
    String token = context.read<TokenCubit>().state;
    context
        .read<NameAddressShowDataCubit>()
        .nameAddressShowData(token: token, uid: widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
            child:
            BlocConsumer<NameAddressShowDataCubit, NameAddressShowDataState>(
              listener: (context, showData){
                if (showData is NameAddressShowDataSSuccessState) {
                  NameAddressShowDataModel data = showData.nameAddressShowDataModel;
        
                  currentLine1AddressController.text = data.data!.current_address_line_1 ?? "";
                  currentLine2AddressController.text = data.data!.current_address_line_2 ?? "";
                  currentCityAddressController.text = data.data!.current_address_city ?? "";
                  currentStateAddressController.text = data.data!.current_address_state ?? "";
                  currentPinCodeController.text = data.data!.current_address_postal_code ?? "";
                  permanentLine1AddressController.text = data.data!.permanent_address_line_1 ?? "";
                  permanentLine2AddressController.text = data.data!.permanent_address_line_2 ?? "";
                  permanentCityAddressController.text = data.data!.permanent_address_city ?? "";
                  permanentStateAddressController.text = data.data!.permanent_address_state ?? "";
                  permanentPinCodeController.text = data.data!.permanent_address_postal_code ?? "";
                  residenceFromDateController.text = data.data!.residing_from_date ?? "";
                  residenceToDateController.text = data.data!.residing_to_date ?? "";
                  // ✅ Checkbox logic
                  isChecked = (data.data!.residing_to_date == null ||
                      data.data!.residing_to_date!.isEmpty);
                  setState(() {});
                }
              },
                builder: (context, showData) {
                  if (showData is NameAddressShowDataSLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (showData is NameAddressShowDataSErrorState) {
                    return Center(
                      child: Text(showData.message),
                    );
                  } else if (showData is NameAddressShowDataSSuccessState) {
                    NameAddressShowDataModel data = showData.nameAddressShowDataModel;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Address Verification",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: Theme.of(context).primaryColorDark),
                        ),
                        Text(
                          "Current Address Verification Remark:",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.red),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          data.data!.verification_remark!,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.red),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          "Permanent Address Verification Remark:",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.red),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          data.data!.permanent_address_verification_remark!,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.red),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          "Person's Current Address",
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              color: Theme.of(context).primaryColorDark, fontSize: 16),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomRequiredTextField(
                            controller: currentLine1AddressController,
                            titleText: "Address Line 1",
                            hintText: "Enter Line 1 Address",
                            textInputType: TextInputType.text
                        ),
                        CustomNotRequiredTextField(
                            controller: currentLine2AddressController,
                            titleText: "Address Line 2",
                            hintText: "Enter Line 2 Address",
                            textInputType: TextInputType.text
                        ),
                        CustomRequiredTextField(
                            controller: currentCityAddressController,
                            titleText: "City",
                            hintText: "Enter City",
                            textInputType: TextInputType.text
                        ),
                        CustomRequiredTextField(
                            controller: currentStateAddressController,
                            titleText: "State",
                            hintText: "Enter State",
                            textInputType: TextInputType.text
                        ),
                        CustomRequiredTextField(
                            controller: currentPinCodeController,
                            titleText: "Postal Code",
                            hintText: "Enter Postal Code",
                            textInputType: TextInputType.text
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          "Person's Permanent Address",
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              color: Theme.of(context).primaryColorDark, fontSize: 16),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: isSameAddress,
                              onChanged: (bool? value) {
                                setState(() {
                                  isSameAddress = value ?? false;
                                }); },
                              activeColor: Colors.orange, // fill color when checked
                              checkColor: Colors.white, // tick mark color
                            ),
                            Text(
                              "Same as Current Address",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        CustomRequiredTextField(
                            controller: isSameAddress ? currentLine1AddressController : permanentLine1AddressController,
                            titleText: "Address Line 1",
                            hintText: "Enter Address Line 1",
                            textInputType: TextInputType.text
                        ),
                        CustomNotRequiredTextField(
                            controller: isSameAddress ? currentLine2AddressController : permanentLine2AddressController,
                            titleText: "Address Line 2",
                            hintText: "Enter Address Line 2",
                            textInputType: TextInputType.text
                        ),
                        CustomRequiredTextField(
                            controller: isSameAddress ? currentCityAddressController : permanentCityAddressController,
                            titleText: "City",
                            hintText: "Enter City",
                            textInputType: TextInputType.text
                        ),
                        CustomRequiredTextField(
                            controller: isSameAddress ? currentStateAddressController : permanentStateAddressController,
                            titleText: "State",
                            hintText: "Enter State",
                            textInputType: TextInputType.text
                        ),
                        CustomRequiredTextField(
                            controller: isSameAddress ? currentPinCodeController : permanentPinCodeController,
                            titleText: "Postal Code",
                            hintText: "Enter Postal Code",
                            textInputType: TextInputType.text
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          "Residing Period",
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              color: Theme.of(context).primaryColorDark, fontSize: 16),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomRequiredTextField(
                            controller: residenceFromDateController,
                            titleText: "Residing From",
                            hintText: "Enter Residing From",
                            textInputType: TextInputType.text
                        ),
                        CustomNotRequiredTextField(
                            enabled: !isChecked,
                            controller: residenceToDateController,
                            titleText: "Residing To",
                            hintText: "Enter Residing To",
                            textInputType: TextInputType.text
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  isChecked = value ?? false;

                                  if (isChecked) { residenceToDateController.clear(); }
                                }); },
                              activeColor: Colors.orange, // fill color when checked
                              checkColor: Colors.white, // tick mark color
                            ),
                            Text(
                              "Till Date",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        BlocConsumer<NameAddressVerificationUpdateFormCubit,
                            NameAddressVerificationUpdateState>(
                            listener: (context, updateData) {
                              if (updateData
                              is NameAddressVerificationUpdateSuccessState) {
                                if (updateData.data["status"] == 200) {
                                  context.pushNamed("AddressList",pathParameters: {
                                    'uid': widget.case_uuid
                                  });
                                }
                              } else if (updateData
                              is NameAddressVerificationUpdateErrorState) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(updateData.message)));
                              }
                            }, builder: (context, updateData) {
                          return CustomButton(
                            isLoading: updateData
                            is NameAddressVerificationUpdateLoadingState,
                            onTap: () {
                              nameAddressUpdate();
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
                  return const SizedBox.shrink();
                }),
          ),
        ),
      ),
    );
  }
}
