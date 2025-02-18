import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/user.dart';

class AppBarMainScreen extends StatefulWidget implements PreferredSizeWidget{
  @override
  final Size preferredSize;

  const AppBarMainScreen({Key? key}) : preferredSize = const Size.fromHeight(180.0), super(key: key);

  @override
  State<StatefulWidget> createState() => _AppBarMainScreen();

}

class _AppBarMainScreen extends State<AppBarMainScreen> {
  String userData = 'Загрузка...';
  User user = User(status: '', name: '', role: '');

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    User? loadedUser = await getUserFromPreferences();
    if (loadedUser != null) {
      setState(() {
        user = loadedUser; // Обновляем состояние виджета
        userData = 'Статус: ${user.status}, Имя: ${user.name}, Роль: ${user.role}';
      });
    } else {
      setState(() {
        userData = 'Данные пользователя не найдены.';
      });
    }
  }

  Future<User?> getUserFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('userData');
    if (userData != null) {
      Map<String, dynamic> json = jsonDecode(userData);
      return User.fromJson(json);
    }
    return null;
  }


  Future<void> logout(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('password');
    await prefs.remove('userData');

    Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false,);
  }


  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image.jpg'),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          // Выравнивание по нижнему краю
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Text(
                    'ИТР ФГБУ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.person, color: Colors.white),
                  onPressed: () {
                    _showRoleDialog(context, user);
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
          Image.asset('assets/img.png', width: 60, height: 60,),
            const SizedBox(height: 8), //
            const Text(
              'Министерство сельского хозяйства РФ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(205, 0, 78, 167),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                'Мелиорация',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _showRoleDialog(BuildContext context, User user) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0), // Увеличение радиуса для округления углов
          ),
          elevation: 5, // Тень
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0), // Увеличение радиуса для округления углов
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: Offset(0, 5), // Смещение тени
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 30, alignment: Alignment.topRight, child: Text('App version: 1.0.0', style: TextStyle(color: Colors.grey)),),
                Row(
                  children: [
                    const Icon(Icons.document_scanner, color: Color.fromARGB(255, 0, 78, 167)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Роль: ${user.role}',
                        style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold), // Увеличение шрифта и жирный текст
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Icon(Icons.person, color: Color.fromARGB(255, 0, 78, 167), size: 24.0),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'ФИО: ${user.name}',
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold, // Увеличение шрифта и жирный текст
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 0, 78, 167),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Закругленные углы
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Изменение размера кнопки
                      ),
                      child: const Text('Закрыть', style: TextStyle(color: Colors.white)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        logout(context); // Выход
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 182, 0, 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Закругленные углы
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Изменение размера кнопки
                      ),
                      child: const Text('Выход', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}
