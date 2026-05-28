import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:sizer/sizer.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/commonComponent/screen_size.dart';
import 'package:v_verify/router/router.dart';
import 'package:v_verify/screen/Complete-Profile/Bloc/register_cubit.dart';
import 'package:v_verify/screen/EditProfile/bloc/editProfile_cubit.dart';
import 'package:v_verify/screen/Home%20screen/bloc/home_screnn_cubit.dart';
import 'package:v_verify/screen/Login-Screen/bloc/login_cubit.dart';
import 'package:v_verify/screen/OTP_Verify-Screen/bloc/otpVerify_cubit.dart';
import 'package:v_verify/screen/Order%20History/bloc/order_history_cubit.dart';
import 'package:v_verify/screen/ProfileScreen/bloc/profile_cubit.dart';
import 'package:v_verify/screen/ProfileScreen/bloc/sign_out_cubit.dart';
import 'package:v_verify/screen/PushNotification/Bloc/push_notification_cubit.dart';
import 'package:v_verify/screen/PushNotification/push_notification.dart';
import 'package:v_verify/screen/ServicesAndPrice/Blocs/apply_coupon_bloc/apply_coupon_cubit.dart';
import 'package:v_verify/screen/ServicesAndPrice/Blocs/chechout_status_checking_bloc/checkout_status_checking_cubit.dart';
import 'package:v_verify/screen/ServicesAndPrice/Blocs/service_prices_bloc/service_prices_cubit.dart';
import 'package:v_verify/screen/ServicesAndPrice/Blocs/checkout_bloc/checkout_cubit.dart';
import 'package:v_verify/screen/ServicesAndPrice/Blocs/all_entities_bloc/all_entities_cubit.dart';
import 'package:v_verify/screen/AllFormList/FormList/widgets/AddressVerification/Bloc/ShowDataBloc/address_show_details_bloc.dart';
import 'package:v_verify/screen/AllFormList/FormList/widgets/DrivingLicense/Bloc/driving_licence_save_form_bloc/driving_licence_save_form_bloc.dart';
import 'package:v_verify/screen/AllFormList/FormList/widgets/DrivingLicense/Bloc/driving_licence_show_details_bloc/driving_licence_show_details_cubit.dart';

import 'package:v_verify/screen/AllFormList/FormList/widgets/EducationVerification/Bloc/education_show_details_bloc/education_show_details_cubit.dart';
import 'package:v_verify/screen/AllFormList/FormList/widgets/EducationVerification/Bloc/education_update_form_bloc/education_update_form_cubit.dart';
import 'package:v_verify/screen/AllFormList/FormList/widgets/EmploymentVerification/Bloc/Update/employment_update_form_cubit.dart';
import 'package:v_verify/screen/AllFormList/FormList/widgets/EmploymentVerification/Bloc/List/employment_list_cubit.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/Common/PoliceStationId/police_station_id_bloc/police_station_id_cubit.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/Mumbai/Form/Blocs/mumbai_police_verification_update_bloc/mumbai_police_update_form_state.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/Mumbai/Form/Blocs/mumbai_police_verification_show_details_bloc/mumbai_police_show_details_cubit.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/Mumbai/Document/Blocs/mumbai_police_document_upload_bloc/mumbai_document_upload_cubit.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/Mumbai/Form/Blocs/mumbai_police_verification_save_bloc/mumbai_police_save_form_cubit.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/Mumbai/Document/Blocs/mumbai_police_document_update_bloc/mumbai_documnet_update_cubit.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/Mumbai/Document/Blocs/mumbai_police_document_show_details_bloc/mumbai_document_show_details_cubit.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/NonMumbai/Form/Blocs/non_mumbai_save_form_bloc/non_mumbai_save_form_cubit.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/NonMumbai/Form/Blocs/non_mumbai_update_form_bloc/non_mumbai_update_form_cubit.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/NonMumbai/Form/Blocs/non_mumbai_show_details_bloc/non_mumbai_show_details_cubit.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/NonMumbai/Document/Blocs/non_mumbai_document_update_bloc/non_mumbai_document_update_cubit.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/NonMumbai/Document/Blocs/non_mumbai_document_show_details_bloc/non_mumbai_show_details_cubit.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/NonMumbai/Document/Blocs/non_mumbai_document_upload_bloc/non_mumbai_document_upload_cubit.dart';
import 'package:v_verify/screen/VerificationForms/VerifyDeatils/Bloc/verify_details_cubit.dart';
import 'package:v_verify/screen/VerificationPending/bloc/pendingDoc_cubit.dart';
import 'package:v_verify/screen/VerificationPending/Pagination/DashBoard/bloc/dashboard_count_bloc.dart';
import 'package:v_verify/screen/VerificationPending/Pagination/DashBoard/bloc/dashboard_entities_cubit.dart';
import 'package:v_verify/screen/VerificationPending/Pagination/DashBoard/bloc/entity_services_cubit.dart';
import 'package:v_verify/screen/VerificationPending/Pagination/DashBoard/bloc/pending_doc_navigation_cubit.dart';

