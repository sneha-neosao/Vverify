import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';

// Blocs/Cubits Imports
import 'package:v_verify/screen/Complete-Profile/Bloc/register_cubit.dart';
import 'package:v_verify/screen/OTP_Verify-Screen/bloc/otpVerify_cubit.dart';
import 'package:v_verify/screen/Home%20screen/bloc/home_screnn_cubit.dart';
import 'package:v_verify/screen/ServicesAndPrice/Blocs/service_prices_bloc/service_prices_cubit.dart';
import 'package:v_verify/screen/ServicesAndPrice/Blocs/checkout_bloc/checkout_cubit.dart';
import 'package:v_verify/screen/ServicesAndPrice/Blocs/apply_coupon_bloc/apply_coupon_cubit.dart';
import 'package:v_verify/screen/ServicesAndPrice/Blocs/chechout_status_checking_bloc/checkout_status_checking_cubit.dart';
import 'package:v_verify/screen/ServicesAndPrice/Blocs/all_entities_bloc/all_entities_cubit.dart';
import 'package:v_verify/screen/VerificationPending/Pagination/DashBoard/bloc/dashboard_entities_cubit.dart';
import 'package:v_verify/screen/VerificationPending/Pagination/DashBoard/bloc/dashboard_count_bloc.dart';
import 'package:v_verify/screen/VerificationPending/bloc/pendingDoc_cubit.dart';
import 'package:v_verify/screen/VerificationPending/Pagination/DashBoard/bloc/entity_services_cubit.dart';
import 'package:v_verify/screen/VerificationPending/Pagination/DashBoard/bloc/pending_doc_navigation_cubit.dart';
import 'package:v_verify/screen/ProfileScreen/bloc/sign_out_cubit.dart';
import 'package:v_verify/screen/EditProfile/bloc/editProfile_cubit.dart';
import 'package:v_verify/screen/VerificationPending/verifyRequestUpdate/Bloc/verify_request_update_cubit.dart';
import 'package:v_verify/screen/VerificationPending/bloc/verify_request_edit_cubit.dart';
import 'package:v_verify/screen/AllFormList/FormList/widgets/DrivingLicense/Bloc/driving_licence_save_form_bloc/driving_licence_save_form_bloc.dart';
import 'package:v_verify/screen/AllFormList/FormList/widgets/DrivingLicense/Bloc/driving_licence_show_details_bloc/driving_licence_show_details_cubit.dart';
import 'package:v_verify/screen/VerificationForms/VerifyDeatils/Bloc/verify_details_cubit.dart';
import 'package:v_verify/screen/VerificationPending/bloc/verify_report_bloc/verify_request_report_cubit.dart';
import 'package:v_verify/screen/Order%20History/bloc/order_history_cubit.dart';

// Screens Imports
import 'package:v_verify/screen/Bottom/bottomNavbar.dart';
import 'package:v_verify/screen/Complete-Profile/complete_profile.dart';
import 'package:v_verify/screen/EditProfile/edit_profile.dart';
import 'package:v_verify/screen/Home%20screen/home_page.dart';
import 'package:v_verify/screen/Login-Screen/login_screen.dart';
import 'package:v_verify/screen/Order%20Details/order_details.dart';
import 'package:v_verify/screen/Payment%20Successful/payment_successful.dart';
import 'package:v_verify/screen/ServicesAndPrice/Screens/services_and_price_screen.dart';
import 'package:v_verify/screen/ServicesAndPrice/CheckOut/Screen/check_out.dart';
import 'package:v_verify/screen/SplashScreen/SplashScreen.dart';
import 'package:v_verify/screen/VerificationPending/verifyRequestUpdate/verify_request_update_new.dart';

