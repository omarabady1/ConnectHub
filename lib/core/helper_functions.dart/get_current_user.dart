import 'dart:convert';

import 'package:connect_hub/constants.dart';
import 'package:connect_hub/core/services/shared_preferences_singleton.dart';
import 'package:connect_hub/features/authentication/data/models/user_model.dart';

UserModel? getCurrentUser() {
  final userJson = Prefs.getString(kUserData);
  if (userJson == null || userJson.isEmpty) return null;

  final decoded = jsonDecode(userJson);
  if (decoded is! Map<String, dynamic>) return null;

  return UserModel.fromJson(decoded);
}