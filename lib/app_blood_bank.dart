import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:blood_bank/feature/localization/cubit/locale_cubit.dart';
import 'package:blood_bank/feature/notification/notification_service.dart';
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

class SplashInitializer extends StatefulWidget {
  const SplashInitializer({super.key});

  @override
  State<SplashInitializer> createState() => _SplashInitializerState();
}

class _SplashInitializerState extends State<SplashInitializer> {
  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    await NotificationService.instance.initialize(context);
  }

  @override
  Widget build(BuildContext context) {
    return SplashView();
  }
}
