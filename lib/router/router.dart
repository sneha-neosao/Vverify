import 'package:go_router/go_router.dart';
import 'package:v_verify/screen/Bottom/bottomNavbar.dart';
import 'package:v_verify/screen/Complete-Profile/complete_profile.dart';
import 'package:v_verify/screen/EditProfile/edit_profile.dart';
import 'package:v_verify/screen/Home%20screen/home_page.dart';
import 'package:v_verify/screen/Login-Screen/login_screen.dart';
import 'package:v_verify/screen/Order%20Details/order_details.dart';
import 'package:v_verify/screen/Payment%20Successful/payment_successful.dart';
import 'package:v_verify/screen/ServicesAndPrice/services_and_price.dart';
import 'package:v_verify/screen/SplashScreen/SplashScreen.dart';
import 'package:v_verify/screen/VerificationForms/EducationVerification/SaveForm/education_save_form_new.dart';
import 'package:v_verify/screen/VerificationForms/EducationVerification/Update/education_save_form_update_new.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentForm/Save/Form/EmploymentSaveFormNew.dart';
import 'package:v_verify/screen/VerificationForms/NameAddressVerificationForm/Save/address_varification_form_new.dart';
import 'package:v_verify/screen/VerificationPending/verifyRequestUpdate/verify_request_update_new.dart';

