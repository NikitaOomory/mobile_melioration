import 'package:flutter/material.dart';

class ListMeliorationObjectsScreenScaffold extends StatelessWidget {
  const ListMeliorationObjectsScreenScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Мелиоративные объекты'), backgroundColor: Colors.white,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Поиск...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(color: Colors.blueAccent),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.filter_alt_outlined),
                    color: Colors.blueAccent,
                    onPressed: () {
                    },
                    padding: const EdgeInsets.all(15.0),
                    constraints: const BoxConstraints(),
                  ),
                ],),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 30,
                itemBuilder: (context, index) => CardMelioObjects(
                    title: 'Мелиоративная система ${index + 1}',
                    ein: 'ЕИН: ${1000 + index}',
                    onTap: () {
                      Navigator.of(context).pushNamed('/list_object_in_melio', arguments: '${index + 1}');
                    },
                  )
              ),
            ),
          ],),
      ),
    );
  }
}

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