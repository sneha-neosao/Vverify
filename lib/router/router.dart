import 'package:go_router/go_router.dart';
import 'package:v_verify/screen/Bottom/bottomNavbar.dart';
import 'package:v_verify/screen/Complete-Profile/complete_profile.dart';
import 'package:v_verify/screen/EditProfile/edit_profile.dart';
import 'package:v_verify/screen/Home%20screen/home_page.dart';
import 'package:v_verify/screen/Login-Screen/login_screen.dart';
import 'package:v_verify/screen/Order%20Details/order_details.dart';
import 'package:v_verify/screen/Payment%20Successful/payment_successful.dart';
import 'package:v_verify/screen/ServicesAndPrice/apply_coupon_screen.dart';
import 'package:v_verify/screen/ServicesAndPrice/services_and_price.dart';
import 'package:v_verify/screen/SplashScreen/SplashScreen.dart';
import 'package:v_verify/screen/VerificationForms/AddressVerificationForm/Documents/Screens/address_documnet_upload_screen.dart';
import 'package:v_verify/screen/VerificationForms/AddressVerificationForm/List/Screens/address_list.dart';
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
import '../screen/VerificationForms/DrvingLicence/Document/update/driving_doc_update.dart';
import '../screen/VerificationForms/DrvingLicence/Document/upload/driver_doc_upload.dart';
import '../screen/VerificationForms/DrvingLicence/Update/driving_licence_update.dart';
import '../screen/VerificationForms/DrvingLicence/driving_licence.dart';
import '../screen/VerificationForms/EducationVerification/List/Screens/education_list.dart';
import '../screen/VerificationForms/EducationVerification/Documents/Screens/education_document_upload_screen.dart';
import '../screen/VerificationForms/EducationVerification/Form/Screens/education_save_form_screen.dart';
import '../screen/VerificationForms/GST_TIN_CIN/Documents/update/gst_pan_cin_doc_update.dart';
import '../screen/VerificationForms/GST_TIN_CIN/Documents/upload/gst_pan_cin_doc_upload.dart';
import '../screen/VerificationForms/GST_TIN_CIN/Save/gst_pan_cin_screen.dart';
import '../screen/VerificationForms/GST_TIN_CIN/Update/gst_pan_cin_update_screen.dart';
import '../screen/VerificationForms/PanVerification/save/pan_verification_save.dart';
import '../screen/VerificationForms/PanVerification/update/pan_verification_update.dart';
import '../screen/VerificationForms/PoliceVerification/Mumbai/UpdateForm/MumbaiPoliceVerificationUpdateForm1.dart';
import '../screen/VerificationForms/PoliceVerification/Mumbai/UploadDocuments/upload_documents_Mumbai.dart';
import '../screen/VerificationForms/PoliceVerification/Mumbai/forms/MumbaiPoliceVerificationForm1.dart';
import '../screen/VerificationForms/PoliceVerification/Mumbai/updateDocuments/mumbai_doc_update.dart';
import '../screen/VerificationForms/PoliceVerification/NonMumbai/Forms/NonMumbaiPoliceVerification.dart';
import '../screen/VerificationForms/PoliceVerification/NonMumbai/Update/NonMumbaiPoliceVerificationForm1Update.dart';
import '../screen/VerificationForms/PoliceVerification/NonMumbai/UpdateDocument/update_documents_non_mumbai.dart';
import '../screen/VerificationForms/PoliceVerification/NonMumbai/UploadDocuments/upload_documents_nonMumbai.dart';
import '../screen/VerificationForms/ReferenceForm/DocUpload/UpdateDoc/reference_doc_update.dart';
import '../screen/VerificationForms/ReferenceForm/DocUpload/uploadDoc/reference_upload_doc.dart';
import '../screen/VerificationForms/ReferenceForm/Save/reference_form.dart';
import '../screen/VerificationForms/ReferenceForm/Update/Reference_form_update.dart';
import '../screen/VerificationForms/courtVerification/court_verification.dart';
import '../screen/VerificationForms/courtVerification/documents/updateDoc/court_doc_update.dart';
import '../screen/VerificationForms/courtVerification/documents/uploadDoc/court_doc_upload.dart';
import '../screen/VerificationForms/courtVerification/update/court_verification_update.dart';
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
        path: '/login',
        name: "login",
        builder: (context, state) {
          return LoginScreen();
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
        path: '/VerifyRequestEditFormNew/:request_id/:uuid',
        name: "VerifyRequestEditFormNew",
        builder: (context, state) {
          final requestId = state.pathParameters['request_id']!;
          final uuid = state.pathParameters['uuid']!;
          return VerifyRequestEditFormNew(
              request_id: requestId,
              uuid: uuid,
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
        path: '/ApplyCouponScreen',
        name: "ApplyCouponScreen",
        builder: (context, state) {
          return ApplyCouponScreen();
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

      GoRoute(
        path: '/nonMumbaiForm',
        name: "nonMumbaiForm",
        builder: (context, state) {
          return const NonMumbaiPoliceVerification();
        },
      ),

      GoRoute(
        path: '/MumbaiForm',
        name: "MumbaiForm",
        builder: (context, state) {
          return const MumbaiPoliceVerificationForm1();
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
        path: '/UploadDocumentsMumbai',
        name: "UploadDocumentsMumbai",
        builder: (context, state) {
          return const UploadDocumentsMumbai();
        },
      ),

      // GoRoute(
      //   path: '/verifyRequestUpdate/:uuid',
      //   name: "verifyRequestUpdate",
      //   builder: (context, state) {
      //     final uuid = state.pathParameters['uuid']!;
      //     return VerifyRequestUpdate(
      //       uuid: uuid,
      //     );
      //   },
      // ),
      GoRoute(
        path: '/verifyRequestUpdateNew/:uuid',
        name: "verifyRequestUpdateNew",
        builder: (context, state) {
          final uuid = state.pathParameters['uuid']!;
          return VerifyRequestUpdateNew(
            uuid: uuid,
          );
        },
      ),




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
      GoRoute(
        path: '/ReferenceForm',
        name: "ReferenceForm",
        builder: (context, state) {
          return const ReferenceForm();
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
        path: '/ReferenceFormUpdate/:uid',
        name: 'ReferenceFormUpdate',
        builder: (context, state) {
          final uid = state.pathParameters['uid']!;
          return ReferenceFormUpdate(
            uid: uid,
          );
        },
      ),
      GoRoute(
        path: '/MumbaiPoliceVerificationUpdateForm1/:uid',
        name: 'MumbaiPoliceVerificationUpdateForm1',
        builder: (context, state) {
          final uid = state.pathParameters['uid']!;
          return MumbaiPoliceVerificationUpdateForm1(
            uid: uid,
          );
        },
      ),
      GoRoute(
        path: '/NonMumbaiPoliceVerificationForm1Update/:uid',
        name: 'NonMumbaiPoliceVerificationForm1Update',
        builder: (context, state) {
          final uid = state.pathParameters['uid']!;
          return NonMumbaiPoliceVerificationForm1Update(
            uid: uid,
          );
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

      GoRoute(
        path: '/DrivingLicence',
        name: 'DrivingLicence',
        builder: (context, state) {
          return const DrivingLicence();
        },
      ),

      GoRoute(
        path: '/DrivingLicenceUpdate/:uid',
        name: 'DrivingLicenceUpdate',
        builder: (context, state) {
          final uid = state.pathParameters['uid']!;
          return DrivingLicenceUpdate(
            uid: uid,
          );
        },
      ),
      GoRoute(
        path: '/GstPanCinUpdateScreen/:uid',
        name: 'GstPanCinUpdateScreen',
        builder: (context, state) {
          final uid = state.pathParameters['uid']!;
          return GstPanCinUpdateScreen(
            uid: uid,
          );
        },
      ),
      GoRoute(
        path: '/GstPanCinScreen',
        name: 'GstPanCinScreen',
        builder: (context, state) {
          return const GstPanCinScreen();
        },
      ),
      GoRoute(
        path: '/CourtVerification',
        name: 'CourtVerification',
        builder: (context, state) {
          return const CourtVerification();
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
        path: '/CourtVerificationUpdate/:uid',
        name: 'CourtVerificationUpdate',
        builder: (context, state) {
          final uid = state.pathParameters['uid']!;
          return CourtVerificationUpdate(
            uid: uid,
          );
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
      GoRoute(
        path: '/CourtDocUpdate/:uid',
        name: 'CourtDocUpdate',
        builder: (context, state) {
          final uid = state.pathParameters['uid']!;
          return CourtDocUpdate(
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
        path: '/PanVerificationUpdate/:uid',
        name: 'PanVerificationUpdate',
        builder: (context, state) {
          final uid = state.pathParameters['uid']!;
          return PanVerificationUpdate(
            uid: uid,
          );
        },
      ),

      GoRoute(
        path: '/CourtDocUpload',
        name: 'CourtDocUpload',
        builder: (context, state) {
          return const CourtDocUpload();
        },
      ),
      GoRoute(
        path: '/DriverDocUpload',
        name: 'DriverDocUpload',
        builder: (context, state) {
          return const DriverDocUpload();
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
      // GoRoute(
      //   path: '/PostsView',
      //   name: 'PostsView',
      //   builder: (context, state) {
      //     return  PostsView();
      //   },
      // ),
      GoRoute(
        path: '/SignatureScreen',
        name: 'SignatureScreen',
        builder: (context, state) {
          return  SignatureScreen();
        },
      ),
      GoRoute(
        path: '/PanVerificationSave',
        name: 'PanVerificationSave',
        builder: (context, state) {
          return  const PanVerificationSave();
        },
      ),
    ],
  );
}
