import 'package:flutter/material.dart';

class CardMelioObjects extends StatelessWidget {

  final String title;
  final String ein;
  final String ref;
  final VoidCallback onTap;


  CardMelioObjects({ required this.title, required this.ein, required this.onTap, required this.ref});

  @override Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(horizontal: 0.5, vertical: 8  ),
        child: Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8),),
          padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text('ЕИН ', style: TextStyle(color: Colors.grey),),
                    Text(ein),
                  ],
                ),
              ],),
        ),
      ),
    );
  }
}