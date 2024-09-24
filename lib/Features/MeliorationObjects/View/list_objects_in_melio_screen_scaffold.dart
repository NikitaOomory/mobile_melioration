import 'dart:developer';

import 'package:flutter/material.dart';

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
      appBar: AppBar(),
      body: Center(child: Text('Мелиоративная система $_name' ?? '...', style: TextStyle(fontSize: 20, color: Colors.red),),),
    );
  }

}