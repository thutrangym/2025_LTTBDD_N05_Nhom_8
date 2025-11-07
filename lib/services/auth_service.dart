import '../data/local/hive_manager.dart';
import '../models/user_model.dart';

class AuthException implements Exception {
  AuthException(this.messageKey);

  final String messageKey;
}

class AuthService {
  static const _sessionKey = 'currentUserId';

  Future<UserModel> register({
    required String displayName,
    required String email,
    required String password,
  }) async {
    final usersBox = HiveManager.usersBox;

    final existing = usersBox.values.firstWhere(
      (dynamic value) => value is Map && value['email'] == email,
      orElse: () => null,
    );

    if (existing != null) {
      throw AuthException('auth_email_exists');
    }

    final userId = 'user_${DateTime.now().microsecondsSinceEpoch}';
    final userData = {
      'uid': userId,
      'displayName': displayName,
      'email': email,
      'password': password,
    };

    await usersBox.put(userId, userData);
    await _persistSession(userId);

    return UserModel.fromJson(userData);
  }

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    final usersBox = HiveManager.usersBox;

    final userEntry = usersBox.values.cast<dynamic>().firstWhere(
      (dynamic value) =>
          value is Map && value['email'] == email && value['password'] == password,
      orElse: () => null,
    );

    if (userEntry == null) {
      throw AuthException('auth_invalid_credentials');
    }

    final userId = userEntry['uid'] as String;
    await _persistSession(userId);

    return UserModel.fromJson(Map<String, dynamic>.from(userEntry as Map));
  }

  Future<UserModel?> loadSession() async {
    final userId = HiveManager.settingsBox.get(_sessionKey) as String?;
    if (userId == null) return null;

    final userData = HiveManager.usersBox.get(userId);
    if (userData is! Map) return null;

    return UserModel.fromJson(Map<String, dynamic>.from(userData));
  }

  Future<void> signOut() async {
    await HiveManager.settingsBox.delete(_sessionKey);
  }

  Future<void> _persistSession(String userId) async {
    await HiveManager.settingsBox.put(_sessionKey, userId);
  }
}

