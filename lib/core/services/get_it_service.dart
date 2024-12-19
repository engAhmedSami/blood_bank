import 'package:blood_bank/core/services/data_service.dart';
import 'package:blood_bank/core/services/fire_storage.dart';
import 'package:blood_bank/core/services/firebase_auth_service.dart';
import 'package:blood_bank/core/services/firestor_service.dart';
import 'package:blood_bank/core/services/storage_service.dart';
import 'package:blood_bank/feature/auth/data/repos/auth_repo_impl.dart';
import 'package:blood_bank/feature/auth/domain/repos/auth_repo.dart';
import 'package:blood_bank/feature/home/data/repos/doner_repo_impl.dart';
import 'package:blood_bank/feature/home/data/repos/needer_repo_impl.dart';
import 'package:blood_bank/feature/home/domain/repos/doner_repo.dart';
import 'package:blood_bank/feature/home/domain/repos/needer_repo.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupGetit() {
  getIt.registerSingleton<FirebaseAuthService>(FirebaseAuthService());
  getIt.registerSingleton<DatabaseService>(FirestorService());
  getIt.registerSingleton<StorageService>(FireStorage());

  getIt.registerSingleton<AuthRepo>(
    AuthRepoImpl(
      firebaseAuthService: getIt<FirebaseAuthService>(),
      databaseService: getIt<DatabaseService>(),
    ),
  );
  getIt.registerSingleton<DonerRepo>(DonerRepoImpl(
    getIt.get<DatabaseService>(),
  ));
  getIt.registerSingleton<NeederRepo>(NeederRepoImpl(
    getIt.get<DatabaseService>(),
  ));
}
