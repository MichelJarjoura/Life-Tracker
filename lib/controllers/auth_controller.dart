import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthController extends GetxController {
  var isLoggedin = false.obs;

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  var token = ''.obs;
  var user = {}.obs;

  @override
  void onInit() {
    super.onInit();

    restoreUser();
  }

  Future<void> restoreUser() async {
    await loadUser();
    isLoggedin.value = token.value.isNotEmpty;
  }

  Future<void> saveUser(Map<String, dynamic> userData, String authToken) async {
    user.value = userData;
    token.value = authToken;

    await storage.write(key: 'token', value: authToken);
    await storage.write(
      key: 'user',
      value: userData.toString(),
    ); // simple example
  }

  Future<void> loadUser() async {
    final storedToken = await storage.read(key: 'token');
    final storedUser = await storage.read(key: 'user');

    if (storedToken != null) token.value = storedToken;
    if (storedUser != null) user.value = {'data': storedUser}; // parse properly
  }

  Future<void> logout() async {
    token.value = '';
    user.value = {};
    await storage.deleteAll();
  }
}
