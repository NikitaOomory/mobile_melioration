import 'package:flutter/material.dart';

class ListApplicationsScaffold extends StatefulWidget{
  const ListApplicationsScaffold({super.key});

  @override
  State<StatefulWidget> createState() => _ListApplicationsScaffold();
}

class _ListApplicationsScaffold extends State<ListApplicationsScaffold>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Заявки на работу'),),
      body: Center(child: Text('Заявки на работу'),),
    );
  }
}