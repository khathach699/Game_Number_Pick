import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:game_flutter/src/providers/auth_provider.dart';
import 'package:game_flutter/src/pages/home/home_page.dart';
import '../auth/login_page.dart';

class WrapperPage extends StatelessWidget {
  const WrapperPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: authProvider.user != null ? const HomePage() : const LoginPage(),
    );
  }
}
