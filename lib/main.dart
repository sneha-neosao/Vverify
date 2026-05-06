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
import 'package:v_verify/screen/PushNotification/Bloc/push_notification_cubit.dart';
import 'package:v_verify/screen/PushNotification/push_notification.dart';
import 'package:v_verify/screen/ServicesAndPrice/Blocs/apply_coupon_bloc/apply_coupon_cubit.dart';
import 'package:v_verify/screen/ServicesAndPrice/Blocs/chechout_status_checking_bloc/checkout_status_checking_cubit.dart';
import 'package:v_verify/screen/ServicesAndPrice/Blocs/service_prices_bloc/service_prices_cubit.dart';
import 'package:v_verify/screen/ServicesAndPrice/Blocs/checkout_bloc/checkout_cubit.dart';
import 'package:v_verify/screen/VerificationForms/AadhaarVerification/AadhaarGetOtp/Bloc/aadhaar_verification_cubit.dart';
import 'package:v_verify/screen/VerificationForms/AadhaarVerification/AadhaarVerifyOtp/bloc/aadhaarVerifyOtp_cubit.dart';
import 'package:v_verify/screen/VerificationForms/AddressVerificationForm/Documents/Blocs/address_document_list_bloc/address_doc_list_cubit.dart';
import 'package:v_verify/screen/VerificationForms/AddressVerificationForm/Documents/Blocs/address_document_upload_bloc/address_document_upload_cubit.dart';
import 'package:v_verify/screen/VerificationForms/AddressVerificationForm/List/Blocs/address_list_cubit.dart';
import 'package:v_verify/screen/VerificationForms/AddressVerificationForm/Form/Blocs/address_save_form_bloc/address_save_form_cubit.dart';
import 'package:v_verify/screen/VerificationForms/AddressVerificationForm/Form/Blocs/address_show_details_bloc/address_show_details_bloc.dart';
import 'package:v_verify/screen/VerificationForms/DrvingLicence/Document/Blocs/driving_licence_document_update_bloc;/driving_document_update_cubit.dart';
import 'package:v_verify/screen/VerificationForms/DrvingLicence/Document/Blocs/driving_licence_document_upload_bloc/driver_document_upload_cubit.dart';
import 'package:v_verify/screen/VerificationForms/DrvingLicence/Form/Blocs/driving_licence_save_form_bloc/driving_licence_save_form_bloc.dart';
import 'package:v_verify/screen/VerificationForms/DrvingLicence/Form/Blocs/driving_licence_show_details_bloc/driving_licence_show_details_cubit.dart';
import 'package:v_verify/screen/VerificationForms/DrvingLicence/Form/Blocs/driving_licence_update_bloc/driving_licence_update_form_cubit.dart';
import 'package:v_verify/screen/VerificationForms/EducationVerification/Documents/Blocs/education_document_list_bloc/education_doc_list_cubit.dart';
import 'package:v_verify/screen/VerificationForms/EducationVerification/List/Blocs/education_list_cubit.dart';
import 'package:v_verify/screen/VerificationForms/EducationVerification/Form/Blocs/education_show_details_bloc/education_show_details_cubit.dart';
import 'package:v_verify/screen/VerificationForms/EducationVerification/Form/Blocs/education_update_form_bloc/education_update_form_cubit.dart';
import 'package:v_verify/screen/VerificationForms/EducationVerification/Names/Collage/Bloc/collage_name_cubit.dart';
import 'package:v_verify/screen/VerificationForms/EducationVerification/Names/University/Bloc/university_name_bloc.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentVerification/Documents/Blocs/employment_document_list_bloc/employment_doc_list_cubit.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentVerification/Form/Blocs/employment_update_form_bloc/employment_update_form_cubit.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentVerification/List/Blocs/employment_list_cubit.dart';
import 'package:v_verify/screen/VerificationForms/GST_TIN_CIN/Document/Blocs/gst_document_update_bloc/gst_document_update_cubit.dart';
import 'package:v_verify/screen/VerificationForms/GST_TIN_CIN/Document/Blocs/gst_document_upload_bloc/gst_document_upload_cubit.dart';
import 'package:v_verify/screen/VerificationForms/GST_TIN_CIN/Form/Blocs/gst_verification_save_form_bloc/gst_verification_save_form_cubit.dart';
import 'package:v_verify/screen/VerificationForms/GST_TIN_CIN/Form/Blocs/gst_verification_update_form_bloc/gst_verification_update_form_cubit.dart';
import 'package:v_verify/screen/VerificationForms/GST_TIN_CIN/Form/Blocs/gst_verification_show_details_bloc/gst_verification_show_details_cubit.dart';
import 'package:v_verify/screen/VerificationForms/PanVerification/Document/Blocs/pan_document_update_bloc/pan_document_update_cubit.dart';
import 'package:v_verify/screen/VerificationForms/PanVerification/Document/Blocs/pan_document_upload_bloc/pan_document_upload_cubit.dart';
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
import 'package:v_verify/screen/VerificationForms/ReferenceForm/Documents/Blocs/reference_document_update_bloc/reference_doc_update_cubit.dart';
import 'package:v_verify/screen/VerificationForms/ReferenceForm/Documents/Blocs/reference_document_show_details_bloc/reference_doc_show_data_cubit.dart';
import 'package:v_verify/screen/VerificationForms/ReferenceForm/Documents/Blocs/reference_document_upload_bloc/reference_upload_doc_cubit.dart';
import 'package:v_verify/screen/VerificationForms/ReferenceForm/Form/Blocs/reference_save_form_bloc/reference_save_form_cubit.dart';
import 'package:v_verify/screen/VerificationForms/ReferenceForm/Form/Blocs/reference_show_details_bloc/reference_show_details_cubit.dart';
import 'package:v_verify/screen/VerificationForms/ReferenceForm/Form/Blocs/reference_update_form_bloc/Reference_update_form_cubit.dart';
import 'package:v_verify/screen/VerificationForms/VerifyDeatils/Bloc/verify_details_cubit.dart';
import 'package:v_verify/screen/VerificationForms/courtVerification/Form/Blocs/court_verification_save_form_bloc/court_verification_save_form_cubit.dart';
import 'package:v_verify/screen/VerificationForms/courtVerification/Document/Blocs/court_verification_documents_update_bloc/court_verification_documents_update_cubit.dart';
import 'package:v_verify/screen/VerificationForms/courtVerification/Document/Blocs/court_verification_documents_upload_bloc/court_verification_documents_upload_cubit.dart';
import 'package:v_verify/screen/VerificationForms/courtVerification/Form/Blocs/court_verification_update_form_bloc/court_verification_update_form_cubit.dart';
import 'package:v_verify/screen/VerificationForms/courtVerification/Form/Blocs/court_verification_show_details_bloc/court_verification_show_details_cubit.dart';
import 'package:v_verify/screen/VerificationPending/bloc/pendingDoc_cubit.dart';
import 'package:v_verify/screen/VerificationPending/bloc/verify_report_bloc/verify_request_report_cubit.dart';
import 'package:v_verify/screen/VerificationPending/bloc/verify_request_edit_cubit.dart';
import 'package:v_verify/screen/VerificationPending/verifyRequestUpdate/Bloc/verify_request_update_cubit.dart';
import 'package:v_verify/theme/theme_cubit.dart';
import 'package:v_verify/theme/theme_data.dart';
import 'firebase_options.dart';
import 'screen/VerificationForms/AddressVerificationForm/Form/Blocs/address_update_form_bloc/name_address_verification_cubit.dart';
import 'screen/VerificationForms/EducationVerification/Documents/Blocs/education_document_upload_bloc/education_document_upload_cubit.dart';
import 'screen/VerificationForms/EducationVerification/Form/Blocs/education_save_form_bloc/education_save_form_cubit.dart';
import 'screen/VerificationForms/EmploymentVerification/Documents/Blocs/employment_document_upload_bloc/employment_document_upload_cubit.dart';
import 'screen/VerificationForms/EmploymentVerification/Form/Blocs/employment_save_form_bloc/employment_save_form_cubit.dart';
import 'screen/VerificationForms/EmploymentVerification/Form/Blocs/employment_show_details_bloc/employ_show_details_cubit.dart';

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
        BlocProvider<EmployDataListCubit>(
            create: (_) => EmployDataListCubit(ApiService())),
        BlocProvider<UniversityNameBloc>(
            create: (_) => UniversityNameBloc(ApiService())),
        BlocProvider<CollageNameCubit>(
            create: (_) => CollageNameCubit(ApiService())),
        BlocProvider<NameAddressVerificationUpdateFormCubit>(
            create: (_) =>
                NameAddressVerificationUpdateFormCubit(ApiService())),
        BlocProvider<NameAddressShowDataCubit>(
            create: (_) => NameAddressShowDataCubit(ApiService())),
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
        BlocProvider<EducationDocsUploadCubitNew>(
            create: (_) => EducationDocsUploadCubitNew(ApiService())),
        BlocProvider<EducationDocsFileCubit>(
            create: (_) => EducationDocsFileCubit()),
        BlocProvider<EducationDocumentListCubit>(
            create: (_) => EducationDocumentListCubit(ApiService())),
        BlocProvider<VerifyRequestEditCubit>(
            create: (_) => VerifyRequestEditCubit(ApiService())),
        BlocProvider<EmploymentDocumentListCubit>(
            create: (_) => EmploymentDocumentListCubit(ApiService())),
        BlocProvider<EmploymentDocsFileCubit>(
            create: (_) => EmploymentDocsFileCubit()),
        BlocProvider<AddressListCubit>(
            create: (_) => AddressListCubit(ApiService())),
        BlocProvider<AddressDocsUploadCubitNew>(
            create: (_) => AddressDocsUploadCubitNew(ApiService())),
        BlocProvider<AddressDocsFileCubit>(
            create: (_) => AddressDocsFileCubit()),
        BlocProvider<AddressDocumentListCubit>(
            create: (_) => AddressDocumentListCubit(ApiService())),
        BlocProvider<ApplyCouponCubit>(
            create: (_) => ApplyCouponCubit(ApiService())),
        BlocProvider<CheckOutStatusCheckingCubit>(
            create: (_) => CheckOutStatusCheckingCubit(ApiService())),
        BlocProvider<VerifyRequestReportCubit>(
            create: (_) => VerifyRequestReportCubit(ApiService())),
        BlocProvider<PanDocsUploadCubitNew>(
            create: (_) => PanDocsUploadCubitNew(ApiService())),
        BlocProvider<PanDocsFileCubit>(create: (_) => PanDocsFileCubit()),
        BlocProvider<PanDocsUpdateCubitNew>(
            create: (_) => PanDocsUpdateCubitNew(ApiService())),
        BlocProvider<PanDocsUpdateFileCubit>(
            create: (_) => PanDocsUpdateFileCubit()),
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