import 'package:v_verify/screen/VerificationPending/bloc/verify_report_bloc/verify_request_report_cubit.dart';
import 'package:v_verify/screen/VerificationPending/bloc/verify_request_edit_cubit.dart';
import 'package:v_verify/screen/VerificationPending/verifyRequestUpdate/Bloc/verify_request_update_cubit.dart';
import 'package:v_verify/theme/theme_cubit.dart';
import 'package:v_verify/theme/theme_data.dart';
import 'firebase_options.dart';
import 'screen/AllFormList/FormList/widgets/EducationVerification/Bloc/education_save_form_bloc/education_save_form_cubit.dart';
import 'screen/AllFormList/FormList/widgets/EmploymentVerification/Bloc/Save/employment_save_form_cubit.dart';
import 'screen/AllFormList/FormList/widgets/EmploymentVerification/Bloc/Show/employ_show_details_cubit.dart';

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotification();
  FirebaseApi().localNotification();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarIconBrightness:

            // isDarkMode
            //     ?
            Brightness.light
        //: Brightness.dark, // For white status bar icons
        ));
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
        BlocProvider<LoginCubit>(create: (_) => LoginCubit(ApiService())),
        BlocProvider<OtpVerifyCubit>(
            create: (_) => OtpVerifyCubit(ApiService())),
        BlocProvider<RegisterCubit>(create: (_) => RegisterCubit(ApiService())),
        BlocProvider<ProfileCubit>(create: (_) => ProfileCubit(ApiService())),
        BlocProvider<SignOutCubit>(create: (_) => SignOutCubit(ApiService())),
        BlocProvider<ServicePriceCubit>(
            create: (_) => ServicePriceCubit(ApiService())),
        BlocProvider<AllEntitiesCubit>(
            create: (_) => AllEntitiesCubit(ApiService())),
        BlocProvider<TokenCubit>(create: (_) => TokenCubit()),
        BlocProvider<IdCubit>(create: (_) => IdCubit()),
        BlocProvider<UserTypeId>(create: (_) => UserTypeId()),
        BlocProvider<CountCubit>(create: (_) => CountCubit()),
        BlocProvider<PickImageCubit>(create: (_) => PickImageCubit()),
        BlocProvider<EditProfileCubit>(
            create: (_) => EditProfileCubit(ApiService())),
        BlocProvider<HomeScreenCubit>(
            create: (_) => HomeScreenCubit(ApiService())),
        BlocProvider<CheckoutCubit>(create: (_) => CheckoutCubit(ApiService())),
        BlocProvider<OrderHistoryCubit>(
            create: (_) => OrderHistoryCubit(ApiService())),
        BlocProvider<PropertyOwnersProfileImage>(
            create: (_) => PropertyOwnersProfileImage()),
        BlocProvider<TenantPhotoProfileImage>(
            create: (_) => TenantPhotoProfileImage()),
        BlocProvider<TenantIdentityProofImage>(
            create: (_) => TenantIdentityProofImage()),
        BlocProvider<TenantCompanyLetterImage>(
            create: (_) => TenantCompanyLetterImage()),
        BlocProvider<NonMumbaiTenantCompanyLetterImage>(
            create: (_) => NonMumbaiTenantCompanyLetterImage()),
        BlocProvider<NonMumbaiSignaturePhotoCubit>(
            create: (_) => NonMumbaiSignaturePhotoCubit()),
        BlocProvider<NonMumbaiPhotoCubit>(create: (_) => NonMumbaiPhotoCubit()),
        BlocProvider<NonMumbaiIdentityProof>(
            create: (_) => NonMumbaiIdentityProof()),
        BlocProvider<NonMumbaiVerificationFormCubit>(
            create: (_) => NonMumbaiVerificationFormCubit(ApiService())),
        BlocProvider<MumbaiVerificationFormCubit>(
            create: (_) => MumbaiVerificationFormCubit(ApiService())),
        BlocProvider<EmployedCubit>(create: (_) => EmployedCubit()),
        BlocProvider<CriminalCubit>(create: (_) => CriminalCubit()),
        BlocProvider<ArrestedCubit>(create: (_) => ArrestedCubit()),
        BlocProvider<UploadDocumentsNonMumbaiCubit>(
            create: (_) => UploadDocumentsNonMumbaiCubit(ApiService())),
        BlocProvider<UploadDocumentNonMumbaiTenantPhoto>(
            create: (_) => UploadDocumentNonMumbaiTenantPhoto()),
        BlocProvider<UploadDocumentNonMumbaiTenantSignaturePhoto>(
            create: (_) => UploadDocumentNonMumbaiTenantSignaturePhoto()),
        BlocProvider<UploadDocumentNonMumbaiTenantIdentityProof>(
            create: (_) => UploadDocumentNonMumbaiTenantIdentityProof()),
        BlocProvider<UploadDocumentNonMumbaiTenantCompanyLetter>(
            create: (_) => UploadDocumentNonMumbaiTenantCompanyLetter()),
        BlocProvider<UploadDocumentMumbaiOwnerPhoto>(
            create: (_) => UploadDocumentMumbaiOwnerPhoto()),
        BlocProvider<UploadDocumentMumbaiTenantPhoto>(
            create: (_) => UploadDocumentMumbaiTenantPhoto()),
        BlocProvider<UploadDocumentMumbaiTenantIdentityProof>(
            create: (_) => UploadDocumentMumbaiTenantIdentityProof()),
        BlocProvider<UploadDocumentMumbaiTenantSignature>(
            create: (_) => UploadDocumentMumbaiTenantSignature()),
        BlocProvider<UploadDocumentsMumbaiCubit>(
            create: (_) => UploadDocumentsMumbaiCubit(ApiService())),
        BlocProvider<EmploymentSaveFormCubit>(
            create: (_) => EmploymentSaveFormCubit(ApiService())),
        BlocProvider<VerifyRequestUpdateCubit>(
            create: (_) => VerifyRequestUpdateCubit(ApiService())),
        BlocProvider<EducationCertificateDocuments>(
            create: (_) => EducationCertificateDocuments()),
        BlocProvider<EducationSaveFormCubit>(
            create: (_) => EducationSaveFormCubit(ApiService())),
        BlocProvider<PendingDocCubit>(
            create: (_) => PendingDocCubit(ApiService())),
        BlocProvider<DashboardCountBloc>(
            create: (_) => DashboardCountBloc(ApiService())),
        BlocProvider<DashboardEntitiesCubit>(
            create: (_) => DashboardEntitiesCubit(ApiService())),
        BlocProvider<EntityServicesCubit>(
            create: (_) => EntityServicesCubit(ApiService())),
        BlocProvider<PendingDocNavigationCubit>(
            create: (_) => PendingDocNavigationCubit()),
        BlocProvider<VerifyDetailsCubit>(
            create: (_) => VerifyDetailsCubit(ApiService())),
        BlocProvider<MumbaiShowDataCubit>(
            create: (_) => MumbaiShowDataCubit(ApiService())),
        BlocProvider<MumbaiPoliceUpdateFromCubit>(
            create: (_) => MumbaiPoliceUpdateFromCubit(ApiService())),
        BlocProvider<NonMumbaiShowDataCubit>(
            create: (_) => NonMumbaiShowDataCubit(ApiService())),
        BlocProvider<NonMumbaiPoliceVerificationCubit>(
            create: (_) => NonMumbaiPoliceVerificationCubit(ApiService())),
        BlocProvider<EducationShowDetailsCubit>(
            create: (_) => EducationShowDetailsCubit(ApiService())),
        BlocProvider<EducationUpdateFormCubit>(
            create: (_) => EducationUpdateFormCubit(ApiService())),
        BlocProvider<EmployShowDataCubit>(
            create: (_) => EmployShowDataCubit(ApiService())),
        BlocProvider<EmploymentUpdateFormCubit>(
            create: (_) => EmploymentUpdateFormCubit(ApiService())),
        BlocProvider<SelectItemCubit>(create: (_) => SelectItemCubit()),
        BlocProvider<NonMumbaiShowDataCubit>(
            create: (_) => NonMumbaiShowDataCubit(ApiService())),
        BlocProvider<NonMumbaiDocShowDataCubit>(
            create: (_) => NonMumbaiDocShowDataCubit(ApiService())),
        BlocProvider<UpdateDocumentsNonMumbaiCubit>(
            create: (_) => UpdateDocumentsNonMumbaiCubit(ApiService())),
        BlocProvider<MumbaiDocShowDataCubit>(
            create: (_) => MumbaiDocShowDataCubit(ApiService())),
        BlocProvider<MumbaiDocUpdateCubit>(
            create: (_) => MumbaiDocUpdateCubit(ApiService())),
        BlocProvider<EmployDataListCubit>(
            create: (_) => EmployDataListCubit(ApiService())),
        BlocProvider<NameAddressShowDataCubit>(
            create: (_) => NameAddressShowDataCubit(ApiService())),
        BlocProvider<DrivingLicenceBloc>(
            create: (_) => DrivingLicenceBloc(ApiService())),
        BlocProvider<DrivingLicenceShowDataCubit>(
            create: (_) => DrivingLicenceShowDataCubit(ApiService())),
        BlocProvider<PoliceStationIdCubit>(
            create: (_) => PoliceStationIdCubit(ApiService())),
        BlocProvider<PushNotificationCubit>(
            create: (_) => PushNotificationCubit(ApiService())),
        BlocProvider<IsPressedCubit>(create: (_) => IsPressedCubit()),
        BlocProvider<UploadDocumentNonMumbai>(
            create: (_) => UploadDocumentNonMumbai()),
        BlocProvider<UploadDocumentMumbai>(
            create: (_) => UploadDocumentMumbai()),
        BlocProvider<PoliceStationCityIdCubit>(
            create: (_) => PoliceStationCityIdCubit(ApiService())),
        BlocProvider<VerifyRequestEditCubit>(
            create: (_) => VerifyRequestEditCubit(ApiService())),
        BlocProvider<ApplyCouponCubit>(
            create: (_) => ApplyCouponCubit(ApiService())),
        BlocProvider<CheckOutStatusCheckingCubit>(
            create: (_) => CheckOutStatusCheckingCubit(ApiService())),
        BlocProvider<VerifyRequestReportCubit>(
            create: (_) => VerifyRequestReportCubit(ApiService())),
      ],
      child: Builder(builder: (context) {
        return Sizer(builder: (BuildContext, Orientation, ScreenType) {
          ScreenSize.init(context);
          return BlocConsumer<ThemeCubit, AppTheme>(
            listener: (context, themeState) {},
            builder: (context, themeState) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                routerConfig: AppRouter.router,
                title: 'Flutter Demo',
                theme: themeState.themeData,
              );
            },
          );
        });
      }),
    );
  }
}
