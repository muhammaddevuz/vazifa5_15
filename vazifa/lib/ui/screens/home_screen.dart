import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocalAuthentication _auth = LocalAuthentication();
  bool _isAuthicated = false;

  _authButton() {
    return FloatingActionButton(
      onPressed: () async {
        if (!_isAuthicated) {
          try {
            final bool canAuthicateWithBiometric =
                await _auth.canCheckBiometrics;
            print(canAuthicateWithBiometric);
            if (canAuthicateWithBiometric) {
              final bool didAuthicate = await _auth.authenticate(
                  localizedReason: 'Soqqeizi korish uchun',
                  options: AuthenticationOptions(biometricOnly: true));
              setState(() {
                _isAuthicated = didAuthicate;
              });
            }
          } catch (e) {
            print(e);
          }
        } else {
          setState(() {
            _isAuthicated = !_isAuthicated;
          });
        }
      },
      child:
          _isAuthicated ? const Icon(Icons.lock_open) : const Icon(Icons.lock),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _authButton(),
      appBar: AppBar(
        title: const Text("Home Screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Account soqqa',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
            if (_isAuthicated)
              const Text(
                '\$25.599',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
            if (!_isAuthicated)
              const Text(
                '*******',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
