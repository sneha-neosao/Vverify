import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/screen/VerificationForms/common/pickphoto.dart';

import '../../common/form_widget.dart';
import '../../common/id.dart';
import '../../common/validator.dart';
import 'Bloc/name_address_verification_cubit.dart';
import 'Bloc/name_address_verification_state.dart';
import 'model/name_address_verification_model.dart';

TextEditingController personNameController = TextEditingController();

class NameAddressVerificationFormNew extends StatefulWidget {
  const NameAddressVerificationFormNew({super.key});

  @override
  State<NameAddressVerificationFormNew> createState() =>
      _NameAddressVerificationFormNewState();
}

class _NameAddressVerificationFormNewState extends State<NameAddressVerificationFormNew> {

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
            permanent_pinCode: isSameAddress ? currentPinCodeController.text : permanentPinCodeController.text
        )
    );
  }

  void pickImageClear() {
    context.read<NameAddressAadhaarFrontSideCubit>().clearImage();
    context.read<NameAddressAadhaarBackSideCubit>().clearImage();
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
                    "Full Name & Address Verification",
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
                    create: (_) => FormUploadNameAddressCubit(),
                    child: BlocBuilder<FormUploadNameAddressCubit, bool>(
                        builder: (context, frmUpload) {
                          return Column(
                            children: [
                              ListTile(
                                splashColor: Colors.transparent,
                                onTap: () {
                                  context
                                      .read<FormUploadNameAddressCubit>()
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
                                  context
                                      .pushReplacementNamed("NameAddressDocUpload");

                                  context
                                      .read<FormUploadNameAddressCubit>()
                                      .formUploadYesNo(yesNo: false);

                                  context
                                      .read<FormUploadNameAddressCubit>()
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
                    "Person's Current Address",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).primaryColorDark, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  FormFieldNotRequired(
                      controller: currentLine1AddressController,
                      titleText: "Address Line 1",
                      hintText: "Enter Line 1 Address",
                      textInputType: TextInputType.text),
                  FormFieldNotRequired(
                      controller: currentLine2AddressController,
                      titleText: "Address Line 2",
                      hintText: "Enter Line 2 Address",
                      textInputType: TextInputType.text),
                  FormFieldNotRequired(
                      controller: currentCityAddressController,
                      titleText: "City",
                      hintText: "Enter City",
                      textInputType: TextInputType.text),
                  FormFieldNotRequired(
                      controller: currentStateAddressController,
                      titleText: "State",
                      hintText: "Enter State",
                      textInputType: TextInputType.text),
                  FormFieldNotRequired(
                      maskFormatter: [pinMask],
                      controller: currentPinCodeController,
                      titleText: 'Postal Code',
                      hintText: "Enter Postal Code",
                      textInputType: TextInputType.number),
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
                        onChanged: (value) {
                          setState(() {
                            isSameAddress = value!;
                          });
                        },
                        side: const BorderSide(
                          color: Colors.orange,
                          width: 2,
                        ),
                        activeColor: Colors.orange,
                        checkColor: Colors.white,
                      ),
                      const Text("Same as Current Address"),
                    ],
                  ),
                  FormFieldNotRequired(
                      controller: isSameAddress ? currentLine1AddressController : permanentLine1AddressController,
                      titleText: "Address Line 1",
                      hintText: "Enter Line 1 Address",
                      textInputType: TextInputType.text),
                  FormFieldNotRequired(
                      controller: isSameAddress ? currentLine2AddressController : permanentLine2AddressController,
                      titleText: "Address Line 2",
                      hintText: "Enter Line 2 Address",
                      textInputType: TextInputType.text),
                  FormFieldNotRequired(
                      controller: isSameAddress ? currentCityAddressController : permanentCityAddressController,
                      titleText: "City",
                      hintText: "Enter City",
                      textInputType: TextInputType.text),
                  FormFieldNotRequired(
                      controller: isSameAddress ? currentStateAddressController : permanentStateAddressController,
                      titleText: "State",
                      hintText: "Enter State",
                      textInputType: TextInputType.text),
                  FormFieldNotRequired(
                      maskFormatter: [pinMask],
                      controller: isSameAddress ? currentPinCodeController : permanentPinCodeController,
                      titleText: 'Postal Code',
                      hintText: "Enter Postal Code",
                      textInputType: TextInputType.number),
                  const SizedBox(height: 24),
                  BlocConsumer<NameAddressVerificationFormCubit,
                      NameAddressVerificationState>(
                      listener: (context, nameAddress) {
                        if (nameAddress is NameAddressVerificationSuccessState) {
                          if (nameAddress.data["status"] == 200) {
                            context.pushReplacementNamed("bottomNav");
                            pickImageClear();
                            context
                                .read<NameAddressAadhaarFrontSideCubit>()
                                .clearImage();
                            context
                                .read<NameAddressAadhaarBackSideCubit>()
                                .clearImage();
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
