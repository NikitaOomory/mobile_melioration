import 'package:flutter/material.dart';

class ListTechnicalConditionsScaffold extends StatefulWidget{
  const ListTechnicalConditionsScaffold({super.key});

  @override
  State<StatefulWidget> createState() => _ListTechnicalConditionsScaffold();
}

class _ListTechnicalConditionsScaffold extends State<ListTechnicalConditionsScaffold>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Реестр зарегистрированных изменений'),),
      body: const Center(child: CircularProgressIndicator(),),
    );
  }

}