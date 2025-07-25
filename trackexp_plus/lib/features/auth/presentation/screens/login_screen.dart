import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackexp_plus/core/services/auth_service.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _smsCodeController = TextEditingController();
  final _handleController = TextEditingController();
  String? _errorMessage;
  String? _verificationId;

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('TrackExp+ Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: userAsync.when(
          data: (user) => user != null
              ? Column(
                  children: [
                    Text('Logged in as: ${user.email ?? user.phoneNumber}'),
                    TextButton(
                      onPressed: () async {
                        await ref.read(authServiceProvider).signOut();
                      },
                      child: const Text('Sign Out'),
                    ),
                  ],
                )
              : _buildLoginForm(),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Text('Error: $error'),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await ref.read(authServiceProvider).signInWithEmailAndPassword(
                      _emailController.text,
                      _passwordController.text,
                      _handleController.text,
                    );
              } on FirebaseAuthException catch (e) {
                setState(() {
                  _errorMessage = e.message;
                });
              } catch (e) {
                setState(() {
                  _errorMessage = e.toString();
                });
              }
            },
            child: const Text('Sign In with Email/Password'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await ref.read(authServiceProvider).sendSignInLinkToEmail(
                      _emailController.text,
                      _handleController.text,
                    );
                setState(() {
                  _errorMessage = 'Check your email for a sign-in link';
                });
              } on FirebaseAuthException catch (e) {
                setState(() {
                  _errorMessage = e.message;
                });
              } catch (e) {
                setState(() {
                  _errorMessage = e.toString();
                });
              }
            },
            child: const Text('Sign In with Email Link'),
          ),
          const Divider(height: 32),
          TextField(
            controller: _phoneController,
            decoration: const InputDecoration(labelText: 'Phone Number (e.g., +1234567890)'),
          ),
          if (_verificationId != null)
            TextField(
              controller: _smsCodeController,
              decoration: const InputDecoration(labelText: 'SMS Code'),
            ),
          const SizedBox(height: 16),
          TextField(
            controller: _handleController,
            decoration: const InputDecoration(labelText: 'Handle (required for all sign-ins)'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              try {
                await ref.read(authServiceProvider).signInWithPhone(
                      _phoneController.text,
                      _handleController.text,
                      // UPDATED: Correct callback signature
                      (String verificationId, int? forceResendingToken) {
                        setState(() {
                          _verificationId = verificationId;
                          _errorMessage = 'Enter SMS code';
                        });
                      },
                    );
              } on FirebaseAuthException catch (e) {
                setState(() {
                  _errorMessage = e.message;
                });
              } catch (e) {
                setState(() {
                  _errorMessage = e.toString();
                });
              }
            },
            child: const Text('Send SMS Code'),
          ),
          if (_verificationId != null)
            ElevatedButton(
              onPressed: () async {
                try {
                  // UPDATED: Use the service method to verify the code
                  await ref.read(authServiceProvider).verifySmsCode(
                        _verificationId!,
                        _smsCodeController.text,
                        _handleController.text,
                      );
                  setState(() {
                    _verificationId = null; // Clear on success
                    _smsCodeController.clear();
                  });
                } on FirebaseAuthException catch (e) {
                  setState(() {
                    _errorMessage = e.message;
                  });
                } catch (e) {
                  setState(() {
                    _errorMessage = e.toString();
                  });
                }
              },
              child: const Text('Verify SMS Code'),
            ),
          const Divider(height: 32),
          ElevatedButton(
            onPressed: () async {
              try {
                await ref.read(authServiceProvider).signInWithGoogle(_handleController.text);
              } catch (e) {
                setState(() {
                  _errorMessage = e.toString();
                });
              }
            },
            child: const Text('Sign In with Google'),
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 16),
            Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
          ],
        ],
      ),
    );
  }
}