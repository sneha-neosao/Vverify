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
import 'package:v_verify/screen/ServicesAndPrice/CheckOut/Screen/check_out.dart';
import 'package:v_verify/screen/SplashScreen/SplashScreen.dart';

import 'package:v_verify/screen/VerificationPending/verifyRequestUpdate/verify_request_update_new.dart';
import '../screen/Add Signature/add_signature.dart';
import '../screen/OTP_Verify-Screen/otp_verify_screen.dart';
import '../screen/ProfileScreen/OtherScreen/Terms_conditions.dart';
import '../screen/ProfileScreen/OtherScreen/privacy_policy.dart';
import '../screen/ProfileScreen/OtherScreen/refund_policy.dart';
import '../screen/ProfileScreen/ProfilePage.dart';

import '../screen/VerificationForms/PoliceVerification/Mumbai/Form/Screens/Update/mumbai_police_update_form_screen1.dart';
import '../screen/VerificationForms/PoliceVerification/Mumbai/Document/Screens/mumbai_police_document_upload_screen.dart';
import '../screen/VerificationForms/PoliceVerification/Mumbai/Form/Screens/Save/mumbai_police_save_form_screen1.dart';
import '../screen/VerificationForms/PoliceVerification/Mumbai/Document/Screens/mumbai_police_document_update_screen.dart';
import '../screen/VerificationForms/PoliceVerification/NonMumbai/Form/Screens/Save/non_mumbai_police_save_form_screen1.dart';
import '../screen/VerificationForms/PoliceVerification/NonMumbai/Form/Screens/Update/non_mumbai_police_update_form_screen1.dart';
import '../screen/VerificationForms/PoliceVerification/NonMumbai/Document/Screens/non_mumbai_documents_update_screen.dart';
import '../screen/VerificationForms/PoliceVerification/NonMumbai/Document/Screens/non_mumbai_documents_upload_screen.dart';

import '../screen/VerificationPending/Pagination/pending_doc_Pagination.dart';
import '../screen/VerificationPending/Pagination/DashBoard/dashboard.dart';
import '../screen/VerificationPending/verifyRequestUpdate/verify_request_edit_form_new.dart';
import '../screen/AllFormList/FormList/form_list.dart';
import '../screen/AllFormList/FormList/widgets/file_view_screen.dart';
import '../screen/VerificationForms/common/Preview/preview.dart';

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
          final isEdit = state.uri.queryParameters['isEdit'] == 'true';
          final cartItemId = state.uri.queryParameters['cartItemId'];
          return ServicesAndPrice(
            entity_id: entityId,
            isEdit: isEdit,
            cartItemId: cartItemId,
          );
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
        path: '/checkOut',
        name: "checkOut",
        builder: (context, state) {
          return const CheckOutScreen();
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
        path: '/dashboard',
        name: "dashboard",
        builder: (context, state) {
          return const DashboardScreen();
        },
      ),
      GoRoute(
        path: '/PendingDoc',
        name: "PendingDoc",
        builder: (context, state) {
          final status = state.uri.queryParameters['status'];
          final groupIdStr = state.uri.queryParameters['groupId'];
          final entityIdStr = state.uri.queryParameters['entityId'];
          return PendingDocPagination(
            initialStatus: status,
            initialGroupId:
                groupIdStr != null ? int.tryParse(groupIdStr) : null,
            initialEntityId:
                entityIdStr != null ? int.tryParse(entityIdStr) : null,
          );
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
          return SignatureScreen();
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

      GoRoute(
        path: '/formList',
        name: "formList",
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return FormListScreen(
            applicantData: extra?['applicantData'],
            serviceNavigate: extra?['serviceNavigate'],
            serviceTitle: extra?['serviceTitle'],
          );
        },
      ),
      GoRoute(
        path: '/preview',
        name: "preview",
        builder: (context, state) {
          final url = state.extra as String? ?? "";
          return Preview(url: url);
        },
      ),
      GoRoute(
        path: '/fileView',
        name: "fileView",
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return FileViewScreen(
            filePath: extra['filePath'],
            fileName: extra['fileName'],
          );
        },
      ),
    ],
  );
}
