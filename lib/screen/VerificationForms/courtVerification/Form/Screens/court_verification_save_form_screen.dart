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
import 'package:v_verify/screen/VerificationForms/common/validator.dart';
import 'package:v_verify/widgets/custom_required_text_field.dart';

import '../../../../../widgets/custom_not_required_text_field.dart';
import '../Blocs/court_verification_save_form_bloc/court_verification_save_form_cubit.dart';
import '../Blocs/court_verification_save_form_bloc/court_verification_save_form_state.dart';

class CourtVerificationSaveFormScreen extends StatefulWidget {
  const CourtVerificationSaveFormScreen({super.key});

  @override
  State<CourtVerificationSaveFormScreen> createState() => _CourtVerificationSaveFormScreenState();
}

class _CourtVerificationSaveFormScreenState extends State<CourtVerificationSaveFormScreen> {
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

    print("Court Verification Payload:");
    print("customer_id: $customerId");
    print("token: $token"); print("request_id: $requestId");
    print("serviceRequestId: $serviceRequestId");
    print("first_name: ${firstNameController.text.trim()}");
    print("last_name: ${lastNameController.text.trim()}");
    print("father_name: ${fatherNameController.text.trim()}");
    print("dob: ${birthDateController.text.trim()}");
    print("address: ${addressController.text.trim()}");

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
      String formattedDate = DateFormat('MM/dd/yyyy').format(picked);

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
                            context.pushReplacementNamed("CourtDocumentUploadScreen");

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
                CustomRequiredTextField(
                    controller: firstNameController,
                    titleText: "First Name",
                    hintText: "Enter First Name",
                    textInputType: TextInputType.text
                ),
                CustomRequiredTextField(
                    controller: lastNameController,
                    titleText: "Last Name",
                    hintText: "Enter Last Name",
                    textInputType: TextInputType.text
                ),
                CustomRequiredTextField(
                    controller: fatherNameController,
                    titleText: "Father Name",
                    hintText: "Enter Father Name",
                    textInputType: TextInputType.text
                ),
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
                    hintText: "mm/dd/yyyy",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectJoiningDate(
                          context), // Open date picker when icon is pressed
                    ),
                  ),
                ),
                CustomRequiredTextField(
                    validator: addressValidator,
                    controller: addressController,
                    titleText: "Address",
                    hintText: "Enter Address",
                    textInputType: TextInputType.text
                ),
                const SizedBox(height: 24),
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
