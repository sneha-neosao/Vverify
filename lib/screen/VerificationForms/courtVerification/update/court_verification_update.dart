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
import 'package:v_verify/screen/VerificationForms/courtVerification/update/ShowData/Model/show_court_data_model.dart';
import 'package:v_verify/screen/VerificationForms/courtVerification/update/ShowData/bloc/show_court_data_state.dart';

import 'Bloc/court_update_cubit.dart';
import 'Bloc/court_update_state.dart';
import 'ShowData/bloc/show_court_data_cubit.dart';

class CourtVerificationUpdate extends StatefulWidget {
  String uid;

  CourtVerificationUpdate({super.key, required this.uid});

  @override
  State<CourtVerificationUpdate> createState() =>
      _CourtVerificationUpdateState();
}

class _CourtVerificationUpdateState extends State<CourtVerificationUpdate> {
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
      String formattedDate = DateFormat('dd/MM/yyyy').format(picked);

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
              DateTime tempDate =
                  DateFormat("yyyy-MM-dd").parse(data.data!.dob.toString());
              String formattedDate = DateFormat('dd/MM/yyyy').format(tempDate);

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
                    "Rejected Reason",
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
                  form_widget(
                      maskFormatter: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                      ],
                      controller: firstNameController
                        ..text = data.data!.firstName!,
                      titleText: "First Name",
                      hintText: "Enter First Name",
                      textInputType: TextInputType.text),
                  form_widget(
                      maskFormatter: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                      ],
                      controller: lastNameController
                        ..text = data.data!.lastName!,
                      titleText: "Last Name",
                      hintText: "Enter List Name",
                      textInputType: TextInputType.text),
                  form_widget(
                      maskFormatter: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                      ],
                      controller: fatherNameController
                        ..text = data.data!.fatherName!,
                      titleText: "Father Name",
                      hintText: "Enter Father Name",
                      textInputType: TextInputType.text),
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
                    style: Theme.of(context).textTheme.bodySmall,
                    keyboardType: TextInputType.number,
                    inputFormatters: [maskFormatter],
                    controller: birthDateController
                      ..text = formattedDate.toString(),
                    decoration: InputDecoration(
                      hintStyle: const TextStyle(color: Colors.grey),
                      hintText: "dd/mm/yyyy",
                      suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => _selectJoiningDate(
                              context) // Open date picker when icon is pressed
                          ),
                    ),
                  ),
                  form_widget(
                      validator: addressValidator,
                      controller: addressController..text = data.data!.address!,
                      titleText: "Address",
                      hintText: "Enter Address",
                      textInputType: TextInputType.text),
                  SizedBox(height: ScreenSize.screenHeight / 6),
                ],
              );
            }
            return const Center(
              child: Text("Error..."),
            );
          })),
        ),
      ),
      bottomSheet: BlocConsumer<CourtUpdateCubit, CourtUpdateState>(
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
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomButton(
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
          ),
        );
      }),
    );
  }
}
