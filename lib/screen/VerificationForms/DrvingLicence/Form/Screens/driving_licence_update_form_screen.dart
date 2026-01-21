import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/screen/VerificationForms/DrvingLicence/Update/Bloc/driving_licence_update_form_cubit.dart';
import 'package:v_verify/screen/VerificationForms/DrvingLicence/Update/Bloc/driving_licence_update_form_state.dart';
import 'package:v_verify/screen/VerificationForms/common/form_widget.dart';
import 'package:v_verify/screen/VerificationForms/common/id.dart';
import '../../ShowData/Bloc/driving_licence_showData_state.dart';
import '../../ShowData/Bloc/drving_licence_shwodata_cubit.dart';
import '../../ShowData/driving_licence_show_data_model.dart';

class DrivingLicenceUpdateFormScreen extends StatefulWidget {
  String uid;

  DrivingLicenceUpdateFormScreen({super.key, required this.uid});

  @override
  State<DrivingLicenceUpdateFormScreen> createState() => _DrivingLicenceUpdateFormScreenState();
}

class _DrivingLicenceUpdateFormScreenState extends State<DrivingLicenceUpdateFormScreen> {
  @override
  void initState() {
    drivingLicenceShowDataLoad();
    super.initState();
  }

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
      lastDate: date18YearsAgo // the latest possible date
    );
    if (picked != null && picked != selectedJoiningDate) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(picked);
     // setState(() {
        selectedJoiningDate = picked;
        dateOfBirthController.text = formattedDate;
     // });
    }
  }

  void drivingLicenceUpdate() {
    String token = context.read<TokenCubit>().state;
    String customerId = context.read<IdCubit>().state;
    context.read<DrivingLicenceUpdateCubit>().drivingLicenceUpdateData(
        customer_id: customerId,
        token: token,
        request_id: requestId!,
        service_request_id: serviceRequestId!,
        driver_licence_number: drivingLicenceController.text.toUpperCase(),
        dob: dateOfBirthController.text);
  }

  void drivingLicenceShowDataLoad() {
    String token = context.read<TokenCubit>().state;
    context
        .read<DrivingLicenceShowDataCubit>()
        .drivingLicenceShowDataLoad(token: token, uid: widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
              child: BlocBuilder<DrivingLicenceShowDataCubit,
                  DrivingLicenceShowDataState>(builder: (context, updateData) {
                if (updateData is DrivingLicenceShowDataLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (updateData is DrivingLicenceShowDataErrorState) {
                  return const Center(
                    child: Text("Something Went Wrong"),
                  );
                } else if (updateData is DrivingLicenceShowDataSuccessState) {
                  DrivingLicenceShowDataModel data =
                      updateData.drivingLicenceShowDataModel;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Driving Licence Verification",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                color: Theme.of(context).primaryColorDark),
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
                          maskFormatter: [drivingMask],
                          controller: drivingLicenceController
                            ..text = data.data!.driverLicenceNumber!,
                          titleText: "Driving Licence",
                          hintText: "Enter Driving Licence",
                          textInputType: TextInputType.text),
                      const SizedBox(
                        height: 16,
                      ),
                      RichText(
                          text: TextSpan(
                              text: " Date of Birth",
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter birth date';
                          }
                          return null;
                        },
                        style: Theme.of(context).textTheme.bodySmall,
                        keyboardType: TextInputType.number,
                        inputFormatters: [maskFormatter],
                        controller: dateOfBirthController
                          ..text = data.data!.dob.toString(),
                        decoration: InputDecoration(
                          hintText: "MM/DD/YYYY",
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
                      BlocConsumer<DrivingLicenceUpdateCubit,
                              DrivingLicenceUpdateState>(
                          listener: (BuildContext context, driving) {
                        if (driving is DrivingLicenceUpdateErrorState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(driving.message)));
                        } else if (driving
                            is DrivingLicenceUpdateSuccessState) {
                          if (driving.data["status"] == 200) {
                            context.pushReplacementNamed("bottomNav");
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(driving.data["message"])));
                        }
                      }, builder: (context, driving) {
                        return CustomButton(
                          isLoading:
                              driving is DrivingLicenceUpdateLoadingState,
                          onTap: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              drivingLicenceUpdate();
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
                  );
                }
                return const Center(
                  child: Text("Error..."),
                );
              })
              // }),
              ),
        ),
      ),
    );
  }
}
