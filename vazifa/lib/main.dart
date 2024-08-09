// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pinput/pinput.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AuthScreen(),
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isBiometricSupported = false;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricSupport();
  }

  Future<void> _checkBiometricSupport() async {
    try {
      final bool canCheckBiometrics = await auth.canCheckBiometrics;
      final bool isDeviceSupported = await auth.isDeviceSupported();
      setState(() {
        _isBiometricSupported = canCheckBiometrics && isDeviceSupported;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _authenticate() async {
    try {
      final bool authenticated = await auth.authenticate(
        localizedReason: 'Biometrik autentifikatsiya orqali kiring',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );

      setState(() {
        _isAuthenticated = authenticated;
      });
    } catch (e) {
      print(e);
    }
  }

  void _onPinEntered(String pin) {
    if (pin == "1234") {
      setState(() {
        _isAuthenticated = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Noto\'g\'ri PIN kod')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isAuthenticated) {
      return const Scaffold(
        body: Center(child: Text('Kirish muvaffaqiyatli amalga oshirildi!')),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Autentifikatsiya'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isBiometricSupported)
                ElevatedButton(
                  onPressed: _authenticate,
                  child: const Text('Biometrik kirish'),
                ),
              const SizedBox(height: 20),
              const Text('Yoki PIN kod kiriting:'),
              Pinput(
                length: 4,
                onCompleted: _onPinEntered,
              ),
            ],
          ),
        ),
      );
    }
  }
}
