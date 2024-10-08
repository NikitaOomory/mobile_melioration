import 'package:flutter/material.dart';

class CardMelioObjects extends StatelessWidget {
  final String title;
  final String ein;
  final VoidCallback onTap;

  const CardMelioObjects({super.key, required this.title, required this.ein, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ein,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],),
        ),
      ),
    );
  }
}