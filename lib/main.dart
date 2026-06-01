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
import 'package:v_verify/screen/Login-Screen/bloc/login_cubit.dart';
import 'package:v_verify/screen/ProfileScreen/bloc/profile_cubit.dart';
import 'package:v_verify/screen/PushNotification/Bloc/push_notification_cubit.dart';
import 'package:v_verify/screen/PushNotification/push_notification.dart';
import 'package:v_verify/theme/theme_cubit.dart';
import 'package:v_verify/theme/theme_data.dart';
import 'firebase_options.dart';

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

    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light));
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
        BlocProvider<LoginCubit>(create: (_) => LoginCubit(ApiService())),
        BlocProvider<ProfileCubit>(create: (_) => ProfileCubit(ApiService())),
        BlocProvider<TokenCubit>(create: (_) => TokenCubit()),
        BlocProvider<IdCubit>(create: (_) => IdCubit()),
        BlocProvider<UserTypeId>(create: (_) => UserTypeId()),
        BlocProvider<PushNotificationCubit>(
            create: (_) => PushNotificationCubit(ApiService())),
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
