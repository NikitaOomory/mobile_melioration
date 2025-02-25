import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile_melioration/server_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Models/user.dart';
import '../../UI-kit/Widgets/show_snack_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _usernameError = false;
  bool _passwordError = false;
  User userClass = User(status: '', name: '', role: '');

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
    _checkLoginStatus();
  }

  void _updateButtonState() {
    setState(() {
      _usernameError = false;
      _passwordError = false;
    });
  }

  @override
  void dispose() {
    _usernameController.removeListener(_updateButtonState);
    _passwordController.removeListener(_updateButtonState);
    super.dispose();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? password = prefs.getString('password');
    if (username != null && password != null) {
      await login(username, password);
    }
  }

  Future<void> login(String username, String password) async {
    final Dio dio = Dio();
    try {
      final response = await dio.get(
        ServerRoutes.LOGIN_ROUTE,
        options: Options(
          headers: {
            'Authorization':
            'Basic ${base64Encode(utf8.encode('$username:$password'))}',
          },
        ),
      );

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);
        await prefs.setString('password', password);
        User user = userClass.parseUserFromResponse(response.data);
        String userData = jsonEncode(user.toJson());
        await prefs.setString('userData', userData);
        ShowSnackBar.showSnackBar(context, 'Вы успешно авторизовались!');
        Navigator.of(context).pushReplacementNamed('/main_screen');
      } else {
        ShowSnackBar.showSnackBar(
            context, 'Ошибка авторизации: ${response.statusCode}');
      }
    } catch (e) {
      ShowSnackBar.showSnackBar(context, 'Ошибка авторизации: 5хх');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/img.png', width: 40, height: 50),
            const SizedBox(width: 8),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Министерство сельского хозяйства',
                    style: TextStyle(fontSize: 18)),
                Text('Российской Федерации', style: TextStyle(fontSize: 18)),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(61, 146, 236, 255)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              color: Colors.white,
              elevation: 7,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Добро пожаловать!',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 78, 167))),
                    const Text(
                        'Авторизируйтесь в системе, чтобы получить доступ к приложению',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 30),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Color.fromARGB(255, 0, 78, 167)),
                        ),
                        labelText: 'Логин',
                        labelStyle: const TextStyle(color: Colors.black),
                        border: const OutlineInputBorder(),
                        errorText: _usernameError ? 'Поле логин должно быть заполнено' : null,
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Color.fromARGB(255, 0, 78, 167)),
                        ),
                        labelText: 'Пароль',
                        labelStyle: const TextStyle(color: Colors.black),
                        border: const OutlineInputBorder(),
                        errorText: _passwordError ? 'Поле пароль должно быть заполнено' : null,
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed:
                      (_usernameController.text.isNotEmpty &&
                          _passwordController.text.isNotEmpty)
                          ? () {
                        bool isValid = true;
                        if (_usernameController.text.isEmpty) {
                          setState(() => _usernameError = true);
                          isValid = false;
                        }
                        if (_passwordController.text.isEmpty) {
                          setState(() => _passwordError = true);
                          isValid = false;
                        }
                        if (isValid) {
                          login(_usernameController.text,
                              _passwordController.text);
                        }
                      }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 0, 78, 167),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        minimumSize: const Size(double.infinity, 40),
                      ),
                      child: const Text("Войти",
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                    const SizedBox(height: 20),
                    const Text('Ещё нет учётной записи?'),
                    TextButton(
                      onPressed: _launchURL,
                      child: const Text(
                        "Зарегистрироваться",
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 78, 167),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: Color.fromARGB(255, 0, 78, 167),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _launchURL() async {
    final Uri url = Uri.parse('https://melio.mcx.ru/melio_esia/');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}