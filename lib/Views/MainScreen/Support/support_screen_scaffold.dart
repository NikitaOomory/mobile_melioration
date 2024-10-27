import 'package:flutter/material.dart';


class SupportScreenScaffold extends StatefulWidget{
  const SupportScreenScaffold({super.key});

  @override
  State<StatefulWidget> createState() => _SupportScreenScaffold();
}

class _SupportScreenScaffold extends State<SupportScreenScaffold>{

  final List<String> array = ['Никита', 'Иван', 'Макс'];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Техническая поддержка'),),
      body:const Center(child: CircularProgressIndicator(),),
    );
  }



}

