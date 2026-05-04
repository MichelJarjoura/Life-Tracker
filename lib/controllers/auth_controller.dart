import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/storage_keys.dart';

class AuthController extends GetxController {
  final _storage = const FlutterSecureStorage();

  final isLoggedIn = false.obs;
  final token = ''.obs;
  final user = <String, dynamic>{}.obs;

  final isReady = false.obs;

  @override
  void onInit() {
    super.onInit();
    _restoreSession().then((_) => isReady.value = true);
  }

  Future<void> _restoreSession() async {
    await _loadFromStorage();
    isLoggedIn.value = token.value.isNotEmpty;
  }

  /// Persist user data and token after login / register.
  Future<void> saveSession(
    Map<String, dynamic> userData,
    String authToken,
  ) async {
    user.value = userData;
    token.value = authToken;

    // ✅ Proper JSON encoding — not .toString()
    await _storage.write(key: StorageKeys.token, value: authToken);
    await _storage.write(key: StorageKeys.user, value: jsonEncode(userData));

    isLoggedIn.value = true;
  }

  Future<void> _loadFromStorage() async {
    final storedToken = await _storage.read(key: StorageKeys.token);
    final storedUser = await _storage.read(key: StorageKeys.user);

    if (storedToken != null && storedToken.isNotEmpty) {
      token.value = storedToken;
    }

    if (storedUser != null && storedUser.isNotEmpty) {
      try {
        // ✅ Actually decode JSON back to Map
        user.value = Map<String, dynamic>.from(jsonDecode(storedUser) as Map);
      } catch (_) {
        // Corrupted data — clear it
        await _storage.deleteAll();
      }
    }
  }

  Future<void> logout() async {
    token.value = '';
    user.value = {};
    isLoggedIn.value = false;
    await _storage.deleteAll();
  }
}
