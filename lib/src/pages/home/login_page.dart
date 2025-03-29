import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text, password: password.text);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(('Login'),),
      ),
      body: Column(
        children: [
          TextField(
            controller: email,
            decoration: InputDecoration(
              hintText: "Email"
            ),
          ),
          20.verticalSpace,
          TextField(
            controller: password,
            decoration: InputDecoration(
                hintText: "Password"
            ),
          ),
          20.verticalSpace,
          ElevatedButton(onPressed: () => signIn(), child: Text("Login"))
        ],
      ),
    );
  }
}
