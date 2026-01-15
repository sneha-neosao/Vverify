import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/screen/VerificationForms/common/id.dart';

import '../../../common/pickphoto.dart';
import '../../Save/Bloc/name_address_verification_cubit.dart';
import '../../Update/ShowData/Bloc/nameAddress_showData_cubit.dart';
import '../../Update/ShowData/Bloc/nameAddress_showData_state.dart';
import '../../Update/ShowData/Model/nameAddress_showData_mdoel.dart';
import 'bloc/name_address_doc_update_cubit.dart';
import 'bloc/name_address_doc_update_state.dart';

class NameAddressDocUpdate extends StatefulWidget {
  String uid;

  NameAddressDocUpdate({super.key, required this.uid});

  @override
  State<NameAddressDocUpdate> createState() => _NameAddressDocUpdateState();
}

class _NameAddressDocUpdateState extends State<NameAddressDocUpdate> {
  @override
  void initState() {
    nameAddressDocShowData();
    super.initState();
  }

  void nameAddressDocUpdate() {
    String token = context.read<TokenCubit>().state;
    String customerId = context.read<IdCubit>().state;

    context.read<NameAddressDocUpdateCubit>().nameAddressDocUpdate(
        customerId: customerId,
        token: token,
        requestId: requestId!,
        serviceRequestId: serviceRequestId!,
        aadhaar_front_side:
            context.read<NameAddressAadhaarFrontSideCubit>().state.path.isEmpty
                ? File("")
                : context.read<NameAddressAadhaarFrontSideCubit>().state,
        aadhaar_back_side:
            context.read<NameAddressAadhaarBackSideCubit>().state.path.isEmpty
                ? File("")
                : context.read<NameAddressAadhaarBackSideCubit>().state);
  }

  void nameAddressDocShowData() {
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
              BlocBuilder<NameAddressShowDataCubit, NameAddressShowDataState>(
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
                  const SizedBox(
                    height: 16,
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
                    height: 24,
                  ),
                  BlocConsumer<NameAddressDocUpdateCubit,
                      NameAddressDocUpdateState>(listener: (context, upload) {
                    if (upload is NameAddressDocUpdateSuccessState) {
                      if (upload.data["status"] == 200) {
                        context.pushReplacementNamed("bottomNav");
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(upload.data["message"])));
                    } else if (upload is NameAddressDocUpdateErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(upload.message)));
                    }
                  }, builder: (context, upload) {
                    return CustomButton(
                      isLoading: upload is NameAddressDocUpdateLoadingState,
                      onTap: () {
                        nameAddressDocUpdate();
                      },
                      text: "SUBMIT",
                      gradientColors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColorDark
                      ],
                    );
                  }),
                  const SizedBox(
                    height: 24,
                  ),
                ],
              );
            }
            return const Center(
              child: Text("Error..."),
            );
          }),
        ),
      ),
    );
  }
}
