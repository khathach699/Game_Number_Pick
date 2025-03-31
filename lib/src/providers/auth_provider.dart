import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:game_flutter/src/pages/auth/login_page.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  bool _isLoading = false;

  // Thêm các TextEditingController
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  User? get user => _user;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Fluttertoast.showToast(
        msg: "Đăng nhập thành công",
        gravity: ToastGravity.TOP_RIGHT,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> signUp(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Kiểm tra các trường rỗng
      if (emailController.text.isEmpty ||
          passwordController.text.isEmpty ||
          confirmPasswordController.text.isEmpty) {
        Fluttertoast.showToast(
          msg: "Vui lòng điền đầy đủ các trường",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP_RIGHT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.orangeAccent,
          textColor: Colors.black,
          fontSize: 16.0,
        );
        return;
      }

      // Kiểm tra mật khẩu khớp nhau
      if (passwordController.text != confirmPasswordController.text) {
        Fluttertoast.showToast(
          msg: "Mật khẩu không khớp",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP_RIGHT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return;
      }

      await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      clearControllers();
      Navigator.pushReplacementNamed(context, LoginPage.routeName);

      return null; // Thành công thì trả về null
    } catch (e) {
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'weak-password':
            Fluttertoast.showToast(
              msg: "Mật khẩu quá yếu.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP_RIGHT,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            return;
          case 'email-already-in-use':
            Fluttertoast.showToast(
              msg: "Email này đã được sử dụng.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP_RIGHT,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            return;
          case 'invalid-email':
            Fluttertoast.showToast(
              msg: "Email không hợp lệ.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP_RIGHT,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            return;
          default:
            Fluttertoast.showToast(
              msg: "Đã xảy ra lỗi: ${e.message}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP_RIGHT,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            return;
        }
      }
      Fluttertoast.showToast(
        msg: "Đã xảy ra lỗi không xác định.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP_RIGHT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearControllers() {
    emailController.clear();
    usernameController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
