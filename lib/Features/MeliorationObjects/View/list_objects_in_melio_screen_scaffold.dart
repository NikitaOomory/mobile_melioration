import 'dart:developer';

import 'package:flutter/material.dart';

import '../Widgets/card_melio_objects.dart';

class ListObjectsInMelioScreenScaffold extends StatefulWidget{
  const ListObjectsInMelioScreenScaffold({super.key});

  @override
  State<StatefulWidget> createState() => _ListObjectsInMelioScreenScaffold();
}

class _ListObjectsInMelioScreenScaffold extends State<ListObjectsInMelioScreenScaffold>{

  String? _name;

  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context)?.settings.arguments;
    if(args == null){
      log('You must provide args');
      return;
    }
    if(args is! String){
      log('You must provide String args');
      return;
    }
    _name = args;
    setState(() {

    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.centerLeft,
          child: Text('Сооружения и объекты \n системы $_name'),
        ),
      ),
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
                      Navigator.of(context).pushNamed(
                          '/object_fun_nav', arguments: '${index + 1}');
                    },
                  )
              ),
            ),
          ],),
      ),
    );
  }
}