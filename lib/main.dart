import 'package:blood_bank/core/services/custom_block_observer.dart';
import 'package:blood_bank/core/services/get_it_service.dart';
import 'package:blood_bank/core/services/shared_preferences_sengleton.dart';
import 'package:blood_bank/feature/localization/cubit/locale_cubit.dart';
import 'package:blood_bank/feature/notification/notification_service.dart';
import 'package:blood_bank/feature/splash/presentation/views/splash_view.dart';
import 'package:blood_bank/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'feature/localization/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService.instance.initialize();

  // await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  await Prefs.init();
  setupGetit();
  Bloc.observer = CustomBlockObserver();
  runApp(const BloodBank());
}

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
            theme: ThemeData(fontFamily: 'iwanzaza'),
            locale: state.locale,
            supportedLocales: const [Locale('en'), Locale('ar')],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate
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
            home: SplashView(),
          );
        },
      ),
    );
  }
}
