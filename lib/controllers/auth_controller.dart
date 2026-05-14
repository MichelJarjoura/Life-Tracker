import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  final _storage = const FlutterSecureStorage();
  final _supabase = Supabase.instance.client;

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
    final session = _supabase.auth.currentSession;

    if (session != null) {
      user.value = {
        'id': session.user.id,
        'email': session.user.email ?? '',
        'name': session.user.userMetadata?['name'] ?? '',
      };
      token.value = session.accessToken;
      isLoggedIn.value = true;
    }
  }

  Future<void> saveSession(
    Map<String, dynamic> userData,
    String authToken,
  ) async {
    user.value = userData;
    token.value = authToken;
    isLoggedIn.value = true;
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
    token.value = '';
    user.value = {};
    isLoggedIn.value = false;
    await _storage.deleteAll();
  }
}
