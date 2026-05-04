/// ─── StorageKeys ─────────────────────────────────────────────────────────────
///
/// All SharedPreferences / FlutterSecureStorage keys in one place.
/// Prevents typos and makes key changes trivial.

abstract class StorageKeys {
  // Secure storage (auth)
  static const token = 'auth_token';
  static const user = 'auth_user';

  // SharedPreferences (local data)
  static const workouts = 'workouts_v1';
  static const sessions = 'study_sessions_v1';
  static const transactions = 'transactions_v1';
}