import 'package:v_verify/screen/Add%20Signature/add_signature.dart';
import 'package:v_verify/screen/OTP_Verify-Screen/otp_verify_screen.dart';
import 'package:v_verify/screen/ProfileScreen/OtherScreen/Terms_conditions.dart';
import 'package:v_verify/screen/ProfileScreen/OtherScreen/privacy_policy.dart';
import 'package:v_verify/screen/ProfileScreen/OtherScreen/refund_policy.dart';
import 'package:v_verify/screen/ProfileScreen/ProfilePage.dart';
import 'package:v_verify/screen/VerificationPending/Pagination/pending_doc_Pagination.dart';
import 'package:v_verify/screen/VerificationPending/Pagination/DashBoard/dashboard.dart';
import 'package:v_verify/screen/VerificationPending/verifyRequestUpdate/verify_request_edit_form_new.dart';
import 'package:v_verify/screen/AllFormList/FormList/form_list.dart';
import 'package:v_verify/screen/AllFormList/FormList/widgets/file_view_screen.dart';
import 'package:v_verify/screen/VerificationForms/common/Preview/preview.dart';

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
          return BlocProvider<OtpVerifyCubit>(
            create: (_) => OtpVerifyCubit(ApiService()),
            child: OtpVerifyScreen(mobileNum: mobileNumber),
          );
        },
      ),
      GoRoute(
        path: '/completeProfile/:mobileNumber',
        name: "completeProfile",
        builder: (context, state) {
          final mobileNumber = state.pathParameters['mobileNumber']!;
          return BlocProvider<RegisterCubit>(
            create: (_) => RegisterCubit(ApiService()),
            child: CompleteProfile(mobileNum: mobileNumber),
          );
        },
      ),

      /// Common routes
      GoRoute(
        path: '/homeScreen',
        name: "homeScreen",
        builder: (context, state) {
          return BlocProvider<HomeScreenCubit>(
            create: (_) => HomeScreenCubit(ApiService()),
            child: HomeScreen(),
          );
        },
      ),

      GoRoute(
        path: '/bottomNav',
        name: "bottomNav",
        builder: (context, state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<HomeScreenCubit>(
                  create: (_) => HomeScreenCubit(ApiService())),
              BlocProvider<PendingDocCubit>(
                  create: (_) => PendingDocCubit(ApiService())),
              BlocProvider<EntityServicesCubit>(
                  create: (_) => EntityServicesCubit(ApiService())),
              BlocProvider<PendingDocNavigationCubit>(
                  create: (_) => PendingDocNavigationCubit()),
              BlocProvider<AllEntitiesCubit>(
                  create: (_) => AllEntitiesCubit(ApiService())),
              BlocProvider<IsPressedCubit>(create: (_) => IsPressedCubit()),
              BlocProvider<VerifyRequestReportCubit>(
                  create: (_) => VerifyRequestReportCubit(ApiService())),
              BlocProvider<VerifyRequestUpdateCubit>(
                  create: (_) => VerifyRequestUpdateCubit(ApiService())),
              BlocProvider<SignOutCubit>(
                  create: (_) => SignOutCubit(ApiService())),
              BlocProvider<CountCubit>(create: (_) => CountCubit()),
              BlocProvider<DashboardEntitiesCubit>(
                  create: (_) => DashboardEntitiesCubit(ApiService())),
              BlocProvider<DashboardCountBloc>(
                  create: (_) => DashboardCountBloc(ApiService())),
              BlocProvider<OrderHistoryCubit>(
                  create: (_) => OrderHistoryCubit(ApiService())),
            ],
            child: BottomNavigationScreen(),
          );
        },
      ),
      GoRoute(
        path: '/servicesAndPrice/:id',
        name: "servicesAndPrice",
        builder: (context, state) {
          final entityId = state.pathParameters['id']!;
          final isEdit = state.uri.queryParameters['isEdit'] == 'true';
          final cartItemId = state.uri.queryParameters['cartItemId'];
          return MultiBlocProvider(
            providers: [
              BlocProvider<ServicePriceCubit>(
                  create: (_) => ServicePriceCubit(ApiService())),
              BlocProvider<CountCubit>(create: (_) => CountCubit()),
              BlocProvider<AllEntitiesCubit>(
                  create: (_) => AllEntitiesCubit(ApiService())),
              BlocProvider<SelectItemCubit>(create: (_) => SelectItemCubit()),
              BlocProvider<CheckOutStatusCheckingCubit>(
                  create: (_) => CheckOutStatusCheckingCubit(ApiService())),
              BlocProvider<CheckoutCubit>(
                  create: (_) => CheckoutCubit(ApiService())),
            ],
            child: ServicesAndPrice(
              entity_id: entityId,
              isEdit: isEdit,
              cartItemId: cartItemId,
            ),
          );
        },
      ),
      GoRoute(
        path: '/paymentSuccess',
        name: "payment_success",
        builder: (context, state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<AllEntitiesCubit>(
                  create: (_) => AllEntitiesCubit(ApiService())),
              BlocProvider<DashboardEntitiesCubit>(
                  create: (_) => DashboardEntitiesCubit(ApiService())),
              BlocProvider<DashboardCountBloc>(
                  create: (_) => DashboardCountBloc(ApiService())),
            ],
            child: const PaymentSuccessful(),
          );
        },
      ),
      GoRoute(
        path: '/checkOut',
        name: "checkOut",
        builder: (context, state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<CheckoutCubit>(
                  create: (_) => CheckoutCubit(ApiService())),
              BlocProvider<ApplyCouponCubit>(
                  create: (_) => ApplyCouponCubit(ApiService())),
              BlocProvider<AllEntitiesCubit>(
                  create: (_) => AllEntitiesCubit(ApiService())),
              BlocProvider<CheckOutStatusCheckingCubit>(
                  create: (_) => CheckOutStatusCheckingCubit(ApiService())),
              BlocProvider<DashboardEntitiesCubit>(
                  create: (_) => DashboardEntitiesCubit(ApiService())),
              BlocProvider<DashboardCountBloc>(
                  create: (_) => DashboardCountBloc(ApiService())),
            ],
            child: const CheckOutScreen(),
          );
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
          return MultiBlocProvider(
            providers: [
              BlocProvider<DashboardEntitiesCubit>(
                  create: (_) => DashboardEntitiesCubit(ApiService())),
              BlocProvider<DashboardCountBloc>(
                  create: (_) => DashboardCountBloc(ApiService())),
            ],
            child: const DashboardScreen(),
          );
        },
      ),
      GoRoute(
        path: '/PendingDoc',
        name: "PendingDoc",
        builder: (context, state) {
          final status = state.uri.queryParameters['status'];
          final groupIdStr = state.uri.queryParameters['groupId'];
          final entityIdStr = state.uri.queryParameters['entityId'];
          return MultiBlocProvider(
            providers: [
              BlocProvider<PendingDocCubit>(
                  create: (_) => PendingDocCubit(ApiService())),
              BlocProvider<EntityServicesCubit>(
                  create: (_) => EntityServicesCubit(ApiService())),
              BlocProvider<PendingDocNavigationCubit>(
                  create: (_) => PendingDocNavigationCubit()),
              BlocProvider<AllEntitiesCubit>(
                  create: (_) => AllEntitiesCubit(ApiService())),
              BlocProvider<IsPressedCubit>(create: (_) => IsPressedCubit()),
              BlocProvider<VerifyRequestReportCubit>(
                  create: (_) => VerifyRequestReportCubit(ApiService())),
              BlocProvider<VerifyRequestUpdateCubit>(
                  create: (_) => VerifyRequestUpdateCubit(ApiService())),
            ],
            child: PendingDocPagination(
              initialStatus: status,
              initialGroupId:
                  groupIdStr != null ? int.tryParse(groupIdStr) : null,
              initialEntityId:
                  entityIdStr != null ? int.tryParse(entityIdStr) : null,
            ),
          );
        },
      ),
      GoRoute(
        path: '/ProfilePage',
        name: "ProfilePage",
        builder: (context, state) {
          return BlocProvider<SignOutCubit>(
            create: (_) => SignOutCubit(ApiService()),
            child: const ProfilePage(),
          );
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
          return MultiBlocProvider(
            providers: [
              BlocProvider<EditProfileCubit>(
                  create: (_) => EditProfileCubit(ApiService())),
              BlocProvider<PickImageCubit>(create: (_) => PickImageCubit()),
            ],
            child: EditProfile(
              user_type: userTypeStr,
            ),
          );
        },
      ),

      ///Verification Request related routes
      GoRoute(
        path: '/verifyRequestUpdateNew/:uuid/:service_title',
        name: "verifyRequestUpdateNew",
        builder: (context, state) {
          final uuid = state.pathParameters['uuid']!;
          final serviceTitle = state.pathParameters['service_title']!;
          return BlocProvider<VerifyRequestUpdateCubit>(
            create: (_) => VerifyRequestUpdateCubit(ApiService()),
            child: VerifyRequestUpdateNew(
              uuid: uuid,
              service_title: serviceTitle,
            ),
          );
        },
      ),
      GoRoute(
        path: '/VerifyRequestEditFormNew/:request_id/:uuid/:service_title',
        name: "VerifyRequestEditFormNew",
        builder: (context, state) {
          final requestId = state.pathParameters['request_id']!;
          final uuid = state.pathParameters['uuid']!;
          final serviceTitle = state.pathParameters['service_title']!;
          return MultiBlocProvider(
            providers: [
              BlocProvider<VerifyRequestEditCubit>(
                  create: (_) => VerifyRequestEditCubit(ApiService())),
              BlocProvider<VerifyDetailsCubit>(
                  create: (_) => VerifyDetailsCubit(ApiService())),
            ],
            child: VerifyRequestEditFormNew(
              request_id: requestId,
              uuid: uuid,
              service_title: serviceTitle,
            ),
          );
        },
      ),

      GoRoute(
        path: '/formList',
        name: "formList",
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return MultiBlocProvider(
            providers: [
              BlocProvider<DrivingLicenceBloc>(
                  create: (_) => DrivingLicenceBloc(ApiService())),
              BlocProvider<DrivingLicenceShowDataCubit>(
                  create: (_) => DrivingLicenceShowDataCubit(ApiService())),
            ],
            child: FormListScreen(
              applicantData: extra?['applicantData'],
              serviceNavigate: extra?['serviceNavigate'],
              serviceTitle: extra?['serviceTitle'],
            ),
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
