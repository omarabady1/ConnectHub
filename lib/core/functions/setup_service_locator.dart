import 'package:connect_hub/core/services/database_service.dart';
import 'package:connect_hub/core/services/firebase_auth_service.dart';
import 'package:connect_hub/core/services/firestore_service.dart';
import 'package:connect_hub/features/authentication/data/repos/auth_repo_implementation.dart';
import 'package:get_it/get_it.dart';
import '../../features/authentication/domain/repos/auth_repo.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerSingleton<FirebaseAuthService>(FirebaseAuthService());
  getIt.registerSingleton<DatabaseService>(FirestoreService());
  getIt.registerSingleton<AuthRepo>(
    AuthRepoImplementation(
      firebaseAuthService: getIt<FirebaseAuthService>(),
      databaseService: getIt<DatabaseService>(),
    ),
  );
}
