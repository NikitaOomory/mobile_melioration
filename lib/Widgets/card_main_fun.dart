import 'package:flutter/material.dart';

class CardMainFun extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Function onTap;

  const CardMainFun({super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8  ),
        child: Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8),),
          padding: const EdgeInsets.all(20),
          child:Column(children: [
            Row(children: [Icon(icon, size: 30, color: const Color.fromARGB(255, 0, 78, 167),),],),
            const SizedBox(height: 4),
            Row(children: [Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),],),
            const SizedBox(height: 4),
            Row(children: [Text(description, style: const TextStyle(color: Colors.grey),),],),
          ],),
        ),
      ),
    );
  }
}