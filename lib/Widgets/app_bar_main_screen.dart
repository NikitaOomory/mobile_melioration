import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/user.dart';

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
    // Загружаем данные при инициализации
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
    return null; // Если данных нет, возвращаем null
  }


  Future<void> logout(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('password');
    await prefs.remove('userData');

    Navigator.of(context).pushNamedAndRemoveUntil(
      '/', // Путь к вашему экрану входа
          (Route<dynamic> route) => false, // Удаляет все предыдущие маршруты
    );
  }


  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image.jpg'),
            fit: BoxFit.cover,
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
                      fontWeight: FontWeight.w200,
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
          Image.asset(
            'assets/img.png', // Используем ваше изображение
            width: 40, // Указываем ширину
            height: 50, // Указываем высоту
          ),
            const SizedBox(height: 8), //
            const Text(
              'Министерство сельского хозяйства РФ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w200,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(131, 0, 78, 167),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                'Мелиорация',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10), // Отступ снизу
          ],
        ),
      ),
    );
  }

  void _showRoleDialog(BuildContext context, User user) {
    showDialog(context: context, barrierDismissible: true, // Позволяет закрыть диалог, нажав вне его
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // Закругленные углы
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8, // Занимает 80% ширины экрана
            height: MediaQuery.of(context).size.height * 0.3, // Занимает 50% высоты экрана
            padding: const EdgeInsets.all(20.0), // Отступы внутри контейнера
            decoration: BoxDecoration(
              color: Colors.white, // Белый цвет фона
              borderRadius: BorderRadius.circular(8.0), // Закругленные углы
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.document_scanner, color: Color.fromARGB(255, 0, 78, 167)), // Увеличенная иконка
                    SizedBox(width: 10), // Отступ между иконкой и текстом
                    Expanded(
                      child: Text(
                        'Роль: ${user.role}', // Роль отображается в заголовке
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20), // Отступ
                Row(
                  children: [
                    Icon(Icons.person, color: Color.fromARGB(255, 0, 78, 167), size: 24.0), // Иконка пользователя
                    SizedBox(width: 10), // Отступ между иконкой и текстом
                    Expanded(
                      child: Text(
                        'ФИО: ${user.name}', // Имя пользователя
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ],
                ),
                Spacer(), // Заполнитель для размещения кнопок внизу
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Размещает кнопки по краям
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Закрыть диалог
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 0, 78, 167),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Закругленные углы
                        ),
                      ),
                      child: const Text('Закрыть', style: TextStyle(color: Colors.white),),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        logout(context); // Выход
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 182, 0, 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Закругленные углы
                        ),
                      ),
                      child: const Text('Выход', style: TextStyle(color: Colors.white),),
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
