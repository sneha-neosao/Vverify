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
import 'package:v_verify/screen/VerificationForms/courtVerification/Form/Models/court_verification_show_details_model.dart';
import 'package:v_verify/screen/VerificationForms/courtVerification/Form/Blocs/court_verification_show_details_bloc/court_verification_show_details_state.dart';
import 'package:v_verify/widgets/custom_not_required_text_field.dart';
import 'package:v_verify/widgets/custom_required_text_field.dart';

import '../Blocs/court_verification_update_form_bloc/court_verification_update_form_cubit.dart';
import '../Blocs/court_verification_update_form_bloc/court_verification_update_form_state.dart';
import '../Blocs/court_verification_show_details_bloc/court_verification_show_details_cubit.dart';

class CourtVerificationUpdateFormScreen extends StatefulWidget {
  String uid;

  CourtVerificationUpdateFormScreen({super.key, required this.uid});

  @override
  State<CourtVerificationUpdateFormScreen> createState() =>
      _CourtVerificationUpdateFormScreenState();
}

class _CourtVerificationUpdateFormScreenState extends State<CourtVerificationUpdateFormScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    showDataLoad();
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    fatherNameController.dispose();
    birthDateController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void courtVerificationUpdate() async {
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
    context.read<CourtUpdateCubit>().courtVerificationUpdateForm(
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
      lastDate: DateTime(2101), // the latest possible date
    );
    if (picked != null && picked != selectedJoiningDate) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(picked);

      //setState(() {
      selectedJoiningDate = picked;
      birthDateController.text = formattedDate;
      // });
    }
  }

  var maskFormatter = MaskTextInputFormatter(
      mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});

  void showDataLoad() {
    String token = context.read<TokenCubit>().state;
    print("uid ${widget.uid} ${token}");
    context
        .read<ShowCourtDataCubit>()
        .courtVerificationShowData(token: token, uid: widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 16, right: 16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(child:
              BlocBuilder<ShowCourtDataCubit, ShowCourtDataState>(
                  builder: (context, showData) {
            if (showData is ShowCourtDataLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (showData is ShowCourtDataErrorState) {
              return Center(
                child: Text(showData.message),
              );
            }
            if (showData is ShowCourtDataSuccessState) {
              ShowCourtDataModel data = showData.showCourtDataModel;
              DateTime tempDate = DateFormat("yyyy-MM-dd").parse(data.data!.dob.toString());
              String formattedDate = DateFormat('dd-MM-yyyy').format(tempDate);

              return Column(
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
                  Text(
                    "Court Legal Verification Remark:",
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
                  CustomRequiredTextField(
                      controller: firstNameController..text = data.data!.firstName!,
                      titleText: "First Name",
                      hintText: "Enter First Name",
                      textInputType: TextInputType.text
                  ),
                  CustomRequiredTextField(
                      controller: lastNameController..text = data.data!.lastName!,
                      titleText: "Last Name",
                      hintText: "Enter Last Name",
                      textInputType: TextInputType.text
                  ),
                  CustomNotRequiredTextField(
                      controller: fatherNameController..text = data.data!.fatherName!,
                      titleText: "Father Name",
                      hintText: "Enter Father Name",
                      textInputType: TextInputType.text
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  RichText(
                      text: TextSpan(
                          text: "Date Of Birth",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontWeight: FontWeight.w700),
                          children: [
                      ])),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    style: Theme.of(context).textTheme.bodySmall,
                    keyboardType: TextInputType.number,
                    inputFormatters: [maskFormatter],
                    controller: birthDateController
                      ..text = formattedDate.toString(),
                    decoration: InputDecoration(
                      hintStyle: const TextStyle(color: Colors.grey),
                      hintText: "DD-MM-YYYY",
                      suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => _selectJoiningDate(
                              context) // Open date picker when icon is pressed
                          ),
                    ),
                  ),
                  CustomRequiredTextField(
                      validator: addressValidator,
                      controller: addressController..text = data.data!.address!,
                      titleText: "Address",
                      hintText: "Enter Address",
                      textInputType: TextInputType.text
                  ),
                  const SizedBox(height: 24),
                  BlocConsumer<CourtUpdateCubit, CourtUpdateState>(
                      listener: (context, court) {
                        if (court is CourtUpdateSuccessState) {
                          if (court.data["status"] == 200) {
                            context.pushReplacementNamed("bottomNav");
                          }
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(court.data["message"])));
                        } else if (court is CourtUpdateErrorState) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(court.message)));
                        }
                      }, builder: (context, court) {
                    return CustomButton(
                      isLoading: court is CourtUpdateLoadingState,
                      onTap: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          courtVerificationUpdate();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please Fill All Fields')));
                        }
                      },
                      text: "SUBMIT",
                      gradientColors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColorDark
                      ],
                    );
                  })
                ],
              );
            }
            return const SizedBox.shrink();
          })),
        ),
      ),
    );
  }
}
