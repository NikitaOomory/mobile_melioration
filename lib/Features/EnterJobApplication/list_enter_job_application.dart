import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mobile_melioration/Models/melioration_object_model.dart';
import 'package:mobile_melioration/Widgets/JobApplicationCard.dart';
import 'package:mobile_melioration/Widgets/search_widget.dart';

class ListEnterJobApplication extends StatefulWidget{
  const ListEnterJobApplication({super.key});

       @override
  State<StatefulWidget> createState()=> _ListEnterJobApplication();
}

class _ListEnterJobApplication extends State<ListEnterJobApplication>{

  Future<void> addTask(MeliorationObjectModel task) async {
    final box = Hive.box<MeliorationObjectModel>('tasks');
    await box.add(task);
  }

  List<MeliorationObjectModel> getTasks() {
    final box = Hive.box<MeliorationObjectModel>('tasks');
    return box.values.toList();
  }

  Future<void> updateTask(int index, MeliorationObjectModel task) async {
    final box = Hive.box<MeliorationObjectModel>('tasks');
    await box.putAt(index, task);
  }

  Future<void> deleteTask(int index) async {
    final box = Hive.box<MeliorationObjectModel>('tasks');
    await box.deleteAt(index);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Заявки на работу'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: getTasks().length,
          itemBuilder: (context, i) {
            final tasks = getTasks().toList();
            return JobApplicationCard(status: tasks[i].status, title: tasks[i].name,
                requestNumber: tasks[i].name, requestDate: tasks[i].endDate, author: tasks[i].author);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.of(context).pushNamed('/enter_job_application_form');
      }, child: Icon(Icons.add, color: Colors.white,),
      ),
    );
  }

}

