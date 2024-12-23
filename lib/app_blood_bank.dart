import 'package:blood_bank/feature/UserStatusCubit.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:blood_bank/feature/localization/cubit/locale_cubit.dart';
import 'package:blood_bank/feature/splash/presentation/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class BloodBank extends StatelessWidget {
  const BloodBank({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LocaleCubit()..getSavedLanguage(),
        ),
        BlocProvider(
          create: (context) => UserStatusCubit(),
        ),
      ],
      child: BlocBuilder<LocaleCubit, ChangeLocaleState>(
        builder: (context, state) {
          return MaterialApp(
            theme: ThemeData(
              fontFamily: 'iwanzaza',
            ),
            locale: state.locale,
            supportedLocales: const [Locale('en'), Locale('ar')],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (deviceLocale, supportedLocales) {
              for (var locale in supportedLocales) {
                if (deviceLocale != null &&
                    deviceLocale.languageCode == locale.languageCode) {
                  return deviceLocale;
                }
              }

              return supportedLocales.first;
            },
            debugShowCheckedModeBanner: false,
            home: const SplashInitializer(),
          );
        },
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class UserBlockedScreen extends StatelessWidget {
  const UserBlockedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [Center(child: Text('UserBlockedScreen'))],
      ),
    );
  }
}

class SplashInitializer extends StatefulWidget {
  const SplashInitializer({super.key});

  @override
  State<SplashInitializer> createState() => _SplashInitializerState();
}

class _SplashInitializerState extends State<SplashInitializer> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {}

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserStatusCubit, String?>(
      builder: (context, status) {
        if (status == null) {
          // لا يوجد مستخدم أو خطأ في التحميل -> الانتقال إلى SplashView
          return const SplashView();
        } else if (status == 'block') {
          // المستخدم محظور
          return const UserBlockedScreen();
        } else {
          // المستخدم مسموح له بالدخول
          return const SplashView();
        }
      },
    );
  }
}
