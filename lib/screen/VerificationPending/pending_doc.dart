import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:v_verify/screen/VerificationForms/common/url.dart';
import '../../commonComponent/bloc/shared_preferences_cubit.dart';
import '../../commonComponent/screen_size.dart';
import '../VerificationForms/common/id.dart';
import 'bloc/pendingDoc_cubit.dart';
import 'bloc/pendingDoc_state.dart';
import 'model/pendingDoc_model.dart';

class PendingDoc extends StatefulWidget {
  const PendingDoc({super.key});

  @override
  State<PendingDoc> createState() => _PendingDocState();
}

void checkCase({required String title, String? uuid,required BuildContext context}) {
  switch (title) {
    case "Police Verification":
      context.pushNamed("nonMumbaiForm");
      break;
    case "Aadhaar Verification":
      context.pushNamed("AadhaarGetOtp");
      break;
    case "Reference Check":
      context.pushNamed("ReferenceForm");
      break;
    case "Fullname and address verification":
      // context.pushNamed("NameAddressVerificationForm");
      context.pushNamed("NameAddressVerificationFormNew");
      break;
    case "Employment Verification":
      context.pushNamed("EmployDataList");
      break;
    case "Education Verification":
      context.pushNamed("EducationList",pathParameters: {'uid': uuid!},
      );
      break;
    case "Driving License":
      context.pushNamed("DrivingLicence");
      break;
    case "GST CIN PAN Verification":
      context.pushNamed("GstPanCinScreen");
      break;
    case "Court Legal Verification":
      context.pushNamed("CourtVerification");
      break;
  }
}

void secondCheckCase(
    {required PendingDocModel data,
    required BuildContext context,
    required int index,
    required int servicesIndex}) {
  switch (data.data![index].services![servicesIndex].serviceTitle) {
    case "Police Verification":
      data.data![index].services![servicesIndex].policeEntryType == 1
          ? data.data![index].services![servicesIndex].dataPreference == "form"
              ? context.pushNamed("MumbaiPoliceVerificationUpdateForm1",
                  pathParameters: {
                      'uid': data.data![index].services![servicesIndex].uid
                          .toString()
                    })
              : context.pushNamed("MumbaiDocUpdate", pathParameters: {
                  'uid':
                      data.data![index].services![servicesIndex].uid.toString()
                })
          : data.data![index].services![servicesIndex].dataPreference == "form"
              ? context.pushNamed("NonMumbaiPoliceVerificationForm1Update",
                  pathParameters: {
                      'uid': data.data![index].services![servicesIndex].uid
                          .toString()
                    })
              : context.pushNamed("UpdateDocumentsNonMumbai", pathParameters: {
                  'uid':
                      data.data![index].services![servicesIndex].uid.toString()
                });
      break;
    case "Aadhaar Verification":
      context.pushNamed("AadhaarGetOtp");
      break;
    case "Reference Check":
      data.data![index].services![servicesIndex].dataPreference == "form"
          ? context.pushNamed("ReferenceFormUpdate", pathParameters: {
              'uid': data.data![index].services![servicesIndex].uid.toString()
            })
          : context.pushNamed("ReferenceUpdateDoc", pathParameters: {
              'uid': data.data![index].services![servicesIndex].uid.toString()
            });
      break;
    case "Fullname and address verification":
      data.data![index].services![servicesIndex].dataPreference == "form"
          ? context.pushNamed("NameAddressVerificationUpdateNew", pathParameters: {
              'uid': data.data![index].services![servicesIndex].uid.toString()
            })
          : context.pushNamed("NameAddressDocUpdate", pathParameters: {
              'uid': data.data![index].services![servicesIndex].uid.toString()
            });
      break;
    // case "Employment Verification":
    //   context.pushNamed("EmployDataList");
    //   break;
    // case "Education Verification":
    //   context.pushNamed("EducationList");
    //   break;
    case "Driving License":
      data.data![index].services![servicesIndex].dataPreference == "form"
          ? context.pushNamed("DrivingLicenceUpdate", pathParameters: {
              "uid": data.data![index].services![servicesIndex].uid.toString()
            })
          : context.pushNamed("DrivingDocUpdate", pathParameters: {
              "uid": data.data![index].services![servicesIndex].uid.toString()
            });
      break;
    case "GST CIN PAN Verification":
      data.data![index].services![servicesIndex].dataPreference == "form"
          ? context.pushNamed("GstPanCinUpdateScreen", pathParameters: {
              "uid": data.data![index].services![servicesIndex].uid.toString()
            })
          : context.pushNamed("GstPanCinDocUpdate", pathParameters: {
              "uid": data.data![index].services![servicesIndex].uid.toString()
            });
      break;

    case "Court Legal Verification":
      data.data![index].services![servicesIndex].dataPreference == "form"
          ? context.pushNamed("CourtVerificationUpdate", pathParameters: {
              "uid": data.data![index].services![servicesIndex].uid.toString()
            })
          : context.pushNamed("CourtDocUpdate", pathParameters: {
              "uid": data.data![index].services![servicesIndex].uid.toString()
            });
      break;
  }
}

