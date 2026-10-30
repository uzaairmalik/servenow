import 'package:flutter/foundation.dart';

import '../core/constants.dart';
import '../data/app_user.dart';

/// Mock auth. Validation lives in the auth screen; this provider only
/// owns the session state. Swap `login` for Firebase Auth / a JWT call
/// and every screen keeps working, because they only read [user].
class AuthProvider extends ChangeNotifier {
  AppUser? _user;
  bool _loading = false;

  AppUser? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _loading;

  Future<void> login({required String email, required String password}) async {
    _loading = true;
    notifyListeners();
    // Simulated network round-trip (real auth would await http/Firebase).
    await Future<void>.delayed(const Duration(milliseconds: 800));
    final name = email == AppConstants.demoEmail
        ? 'Demo User'
        : email.split('@').first.replaceAll('.', ' ');
    _user = AppUser(
      id: 'u-1',
      name: name.isEmpty ? 'ServeNow User' : _titleCase(name),
      email: email,
      city: 'Islamabad',
    );
    _loading = false;
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }

  String _titleCase(String input) => input
      .split(' ')
      .map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1))
      .join(' ');
}
