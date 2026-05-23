import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../apiServices/api_services.dart';
import '../../../../../commonComponent/custom_button.dart';
import '../../../../VerificationForms/common/form_widget.dart';
import '../common_widgets.dart';
import '../../../../VerificationForms/AddressVerificationForm/Form/Models/address_save_model.dart';
import '../../../../VerificationForms/AddressVerificationForm/Form/Models/address_show_details_model.dart';
import 'Bloc/ShowDataBloc/address_show_details_bloc.dart';
import 'Bloc/ShowDataBloc/address_show_details_state.dart';
import '../../../../VerificationPending/bloc/pendingDoc_cubit.dart';
import '../../../../../commonComponent/bloc/shared_preferences_cubit.dart';
import '../../../../VerificationForms/AddressVerificationForm/Form/Blocs/address_save_form_bloc/address_save_form_cubit.dart';
import '../../../../VerificationForms/AddressVerificationForm/Form/Blocs/address_save_form_bloc/address_save_from_state.dart';
import '../../../../VerificationForms/AddressVerificationForm/Form/Blocs/address_update_form_bloc/name_address_verification_cubit.dart';
import '../../../../VerificationForms/AddressVerificationForm/Form/Blocs/address_update_form_bloc/name_address_verification_state.dart';
import '../../../../VerificationForms/AddressVerificationForm/List/Blocs/address_list_cubit.dart';
import '../../../../VerificationForms/AddressVerificationForm/List/Blocs/address_list_state.dart';
import '../../../../VerificationForms/VerifyDeatils/Bloc/verify_details_cubit.dart';
import '../../../../VerificationForms/VerifyDeatils/Bloc/verify_details_state.dart';
import '../../../../VerificationForms/AddressVerificationForm/Form/Models/address_update_model.dart';

class AddressVerificationCard extends StatefulWidget {
  final String? serviceTitle;
  final Map<String, dynamic>? serviceData;
  final Map<String, dynamic>? applicantData;

  const AddressVerificationCard({
    super.key,
    this.serviceTitle,
    this.serviceData,
    this.applicantData,
  });

  @override
  State<AddressVerificationCard> createState() =>
      _AddressVerificationCardState();
}

