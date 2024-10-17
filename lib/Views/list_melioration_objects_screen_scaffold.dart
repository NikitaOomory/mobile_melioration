import 'package:flutter/material.dart';
import 'package:mobile_melioration/Models/melioration_object_model.dart';
import 'package:mobile_melioration/TestData/melioration_objects.dart';
import 'package:mobile_melioration/Widgets/search_widget.dart';

import '../Widgets/card_melio_objects.dart';



class ListMeliorationObjectsScreenScaffold extends StatefulWidget {

  const ListMeliorationObjectsScreenScaffold({super.key});

  @override
  State<StatefulWidget> createState() => _ListMeliorationObjectsScreenScaffold();

}

class _ListMeliorationObjectsScreenScaffold extends State<ListMeliorationObjectsScreenScaffold>{

  //todo: метод получения данных о мелиоративных системах с 1С сервиса
  //todo: метод сверки данных с 1С и с БД устройства который обновит базу

  List<MeliorationObjectModel> arrayMelioObjects = TestData().arrayMelioSystem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Мелиоративные объекты'), backgroundColor: Colors.white,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
           const SearchWidget(),
            Expanded(
              child: ListView.builder(
                itemCount: arrayMelioObjects.length,
                itemBuilder: (context, i) => CardMelioObjects(
                    title: arrayMelioObjects[i].name,
                    ein: arrayMelioObjects[i].ein,
                    onTap: () {
                      Navigator.of(context).pushNamed('/list_object_in_melio', arguments: arrayMelioObjects[i].name);
                    },
                  )
              ),
            ),
          ],),
      ),
    );
  }
}

