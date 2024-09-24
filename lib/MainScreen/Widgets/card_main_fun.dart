import 'package:flutter/material.dart';

class CardMainFun extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Function onTap;

  CardMainFun({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4  ),
        child: Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8),),
          padding: EdgeInsets.all(20),
          child:Column(children: [
            Row(children: [Icon(icon, size: 30, color: const Color.fromARGB(
                229, 0, 13, 255),),],),
            SizedBox(height: 4),
            Row(children: [Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),],),
            SizedBox(height: 4),
            Row(children: [Text(description, style: TextStyle(color: Colors.grey),),],),
          ],),
        ),
      ),
    );
  }
}