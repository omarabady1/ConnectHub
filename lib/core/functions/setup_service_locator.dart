import 'package:connect_hub/core/services/cloud_storage_service.dart';
import 'package:connect_hub/core/services/database_service.dart';
import 'package:connect_hub/core/services/firebase_auth_service.dart';
import 'package:connect_hub/core/services/firestore_service.dart';
import 'package:connect_hub/core/services/imagebb_api_service.dart';
import 'package:connect_hub/features/authentication/data/repos/auth_repo_implementation.dart';
import 'package:connect_hub/features/chatbot/data/services/chat_service.dart';
import 'package:connect_hub/features/chatbot/data/services/chat_storage_service.dart';
import 'package:connect_hub/features/chatbot/data/services/chatbot_api_service.dart';
import 'package:connect_hub/features/post_details/data/repos_implementation/post_details_repo_impl.dart';
import 'package:connect_hub/features/post_details/data/services/post_interaction_service.dart';
import 'package:connect_hub/features/post_details/domain/repos/post_details_repo.dart';
import 'package:get_it/get_it.dart';
import '../../features/authentication/domain/repos/auth_repo.dart';

import 'package:connect_hub/features/profile/data/repos_implementation/profile_repo_impl.dart';
import 'package:connect_hub/features/profile/domain/repos/profile_repo.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerSingleton<FirebaseAuthService>(FirebaseAuthService());
  getIt.registerSingleton<DatabaseService>(FirestoreService());
  getIt.registerSingleton<CloudStorageService>(ImagebbApiService());
  getIt.registerSingleton<AuthRepo>(
    AuthRepoImplementation(
      firebaseAuthService: getIt<FirebaseAuthService>(),
      databaseService: getIt<DatabaseService>(),
    ),
  );
  getIt.registerSingleton<ChatService>(ChatService());
  getIt.registerSingleton<ChatbotApiService>(ChatbotApiService());
  getIt.registerSingleton<ChatStorageService>(ChatStorageService());
  getIt.registerLazySingleton<PostInteractionService>(
    () => PostInteractionService(
      databaseService: getIt<DatabaseService>(),
    ),
  );
  getIt.registerLazySingleton<PostDetailsRepo>(
    () => PostDetailsRepoImpl(
      databaseService: getIt<DatabaseService>(),
      postInteractionService: getIt<PostInteractionService>(),
    ),
  );
  getIt.registerLazySingleton<ProfileRepo>(
    () => ProfileRepoImpl(
      authRepo: getIt<AuthRepo>(),
      databaseService: getIt<DatabaseService>(),
      postInteractionService: getIt<PostInteractionService>(),
    ),
  );
}



