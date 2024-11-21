import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

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
  final ShowSnackBar _showSnackBar = ShowSnackBar();
  User userClass = User(status: '', name: '', role: '');
  final Uri _url = Uri.parse('https://melio.mcx.ru/melio_site/');

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
        title: Row(
          children: [
            Image.asset('assets/img.png', width: 40, height: 50,),
            const SizedBox(width: 8),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Министерство сельского хозяйства', style: TextStyle(fontSize: 18),),
                Text('Российской Федерации', style: TextStyle(fontSize: 18),),
              ],),
          ],),
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
                        color: Color.fromARGB(255, 0, 78, 167),
                      ),
                    ),
                    const Text('Авторизируйтесь в системе, чтобы получить доступ к приложению',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color.fromARGB(255, 0, 78, 167)),
                        ),
                        labelText: 'Логин',
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color.fromARGB(255, 0, 78, 167)),
                        ),
                        labelText: 'Пароль',
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: (){
                        login(_usernameController.text, _passwordController.text);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 0, 78, 167),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        minimumSize: const Size(double.infinity, 40),
                      ),
                      child: const Text("Войти", style: TextStyle(color: Colors.white, fontSize: 16),),
                    ),
                    SizedBox(height: 20,),
                    Text('Ещё нет учётной записи?'),
                    TextButton(
                      onPressed: () {
                        _launchURL();
                      },
                      child: Text(
                        "Зарегистрироваться",
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 78, 167),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline, // Подчеркивание текста
                          decorationColor: Color.fromARGB(255, 0, 78, 167), // Синий цвет подчеркивания
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
    final Uri url = Uri.parse('https://melio.mcx.ru/melio_pmi');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $_url');
    }
  }

}
