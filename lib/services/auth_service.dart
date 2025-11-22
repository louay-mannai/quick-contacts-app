class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final Map<String, String> _users = {}; // email -> password

  Future<bool> register(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (_users.containsKey(email)) return false;
    _users[email] = password;
    return true;
  }

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _users[email] == password;
  }

  // helper for tests: prefill one account
  void seed(String email, String password) {
    _users[email] = password;
  }
}
