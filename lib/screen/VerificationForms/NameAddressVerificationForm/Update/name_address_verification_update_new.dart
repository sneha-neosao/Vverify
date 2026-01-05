import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/screen/VerificationForms/NameAddressVerificationForm/Update/model/name_address_verification_model.dart';
import 'package:v_verify/screen/VerificationForms/common/id.dart';
import 'package:v_verify/screen/VerificationForms/common/pickphoto.dart';
import 'package:v_verify/screen/VerificationForms/common/validator.dart';

import '../../common/form_widget.dart';
import '../Save/Bloc/name_address_verification_cubit.dart';
import 'Bloc/name_address_verification_cubit.dart';
import 'Bloc/name_address_verification_state.dart';
import 'ShowData/Bloc/nameAddress_showData_cubit.dart';
import 'ShowData/Bloc/nameAddress_showData_state.dart';
import 'ShowData/Model/nameAddress_showData_mdoel.dart';

class NameAddressVerificationUpdateNew extends StatefulWidget {
  String uid;

  NameAddressVerificationUpdateNew({super.key, required this.uid});

  @override
  State<NameAddressVerificationUpdateNew> createState() =>
      _NameAddressVerificationUpdateNewState();
}

class _NameAddressVerificationUpdateNewState extends State<NameAddressVerificationUpdateNew> {
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
    showDataLoad();
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

  void nameAddressUpdate() {
    print(requestId);
    print(serviceRequestId);
    String token = context.read<TokenCubit>().state;
    String customerId = context.read<IdCubit>().state;
    context
        .read<NameAddressVerificationUpdateFormCubit>()
        .nameAddressUpdateForm(
        customer_id: customerId,
        token: token,
        nameAddressVerificationUpdateModel:
        NameAddressVerificationUpdateModel(
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

  void showDataLoad() {
    String token = context.read<TokenCubit>().state;
    context
        .read<NameAddressShowDataCubit>()
        .nameAddressShowData(token: token, uid: widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
          child:
          BlocConsumer<NameAddressShowDataCubit, NameAddressShowDataState>(
            listener: (context, showData){
              if (showData is NameAddressShowDataSSuccessState) {
                NameAddressShowDataModel data = showData.nameAddressShowDataModel;

                currentLine1AddressController.text = data.data!.current_address_line_1 ?? "";
                currentLine2AddressController.text = data.data!.current_address_line_2 ?? "";
                currentCityAddressController.text = data.data!.current_city_id ?? "";
                currentStateAddressController.text = data.data!.current_state ?? "";
                currentPinCodeController.text = data.data!.current_pinCode ?? "";
                permanentLine1AddressController.text = data.data!.permanent_address_line_1 ?? "";
                permanentLine2AddressController.text = data.data!.permanent_address_line_2 ?? "";
                permanentCityAddressController.text = data.data!.permanent_city_id ?? "";
                permanentStateAddressController.text = data.data!.permanent_state ?? "";
                permanentPinCodeController.text = data.data!.permanent_pinCode ?? "";
              }
            },
              builder: (context, showData) {
                if (showData is NameAddressShowDataSLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (showData is NameAddressShowDataSErrorState) {
                  return Center(
                    child: Text(showData.message),
                  );
                } else if (showData is NameAddressShowDataSSuccessState) {
                  NameAddressShowDataModel data = showData.nameAddressShowDataModel;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Full Name & Address Verification",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Theme.of(context).primaryColorDark),
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
                          textInputType: TextInputType.text
                      ),
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
                      const SizedBox(
                        height: 24,
                      ),
                      BlocConsumer<NameAddressVerificationUpdateFormCubit,
                          NameAddressVerificationUpdateState>(
                          listener: (context, updateData) {
                            if (updateData
                            is NameAddressVerificationUpdateSuccessState) {
                              if (updateData.data["status"] == 200) {
                                context.pushReplacementNamed("bottomNav");
                                context
                                    .read<NameAddressAadhaarFrontSideCubit>()
                                    .clearImage();
                                context
                                    .read<NameAddressAadhaarBackSideCubit>()
                                    .clearImage();
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(updateData.data["message"])));
                                // pickImageClear();
                              }
                            } else if (updateData
                            is NameAddressVerificationUpdateSuccessState) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(updateData.data["message"])));
                            }
                          }, builder: (context, updateData) {
                        return CustomButton(
                          isLoading: updateData
                          is NameAddressVerificationUpdateLoadingState,
                          onTap: () {
                            nameAddressUpdate();
                          },
                          text: "Update",
                          gradientColors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).primaryColorDark
                          ],
                        );
                      }),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              }),
        ),
      ),
    );
  }
}
