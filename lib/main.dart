import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
import 'package:v_verify/screen/PushNotification/Bloc/push_notification_cubit.dart';
import 'package:v_verify/screen/PushNotification/push_notification.dart';
import 'package:v_verify/screen/ServicesAndPrice/bloc/servicePrice_cubit.dart';
import 'package:v_verify/screen/ServicesAndPrice/bloc_checkout/checkout_cubit.dart';
import 'package:v_verify/screen/VerificationForms/AadhaarVerification/AadhaarGetOtp/Bloc/aadhaar_verification_cubit.dart';
import 'package:v_verify/screen/VerificationForms/AadhaarVerification/AadhaarVerifyOtp/bloc/aadhaarVerifyOtp_cubit.dart';
import 'package:v_verify/screen/VerificationForms/DrvingLicence/Bloc/driving_licence_bloc.dart';
import 'package:v_verify/screen/VerificationForms/DrvingLicence/Document/update/Bloc/driving_doc_update_cubit.dart';
import 'package:v_verify/screen/VerificationForms/DrvingLicence/Document/upload/bloc/driver_doc_upload_cubit.dart';
import 'package:v_verify/screen/VerificationForms/DrvingLicence/ShowData/Bloc/drving_licence_shwodata_cubit.dart';
import 'package:v_verify/screen/VerificationForms/DrvingLicence/Update/Bloc/driving_licence_update_cubit.dart';
import 'package:v_verify/screen/VerificationForms/EducationVerification/DocUpdate/Bloc/education_doc_update_cubit.dart';
import 'package:v_verify/screen/VerificationForms/EducationVerification/DocUpdate/ShowData/Bloc/education_doc_show_data_cubit.dart';
import 'package:v_verify/screen/VerificationForms/EducationVerification/EducationDocUpload/Bloc/education_doc_upload_cubit.dart';
import 'package:v_verify/screen/VerificationForms/EducationVerification/EducationList/Bloc/education_list_cubit.dart';
import 'package:v_verify/screen/VerificationForms/EducationVerification/Names/Collage/Bloc/collage_name_cubit.dart';
import 'package:v_verify/screen/VerificationForms/EducationVerification/Names/University/Bloc/university_name_bloc.dart';
import 'package:v_verify/screen/VerificationForms/EducationVerification/SaveForm/Bloc/education_save_form_bloc.dart';
import 'package:v_verify/screen/VerificationForms/EducationVerification/Update/Bloc/Education_update_form_cubit.dart';
import 'package:v_verify/screen/VerificationForms/EducationVerification/Update/ShowDetails/Bloc/education_show_details_cubit.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentForm/EmployList/Bloc/employ_data_list_cubit.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentForm/Save/Bloc/EmploymentSaveForm.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentForm/Update/Bloc/employment_update_form.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentForm/Update/showData/Bloc/employ_show_data_cubit.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentForm/UploadDoc/Bloc/employment_upload_cubit.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentForm/employUpdateDoc/Bloc/employ_doc_update_cubit.dart';
import 'package:v_verify/screen/VerificationForms/GST_TIN_CIN/Documents/update/bloc/gst_pan_cin_doc_update_cubit.dart';
import 'package:v_verify/screen/VerificationForms/GST_TIN_CIN/Documents/upload/bloc/gst_pan_cin_doc_upload_cubit.dart';
import 'package:v_verify/screen/VerificationForms/GST_TIN_CIN/Save/Bloc/gst_pan_cin_save_cubit.dart';
import 'package:v_verify/screen/VerificationForms/GST_TIN_CIN/Update/Bloc/gst_pan_cin_update_cubit.dart';
import 'package:v_verify/screen/VerificationForms/GST_TIN_CIN/Update/ShowData/Bloc/GstPanCin_show_data_cubit.dart';
import 'package:v_verify/screen/VerificationForms/NameAddressVerificationForm/Documents/DocUpdate/bloc/name_address_doc_update_cubit.dart';
import 'package:v_verify/screen/VerificationForms/NameAddressVerificationForm/Documents/DocUpload/Bloc/name_address_doc_upload_cubit.dart';
import 'package:v_verify/screen/VerificationForms/NameAddressVerificationForm/Save/Bloc/name_address_verification_cubit.dart';
import 'package:v_verify/screen/VerificationForms/NameAddressVerificationForm/Update/Bloc/name_address_verification_cubit.dart';
import 'package:v_verify/screen/VerificationForms/NameAddressVerificationForm/Update/ShowData/Bloc/nameAddress_showData_cubit.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/Mumbai/PoliceStationId/Bloc/police_station_id_cubit.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/Mumbai/UpdateForm/Update/Bloc/mumbaiPoliceUpdateFrom_cubit.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/Mumbai/UpdateForm/showDetails/Bloc/mumbaiShowData_cubit.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/Mumbai/UploadDocuments/bloc/upload_documents_mumbai_cubit.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/Mumbai/forms/bloc/mumbaiPolice_verification_blocCubit.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/Mumbai/updateDocuments/Bloc/mumbai_doc_update_cubit.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/Mumbai/updateDocuments/ShowData/mumbai_doc_show_data_cubit.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/NonMumbai/Forms/Bloc/nonMumbai_verification_cubit.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/NonMumbai/Update/Bloc/non_MumbaiPoliceVerification_cubit.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/NonMumbai/Update/showDetails/Bloc/non_mumbaiShowData_cubit.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/NonMumbai/UpdateDocument/Bloc/update_document_non_mumbai_cubit.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/NonMumbai/UpdateDocument/showdata/Bloc/non_mumbai_show_data_cubit.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/NonMumbai/UploadDocuments/bloc/upload_document_nonMumbai_cubit.dart';
import 'package:v_verify/screen/VerificationForms/ReferenceForm/DocUpload/UpdateDoc/Bloc/reference_doc_update_cubit.dart';
import 'package:v_verify/screen/VerificationForms/ReferenceForm/DocUpload/UpdateDoc/ShowData/Bloc/reference_doc_show_data_cubit.dart';
import 'package:v_verify/screen/VerificationForms/ReferenceForm/DocUpload/uploadDoc/Bloc/reference_upload_doc_cubit.dart';
import 'package:v_verify/screen/VerificationForms/ReferenceForm/Save/Bloc/reference_form_cubit.dart';
import 'package:v_verify/screen/VerificationForms/ReferenceForm/ShowDetails/Bloc/reference_check_details_cubit.dart';
import 'package:v_verify/screen/VerificationForms/ReferenceForm/Update/Bloc/Reference_update_cubit.dart';
import 'package:v_verify/screen/VerificationForms/VerifyDeatils/Bloc/verify_details_cubit.dart';
import 'package:v_verify/screen/VerificationForms/courtVerification/Bloc/court_verification_cubit.dart';
import 'package:v_verify/screen/VerificationForms/courtVerification/documents/updateDoc/bloc/court_doc_update_cubit.dart';
import 'package:v_verify/screen/VerificationForms/courtVerification/documents/uploadDoc/Bloc/court_doc_upload_cubit.dart';
import 'package:v_verify/screen/VerificationForms/courtVerification/update/Bloc/court_update_cubit.dart';
import 'package:v_verify/screen/VerificationForms/courtVerification/update/ShowData/bloc/show_court_data_cubit.dart';
import 'package:v_verify/screen/VerificationPending/bloc/pendingDoc_cubit.dart';
import 'package:v_verify/screen/VerificationPending/verifyRequestUpdate/Bloc/verify_request_update_cubit.dart';
import 'package:v_verify/theme/theme_cubit.dart';
import 'package:v_verify/theme/theme_data.dart';

