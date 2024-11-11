import 'package:flutter/material.dart';

class ShowSnackBar{
  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.black), // Установите цвет текста на черный для контраста
      ),
      backgroundColor: Colors.white, // Установите белый фон
      action: SnackBarAction(
        label: 'Закрыть',
        textColor: Color.fromARGB(255, 0, 78, 167), // Установите цвет текста действия
        onPressed: () {
          // Здесь можно добавить действие при нажатии на кнопку 'Закрыть'
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}