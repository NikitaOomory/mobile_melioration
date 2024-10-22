import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> login(String username, String password) async {
    final String url = 'http://192.168.7.6/MCX_melio_dev_atropin/hs/api/?typerequest=login';
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

      // Выводим ответ в консоль
      print('Ответ от сервера: ${response.data}');

      if (response.statusCode == 200) {
        // Успешная авторизация
        Navigator.of(context).pushReplacementNamed('/main_screen');
      } else {
        // Обработка неуспешной авторизации
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка авторизации: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Ошибка: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Авторизация'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Имя пользователя'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Пароль'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final username = _usernameController.text;
                final password = _passwordController.text;
                login(username, password);
              },
              child: Text('Войти'),
            ),
          ],
        ),
      ),
    );
  }
}