import 'firebase_options.dart';

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
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
      statusBarIconBrightness: isDarkMode
          ? Brightness.light
          : Brightness.dark, // For white status bar icons
    ));
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
        BlocProvider<LoginCubit>(create: (_) => LoginCubit(ApiService())),
        BlocProvider<OtpVerifyCubit>(
            create: (_) => OtpVerifyCubit(ApiService())),
        BlocProvider<RegisterCubit>(create: (_) => RegisterCubit(ApiService())),
        BlocProvider<ProfileCubit>(create: (_) => ProfileCubit(ApiService())),
        BlocProvider<ServicePriceCubit>(
            create: (_) => ServicePriceCubit(ApiService())),
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
        BlocProvider<ReferenceFormCubit>(
            create: (_) => ReferenceFormCubit(ApiService())),
        BlocProvider<NameAddressVerificationFormCubit>(
            create: (_) => NameAddressVerificationFormCubit(ApiService())),
        BlocProvider<NameAddressAadhaarBackSideCubit>(
            create: (_) => NameAddressAadhaarBackSideCubit()),
        BlocProvider<NameAddressAadhaarFrontSideCubit>(
            create: (_) => NameAddressAadhaarFrontSideCubit()),
        BlocProvider<AadhaarGetOtpCubit>(
            create: (_) => AadhaarGetOtpCubit(ApiService())),
        BlocProvider<AadhaarVerifyOtpCubit>(
            create: (_) => AadhaarVerifyOtpCubit(ApiService())),
        BlocProvider<EmploymentLetterImage>(
            create: (_) => EmploymentLetterImage()),
        BlocProvider<EmploymentSupportDocumentImage>(
            create: (_) => EmploymentSupportDocumentImage()),
        BlocProvider<EmploymentSaveFormCubit>(
            create: (_) => EmploymentSaveFormCubit(ApiService())),
        BlocProvider<VerifyRequestUpdateCubit>(
            create: (_) => VerifyRequestUpdateCubit(ApiService())),
        BlocProvider<EmploymentUploadCubit>(
            create: (_) => EmploymentUploadCubit(ApiService())),
        BlocProvider<EducationCertificateDocuments>(
            create: (_) => EducationCertificateDocuments()),
        BlocProvider<EducationSaveFormCubit>(
            create: (_) => EducationSaveFormCubit(ApiService())),
        BlocProvider<EducationDocUploadCubit>(
            create: (_) => EducationDocUploadCubit(ApiService())),
        BlocProvider<PendingDocCubit>(
            create: (_) => PendingDocCubit(ApiService())),
        BlocProvider<VerifyDetailsCubit>(
            create: (_) => VerifyDetailsCubit(ApiService())),
        BlocProvider<ReferenceCheckDetailsCubit>(
            create: (_) => ReferenceCheckDetailsCubit(ApiService())),
        BlocProvider<ReferenceUpdateFormCubit>(
            create: (_) => ReferenceUpdateFormCubit(ApiService())),
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
        BlocProvider<EducationListCubit>(
            create: (_) => EducationListCubit(ApiService())),
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
        BlocProvider<EducationDocShowDataCubit>(
            create: (_) => EducationDocShowDataCubit(ApiService())),
        BlocProvider<EducationDocUpdateCubit>(
            create: (_) => EducationDocUpdateCubit(ApiService())),
        BlocProvider<EmployDataListCubit>(
            create: (_) => EmployDataListCubit(ApiService())),
        BlocProvider<EmployDocUpdateCubit>(
            create: (_) => EmployDocUpdateCubit(ApiService())),
        BlocProvider<UniversityNameBloc>(
            create: (_) => UniversityNameBloc(ApiService())),
        BlocProvider<CollageNameCubit>(
            create: (_) => CollageNameCubit(ApiService())),
        BlocProvider<NameAddressVerificationUpdateFormCubit>(
            create: (_) =>
                NameAddressVerificationUpdateFormCubit(ApiService())),
        BlocProvider<NameAddressShowDataCubit>(
            create: (_) => NameAddressShowDataCubit(ApiService())),
        BlocProvider<EmploymentSupportDocument>(
            create: (_) => EmploymentSupportDocument()),
        // BlocProvider<EmploymentMarkSheetDocument>(
        //     create: (_) => EmploymentMarkSheetDocument()),
        BlocProvider<EducationDocFileCubit>(
            create: (_) => EducationDocFileCubit()),
        BlocProvider<DrivingLicenceBloc>(
            create: (_) => DrivingLicenceBloc(ApiService())),
        BlocProvider<DrivingLicenceShowDataCubit>(
            create: (_) => DrivingLicenceShowDataCubit(ApiService())),
        BlocProvider<DrivingLicenceUpdateCubit>(
            create: (_) => DrivingLicenceUpdateCubit(ApiService())),
        BlocProvider<GstPanCinSaveCubit>(
            create: (_) => GstPanCinSaveCubit(ApiService())),
        BlocProvider<GstPanCinShowDataCubit>(
            create: (_) => GstPanCinShowDataCubit(ApiService())),
        BlocProvider<GstPanCinUpdateCubit>(
            create: (_) => GstPanCinUpdateCubit(ApiService())),
        BlocProvider<PoliceStationIdCubit>(
            create: (_) => PoliceStationIdCubit(ApiService())),
        BlocProvider<PushNotificationCubit>(
            create: (_) => PushNotificationCubit(ApiService())),
        BlocProvider<CourtVerificationCubit>(
            create: (_) => CourtVerificationCubit(ApiService())),
        BlocProvider<ShowCourtDataCubit>(
            create: (_) => ShowCourtDataCubit(ApiService())),
        BlocProvider<CourtUpdateCubit>(
            create: (_) => CourtUpdateCubit(ApiService())),
        BlocProvider<IsPressedCubit>(create: (_) => IsPressedCubit()),
        BlocProvider<UpdateDateCubit>(create: (_) => UpdateDateCubit()),
        BlocProvider<ReferenceUploadDocCubit>(
            create: (_) => ReferenceUploadDocCubit(ApiService())),
        BlocProvider<ReferenceCheckUploadDoc>(
            create: (_) => ReferenceCheckUploadDoc()),
        BlocProvider<ReferenceDocShowDataCubit>(
            create: (_) => ReferenceDocShowDataCubit(ApiService())),
        BlocProvider<ReferenceDocUpdateCubit>(
            create: (_) => ReferenceDocUpdateCubit(ApiService())),
        BlocProvider<NameAddressDocUploadCubit>(
            create: (_) => NameAddressDocUploadCubit(ApiService())),
        BlocProvider<NameAddressDocUpdateCubit>(
            create: (_) => NameAddressDocUpdateCubit(ApiService())),
        BlocProvider<GstPanCinDocUploadCubit>(
            create: (_) => GstPanCinDocUploadCubit(ApiService())),
        BlocProvider<GstDocUpload>(create: (_) => GstDocUpload()),
        BlocProvider<PanDocUpload>(create: (_) => PanDocUpload()),
        BlocProvider<CinDocUpload>(create: (_) => CinDocUpload()),
        BlocProvider<GstPanCinDocUpdateCubit>(
            create: (_) => GstPanCinDocUpdateCubit(ApiService())),
        BlocProvider<CourtAadhaarUpload>(create: (_) => CourtAadhaarUpload()),
        BlocProvider<CourtPanUpload>(create: (_) => CourtPanUpload()),
        BlocProvider<DriverDocFileUpload>(create: (_) => DriverDocFileUpload()),
        BlocProvider<CourtDocUploadCubit>(
            create: (_) => CourtDocUploadCubit(ApiService())),
        BlocProvider<CourtDocUpdateCubit>(
            create: (_) => CourtDocUpdateCubit(ApiService())),
        BlocProvider<DriverDocUploadCubit>(
            create: (_) => DriverDocUploadCubit(ApiService())),
        BlocProvider<DrivingDocUpdateCubit>(
            create: (_) => DrivingDocUpdateCubit(ApiService())),
        BlocProvider<UploadDocumentNonMumbai>(
            create: (_) => UploadDocumentNonMumbai()),
        BlocProvider<UploadDocumentMumbai>(
            create: (_) => UploadDocumentMumbai()),
        BlocProvider<PoliceStationCityIdCubit>(
            create: (_) => PoliceStationCityIdCubit(ApiService())),
        BlocProvider<RelivingLetterDocumentImage>(
            create: (_) => RelivingLetterDocumentImage()),
        BlocProvider<ExperienceDocumentImage>(
            create: (_) => ExperienceDocumentImage()),
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
