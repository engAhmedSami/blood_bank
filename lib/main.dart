import 'package:blood_bank/app_blood_bank.dart';
import 'package:blood_bank/core/services/sql_helper_health_request.dart';
import 'package:blood_bank/core/services/custom_block_observer.dart';
import 'package:blood_bank/core/services/get_it_service.dart';
import 'package:blood_bank/core/services/shared_preferences_sengleton.dart';
import 'package:blood_bank/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Prefs.init();
  setupGetit();
  Bloc.observer = CustomBlockObserver();
  await SQlHelperHealthRequest().database;

  runApp(const BloodBank());
}
