import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:v_verify/commonComponent/screen_size.dart';
import 'package:v_verify/screen/VerificationForms/common/validator.dart';

import '../../../../../commonComponent/custom_button.dart';
import '../../../common/form_widget.dart';
import 'MumbaiPoliceVerificationForm3.dart';
import 'TextController/mumbai_text_controller.dart';

class MumbaiPoliceVerificationForm2 extends StatefulWidget {
  const MumbaiPoliceVerificationForm2({super.key});

  @override
  State<MumbaiPoliceVerificationForm2> createState() =>
      _MumbaiPoliceVerificationForm2State();
}

class _MumbaiPoliceVerificationForm2State
    extends State<MumbaiPoliceVerificationForm2> {
  // Initially setting the date as today's date
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();

  // Function to call the date picker
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedStartDate, // initial date
      firstDate: DateTime(1900), // the earliest possible date
      lastDate: DateTime(2101), // the latest possible date
    );
    if (picked != null && picked != selectedStartDate) {
      setState(() {
        selectedStartDate = picked;
        mumbaiTextController.rentedPropertyAgreementStartDateController.text =
            "${selectedStartDate.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedEndDate, // initial date
      firstDate: selectedStartDate, // the earliest possible date
      lastDate: DateTime(2101), // the latest possible date
    );
    if (picked != null && picked != selectedEndDate) {
      setState(() {
        selectedEndDate = picked;
        mumbaiTextController.rentedPropertyAgreementEndDateController.text =
            "${selectedEndDate.toLocal()}".split(' ')[0];
      });
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var maskFormatter = MaskTextInputFormatter(
        mask: '####-##-##', filter: {"#": RegExp(r'[0-9]')});

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
        child: SingleChildScrollView(
          child: SizedBox(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Rented Property Details",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).primaryColorDark,
                        ),
                  ),
                  form_widget(
                    validator: addressValidator,
                    textInputType: TextInputType.text,
                    controller: mumbaiTextController.rentedPropertyAddressMumbaiController,
                    titleText: 'Address',
                    hintText: "Enter Address",
                  ),
                  form_widget(
                    textInputType: TextInputType.text,
                    controller: mumbaiTextController.rentedPropertyStateMumbaiController,
                    titleText: 'State',
                    hintText: "Enter State",
                  ),
                  form_widget(
                    textInputType: TextInputType.text,
                    controller: mumbaiTextController.rentedPropertyCityDistrictMumbaiController,
                    titleText: 'City/District',
                    hintText: "Enter City/District",
                  ),
                  form_widget(
                    maskFormatter: [pinMask],
                    validator: validatePinCode,
                    textInputType: TextInputType.number,
                    controller: mumbaiTextController.rentedPropertyPinCodeMumbaiController,
                    titleText: 'Pin Code',
                    hintText: "Enter Pin Code",
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  RichText(
                      text: TextSpan(
                          text: "Agreement Start Date",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontWeight: FontWeight.w700),
                          children: [
                        TextSpan(
                          text: " * ",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.red),
                        ),
                      ])),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    validator: validateDate,
                    style: Theme.of(context).textTheme.bodySmall,
                    keyboardType: TextInputType.number,
                    inputFormatters: [maskFormatter],
                    controller: mumbaiTextController.rentedPropertyAgreementStartDateController,
                    decoration: InputDecoration(
                      hintText: "YYYY-MM-DD",
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectStartDate(
                            context), // Open date picker when icon is pressed
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  RichText(
                      text: TextSpan(
                          text: "Agreement End Date",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontWeight: FontWeight.w700),
                          children: [
                        TextSpan(
                          text: " * ",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.red),
                        ),
                      ])),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    validator: validateDate,
                    style: Theme.of(context).textTheme.bodySmall,
                    keyboardType: TextInputType.number,
                    inputFormatters: [maskFormatter],
                    controller: mumbaiTextController.rentedPropertyAgreementEndDateController,
                    decoration: InputDecoration(
                      hintText: "YYYY-MM-DD",
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectEndDate(
                            context), // Open date picker when icon is pressed
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenSize.screenHeight / 10.5),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          height: 45,
                          onTap: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            context.pop();
                          },
                          text: "PREV",
                          gradientColors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).primaryColorDark,
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: CustomButton(
                            height: 45,
                            onTap: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              if (_formKey.currentState?.validate() ?? false) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MumbaiPoliceVerificationForm3()));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Please fill all fields')));
                              }
                            },
                            text: "NEXT",
                            gradientColors: [
                              Theme.of(context).primaryColor,
                              Theme.of(context).primaryColorDark,
                            ]),
                      )
                    ],
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
