import 'package:flutter/material.dart';
import 'package:mobile_melioration/Widgets/search_widget.dart';

import '../../../Widgets/card_melio_objects.dart';



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
           const SearchWidget(),
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

