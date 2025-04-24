import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoggedIn = false;
  String? _currentUser;

  Future<bool> login(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        _isLoggedIn = true;
        _currentUser = userCredential.user!.email;
        await SharedPreferences.getInstance()
          ..setBool('isLoggedIn', true)
          ..setString('currentUser', _currentUser!);
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<bool> signup(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        _isLoggedIn = true;
        _currentUser = userCredential.user!.email;
        await SharedPreferences.getInstance()
          ..setBool('isLoggedIn', true)
          ..setString('currentUser', _currentUser!);
        return true;
      }
      return false;
    } catch (e) {
      print('Signup error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      _isLoggedIn = false;
      _currentUser = null;
      await SharedPreferences.getInstance()
        ..setBool('isLoggedIn', false)
        ..remove('currentUser');
    } catch (e) {
      print('Logout error: $e');
    }
  }

  bool get isLoggedIn => _isLoggedIn;
  String? get currentUser => _currentUser;

  Future<void> checkLoginStatus() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        _isLoggedIn = true;
        _currentUser = user.email;
      } else {
        final prefs = await SharedPreferences.getInstance();
        _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
        _currentUser = prefs.getString('currentUser');
      }
    } catch (e) {
      print('Check login status error: $e');
      final prefs = await SharedPreferences.getInstance();
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      _currentUser = prefs.getString('currentUser');
    }
  }
} 