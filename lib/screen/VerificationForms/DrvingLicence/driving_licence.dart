import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/screen/VerificationForms/common/form_widget.dart';
import 'package:v_verify/screen/VerificationForms/common/id.dart';

import 'Bloc/driving_licence_bloc.dart';
import 'Bloc/driving_licence_state.dart';

class DrivingLicence extends StatefulWidget {
  const DrivingLicence({super.key});

  @override
  State<DrivingLicence> createState() => _DrivingLicenceState();
}

class _DrivingLicenceState extends State<DrivingLicence> {
  TextEditingController drivingLicenceController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();

  @override
  void dispose() {
    drivingLicenceController.dispose();
    dateOfBirthController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  var maskFormatter = MaskTextInputFormatter(
      mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});

  var drivingMask = MaskTextInputFormatter(
      mask: '#### ###########', filter: {"#": RegExp('[A-Za-z0-9]')});

  DateTime selectedJoiningDate = DateTime.now();

  DateTime _getDate18YearsAgo() {
    DateTime today = DateTime.now();
    return DateTime(today.year - 18, today.month, today.day);
  }

  // Function to call the date picker
  Future<void> _selectDobDate(BuildContext context) async {
    DateTime date18YearsAgo = _getDate18YearsAgo();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date18YearsAgo, // initial date
      firstDate: DateTime(1950), // the earliest possible date
      lastDate: date18YearsAgo, // the latest possible date
    );
    if (picked != null && picked != selectedJoiningDate) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(picked);
      setState(() {
        selectedJoiningDate = picked;
        //dobController.text = "${selectedJoiningDate.toLocal()}".split(' ')[0];
        dateOfBirthController.text = formattedDate;
      });
    }
  }

  void drivingLicence() {
    print(drivingLicenceController.text.toUpperCase());
    String token = context.read<TokenCubit>().state;
    String customerId = context.read<IdCubit>().state;
    context.read<DrivingLicenceBloc>().drivingLicenceSaveData(
        customer_id: customerId,
        token: token,
        request_id: requestId!,
        service_request_id: serviceRequestId!,
        driver_licence_number: drivingLicenceController.text.toUpperCase(),
        dob: dateOfBirthController.text);
  }

  // email Validator Function
  String? validateDrivingLicence(String? value) {
    RegExp regExp = RegExp(r'^[a-zA-Z]{2}\d{2}\s?\d{11}');

    if (value == null || value.isEmpty) {
      return 'Please enter a email';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter a valid driving licence number';
    }
    return null;
  }

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
                  "Driving Licence Verification",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Theme.of(context).primaryColorDark),
                ),
                const SizedBox(height: 16,),
                Text("Choose an Option:",style: Theme.of(context).textTheme.bodySmall),
                BlocProvider(
                  create: (_) => FormUploadDrivingCubit(),
                  child: BlocBuilder<FormUploadDrivingCubit, bool>(
                      builder: (context, frmUpload) {
                    return Column(
                      children: [
                        ListTile(
                          splashColor: Colors.transparent,
                          onTap: () {
                            context
                                .read<FormUploadDrivingCubit>()
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
                            context.pushReplacementNamed("DriverDocUpload");

                            context
                                .read<FormUploadDrivingCubit>()
                                .formUploadYesNo(yesNo: false);

                            context
                                .read<FormUploadDrivingCubit>()
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
                form_widget(
                    maskFormatter: [drivingMask],
                    validator: validateDrivingLicence,
                    controller: drivingLicenceController..text.toUpperCase(),
                    titleText: "Driving Licence Number",
                    hintText: "Enter Driving Licence Number",
                    textInputType: TextInputType.text),
                const SizedBox(
                  height: 16,
                ),
                RichText(
                    text: TextSpan(
                        text: "Date of Birth",
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter birth date';
                    }
                    return null;
                  },
                  style: Theme.of(context).textTheme.bodySmall,
                  keyboardType: TextInputType.number,
                  inputFormatters: [maskFormatter],
                  controller: dateOfBirthController,
                  decoration: InputDecoration(
                    hintText: "DD/MM/YYYY",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectDobDate(
                          context), // Open date picker when icon is pressed
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                BlocConsumer<DrivingLicenceBloc, DrivingLicenceState>(
                    listener: (BuildContext context, driving) {
                  if (driving is DrivingLicenceErrorState) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(driving.message)));
                  } else if (driving is DrivingLicenceSuccessState) {
                    if (driving.data["status"] == 200) {
                      context.pushReplacementNamed("bottomNav");
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(driving.data["message"])));
                  }
                }, builder: (context, driving) {
                  return CustomButton(
                    isLoading: driving is DrivingLicenceLoadingState,
                    onTap: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        drivingLicence();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please fill all fields")));
                      }
                    },
                    text: 'Submit',
                    gradientColors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColorDark
                    ],
                  );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
