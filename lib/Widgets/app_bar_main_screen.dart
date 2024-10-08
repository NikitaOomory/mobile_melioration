import 'package:flutter/material.dart';

class AppBarMainScreen extends StatelessWidget implements PreferredSizeWidget {
  const AppBarMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end, // Выравнивание по нижнему краю
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Text('ИТР ФГБУ', style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.person, color: Colors.white),
                  onPressed: () {_showRoleDialog(context);},
                ),
              ],),
            const SizedBox(height: 8),
            const Icon(Icons.agriculture, size: 40, color: Color.fromARGB(
                255, 255, 134, 0),), // Иконка
            const SizedBox(height: 8), //
            const Text('Министерство сельского хозяйства РФ', style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w200,
              ),
            ),
           const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(100, 0, 13, 255),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Text('Мелиорация', style: TextStyle(
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

  void _showRoleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Васильев Никита Сергеевич'),
          content: const Text('Организация: ООО Оомори'), // Название роли
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Закрыть', style: TextStyle(color: Colors.black),),
            ),
            TextButton(
              onPressed: () {
                // Логика выхода (например, очистка токена и т.д.)
                Navigator.of(context).pop(); // Закрыть диалог
              },
              child: const Text('Выход', style: TextStyle(color: Colors.red),),
            ),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(180.0); // Высота AppBar
}