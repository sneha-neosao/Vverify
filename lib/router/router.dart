import 'package:go_router/go_router.dart';
import 'package:v_verify/screen/Bottom/bottomNavbar.dart';
import 'package:v_verify/screen/Complete-Profile/complete_profile.dart';
import 'package:v_verify/screen/EditProfile/edit_profile.dart';
import 'package:v_verify/screen/Home%20screen/home_page.dart';
import 'package:v_verify/screen/Login-Screen/login_screen.dart';
import 'package:v_verify/screen/Order%20Details/order_details.dart';
import 'package:v_verify/screen/Payment%20Successful/payment_successful.dart';
import 'package:v_verify/screen/ServicesAndPrice/Screens/apply_coupon_screen.dart';
import 'package:v_verify/screen/ServicesAndPrice/Screens/services_and_price_screen.dart';
import 'package:v_verify/screen/SplashScreen/SplashScreen.dart';
import 'package:v_verify/screen/VerificationForms/AddressVerificationForm/Documents/Screens/address_documnet_upload_screen.dart';
import 'package:v_verify/screen/VerificationForms/AddressVerificationForm/List/Screens/address_list.dart';
import 'package:v_verify/screen/VerificationForms/DrvingLicence/Form/Screens/driving_licence_save_form_screen.dart';
import 'package:v_verify/screen/VerificationForms/EducationVerification/Form/Screens/education_update_form_screen.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentVerification/Documents/Screens/employment_document_upload_screen.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentVerification/Form/Screens/employment_save_form_screen.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentVerification/Form/Screens/employment_update_form_screen.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentVerification/List/Screens/employment_list.dart';
import 'package:v_verify/screen/VerificationPending/verifyRequestUpdate/verify_request_update_new.dart';
import '../screen/Add Signature/add_signature.dart';
import '../screen/OTP_Verify-Screen/otp_verify_screen.dart';
import '../screen/ProfileScreen/OtherScreen/Terms_conditions.dart';
import '../screen/ProfileScreen/OtherScreen/privacy_policy.dart';
import '../screen/ProfileScreen/OtherScreen/refund_policy.dart';
import '../screen/ProfileScreen/ProfilePage.dart';
import '../screen/VerificationForms/AadhaarVerification/AadhaarGetOtp/aadhaar_verification.dart';
import '../screen/VerificationForms/AadhaarVerification/AadhaarVerifyOtp/AadhaarVerifyOtp.dart';
import '../screen/VerificationForms/AddressVerificationForm/Form/Screens/address_save_form_screen.dart';
import '../screen/VerificationForms/AddressVerificationForm/Form/Screens/address_update_form_screen.dart';
import '../screen/VerificationForms/DrvingLicence/Document/Screens/driver_documents_upload_screen.dart';
import '../screen/VerificationForms/DrvingLicence/Document/Screens/driving_documents_update_screen.dart';
import '../screen/VerificationForms/DrvingLicence/Form/Screens/driving_licence_update_form_screen.dart';
import '../screen/VerificationForms/EducationVerification/List/Screens/education_list.dart';
import '../screen/VerificationForms/EducationVerification/Documents/Screens/education_document_upload_screen.dart';
import '../screen/VerificationForms/EducationVerification/Form/Screens/education_save_form_screen.dart';
import '../screen/VerificationForms/GST_TIN_CIN/Document/Screens/gst_document_update_screen.dart';
import '../screen/VerificationForms/GST_TIN_CIN/Document/Screens/gst_document_upload_screen.dart';
import '../screen/VerificationForms/GST_TIN_CIN/Form/Screens/gst_verification_save_form_screen.dart';
import '../screen/VerificationForms/GST_TIN_CIN/Form/Screens/gst_verification_update_form_screen.dart';
import '../screen/VerificationForms/PanVerification/Screens/pan_save_form_screen.dart';
import '../screen/VerificationForms/PanVerification/Screens/pan_update_form_screen.dart';
import '../screen/VerificationForms/PoliceVerification/Mumbai/Form/Screens/Update/mumbai_police_update_form_screen1.dart';
import '../screen/VerificationForms/PoliceVerification/Mumbai/Document/Screens/mumbai_police_document_upload_screen.dart';
import '../screen/VerificationForms/PoliceVerification/Mumbai/Form/Screens/Save/mumbai_police_save_form_screen1.dart';
import '../screen/VerificationForms/PoliceVerification/Mumbai/Document/Screens/mumbai_police_document_update_screen.dart';
import '../screen/VerificationForms/PoliceVerification/NonMumbai/Form/Screens/Save/non_mumbai_police_save_form_screen1.dart';
import '../screen/VerificationForms/PoliceVerification/NonMumbai/Form/Screens/Update/non_mumbai_police_update_form_screen1.dart';
import '../screen/VerificationForms/PoliceVerification/NonMumbai/Document/Screens/non_mumbai_documents_update_screen.dart';
import '../screen/VerificationForms/PoliceVerification/NonMumbai/Document/Screens/non_mumbai_documents_upload_screen.dart';
import '../screen/VerificationForms/ReferenceForm/Documents/Screens/reference_document_update_screen.dart';
import '../screen/VerificationForms/ReferenceForm/Documents/Screens/reference_document_upload_screen.dart';
import '../screen/VerificationForms/ReferenceForm/Form/Screens/reference_save_form_screen.dart';
import '../screen/VerificationForms/ReferenceForm/Form/Screens/Reference_update_form_screen.dart';
import '../screen/VerificationForms/courtVerification/Form/Screens/court_verification_save_form_screen.dart';
import '../screen/VerificationForms/courtVerification/Document/Screens/court_document_update_form_screen.dart';
import '../screen/VerificationForms/courtVerification/Document/Screens/court_document_upload_screen.dart';
import '../screen/VerificationForms/courtVerification/Form/Screens/court_verification_update_form_screen.dart';
import '../screen/VerificationPending/Pagination/pending_doc_Pagination.dart';
import '../screen/VerificationPending/verifyRequestUpdate/verify_request_edit_form_new.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // Home Route
      GoRoute(
        path: '/',
        builder: (context, state) {
          return const SplashScreen();
        },
      ),

      /// Authentication related routes
      GoRoute(
        path: '/login',
        name: "login",
        builder: (context, state) {
          return LoginScreen();
        },
      ),
      GoRoute(
        path: '/otpVerifyScreen/:mobileNumber',
        name: "otpVerifyScreen",
        builder: (context, state) {
          final mobileNumber = state.pathParameters['mobileNumber']!;
          return OtpVerifyScreen(
            mobileNum: mobileNumber,
          );
        },
      ),
      GoRoute(
        path: '/completeProfile/:mobileNumber',
        name: "completeProfile",
        builder: (context, state) {
          final mobileNumber = state.pathParameters['mobileNumber']!;
          return CompleteProfile(mobileNum: mobileNumber);
        },
      ),




      /// Common routes
      GoRoute(
        path: '/homeScreen',
        name: "homeScreen",
        builder: (context, state) {
          return HomeScreen();
        },
      ),

      GoRoute(
        path: '/bottomNav',
        name: "bottomNav",
        builder: (context, state) {
          return BottomNavigationScreen();
        },
      ),
      GoRoute(
        path: '/servicesAndPrice/:id',
        name: "servicesAndPrice",
        builder: (context, state) {
          final entityId = state.pathParameters['id']!;
          return ServicesAndPrice(entity_id: entityId,);
        },
      ),
      GoRoute(
        path: '/paymentSuccess',
        name: "payment_success",
        builder: (context, state) {
          return const PaymentSuccessful();
        },
      ),

      GoRoute(
        path: '/orderDetails/:txnId',
        name: "orderDetails",
        builder: (context, state) {
          final orderTxnId = state.pathParameters['txnId']!;
          return OrderDetails(
            txnId: orderTxnId,
          );
        },
      ),

      GoRoute(
        path: '/PendingDoc',
        name: "PendingDoc",
        builder: (context, state) {
          return  PendingDocPagination();
        },
      ),
      GoRoute(
        path: '/ProfilePage',
        name: "ProfilePage",
        builder: (context, state) {
          return const ProfilePage();
        },
      ),
      GoRoute(
        path: '/TermsConditions',
        name: 'TermsConditions',
        builder: (context, state) {
          return const TermsConditions();
        },
      ),

      GoRoute(
        path: '/PrivacyPolicy',
        name: 'PrivacyPolicy',
        builder: (context, state) {
          return const PrivacyPolicy();
        },
      ),
      GoRoute(
        path: '/RefundPolicy',
        name: 'RefundPolicy',
        builder: (context, state) {
          return const RefundPolicy();
        },
      ),
      GoRoute(
        path: '/SignatureScreen',
        name: 'SignatureScreen',
        builder: (context, state) {
          return  SignatureScreen();
        },
      ),
      GoRoute(
        path: '/EditProfile/:user_type',
        name: "edit_profile",
        builder: (context, state) {
          final String userTypeStr = state.pathParameters['user_type']!;
          return EditProfile(
            user_type: userTypeStr, // change EditProfile to accept String
          );
        },
      ),




      ///Verification Request related routes
      GoRoute(
        path: '/verifyRequestUpdateNew/:uuid/:service_title',
        name: "verifyRequestUpdateNew",
        builder: (context, state) {
          final uuid = state.pathParameters['uuid']!;
          final service_title = state.pathParameters['service_title']!;
          return VerifyRequestUpdateNew(
            uuid: uuid,
            service_title: service_title,
          );
        },
      ),
      GoRoute(
        path: '/VerifyRequestEditFormNew/:request_id/:uuid/:service_title',
        name: "VerifyRequestEditFormNew",
        builder: (context, state) {
          final requestId = state.pathParameters['request_id']!;
          final uuid = state.pathParameters['uuid']!;
          final service_title = state.pathParameters['service_title']!;
          return VerifyRequestEditFormNew(
              request_id: requestId,
              uuid: uuid,
            service_title: service_title,
          );
        },
      ),




      /// Education Verification Service related routes
      GoRoute(
        path: '/EducationList/:uid',
        name: 'EducationList',
        builder: (context, state) {
          final uid = state.pathParameters['uid'] ?? "";
          return EducationList(
            Case_uuid: uid,
          );
        },
      ),
      GoRoute(
        path: '/EducationSaveFormScreen/:uid',
        name: "EducationSaveFormScreen",
        builder: (context, state) {
          final uid = state.pathParameters['uid'] ?? "";
          return EducationSaveFormScreen(
            Case_uuid: uid,
          );
        },
      ),
      GoRoute(
        path: '/EducationUpdateFormScreen/:uid/:case_uuid/:education_uuid',
        name: 'EducationUpdateFormScreen',
        builder: (context, state) {
          final uid = state.pathParameters['uid']!;
          final caseUuid = state.pathParameters['case_uuid']!;
          final education_uuid = state.pathParameters['education_uuid']!;

          return EducationUpdateFormScreen(
            uid: uid,
            case_uuid: caseUuid,
            education_uuid: education_uuid,
          );
        },
      ),
      GoRoute(
        path: '/EducationDocumentUpload/:uid',
        name: "EducationDocumentUpload",
        builder: (context, state) {
          final uid = state.pathParameters['uid'] ?? "";
          return EducationDocumentUpload(
            Case_uuid: uid,
          );
        },
      ),



      /// Employment Verification Service related routes
      GoRoute(
        path: '/EmployDataList/:uid',
        name: 'EmployDataList',
        builder: (context, state) {
          final uid = state.pathParameters['uid'] ?? "";
          return  EmployDataList(Case_uuid: uid,);
        },
      ),
      GoRoute(
        path: '/EmploymentSaveFormScreen/:case_uid',
        name: "EmploymentSaveFormScreen",
        builder: (context, state) {
          final case_uid = state.pathParameters['case_uid'] ?? "";
          return EmploymentSaveFormScreen(Case_uuid: case_uid,);
        },
      ),
      GoRoute(
        path: '/EmploymentUpdateFormScreen/:uid/:case_uuid/:employment_uuid',
        name: 'EmploymentUpdateFormScreen',
        builder: (context, state) {
          final uid = state.pathParameters['uid']!;
          final caseUuid = state.pathParameters['case_uuid']!;
          final employment_uuid = state.pathParameters['employment_uuid']!;

          return EmploymentUpdateFormScreen(
            uid: uid,
            case_uuid: caseUuid,
            employment_uuid: employment_uuid,
          );
        },
      ),
      GoRoute(
        path: '/EmploymentDocumentUpload/:uid',
        name: "EmploymentDocumentUpload",
        builder: (context, state) {
          final uid = state.pathParameters['uid'] ?? "";
          return EmploymentDocumentUpload(
            Case_uuid: uid,
          );
        },
      ),



      /// Address Verification Service related routes
      GoRoute(
        path: '/AddressList/:uid',
        name: 'AddressList',
        builder: (context, state) {
          final uid = state.pathParameters['uid'] ?? "";
          return AddressList(
            Case_uuid: uid,
          );
        },
      ),
      GoRoute(
        path: '/AddressSaveFormScreen/:uid',
        name: "AddressSaveFormScreen",
        builder: (context, state) {
          final uid = state.pathParameters['uid'] ?? "";
          return AddressSaveFormScreen(Case_uuid: uid,);
        },
      ),
      GoRoute(
        path: '/AddressUpdateFormScreen/:uid/:case_uuid/:address_uuid',
        name: 'AddressUpdateFormScreen',
        builder: (context, state) {
          final uid = state.pathParameters['uid']!;
          final caseUuid = state.pathParameters['case_uuid']!;
          final address_uuid = state.pathParameters['address_uuid']!;

          return AddressUpdateFormScreen(
            uid: uid,
            case_uuid: caseUuid,
            address_uuid: address_uuid,
          );
        },
      ),
      GoRoute(
        path: '/AddressDocumentUpload/:uid',
        name: "AddressDocumentUpload",
        builder: (context, state) {
          final uid = state.pathParameters['uid'] ?? "";
          return AddressDocumentUpload(
            Case_uuid: uid,
          );
        },
      ),
      GoRoute(
        path: '/ApplyCouponScreen/:subtotal/:entityId',
        name: "ApplyCouponScreen",
        builder: (context, state) {
          final subtotal = state.pathParameters['subtotal'] ?? "";
          final entityId = state.pathParameters['entityId'] ?? "";
          return ApplyCouponScreen(subTotal: subtotal,entity_id: entityId,);
        },
      ),



      /// KYC Verification Service related routes
      GoRoute(
        path: '/PanSaveFormScreen',
        name: 'PanSaveFormScreen',
        builder: (context, state) {
          return  const PanSaveFormScreen();
        },
      ),
      GoRoute(
        path: '/PanUpdateFormScreen/:uid',
        name: 'PanUpdateFormScreen',
        builder: (context, state) {
          final uid = state.pathParameters['uid']!;
          return PanUpdateFormScreen(
            uid: uid,
          );
        },
      ),



      /// Court Verification Service related routes
      GoRoute(
        path: '/CourtVerificationSaveFormScreen',
        name: 'CourtVerificationSaveFormScreen',
        builder: (context, state) {
          return const CourtVerificationSaveFormScreen();
        },
      ),
      GoRoute(
        path: '/CourtVerificationUpdateFormScreen/:uid',
        name: 'CourtVerificationUpdateFormScreen',
        builder: (context, state) {
          final uid = state.pathParameters['uid']!;
          return CourtVerificationUpdateFormScreen(
            uid: uid,
          );
        },
      ),
      GoRoute(
        path: '/CourtDocumentUploadScreen',
        name: 'CourtDocumentUploadScreen',
        builder: (context, state) {
          return const CourtDocumentUploadScreen();
        },
      ),
      GoRoute(
        path: '/CourtDocumentUpdateFormScreen/:uid',
        name: 'CourtDocumentUpdateFormScreen',
        builder: (context, state) {
          final uid = state.pathParameters['uid']!;
          return CourtDocumentUpdateFormScreen(
            uid: uid,
          );
        },
      ),



      /// Reference Check Verification Service related routes
      GoRoute(
        path: '/ReferenceSaveFormScreen',
        name: "ReferenceSaveFormScreen",
        builder: (context, state) {
          return const ReferenceSaveFormScreen();
        },
      ),
      GoRoute(
        path: '/ReferenceUpdateFormScreen/:uid',
        name: 'ReferenceUpdateFormScreen',
        builder: (context, state) {
          final uid = state.pathParameters['uid']!;
          return ReferenceUpdateFormScreen(
            uid: uid,
          );
        },
      ),
      GoRoute(
        path: '/ReferenceUploadDoc',
        name: 'ReferenceUploadDoc',
        builder: (context, state) {
          return const ReferenceUploadDoc();
        },
      ),

      GoRoute(
        path: '/ReferenceUpdateDoc/:uid',
        name: 'ReferenceUpdateDoc',
        builder: (context, state) {
          final uid = state.pathParameters['uid']!;
          return ReferenceUpdateDoc(
            uid: uid,
          );
        },
      ),




      /// GST Verification Service related routes
      GoRoute(
        path: '/GstVerificationSaveFormScreen',
        name: 'GstVerificationSaveFormScreen',
        builder: (context, state) {
          return const GstVerificationSaveFormScreen();
        },
      ),
      GoRoute(
        path: '/GstVerificationUpdateFormScreen/:uid',
        name: 'GstVerificationUpdateFormScreen',
        builder: (context, state) {
          final uid = state.pathParameters['uid']!;
          return GstVerificationUpdateFormScreen(
            uid: uid,
          );
        },
      ),
      GoRoute(
        path: '/GstPanCinDocUpload',
        name: 'GstPanCinDocUpload',
        builder: (context, state) {
          return const GstPanCinDocUpload();
        },
      ),
      GoRoute(
        path: '/GstPanCinDocUpdate/:uid',
        name: 'GstPanCinDocUpdate',
        builder: (context, state) {
          final uid = state.pathParameters['uid']!;
          return GstPanCinDocUpdate(
            uid: uid,
          );
        },
      ),




      /// Driving Licence Verification Service related routes
      GoRoute(
        path: '/DrivingLicenceSaveFormScreen',
        name: 'DrivingLicenceSaveFormScreen',
        builder: (context, state) {
          return const DrivingLicenceSaveFormScreen();
        },
      ),
      GoRoute(
        path: '/DrivingLicenceUpdateFormScreen/:uid',
        name: 'DrivingLicenceUpdateFormScreen',
        builder: (context, state) {
          final uid = state.pathParameters['uid']!;
          return DrivingLicenceUpdateFormScreen(
            uid: uid,
          );
        },
      ),
      GoRoute(
        path: '/DrivingDocUpdate/:uid',
        name: 'DrivingDocUpdate',
        builder: (context, state) {
          final uid = state.pathParameters['uid']!;
          return DrivingDocUpdate(
            uid: uid,
          );
        },
      ),
      GoRoute(
        path: '/DriverDocUpload',
        name: 'DriverDocUpload',
        builder: (context, state) {
          return const DriverDocUpload();
        },
      ),



      /// Police Verification Service related routes (Mumbai)
      GoRoute(
        path: '/MumbaiPoliceSaveFormScreen1',
        name: "MumbaiPoliceSaveFormScreen1",
        builder: (context, state) {
          return const MumbaiPoliceSaveFormScreen1();
        },
      ),
      GoRoute(
        path: '/MumbaiPoliceUpdateFormScreen1/:uid',
        name: 'MumbaiPoliceUpdateFormScreen1',
        builder: (context, state) {
          final uid = state.pathParameters['uid']!;
          return MumbaiPoliceUpdateFormScreen1(
            uid: uid,
          );
        },
      ),
      GoRoute(
        path: '/UploadDocumentsMumbai',
        name: "UploadDocumentsMumbai",
        builder: (context, state) {
          return const UploadDocumentsMumbai();
        },
      ),
      GoRoute(
        path: '/MumbaiDocUpdate/:uid',
        name: 'MumbaiDocUpdate',
        builder: (context, state) {
          final uid = state.pathParameters['uid']!;
          return MumbaiDocUpdate(
            uid: uid,
          );
        },
      ),



      /// Police Verification Service related routes (Non Mumbai)
      GoRoute(
        path: '/NonMumbaiPoliceSaveFormScreen1',
        name: "NonMumbaiPoliceSaveFormScreen1",
        builder: (context, state) {
          return const NonMumbaiPoliceSaveFormScreen1();
        },
      ),
      GoRoute(
        path: '/NonMumbaiPoliceUpdateFormScreen1/:uid',
        name: 'NonMumbaiPoliceUpdateFormScreen1',
        builder: (context, state) {
          final uid = state.pathParameters['uid']!;
          return NonMumbaiPoliceUpdateFormScreen1(
            uid: uid,
          );
        },
      ),
      GoRoute(
        path: '/nonMumbaiUploadDoc',
        name: "nonMumbaiUploadDoc",
        builder: (context, state) {
          return const UploadDocumentsNonMumbai();
        },
      ),
      GoRoute(
        path: '/UpdateDocumentsNonMumbai/:uid',
        name: 'UpdateDocumentsNonMumbai',
        builder: (context, state) {
          final uid = state.pathParameters['uid']!;
          return UpdateDocumentsNonMumbai(
            uid: uid,
          );
        },
      ),




      /// Aadhaar Verification related routes
      GoRoute(
        path: '/aadhaarVerifyOtp/:number/:otp',
        name: "aadhaarVerifyOtp",
        builder: (context, state) {
          final aadhaarNumber = state.pathParameters['number']!;
          final otp = state.pathParameters['otp']!;
          return AadhaarVerifyOtp(
            number: aadhaarNumber,
            otp: otp,
          );
        },
      ),
      GoRoute(
        path: '/AadhaarGetOtp',
        name: "AadhaarGetOtp",
        builder: (context, state) {
          return AadhaarGetOtp();
        },
      ),

    ],
  );
}
