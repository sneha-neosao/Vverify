import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/screen/VerificationForms/common/validator.dart';
import 'package:v_verify/widgets/custom_not_required_text_field.dart';
import 'package:v_verify/widgets/custom_required_text_field.dart';
import '../../../commonComponent/bloc/shared_preferences_cubit.dart';
import 'Bloc/verify_request_update_cubit.dart';
import 'Bloc/verify_request_update_state.dart';

class VerifyRequestUpdateNew extends StatefulWidget {
  String uuid;
  String service_title;

  VerifyRequestUpdateNew(
      {super.key, required this.uuid, required this.service_title});

  @override
  State<VerifyRequestUpdateNew> createState() => _VerifyRequestUpdateNewState();
}

class _VerifyRequestUpdateNewState extends State<VerifyRequestUpdateNew> {
  TextEditingController firstnameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController employeeCodeController = TextEditingController();
  TextEditingController joiningController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  String? selectedGender;
  List<String> genderValues = <String>['Male', 'Female', 'Others'];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    firstnameController.dispose();
    middleNameController.dispose();
    lastnameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    employeeCodeController.dispose();
    joiningController.dispose();
    dobController.dispose();
    super.dispose();
  }

  void verifyUpdateData() {
    final String token = context.read<TokenCubit>().state;
    print('''
      UUID: ${widget.uuid}
      Phone: ${phoneController.text.trim()}
      DOB: ${dobController.text}
      First Name: ${firstnameController.text}
      Middle Name: ${middleNameController.text}
      Last Name: ${lastnameController.text}
      Email: ${emailController.text}
      Employee Code: ${employeeCodeController.text}
      Date of Joining: ${joiningController.text}
      Gender: $selectedGender
      ''');

    context.read<VerifyRequestUpdateCubit>().verifyRequestUpdate(
        token: token,
        uuid: widget.uuid,
        phone: phoneController.text.trim(),
        dob: dobController.text,
        firstName: firstnameController.text,
        middleName: middleNameController.text,
        lastName: lastnameController.text,
        email: emailController.text,
        employee_code: employeeCodeController.text,
        date_of_joining: joiningController.text,
        gender: selectedGender ?? "");
  }

  final _formkey = GlobalKey<FormState>();

  var maskFormatter = MaskTextInputFormatter(
      mask: '##-##-####', filter: {"#": RegExp(r'[0-9]')});

  var mobileMaskFormatter = MaskTextInputFormatter(
      mask: '##########', filter: {"#": RegExp(r'[0-9]')});

  var emailFormatter = FilteringTextInputFormatter.allow(
    RegExp(r'[a-zA-Z0-9@._-]'),
  );

  DateTime _selectedDate = DateTime.now();

  // Function to calculate the date 18 years ago
  DateTime _getDate18YearsAgo() {
    DateTime today = DateTime.now();
    return DateTime(today.year - 18, today.month, today.day);
  }

  // Function to show the date picker
  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(), // Max date: today
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);

      //setState(() {
      _selectedDate = pickedDate;
      dobController.text = formattedDate;
      // });
    }
  }

  Future<void> _selectJoiningDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(), // Max date: today
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);

      //setState(() {
      _selectedDate = pickedDate;
      joiningController.text = formattedDate;
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.service_title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Theme.of(context).primaryColorDark),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  "Note: * Indicates required fields.",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.grey),
                ),
                CustomRequiredTextField(
                    controller: firstnameController,
                    titleText: "First Name",
                    hintText: "Enter First Name",
                    textInputType: TextInputType.text),
                // CustomNotRequiredTextField(
                //     controller: middleNameController,
                //     titleText: "Middle Name",
                //     hintText: "Enter Middle Name",
                //     textInputType: TextInputType.text
                // ),
                CustomRequiredTextField(
                    controller: lastnameController,
                    titleText: "Last Name",
                    hintText: "Enter Last Name",
                    textInputType: TextInputType.text),
                CustomNotRequiredTextField(
                    validator: validateMobileNotRequired,
                    controller: phoneController,
                    titleText: "Mobile Number",
                    hintText: "Enter Mobile Number",
                    textInputType: TextInputType.text),
                CustomNotRequiredTextField(
                    validator: validateEmailNotRequired,
                    controller: emailController,
                    titleText: "Email",
                    hintText: "Enter Email",
                    textInputType: TextInputType.text),
                // CustomNotRequiredTextField(
                //     controller: employeeCodeController,
                //     titleText: "Employee Code",
                //     hintText: "Enter Employee Code",
                //     textInputType: TextInputType.text
                // ),
                // const SizedBox(
                //   height: 16,
                // ),
                // RichText(
                //     text: TextSpan(
                //         text: "Date of Joining",
                //         style: Theme.of(context)
                //             .textTheme
                //             .bodySmall!
                //             .copyWith(fontWeight: FontWeight.w700),
                //     )),
                // const SizedBox(
                //   height: 8,
                // ),
                // TextFormField(
                //   readOnly: true,
                //   style: Theme.of(context).textTheme.bodySmall,
                //   keyboardType: TextInputType.number,
                //   inputFormatters: [maskFormatter],
                //   controller: joiningController,
                //   decoration: InputDecoration(
                //     hintText: "DD-MM-YYYY",
                //     suffixIcon: IconButton(
                //       icon: const Icon(Icons.calendar_today),
                //       onPressed: () => _selectJoiningDate(
                //           context), // Open date picker when icon is pressed
                //     ),
                //   ),
                // ),
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
                )),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  readOnly: true,
                  style: Theme.of(context).textTheme.bodySmall,
                  keyboardType: TextInputType.number,
                  inputFormatters: [maskFormatter],
                  controller: dobController,
                  decoration: InputDecoration(
                    hintText: "DD-MM-YYYY",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectBirthDate(
                          context), // Open date picker when icon is pressed
                    ),
                  ),
                ),
                // const SizedBox(
                //   height: 16,
                // ),
                //
                // RichText(
                //     text: TextSpan(
                //         text: "Gender",
                //         style: Theme.of(context)
                //             .textTheme
                //             .bodySmall!
                //             .copyWith(fontWeight: FontWeight.w700),
                //         )),
                // const SizedBox(
                //   height: 4,
                // ),
                // SizedBox(
                //   height: 54,
                //   child: Theme(
                //     data: Theme.of(context).copyWith( highlightColor: Colors.black, ),
                //     child: DropdownButtonFormField<String>(
                //       value: genderValues.contains(selectedGender) ? selectedGender : null,
                //       hint: Text(
                //         "Select Gender",
                //         style: Theme.of(context)
                //             .textTheme
                //             .bodySmall!
                //             .copyWith(color: Colors.grey),
                //       ),
                //       onChanged: (String? value) {
                //         setState(() {
                //           selectedGender = value!.toLowerCase();
                //         });
                //       },
                //       items: genderValues.map((String value) {
                //         return DropdownMenuItem<String>(
                //           value: value,
                //           child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
                //         );
                //       }).toList(),
                //       dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                //       decoration: InputDecoration(
                //         contentPadding:
                //         const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
                //         enabledBorder: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(8),
                //           borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                //         ),
                //         focusedBorder: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(8),
                //           borderSide:
                //           BorderSide(color: Theme.of(context).canvasColor, width: 1.0),
                //         ),
                //         border: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(8),
                //           borderSide: BorderSide(color: Theme.of(context).canvasColor, width: 1.0),
                //         ),
                //         filled: true,
                //         fillColor: Theme.of(context).scaffoldBackgroundColor,
                //       ),
                //     ),
                //   ),
                // ),
                const SizedBox(
                  height: 24,
                ),
                BlocConsumer<VerifyRequestUpdateCubit,
                        VerifyRequestUpdateState>(
                    listener: (context, verifyUpdate) {
                  if (verifyUpdate is VerifyRequestUpdateSuccessState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(verifyUpdate.data["message"])));
                    if (verifyUpdate.data["status"] == 200) {
                      context.pushReplacementNamed("bottomNav");
                    }
                  } else if (verifyUpdate is VerifyRequestUpdateErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(verifyUpdate.message)));
                  }
                }, builder: (context, verifyUpdate) {
                  return CustomButton(
                    isLoading: verifyUpdate is VerifyRequestUpdateLoadingState,
                    onTap: () {
                      if (_formkey.currentState?.validate() ?? false) {
                        verifyUpdateData();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please fill all fields")));
                      }
                    },
                    text: "SAVE",
                    gradientColors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColorDark,
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
