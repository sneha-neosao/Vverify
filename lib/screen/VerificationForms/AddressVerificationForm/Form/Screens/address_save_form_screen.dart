import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/screen/VerificationForms/common/pickphoto.dart';

import '../../../common/form_widget.dart';
import '../../../common/id.dart';
import '../../../common/validator.dart';
import '../../Save/Bloc/name_address_verification_cubit.dart';
import '../../Save/Bloc/name_address_verification_state.dart';
import '../../Save/model/name_address_verification_model.dart';

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

  var maskFormatter = MaskTextInputFormatter(
      mask: '##-##-####', filter: {"#": RegExp(r'[0-9]')});

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
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  // Function to show the date picker
  Future<void> _selectResidenceFromDate(BuildContext context) async {
    // DateTime date18YearsAgo = _getDate18YearsAgo();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950), // Min date: 18 years ago
      lastDate: DateTime.now(), // Max date: today
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);

      //setState(() {
      _selectedDate = pickedDate;
      residenceFromDateController.text = formattedDate;
      // });
    }
  }

  // Function to show the date picker
  Future<void> _selectResidenceToDate(BuildContext context) async {
    // DateTime date18YearsAgo = _getDate18YearsAgo();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950), // Min date: 18 years ago
      lastDate: DateTime.now(), // Max date: today
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);

      //setState(() {
      _selectedDate = pickedDate;
      residenceToDateController.text = formattedDate;
      // });
    }
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
                  RichText(
                      text: TextSpan(
                          text: "Residing From",
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
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    readOnly: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter residing from date';
                      }
                      return null;
                    },
                    style: Theme.of(context).textTheme.bodySmall,
                    keyboardType: TextInputType.number,
                    inputFormatters: [maskFormatter],
                    controller: residenceFromDateController,
                    decoration: InputDecoration(
                      hintText: "DD-MM-YYYY",
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectResidenceFromDate(
                            context), // Open date picker when icon is pressed
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  RichText(
                      text: TextSpan(
                        text: "Residing To",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(fontWeight: FontWeight.w700),
                      )),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    readOnly: true,
                    style: Theme.of(context).textTheme.bodySmall,
                    keyboardType: TextInputType.number,
                    inputFormatters: [maskFormatter],
                    controller: residenceToDateController,
                    decoration: InputDecoration(
                      hintText: "DD-MM-YYYY",
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectResidenceToDate(
                            context), // Open date picker when icon is pressed
                      ),
                    ),
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
                            context.pushReplacementNamed("bottomNav");
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