class _PendingDocState extends State<PendingDoc> {
  @override
  void initState() {
    pendingDoc();
    super.initState();
  }


  void pendingDoc() {
    final String token = context.read<TokenCubit>().state;

    final String id = context.read<IdCubit>().state;

    context.read<PendingDocCubit>().getPendingDoc(
        token: token, customerId: int.parse(id), page: 1, limit: 100);
  }

  @override
  Widget build(BuildContext context) {
    const PageStorageKey<String> listViewKey =
        PageStorageKey<String>('listViewKey');
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 16, right: 16),
        child: RefreshIndicator(
          onRefresh: () {
            final String token = context.read<TokenCubit>().state;

            final String id = context.read<IdCubit>().state;

            return context.read<PendingDocCubit>().getPendingDoc(
                token: token, customerId: int.parse(id), page: 1, limit: 100);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("VVerification Pending",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 28)),
              const SizedBox(
                height: 24,
              ),
              BlocBuilder<PendingDocCubit, PendingDocState>(
                builder: (context, pendingDoc) {
                  if (pendingDoc is PendingDocLoadingState) {
                    return Expanded(
                      child: ListView.builder(
                          key: listViewKey,
                          shrinkWrap: true,
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Shimmer.fromColors(
                                  baseColor: Colors.grey[400]!,
                                  highlightColor: Colors.grey[50]!,
                                  child: Container(
                                      height: ScreenSize.screenHeight / 8,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12))),
                                ),
                                const SizedBox(
                                  height: 8,
                                )
                              ],
                            );
                          }),
                    );
                  } else if (pendingDoc is PendingDocErrorState) {
                    return Center(
                      child:
                          Text(textAlign: TextAlign.center, pendingDoc.message),
                    );
                  } else if (pendingDoc is PendingDocSuccessState) {
                    PendingDocModel data = pendingDoc.pendingDocModel;
                    return BlocBuilder<IsPressedCubit, int>(
                        builder: (context, isPressed) {
                      return Expanded(
                        child: ListView.builder(
                            itemCount: data.data!.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                color: Theme.of(context).cardColor,
                                child: Column(
                                  children: [
                                    ListTile(
                                      onTap: () {
                                        context
                                            .read<IsPressedCubit>()
                                            .isPressed(index);
                                      },
                                      tileColor:
                                          Theme.of(context).primaryColorDark,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              topRight: Radius.circular(8))),
                                      title: data.data![index].name == null
                                          ? Text(data
                                              .data![index].entity!.entityName.toString())
                                          : Text(data.data![index].name
                                              .toString()),
                                      trailing: Icon(isPressed == index
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down),
                                    ),
                                    isPressed == index
                                        ? ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: data
                                                .data![index].services!.length,
                                            itemBuilder: (BuildContext context,
                                                int servicesIndex) {
                                              return Column(
                                                children: [
                                                  ListTile(
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 8,
                                                            vertical: 4),
                                                    onTap: () {
                                                      serviceRequestId = data
                                                          .data![index]
                                                          .services![
                                                              servicesIndex]
                                                          .serviceRequestId
                                                          .toString();

                                                      requestId = data
                                                          .data![index]
                                                          .requestId
                                                          .toString();

                                                      if (data.data![index]
                                                              .detailsUpdated ==
                                                          0) {
                                                        // context.pushNamed(
                                                        //     "verifyRequestUpdate",
                                                        //     pathParameters: {
                                                        //       'uuid': data
                                                        //           .data![index]
                                                        //           .uuid
                                                        //           .toString()
                                                        //     });
                                                        context.pushNamed(
                                                            "verifyRequestUpdateNew",
                                                            pathParameters: {
                                                              'uuid': data
                                                                  .data![index]
                                                                  .uuid
                                                                  .toString()
                                                            });
                                                      } else if (data
                                                              .data![index]
                                                              .detailsUpdated ==
                                                          1) {
                                                        if (data
                                                                .data![index]
                                                                .services![
                                                                    servicesIndex]
                                                                .status ==
                                                            "pending") {
                                                          if (data
                                                                  .data![index]
                                                                  .services![
                                                                      servicesIndex]
                                                                  .serviceTitle ==
                                                              "Employment Verification") {
                                                            context.pushNamed(
                                                                "EmployDataList");
                                                          } else if (data.data![index].services![servicesIndex].serviceTitle =="Education Verification") {
                                                            print("case_uuid at pending doc: ${data.data![index].case_uuid.toString()}");
                                                            context.pushNamed("EducationList",pathParameters: {
                                                            'uid': data.data![index].case_uuid.toString()
                                                            });
                                                          } else {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    const SnackBar(
                                                                        content:
                                                                            Text("Please wait your application under process")));
                                                          }
                                                        } else if (data
                                                                .data![index]
                                                                .services![
                                                                    servicesIndex]
                                                                .status ==
                                                            "verified") {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  const SnackBar(
                                                                      content: Text(
                                                                          "Your application already verified")));
                                                        } else if (data
                                                                .data![index]
                                                                .services![
                                                                    servicesIndex]
                                                                .status ==
                                                            "rejected") {
                                                          secondCheckCase(
                                                              data: data,
                                                              context: context,
                                                              index: index,
                                                              servicesIndex:
                                                                  servicesIndex);
                                                        } else if (data
                                                                .data![index]
                                                                .services![
                                                                    servicesIndex]
                                                                .status ==
                                                            "failed") {
                                                          secondCheckCase(
                                                              data: data,
                                                              context: context,
                                                              index: index,
                                                              servicesIndex:
                                                                  servicesIndex);
                                                        } else {
                                                          checkCase(
                                                              title: data
                                                                  .data![index]
                                                                  .services![
                                                                      servicesIndex]
                                                                  .serviceTitle
                                                                  .toString(),
                                                              context: context);
                                                        }
                                                      }
                                                    },
                                                    leading: Image.network(
                                                      "$imageUrl${data.data![index].services![servicesIndex].serviceIcon}",
                                                      width: 30,
                                                    ),
                                                    title: Text(
                                                      '${data.data![index].services![servicesIndex].serviceTitle}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall,
                                                    ),
                                                    subtitle: Row(
                                                      children: [
                                                        data
                                                                        .data![
                                                                            index]
                                                                        .services![
                                                                            servicesIndex]
                                                                        .status ==
                                                                    "failed" ||
                                                                data
                                                                        .data![
                                                                            index]
                                                                        .services![
                                                                            servicesIndex]
                                                                        .status ==
                                                                    "rejected"
                                                            ? const Icon(
                                                                Icons.info,
                                                                color:
                                                                    Colors.red,
                                                                size: 18,
                                                              )
                                                            : data
                                                                        .data![
                                                                            index]
                                                                        .services![
                                                                            servicesIndex]
                                                                        .status ==
                                                                    "verified"
                                                                ? const Icon(
                                                                    Icons
                                                                        .verified,
                                                                    color: Colors
                                                                        .green,
                                                                    size: 18,
                                                                  )
                                                                : data.data![index].services![servicesIndex]
                                                                            .status ==
                                                                        "NA"
                                                                    ? Icon(
                                                                        Icons
                                                                            .person_add,
                                                                        color: Theme.of(context)
                                                                            .primaryColorDark,
                                                                        size:
                                                                            18,
                                                                      )
                                                                    : Icon(
                                                                        Icons
                                                                            .schedule,
                                                                        color: Theme.of(context)
                                                                            .primaryColorDark,
                                                                        size:
                                                                            18,
                                                                      ),
                                                        const SizedBox(
                                                          width: 4,
                                                        ),
                                                        Text(
                                                            '${data.data![index].services![servicesIndex].status}',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodySmall!
                                                                .copyWith(
                                                                    fontSize:
                                                                        14,
                                                                    color: data.data![index].services![servicesIndex].status ==
                                                                                "failed" ||
                                                                            data.data![index].services![servicesIndex].status ==
                                                                                "rejected"
                                                                        ? Colors
                                                                            .red
                                                                        : data.data![index].services![servicesIndex].status ==
                                                                                "verified"
                                                                            ? Colors.green
                                                                            : Theme.of(context).primaryColorDark))
                                                      ],
                                                    ),
                                                    trailing: data
                                                                    .data![
                                                                        index]
                                                                    .services![
                                                                        servicesIndex]
                                                                    .status ==
                                                                "failed" ||
                                                            data
                                                                    .data![
                                                                        index]
                                                                    .services![
                                                                        servicesIndex]
                                                                    .status ==
                                                                "rejected"
                                                        ? TextButton(
                                                            onPressed: null,
                                                            child: Text(
                                                              "Update",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodySmall,
                                                            ))
                                                        : data.data![index]
                                                                        .detailsUpdated ==
                                                                    1 &&
                                                                data
                                                                        .data![
                                                                            index]
                                                                        .services![
                                                                            servicesIndex]
                                                                        .status ==
                                                                    "NA"
                                                            ? TextButton(
                                                                onPressed: null,
                                                                child: Text(
                                                                  "Verify Now >",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodySmall,
                                                                ))
                                                            : Icon(
                                                                Icons
                                                                    .arrow_forward_ios,
                                                                size: 15,
                                                                color: Theme.of(
                                                                        context)
                                                                    .iconTheme
                                                                    .color,
                                                              ),
                                                  ),
                                                  data.data![index].services!
                                                              .length ==
                                                          1
                                                      ? const SizedBox()
                                                      : const Divider(),
                                                ],
                                              );
                                            })
                                        : const SizedBox()
                                  ],
                                ),
                              );
                            }),
                      );
                    });
                  }
                  return const Center(
                    child: Text("something went"),
                  );
                },
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
