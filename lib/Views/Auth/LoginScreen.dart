import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile_melioration/Widgets/show_snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ShowSnackBar _showSnackBar = ShowSnackBar();
  User userClass = User(status: '', name: '', role: '');

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> login(String username, String password,) async {
    const String url = 'https://melio.mcx.ru/melio_pmi_login/hs/api/?typerequest=login';
    final Dio dio = Dio();
    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Basic ${base64Encode(utf8.encode('$username:$password'))}',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Сохранение логина и пароля
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);
        await prefs.setString('password', password);

        print('Ответ от сервера: ${response.data}');

        // Десериализация ответа в объект User
        User user = userClass.parseUserFromResponse(response.data);

        // Сохранение объекта User в SharedPreferences
        String userData = jsonEncode(user.toJson());
        await prefs.setString('userData', userData);
        _showSnackBar.showSnackBar(context, 'Вы успешно авторизовались!');
        Navigator.of(context).pushReplacementNamed('/main_screen');
      } else {
        print(response.statusCode);
        _showSnackBar.showSnackBar(context, 'Ошибка авторизации: ${response.statusCode}');
      }
    } catch (e) {
      print('Ошибка: $e');
      _showSnackBar.showSnackBar(context, 'Ошибка: ${e.toString()}');
    }
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? password = prefs.getString('password');
    if (username != null && password != null) {
      await login(username, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Министерство сельского хозяйства Российской Федерации',
          maxLines: 2, textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 255, 255, 255), Color.fromARGB(61, 146, 236, 255)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              color: Colors.white,
              elevation: 5,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Добро пожаловать!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 78, 167),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text('Авторизируйтесь, чтобы получить доступ к системе',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Логин',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Пароль',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: (){
                        login(_usernameController.text, _passwordController.text);
                      },
                      child: const Text("Войти", style: TextStyle(color: Colors.white, fontSize: 16),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 0, 78, 167),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: const Size(double.infinity, 40),
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
}
