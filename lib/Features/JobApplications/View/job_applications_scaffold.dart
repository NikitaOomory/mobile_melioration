import 'package:flutter/material.dart';

class JobApplicationsScaffold extends StatefulWidget {
  const JobApplicationsScaffold({super.key});

  @override
  State<StatefulWidget> createState() => _JobApplicationsScaffold();
  
}

class _JobApplicationsScaffold extends State<JobApplicationsScaffold>{
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Заявка на работы'),),
      body: Center(child: Text('Форма заявки на работы'),),
    );
  }
}