class _AddressVerificationCardState extends State<AddressVerificationCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _line1Controller = TextEditingController();
  final TextEditingController _line2Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();

  late final NameAddressVerificationFormCubit _saveCubit;
  late final NameAddressVerificationUpdateFormCubit _updateCubit;
  late final NameAddressShowDataCubit _showCubit;
  late final AddressListCubit _listCubit;
  late final VerifyDetailsCubit _verifyDetailsCubit;

  bool _isReadOnly = false;
  bool _isEditing = false;
  String? _caseUuid;
  String? _addressUuid;
  String? _artefactImgUrl;
  String? _rejectionReason;

  @override
  void initState() {
    super.initState();
    _saveCubit = NameAddressVerificationFormCubit(ApiService());
    _updateCubit = NameAddressVerificationUpdateFormCubit(ApiService());
    _showCubit = NameAddressShowDataCubit(ApiService());
    _listCubit = AddressListCubit(ApiService());
    _verifyDetailsCubit = VerifyDetailsCubit(ApiService());

    _caseUuid = widget.applicantData?['case_uuid']?.toString() ?? "";

    _fetchAddressList();
    _fetchVerifyDetails();
  }

  @override
  void dispose() {
    _saveCubit.close();
    _updateCubit.close();
    _showCubit.close();
    _listCubit.close();
    _verifyDetailsCubit.close();
    _line1Controller.dispose();
    _line2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  Future<void> _fetchAddressList() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? "";
    final requestId =
        int.tryParse(widget.applicantData?['request_id']?.toString() ?? "");
    final serviceRequestId = int.tryParse(
        widget.serviceData?['service_request_id']?.toString() ?? "");

    debugPrint('Address List token: $token');
    debugPrint('Address List request_id: $requestId');
    debugPrint('Address List service_request_id: $serviceRequestId');

    if (token.isNotEmpty && requestId != null && serviceRequestId != null) {
      _listCubit.addressList(
        token: token,
        requestId: requestId,
        serviceRequestId: serviceRequestId,
      );
    }
  }

  Future<void> _fetchVerifyDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? "";
    final requestId = widget.applicantData?['request_id']?.toString() ?? "";
    if (token.isNotEmpty && requestId.isNotEmpty) {
      _verifyDetailsCubit.verifyDetails(token: token, requestId: requestId);
    }
  }

  Future<void> _fetchShowData({required String uid}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? "";
    if (token.isNotEmpty && uid.isNotEmpty) {
      _showCubit.nameAddressShowData(token: token, uid: uid);
    }
  }

  Future<void> _checkAndFetchDetails({bool force = false}) async {
    _fetchAddressList();
  }

  void _populateData(NameAddressShowDataModel model) {
    if (model.data != null) {
      setState(() {
        _isReadOnly = true;
        _isEditing = false;
        _line1Controller.text = model.data!.current_address_line_1 ?? "";
        _line2Controller.text = model.data!.current_address_line_2 ?? "";
        _cityController.text = model.data!.current_address_city ?? "";
        _stateController.text = model.data!.current_address_state ?? "";
        _pincodeController.text = model.data!.current_address_postal_code ?? "";
        _addressUuid = model.data!.address_uuid ?? "";
        _artefactImgUrl = model.data!.artefact_img;
        _rejectionReason = model.data!.verification_remark;
      });
    }
  }

  void _refreshPendingDocs(BuildContext context) {
    final token = context.read<TokenCubit>().state;
    final customerId = context.read<IdCubit>().state;
    context.read<PendingDocCubit>().getPendingDoc(
          token: token,
          customerId: int.tryParse(customerId) ?? 0,
          page: 1,
          limit: 100,
          isLoading: false,
        );
  }

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? "";
      final customerId = prefs.getString('id') ?? "";

      final requestId = widget.applicantData?['request_id']?.toString() ?? "";
      final serviceRequestId =
          widget.serviceData?['service_request_id']?.toString() ?? "";

      final caseUuid = _caseUuid ?? "";

      debugPrint("case uuid: $caseUuid");

      if (caseUuid.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Case UUID is required to submit address details."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_isEditing) {
        final updateModel = NameAddressVerificationUpdateModel(
          request_id: requestId,
          service_request_id: serviceRequestId,
          current_address_line_1: _line1Controller.text.trim(),
          current_address_line_2: _line2Controller.text.trim(),
          current_city_id: _cityController.text.trim(),
          current_state: _stateController.text.trim(),
          current_pinCode: _pincodeController.text.trim(),
          case_uuid: caseUuid,
          address_uuid: _addressUuid ??
              widget.serviceData?['address_uuid']?.toString() ??
              "",
          data_preference: "form",
          uid: widget.serviceData?['uid']?.toString() ?? "",
        );

        _updateCubit.nameAddressUpdateForm(
          token: token,
          customer_id: customerId,
          nameAddressVerificationUpdateModel: updateModel,
        );
      } else {
        final saveModel = NameAddressVerificationModel(
          request_id: requestId,
          service_request_id: serviceRequestId,
          current_address_line_1: _line1Controller.text.trim(),
          current_address_line_2: _line2Controller.text.trim(),
          current_city_id: _cityController.text.trim(),
          current_state: _stateController.text.trim(),
          current_pinCode: _pincodeController.text.trim(),
          data_preference: "form",
          case_uuid: caseUuid,
        );

        _saveCubit.nameAddressForm(
          token: token,
          customer_id: customerId,
          nameAddressVerificationModel: saveModel,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _saveCubit),
        BlocProvider.value(value: _updateCubit),
        BlocProvider.value(value: _showCubit),
        BlocProvider.value(value: _listCubit),
        BlocProvider.value(value: _verifyDetailsCubit),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AddressListCubit, AddressDataListState>(
            listener: (context, state) {
              if (state is AddressDataListSuccessState) {
                final records = state.addressListDataModel.data;
                if (records != null && records.isNotEmpty) {
                  final uid = records.first.uid ?? "";
                  if (uid.isNotEmpty) {
                    _fetchShowData(uid: uid);
                  }
                }
              }
            },
          ),
          BlocListener<NameAddressVerificationFormCubit,
              NameAddressVerificationState>(
            listener: (context, state) {
              if (state is NameAddressVerificationSuccessState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.data["message"] ??
                        "Address details saved successfully."),
                    backgroundColor: Colors.green,
                  ),
                );
                setState(() {
                  _isReadOnly = true;
                  _isEditing = false;
                });
                _checkAndFetchDetails(force: true);
                _refreshPendingDocs(context);
              } else if (state is NameAddressVerificationErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
          BlocListener<NameAddressVerificationUpdateFormCubit,
              NameAddressVerificationUpdateState>(
            listener: (context, state) {
              if (state is NameAddressVerificationUpdateSuccessState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.data["message"] ??
                        "Address details updated successfully."),
                    backgroundColor: Colors.green,
                  ),
                );
                setState(() {
                  _isReadOnly = true;
                  _isEditing = false;
                });
                _checkAndFetchDetails(force: true);
                _refreshPendingDocs(context);
              } else if (state is NameAddressVerificationUpdateErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
          BlocListener<NameAddressShowDataCubit, NameAddressShowDataState>(
            listener: (context, state) {
              if (state is NameAddressShowDataSSuccessState) {
                _populateData(state.nameAddressShowDataModel);
              } else if (state is NameAddressShowDataSErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
          BlocListener<VerifyDetailsCubit, VerifyDetailsState>(
            listener: (context, state) {
              if (state is VerifyDetailsSuccessState) {
                setState(() {
                  _caseUuid = state.verifyDetailsModel.data?.caseUuid ??
                      state.verifyDetailsModel.data?.uuid;
                });
                debugPrint(
                    "Fetched case uuid via VerifyDetailsCubit: $_caseUuid");
              }
            },
          ),
        ],
        child: BlocBuilder<AddressListCubit, AddressDataListState>(
          builder: (context, listState) {
            return BlocBuilder<NameAddressShowDataCubit,
                NameAddressShowDataState>(
              builder: (context, showState) {
                return BlocBuilder<NameAddressVerificationFormCubit,
                    NameAddressVerificationState>(
                  builder: (context, saveState) {
                    return BlocBuilder<NameAddressVerificationUpdateFormCubit,
                        NameAddressVerificationUpdateState>(
                      builder: (context, updateState) {
                        if (listState is AddressDataListLoadingState ||
                            showState is NameAddressShowDataSLoadingState ||
                            saveState is NameAddressVerificationLoadingState ||
                            updateState
                                is NameAddressVerificationUpdateLoadingState) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        String currentStatus =
                            widget.serviceData?['status']?.toString() ??
                                "PENDING";
                        if (listState is AddressDataListEmptyState) {
                          currentStatus = "Pending";
                        } else if (showState
                            is NameAddressShowDataSSuccessState) {
                          currentStatus = showState
                                  .nameAddressShowDataModel.data?.v_status ??
                              currentStatus;
                        }

                        if (currentStatus.trim().isEmpty ||
                            currentStatus == "-") {
                          currentStatus = "Pending";
                        }

                        final bool isRejected = currentStatus
                                .toLowerCase()
                                .contains("reject") ||
                            currentStatus.toLowerCase().contains("discrepancy");

                        String? rejectionReason = _rejectionReason;
                        if (showState is NameAddressShowDataSSuccessState) {
                          rejectionReason = showState.nameAddressShowDataModel
                                  .data?.verification_remark ??
                              rejectionReason;
                        }

                        return Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.disabled,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        const Icon(Icons.home_outlined,
                                            color: Color(0xFFFFB74D), size: 28),
                                        const SizedBox(width: 12),
                                        Flexible(
                                          child: Text(
                                            widget.serviceTitle ??
                                                "Address Verification",
                                            style: GoogleFonts.outfit(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFF263238),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  StatusChip(
                                    status: (currentStatus.isNotEmpty)
                                        ? '${currentStatus[0].toUpperCase()}${currentStatus.substring(1).toLowerCase()}'
                                        : "Pending",
                                  ),
                                ],
                              ),
                              if (rejectionReason != null &&
                                  rejectionReason.isNotEmpty)
                                Builder(builder: (context) {
                                  final bool isRejectTheme = isRejected;
                                  final Color bgColor = isRejectTheme
                                      ? const Color(0xFFFFEBEE)
                                      : const Color(0xFFE8F5E9);
                                  final Color borderColor = isRejectTheme
                                      ? const Color(0xFFEF9A9A).withOpacity(0.5)
                                      : const Color(0xFFA5D6A7)
                                          .withOpacity(0.5);
                                  final Color textColor = isRejectTheme
                                      ? const Color(0xFFD32F2F)
                                      : const Color(0xFF2E7D32);
                                  final IconData icon = isRejectTheme
                                      ? Icons.info_outline
                                      : Icons.check_circle_outline;

                                  return Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(top: 12),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: bgColor,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: borderColor),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(icon,
                                                color: textColor, size: 18),
                                            const SizedBox(width: 8),
                                            Text(
                                              "Verification Remark",
                                              style: GoogleFonts.outfit(
                                                color: textColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.2,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          rejectionReason!,
                                          style: GoogleFonts.outfit(
                                            color: textColor.withOpacity(0.9),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            height: 1.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              const SizedBox(height: 24),
                              form_widget(
                                controller: _line1Controller,
                                titleText: "Address Line 1",
                                hintText: "Building No, Street Name",
                                textInputType: TextInputType.streetAddress,
                                isReadOnly: _isReadOnly,
                                isRequired: true,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) =>
                                    (value == null || value.trim().isEmpty)
                                        ? "Address Line 1 is required"
                                        : null,
                              ),
                              form_widget(
                                controller: _line2Controller,
                                titleText: "Address Line 2 (Optional)",
                                hintText: "Floor, Area, Landmark",
                                textInputType: TextInputType.streetAddress,
                                isReadOnly: _isReadOnly,
                                isRequired: false,
                              ),
                              form_widget(
                                controller: _cityController,
                                titleText: "City",
                                hintText: "Enter City",
                                textInputType: TextInputType.text,
                                isReadOnly: _isReadOnly,
                                isRequired: true,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) =>
                                    (value == null || value.trim().isEmpty)
                                        ? "City is required"
                                        : null,
                              ),
                              form_widget(
                                controller: _stateController,
                                titleText: "State",
                                hintText: "Enter State",
                                textInputType: TextInputType.text,
                                isReadOnly: _isReadOnly,
                                isRequired: true,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) =>
                                    (value == null || value.trim().isEmpty)
                                        ? "State is required"
                                        : null,
                              ),
                              form_widget(
                                controller: _pincodeController,
                                titleText: "Pincode",
                                hintText: "Enter 6-digit Pincode",
                                textInputType: TextInputType.number,
                                isReadOnly: _isReadOnly,
                                isRequired: true,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "Pincode is required";
                                  }
                                  if (value.trim().length != 6) {
                                    return "Pincode must be 6 digits";
                                  }
                                  return null;
                                },
                              ),
                              if (_artefactImgUrl != null &&
                                  _artefactImgUrl!.isNotEmpty)
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 12.0),
                                    child: InkWell(
                                      onTap: () {
                                        context.pushNamed(
                                          'preview',
                                          extra: _artefactImgUrl,
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF0F4FF),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              color: const Color(0xFFE0E7FF)),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.link,
                                                color: Color(0xFF4F46E5),
                                                size: 18),
                                            const SizedBox(width: 8),
                                            Text(
                                              "View Artefact",
                                              style: GoogleFonts.outfit(
                                                color: const Color(0xFF4F46E5),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 24),
                              if (!_isReadOnly && _isEditing)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    CustomButton(
                                      text: "Cancel",
                                      width: 120,
                                      height: 48,
                                      iconSize: 18,
                                      gradientColors: const [
                                        Color(0xFF9E9E9E),
                                        Color(0xFFBDBDBD),
                                      ],
                                      onTap: () {
                                        setState(() {
                                          _isReadOnly = true;
                                          _isEditing = false;
                                          _formKey.currentState?.reset();
                                        });
                                        if (showState
                                            is NameAddressShowDataSSuccessState) {
                                          _populateData(showState
                                              .nameAddressShowDataModel);
                                        }
                                      },
                                    ),
                                    const SizedBox(width: 16),
                                    CustomButton(
                                      text: "Save",
                                      width: 120,
                                      height: 48,
                                      prefixIcon: Icons.save,
                                      iconSize: 18,
                                      gradientColors: const [
                                        Color(0xFFF4511E),
                                        Color(0xFFFFB74D),
                                      ],
                                      onTap: () => _submitForm(context),
                                    ),
                                  ],
                                )
                              else if (!_isReadOnly ||
                                  (_isReadOnly && isRejected))
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: CustomButton(
                                    text: (_isReadOnly && isRejected)
                                        ? "Update"
                                        : "Submit",
                                    width: 140,
                                    height: 48,
                                    prefixIcon: (_isReadOnly && isRejected
                                        ? Icons.edit
                                        : Icons.send),
                                    iconSize: 18,
                                    gradientColors: const [
                                      Color(0xFFF4511E),
                                      Color(0xFFFFB74D),
                                    ],
                                    onTap: () {
                                      if (_isReadOnly && isRejected) {
                                        setState(() {
                                          _isReadOnly = false;
                                          _isEditing = true;
                                        });
                                      } else {
                                        _submitForm(context);
                                      }
                                    },
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
