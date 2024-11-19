import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  // final TextEditingController controller;

  const SearchWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Поиск', // Текст-подсказка
          hintStyle: TextStyle(color: Colors.grey), // Цвет подсказки
          prefixIcon: Icon(Icons.search, color: Colors.grey), // Иконка поиска
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8), // Закругление краёв
            borderSide: BorderSide(color: Colors.blue), // Цвет рамки
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8), // Закругление краёв при фокусе
            borderSide: BorderSide(color: Colors.blue), // Цвет рамки при фокусе
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8), // Закругление краёв при обычном состоянии
            borderSide: BorderSide(color: Colors.grey), // Цвет рамки при обычном состоянии
          ),
        ),
      ),
    );
  }
}