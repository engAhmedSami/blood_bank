// import 'package:blood_bank/feature/localization/app_localizations.dart';
// import 'package:blood_bank/feature/localization/cubit/locale_cubit.dart';
// import 'package:blood_bank/feature/splash/Presentation/views/SplashInitializer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';

// class BloodBank extends StatelessWidget {
//   const BloodBank({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (context) => LocaleCubit()..getSavedLanguage(),
//         ),
//       ],
//       child: BlocBuilder<LocaleCubit, ChangeLocaleState>(
//         builder: (context, state) {
//           return MaterialApp(
//             theme: ThemeData(fontFamily: 'iwanzaza'),
//             locale: state.locale,
//             supportedLocales: const [Locale('en'), Locale('ar')],
//             localizationsDelegates: const [
//               AppLocalizations.delegate,
//               GlobalMaterialLocalizations.delegate,
//               GlobalWidgetsLocalizations.delegate,
//               GlobalCupertinoLocalizations.delegate,
//             ],
//             localeResolutionCallback: (deviceLocale, supportedLocales) {
//               for (var locale in supportedLocales) {
//                 if (deviceLocale != null &&
//                     deviceLocale.languageCode == locale.languageCode) {
//                   return deviceLocale;
//                 }
//               }

//               return supportedLocales.first;
//             },
//             debugShowCheckedModeBanner: false,
//             home: const SplashInitializer(),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:blood_bank/core/widget/UserBlockedScreen.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:blood_bank/feature/localization/cubit/locale_cubit.dart';
import 'package:blood_bank/feature/splash/Presentation/views/SplashInitializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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
            theme: ThemeData(fontFamily: 'iwanzaza'),
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
            home: FutureBuilder<String>(
              future: FirestoreService.getUserState(
                  FirebaseAuth.instance.currentUser!.uid), // Pass the user ID
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SplashInitializer();
                }

                if (snapshot.hasData && snapshot.data == "blocked") {
                  return const UserBlockedScreen();
                }

                return const SplashInitializer(); // Proceed to your app's main logic
              },
            ),
          );
        },
      ),
    );
  }
}

class FirestoreService {
  static Future<String> getUserState(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users') // Your Firestore collection
          .doc(userId)
          .get();

      if (userDoc.exists) {
        return userDoc.data()?['UserStatusAccessRule'] ?? 'allowedUser';
      } else {
        return 'allowedUser'; // Default state if user document does not exist
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user state: $e');
      }
      return 'allowed'; // Handle error gracefully
    }
  }
}
