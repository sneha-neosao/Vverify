import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/screen/VerificationForms/AddressVerificationForm/List/Blocs/address_list_cubit.dart';
import 'package:v_verify/screen/VerificationForms/AddressVerificationForm/List/Blocs/address_list_state.dart';
import 'package:v_verify/screen/VerificationForms/AddressVerificationForm/List/Models/address_list_model.dart';
import 'package:v_verify/screen/VerificationForms/common/id.dart';
import '../../../../Bottom/bottomNavbar.dart';

class AddressList extends StatefulWidget {
  String Case_uuid;

  AddressList({super.key, required this.Case_uuid,});

  @override
  State<AddressList> createState() => _AddressListState();
}

class _AddressListState extends State<AddressList> {
  @override
  void initState() {
    addressList();
    super.initState();
    print("case uuid on address list : ${widget.Case_uuid}");
  }

  void addressList() {
    String token = context.read<TokenCubit>().state;
    context.read<AddressListCubit>().addressList(
        token: token,
        requestId: int.parse(requestId!),
        serviceRequestId: int.parse(serviceRequestId!));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        selectedIndex = 0; // your bottom nav index
        context.go("/bottomNav"); // navigate to Home
        return false; // prevent default back
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
          child: Column(
            children: [
              Text(
                "Address Verification List",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Theme.of(context).primaryColorDark),
              ),
              const SizedBox(
                height: 16,
              ),
              BlocBuilder<AddressListCubit, AddressDataListState>(
                builder: (context, state) {
                  if (state is AddressDataListLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is AddressDataListEmptyState) {
                    return CustomButton(
                      onTap: () {
                        context.pushNamed(
                          "AddressSaveFormScreen",
                          pathParameters: {'uid': widget.Case_uuid}, // must be non-empty
                        );
                      },
                      text: "Add Address Details",
                      gradientColors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColorDark,
                      ],
                    );
                  } else if (state is AddressDataListSuccessState) {
                    final data = state.addressListDataModel;
                    if (data.data == null || data.data!.isEmpty) {
                      return CustomButton(
                        onTap: () {
                          context.pushNamed(
                            "AddressSaveFormScreen",
                            pathParameters: {'uid': widget.Case_uuid}, // must be non-empty
                          );
                        },
                        text: "Add Address Details",
                        gradientColors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColorDark,
                        ],
                      );
                    }
                    // render list
                  }
                  return const SizedBox();
                },
              ),
              const SizedBox(
                height: 16,
              ),
              CustomButton(
                onTap: () {
                  context.pushNamed(
                    "EducationDocumentUpload",
                    pathParameters: {'uid': widget.Case_uuid}, // must be non-empty
                  );
                },
                text: "Add Documents",
                gradientColors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColorDark,
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              CustomButton(
                onTap: () {
                  selectedIndex = 0;
                  context.go("/bottomNav");
                },
                text: "Home Page",
                gradientColors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColorDark,
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              BlocBuilder<AddressListCubit, AddressDataListState>(
                  builder: (context, addressList) {
                if (addressList is AddressDataListLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (addressList is AddressDataListEmptyState) {
                  return const Center(
                    child: SizedBox.shrink(),
                  );
                } else if (addressList is AddressDataListSuccessState) {
                  AddressListModel data = addressList.addressListDataModel;

                  return Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: data.data!.length,
                        itemBuilder: (context, index) {
                          final rawStatus = data.data![index].vStatus ?? "";
                          String status;

                          if (rawStatus.isEmpty || rawStatus == "-" || rawStatus == "") {
                            status = "pending";
                          } else if (rawStatus == "discrepancy") {
                            status = "discrepancy";
                          } else if (rawStatus == "verified" || rawStatus == "clear") {
                            status = "verified";
                          } else {
                            status = rawStatus; // fallback for other values
                          }

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                                    children: [
                                      ListTile(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        tileColor: Theme.of(context).cardColor,
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                status.toLowerCase() == "verified"
                                                    ? "Verified"
                                                    : status.toLowerCase() == "discrepancy"
                                                    ? "Discrepancy" : "Verification Pending",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                    fontSize: 14,
                                                    color: status.toLowerCase() == "verified"
                                                        ? Colors.green
                                                        :status.toLowerCase() == "discrepancy"
                                                        ? Colors.red
                                                        : Colors.orange
                                                )

                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Text(
                                                  "Person's Current Address",
                                                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                                      color: Theme.of(context).primaryColorDark, fontSize: 16),
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Address Line 1",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                              color: Colors.grey),
                                                    ),
                                                    Text(
                                                      data.data![index].currentAddressLine1?.trim().isEmpty ?? true
                                                          ? "NA"
                                                          : data.data![index].currentAddressLine1!,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Address Line 2",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                              color: Colors.grey),
                                                    ),
                                                    Text(
                                                      data.data![index].currentAddressLine2?.trim().isEmpty ?? true
                                                          ? "NA"
                                                          : data.data![index].currentAddressLine2!,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "City",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                              color: Colors.grey),
                                                    ),
                                                    Text(
                                                      data.data![index].currentAddressCity?.trim().isEmpty ?? true
                                                          ? "NA"
                                                          : data.data![index].currentAddressCity!,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "State",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                          color: Colors.grey),
                                                    ),
                                                    Text(
                                                      data.data![index].currentAddressState?.trim().isEmpty ?? true
                                                          ? "NA"
                                                          : data.data![index].currentAddressState!,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Postal Code",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                          color: Colors.grey),
                                                    ),
                                                    Text(
                                                      data.data![index].currentAddressPostalCode?.trim().isEmpty ?? true
                                                          ? "NA"
                                                          : data.data![index].currentAddressPostalCode!,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Text(
                                                  "Person's Permanent Address",
                                                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                                      color: Theme.of(context).primaryColorDark, fontSize: 16),
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Address Line 1",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                          color: Colors.grey),
                                                    ),
                                                    Text(
                                                      data.data![index].currentAddressLine1?.trim().isEmpty ?? true
                                                          ? "NA"
                                                          : data.data![index].currentAddressLine1!,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Address Line 2",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                          color: Colors.grey),
                                                    ),
                                                    Text(
                                                      data.data![index].currentAddressLine2?.trim().isEmpty ?? true
                                                          ? "NA"
                                                          : data.data![index].currentAddressLine2!,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "City",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                          color: Colors.grey),
                                                    ),
                                                    Text(
                                                      data.data![index].currentAddressCity?.trim().isEmpty ?? true
                                                          ? "NA"
                                                          : data.data![index].currentAddressCity!,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "State",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                          color: Colors.grey),
                                                    ),
                                                    Text(
                                                      data.data![index].currentAddressState?.trim().isEmpty ?? true
                                                          ? "NA"
                                                          : data.data![index].currentAddressState!,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Postal Code",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                          color: Colors.grey),
                                                    ),
                                                    Text(
                                                      data.data![index].currentAddressPostalCode?.trim().isEmpty ?? true
                                                          ? "NA"
                                                          : data.data![index].currentAddressPostalCode!,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Text(
                                                  "Residing Period",
                                                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                                      color: Theme.of(context).primaryColorDark, fontSize: 16),
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Residing From",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                          color: Colors.grey),
                                                    ),
                                                    Text(
                                                      data.data![index].residingFromDate?.trim().isEmpty ?? true
                                                          ? "NA"
                                                          : data.data![index].residingFromDate!,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Residing to",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                          color: Colors.grey),
                                                    ),
                                                    Text(
                                                      data.data![index].residingToDate?.trim().isEmpty ?? true
                                                          ? "NA"
                                                          : data.data![index].residingToDate!,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            print('uid: ${data.data![index].uid}');
                                            print('case_uuid: ${data.data![index].caseUuid}');
                                            print('address_uuid: ${data.data![index].addressUuid}');

                                            if (data.data![index].vStatus ==
                                                "") {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          "Please wait your application under process")));
                                            } else if (data.data![index].vStatus ==
                                                "verified") {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          "Your application already verified")));
                                            } else {
                                              context.pushNamed(
                                                'AddressUpdateFormScreen',
                                                pathParameters: {
                                                  'uid': data.data![index].uid!,
                                                  'case_uuid': data.data![index].caseUuid!,
                                                  'address_uuid': data.data![index].addressUuid!
                                                },
                                              );
                                            }
                                          },
                                          child: Text(
                                            "Update",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ))
                                    ],
                                  ),
                          );
                        }),
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
        ),
      ),
    );
  }
}
