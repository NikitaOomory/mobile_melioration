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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Заявки на работу'),
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
        Navigator.of(context).pushNamed('/enter_job_application_form');
      }, child: Icon(Icons.add, color: Colors.white,),
        backgroundColor: CupertinoColors.activeBlue,

      ),
    );
  }

}

