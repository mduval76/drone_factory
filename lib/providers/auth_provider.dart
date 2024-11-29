import 'package:drone_factory/data/db_handler.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  final DbHandler _dbHandler = DbHandler();
  bool _isGuest = true;
  User? _user;

  bool get isGuest => _isGuest;
  User? get user => _user;

  Future<void> signUp(String email, String pwd) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: pwd);
      _user = userCredential.user;
      _isGuest = false;

      String userId = _user!.uid;
      String result = await _dbHandler.insertUser(userId);

      if (result == userId) {
        debugPrint('User $userId inserted, or already exists');
      }
      else if (result == 'error') {
        debugPrint('Failed to insert user: $userId into database');
      }

      notifyListeners();
    }
    catch (e) {
      debugPrint('Failed to sign up: $e');
      rethrow;
    }
  }

  Future<void> signIn(String email, String pwd) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pwd);
      _user = userCredential.user;
      _isGuest = false;
      notifyListeners();
    }
    catch (e) {
      debugPrint('Failed to sign in: $e');
      rethrow; 
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      _user = null;
      _isGuest = true;
      notifyListeners();
    }
    catch (e) {
      debugPrint('Failed to sign out: $e');
    }
  }
}