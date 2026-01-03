import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/commonComponent/screen_size.dart';
import 'package:v_verify/screen/VerificationForms/common/form_widget.dart';
import 'package:v_verify/screen/VerificationForms/common/id.dart';

import 'Bloc/court_verification_cubit.dart';
import 'Bloc/court_verification_state.dart';

class CourtVerification extends StatefulWidget {
  const CourtVerification({super.key});

  @override
  State<CourtVerification> createState() => _CourtVerificationState();
}

class _CourtVerificationState extends State<CourtVerification> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    fatherNameController.dispose();
    birthDateController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void courtVerification() async {
    String token = context.read<TokenCubit>().state;
    String customerId = context.read<IdCubit>().state;
    context.read<CourtVerificationCubit>().courtVerificationForm(
        customer_id: customerId,
        token: token,
        request_id: requestId!,
        serviceRequestId: serviceRequestId!,
        first_name: firstNameController.text.trim(),
        last_name: lastNameController.text.trim(),
        father_name: fatherNameController.text.trim(),
        dob: birthDateController.text.trim(),
        address: addressController.text.trim());
  }

  final _formKey = GlobalKey<FormState>();
  DateTime selectedJoiningDate = DateTime.now();

  // Function to call the date picker
  Future<void> _selectJoiningDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedJoiningDate, // initial date
      firstDate: DateTime(1900), // the earliest possible date
      lastDate: DateTime.now(), // the latest possible date
    );
    if (picked != null && picked != selectedJoiningDate) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(picked);

      setState(() {
        selectedJoiningDate = picked;
        birthDateController.text = formattedDate;
      });
    }
  }

  var maskFormatter = MaskTextInputFormatter(
      mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 16, right: 16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Court Legal Verification",
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
                  create: (_) => FormUploadCourtCubit(),
                  child: BlocBuilder<FormUploadCourtCubit, bool>(
                      builder: (context, frmUpload) {
                    return Column(
                      children: [
                        ListTile(
                          splashColor: Colors.transparent,
                          onTap: () {
                            context
                                .read<FormUploadCourtCubit>()
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
                            context.pushReplacementNamed("CourtDocUpload");

                            context
                                .read<FormUploadCourtCubit>()
                                .formUploadYesNo(yesNo: false);

                            context
                                .read<FormUploadCourtCubit>()
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
                    maskFormatter: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                    ],
                    controller: firstNameController,
                    titleText: "First Name",
                    hintText: "Enter First Name",
                    textInputType: TextInputType.text),
                form_widget(
                    maskFormatter: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                    ],
                    controller: lastNameController,
                    titleText: "Last Name",
                    hintText: "Enter List Name",
                    textInputType: TextInputType.text),
                form_widget(
                    maskFormatter: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                    ],
                    controller: fatherNameController,
                    titleText: "Father Name",
                    hintText: "Enter Father Name",
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
                  style: Theme.of(context).textTheme.bodySmall,
                  keyboardType: TextInputType.number,
                  inputFormatters: [maskFormatter],
                  controller: birthDateController,
                  decoration: InputDecoration(
                    hintText: "dd/mm/yyyy",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectJoiningDate(
                          context), // Open date picker when icon is pressed
                    ),
                  ),
                ),
                form_widget(
                    // validator: addressValidator,
                    controller: addressController,
                    titleText: "Address",
                    hintText: "Enter Address",
                    textInputType: TextInputType.text),
                SizedBox(height: ScreenSize.screenHeight / 10),
                BlocConsumer<CourtVerificationCubit, CourtVerificationState>(
                    listener: (context, court) {
                  if (court is CourtVerificationErrorState) {
                  } else if (court is CourtVerificationSuccessState) {
                    if (court.data["status"] == 200) {
                      context.pushReplacementNamed("bottomNav");
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(court.data["message"])));
                  } else if (court is CourtVerificationErrorState) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(court.message)));
                  }
                }, builder: (context, court) {
                  return CustomButton(
                    isLoading: court is CourtVerificationLoadingState,
                    onTap: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        courtVerification();
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
                const SizedBox(
                  height: 16,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
