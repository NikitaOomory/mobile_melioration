import 'package:flutter/material.dart';

import '../Widgets/card_melio_objects.dart';

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