import '../screen/Add Signature/add_signature.dart';
import '../screen/OTP_Verify-Screen/otp_verify_screen.dart';
import '../screen/Order History/order_history.dart';
import '../screen/ProfileScreen/OtherScreen/Terms_conditions.dart';
import '../screen/ProfileScreen/OtherScreen/privacy_policy.dart';
import '../screen/ProfileScreen/OtherScreen/refund_policy.dart';
import '../screen/ProfileScreen/ProfilePage.dart';
import '../screen/VerificationForms/AadhaarVerification/AadhaarGetOtp/aadhaar_verification.dart';
import '../screen/VerificationForms/AadhaarVerification/AadhaarVerifyOtp/AadhaarVerifyOtp.dart';
import '../screen/VerificationForms/DrvingLicence/Document/update/driving_doc_update.dart';
import '../screen/VerificationForms/DrvingLicence/Document/upload/driver_doc_upload.dart';
import '../screen/VerificationForms/DrvingLicence/Update/driving_licence_update.dart';
import '../screen/VerificationForms/DrvingLicence/driving_licence.dart';
import '../screen/VerificationForms/EducationVerification/DocUpdate/education_doc_update.dart';
import '../screen/VerificationForms/EducationVerification/EducationDocUpload/EducationDocUpload.dart';
import '../screen/VerificationForms/EducationVerification/EducationList/EducationList.dart';
import '../screen/VerificationForms/EducationVerification/SaveForm/education_save_form.dart';
import '../screen/VerificationForms/EducationVerification/Update/education_save_form1_update.dart';
import '../screen/VerificationForms/EmploymentForm/EmployList/employ_data_list.dart';
import '../screen/VerificationForms/EmploymentForm/Save/Form/EmploymentSaveForm.dart';
import '../screen/VerificationForms/EmploymentForm/Save/Form/EmploymentSaveForm2.dart';
import '../screen/VerificationForms/EmploymentForm/Save/Form/employmentSaveForm3.dart';
import '../screen/VerificationForms/EmploymentForm/Update/employmentUpdateForm1.dart';
import '../screen/VerificationForms/EmploymentForm/UploadDoc/employment_upload_document.dart';
import '../screen/VerificationForms/EmploymentForm/employUpdateDoc/employ_update_doc.dart';
import '../screen/VerificationForms/GST_TIN_CIN/Documents/update/gst_pan_cin_doc_update.dart';
import '../screen/VerificationForms/GST_TIN_CIN/Documents/upload/gst_pan_cin_doc_upload.dart';
import '../screen/VerificationForms/GST_TIN_CIN/Save/gst_pan_cin_screen.dart';
import '../screen/VerificationForms/GST_TIN_CIN/Update/gst_pan_cin_update_screen.dart';
import '../screen/VerificationForms/NameAddressVerificationForm/Documents/DocUpdate/name_address_doc_update.dart';
import '../screen/VerificationForms/NameAddressVerificationForm/Documents/DocUpload/name_address_doc_upload.dart';
import '../screen/VerificationForms/NameAddressVerificationForm/Save/name_address_verification_form.dart';
import '../screen/VerificationForms/NameAddressVerificationForm/Update/name_address_verification_update.dart';
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
import '../screen/VerificationPending/verifyRequestUpdate/verify_request_update.dart';

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

      // GoRoute(
      //   path: '/OrderHistory',
      //   name: "order_history",
      //   builder: (context, state) {
      //     return const OrderHistory();
      //   },
      // ),
      GoRoute(
        path: '/EditProfile',
        name: "edit_profile",
        builder: (context, state) {
          return EditProfile();
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
      // GoRoute(
      //   path: '/NameAddressVerificationForm',
      //   name: "NameAddressVerificationForm",
      //   builder: (context, state) {
      //     return const NameAddressVerificationForm();
      //   },
      // ),
      GoRoute(
        path: '/NameAddressVerificationFormNew',
        name: "NameAddressVerificationFormNew",
        builder: (context, state) {
          return const NameAddressVerificationFormNew();
        },
      ),
      GoRoute(
        path: '/EmploymentUploadDocument',
        name: "EmploymentUploadDocument",
        builder: (context, state) {
          return const EmploymentUploadDocument();
        },
      ),
      GoRoute(
        path: '/EmploymentSaveFormNew',
        name: "EmploymentSaveFormNew",
        builder: (context, state) {
          return const EmploymentSaveFormNew();
        },
      ),
      GoRoute(
        path: '/EmploymentSaveForm',
        name: "EmploymentSaveForm",
        builder: (context, state) {
          return const EmploymentSaveForm();
        },
      ),
      GoRoute(
        path: '/EmploymentSaveForm2',
        name: "EmploymentSaveForm2",
        builder: (context, state) {
          return const EmploymentSaveForm2();
        },
      ),
      GoRoute(
        path: '/EmploymentSaveForm3',
        name: "EmploymentSaveForm3",
        builder: (context, state) {
          return const EmploymentSaveForm3();
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
      // GoRoute(
      //   path: '/EducationSaveForm',
      //   name: "EducationSaveForm",
      //   builder: (context, state) {
      //     return const EducationSaveForm();
      //   },
      // ),
      GoRoute(
        path: '/EducationSaveFormNew',
        name: "EducationSaveFormNew",
        builder: (context, state) {
          return const EducationSaveFormNew();
        },
      ),
      GoRoute(
        path: '/EducationDocUpload',
        name: "EducationDocUpload",
        builder: (context, state) {
          return const EducationDocUpload();
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
      // GoRoute(
      //   path: '/EducationSaveForm1Update/:uid',
      //   name: 'EducationSaveForm1Update',
      //   builder: (context, state) {
      //     final uid = state.pathParameters['uid']!;
      //     return EducationSaveForm1Update(
      //       uid: uid,
      //     );
      //   },
      // ),
      GoRoute(
        path: '/EducationSaveFormUpdateNew/:uid',
        name: 'EducationSaveFormUpdateNew',
        builder: (context, state) {
          final uid = state.pathParameters['uid']!;
          return EducationSaveFormUpdateNew(
            uid: uid,
          );
        },
      ),
      GoRoute(
        path: '/EmploymentUpdateForm1/:uid',
        name: 'EmploymentUpdateForm1',
        builder: (context, state) {
          final uid = state.pathParameters['uid']!;
          return EmploymentUpdateForm1(
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
        path: '/EducationDocUpdate/:uid',
        name: 'EducationDocUpdate',
        builder: (context, state) {
          final uid = state.pathParameters['uid']!;
          return EducationDocUpdate(
            uid: uid,
          );
        },
      ),
      GoRoute(
        path: '/EmployUpdateDoc/:uid',
        name: 'EmployUpdateDoc',
        builder: (context, state) {
          final uid = state.pathParameters['uid']!;
          return EmployUpdateDoc(
            uid: uid,
          );
        },
      ),
      GoRoute(
        path: '/NameAddressVerificationUpdate/:uid',
        name: 'NameAddressVerificationUpdate',
        builder: (context, state) {
          final uid = state.pathParameters['uid']!;
          return NameAddressVerificationUpdate(
            uid: uid,
          );
        },
      ),
      GoRoute(
        path: '/EducationList',
        name: 'EducationList',
        builder: (context, state) {
          return const EducationList();
        },
      ),
      GoRoute(
        path: '/EmployDataList',
        name: 'EmployDataList',
        builder: (context, state) {
          return const EmployDataList();
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
        path: '/NameAddressDocUpload',
        name: 'NameAddressDocUpload',
        builder: (context, state) {
          return NameAddressDocUpload();
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
        path: '/NameAddressDocUpdate/:uid',
        name: 'NameAddressDocUpdate',
        builder: (context, state) {
          final uid = state.pathParameters['uid']!;
          return NameAddressDocUpdate(
            uid: uid,
          );
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
