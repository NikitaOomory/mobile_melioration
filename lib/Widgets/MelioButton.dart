import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MelioButton extends StatelessWidget{

  final VoidCallback onTap;
  late String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onTap,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white, // Цвет текста
          fontSize: 16, // Размер текста
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue, // Цвет фона кнопки
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Закругление краёв
        ),
        minimumSize: Size(double.infinity, 40), // Ширина кнопки
      ),
    );
  }

  MelioButton(this.onTap, this.text);
}