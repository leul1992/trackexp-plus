import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trackexp_plus/core/constants/api_endpoints.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> signInWithEmailAndPassword(
    String email,
    String password,
    String handle,
  ) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
    await _createUserProfile(userCredential.user!, handle);
  }

  Future<void> sendSignInLinkToEmail(String email, String handle) async {
    await _auth.sendSignInLinkToEmail(
      email: email.trim(),
      actionCodeSettings: ActionCodeSettings(
        url: 'https://trackexp-plus.page.link/finishSignIn',
        handleCodeInApp: true,
        iOSBundleId: 'com.example.trackexpPlus',
        androidPackageName: 'com.example.trackexp_plus',
        androidInstallApp: true,
        androidMinimumVersion: '1',
      ),
    );
    await _storage.write(key: 'pendingHandle', value: handle);
  }

  Future<void> signInWithPhone(
    String phoneNumber,
    String handle,
    void Function(String, int?) onCodeSent,
  ) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber.trim(),
      verificationCompleted: (PhoneAuthCredential credential) async {
        final userCredential = await _auth.signInWithCredential(credential);
        await _createUserProfile(userCredential.user!, handle);
      },
      verificationFailed: (FirebaseAuthException e) {
        throw e;
      },
      codeSent: onCodeSent,
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  // NEW: Method to handle SMS code verification
  Future<void> verifySmsCode(
    String verificationId,
    String smsCode,
    String handle,
  ) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode.trim(),
    );
    final userCredential = await _auth.signInWithCredential(credential);
    await _createUserProfile(userCredential.user!, handle);
  }

  // UPDATED: signInWithGoogle with null safety checks
  Future<void> signInWithGoogle(String handle) async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      // User cancelled the sign-in
      return;
    }

    final googleAuth = await googleUser.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null || idToken == null) {
      throw Exception('Google sign-in failed: Missing auth token.');
    }

    final credential = GoogleAuthProvider.credential(
      accessToken: accessToken,
      idToken: idToken,
    );
    final userCredential = await _auth.signInWithCredential(credential);
    await _createUserProfile(userCredential.user!, handle);
  }

  Future<void> _createUserProfile(User user, String handle) async {
    final idToken = await user.getIdToken();
    await _storage.write(key: 'idToken', value: idToken);
    print('the id Token is: $idToken');

    final response = await http.post(
      Uri.parse(ApiEndpoints.createUser),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
      body: jsonEncode({'email': user.email, 'handle': handle.trim()}),
    );

    if (response.statusCode == 409) {
      await _getUserProfile(idToken!);
    } else if (response.statusCode != 201) {
      throw Exception('Failed to create user: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> _getUserProfile(String idToken) async {
    final response = await http.get(
      Uri.parse(ApiEndpoints.getUserProfile),
      headers: {'Authorization': 'Bearer $idToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get profile: ${response.body}');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    await _storage.delete(key: 'idToken');
    await _storage.delete(key: 'pendingHandle');
  }

  User? get currentUser => _auth.currentUser;
}

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final userProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});
