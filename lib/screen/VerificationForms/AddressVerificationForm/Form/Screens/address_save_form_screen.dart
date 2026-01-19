import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/screen/VerificationForms/AddressVerificationForm/Form/Blocs/address_save_form_bloc/address_save_form_cubit.dart';
import 'package:v_verify/screen/VerificationForms/AddressVerificationForm/Form/Blocs/address_save_form_bloc/address_save_from_state.dart';
import 'package:v_verify/widgets/custom_not_required_text_field.dart';
import 'package:v_verify/widgets/custom_required_text_field.dart';
import '../../../common/id.dart';
import '../Models/address_save_model.dart';

TextEditingController personNameController = TextEditingController();

class AddressSaveFormScreen extends StatefulWidget {
  String Case_uuid;

   AddressSaveFormScreen({super.key,required this.Case_uuid,});

  @override
  State<AddressSaveFormScreen> createState() =>
      _AddressSaveFormScreenState();
}

class _AddressSaveFormScreenState extends State<AddressSaveFormScreen> {
  bool isChecked = false;
  bool isSameAddress = false;

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
    super.initState();
  }

  @override
  void dispose() {
    currentCityAddressController.dispose();
    currentLine2AddressController.dispose();
    currentCityAddressController.dispose();
    currentStateAddressController.dispose();
    currentPinCodeController.dispose();
    permanentLine1AddressController.dispose();
    permanentLine2AddressController.dispose();
    permanentCityAddressController.dispose();
    permanentStateAddressController.dispose();
    permanentPinCodeController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  void nameAddressFormSave() {
    String token = context.read<TokenCubit>().state;
    String customerId = context.read<IdCubit>().state;

    print('AddressSaveFormModel:');
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
    print('case_uuid: ${widget.Case_uuid}');
    print('till_date: ${isChecked == true ? 1 : null}');

    context.read<NameAddressVerificationFormCubit>().nameAddressForm(
        customer_id: customerId,
        token: token,
        nameAddressVerificationModel: NameAddressVerificationModel(
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
            residing_from_date: residenceFromDateController.text,
            residing_to_date: residenceToDateController.text,
            data_preference: "form",
            case_uuid: widget.Case_uuid,
            till_date: isChecked == true ? 1 : null
        )
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Address Verification",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Theme.of(context).primaryColorDark),
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
                  const SizedBox(height: 24),
                  BlocConsumer<NameAddressVerificationFormCubit,
                      NameAddressVerificationState>(
                      listener: (context, nameAddress) {
                        if (nameAddress is NameAddressVerificationSuccessState) {
                          if (nameAddress.data["status"] == 200) {
                            context.pushNamed("AddressList",pathParameters: {
                              'uid': widget.Case_uuid
                            });
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(nameAddress.data["message"])));
                        } else if (nameAddress is NameAddressVerificationErrorState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(nameAddress.message)));
                        }
                      }, builder: (context, nameAddress) {
                    return CustomButton(
                      isLoading:
                      nameAddress is NameAddressVerificationLoadingState,
                      onTap: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          nameAddressFormSave();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please Fill All Fields')));
                        }
                      },
                      text: "SUBMIT",
                      gradientColors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColorDark
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
