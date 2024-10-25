import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_melioration/Database/JobApplication/db_utils_melio_object.dart';
import 'package:mobile_melioration/Widgets/JobApplicationCard.dart';

class ListEnterJobApplication extends StatefulWidget{
  const ListEnterJobApplication({super.key});

  @override
  State<StatefulWidget> createState()=> _ListEnterJobApplication();
}

class _ListEnterJobApplication extends State<ListEnterJobApplication>{

  String ref = '';

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
    ref = args;
    setState(() {

    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ref),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: DBUtilsJobApplications().getTasks().length,
          itemBuilder: (context, i) {
            final tasks = DBUtilsJobApplications().getTasks().toList();
            return JobApplicationCard(status: tasks[i].status, title: tasks[i].name,
                requestNumber: tasks[i].name, requestDate: tasks[i].endDate, author: tasks[i].author,
              onTap:(){
                 Navigator.of(context).pushNamed('/enter_job_application_form', arguments: {'task': tasks[i], 'index': i});
              } ,);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.of(context).pushNamed('/enter_job_application_form', arguments: ref);
      }, child: Icon(Icons.add, color: Colors.white,),
        backgroundColor: CupertinoColors.activeBlue,

      ),
    );
  }

}

