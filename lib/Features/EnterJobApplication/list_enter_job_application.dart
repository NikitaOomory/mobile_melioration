import 'package:flutter/material.dart';
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
        child: ListView(
          children: [
            JobApplicationCard(
              status: 'В работе',
              title: 'Разработка нового приложения',
              requestNumber: '12345',
              requestDate: '2023-10-01',
              author: 'Иван Иванов',
            ),
            JobApplicationCard(
              status: 'На отправке',
              title: 'Обновление веб-сайта',
              requestNumber: '12346',
              requestDate: '2023-10-02',
              author: 'Петр Петров',
            ),
            JobApplicationCard(
              status: 'В проекте',
              title: 'Создание базы данных',
              requestNumber: '12347',
              requestDate: '2023-10-03',
              author: 'Сергей Сергеев',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.of(context).pushNamed('/enter_job_application_form');
      }, child: Icon(Icons.add),),
    );
  }

}

