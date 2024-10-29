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

      print('Ответ от сервера: ${response.data}');

      if (response.statusCode == 200) {
        Navigator.of(context).pushReplacementNamed('/main_screen');
      } else {
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
        title: Text('Министерство сельского хозяйства Российской Федерации',
        maxLines: 2, textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),),
      ),
      body: Container(
        decoration: BoxDecoration(
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
              elevation: 5,
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Добро пожаловать!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 78, 167),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Авторизируйтесь, чтобы получить доступ к системе',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Логин',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Пароль',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: (){
                        login(_usernameController.text, _passwordController.text);
                      },
                      child: Text(
                        "Войти",
                        style: TextStyle(
                          color: Colors.white, // Цвет текста
                          fontSize: 16, // Размер текста
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 0, 78, 167), // Цвет фона кнопки
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Закругление краёв
                        ),
                        minimumSize: Size(double.infinity, 40), // Ширина кнопки
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
