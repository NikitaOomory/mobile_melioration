import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:mobile_melioration/Database/JobApplication/db_utils_melio_object.dart';

import '../../../../../../../Models/melioration_object_model.dart';
import '../../../../../../../Models/my_arguments.dart';

class EnterJobApplicationForm extends StatefulWidget{
  const EnterJobApplicationForm({super.key});

  @override
  State<StatefulWidget> createState() => _EnterJobApplicationForm();
}

class _EnterJobApplicationForm extends State<EnterJobApplicationForm>{
 DBUtilsJobApplications? dbUtilsMelioObject = DBUtilsJobApplications();

  MeliorationObjectModel? dat;
  int? indexObj =1;
  bool isUpdate = false;

  String status = 'В проекте'; //Статус, заполненный заранее
  String author = 'Иван Иванов'; //Автор, заполненный заранее
  String meliorativeObject = 'Сооружение 1';// Мелиоративный объект, заполненный заранее
  String ein = '30Ф-ОРО-0001-ООС-001'; // ЕИН объекта, заполненный заранее
  DateTime? startDate; // Дата начала работ
  DateTime? endDate; // Дата окончания работ
  String description = ''; // Описание работ
  List<File> attachedFiles = []; // Список прикрепленных файлов

 String ref = '';
 String refValue = '';

 @override
 void didChangeDependencies() {
   final MyArguments args = ModalRoute.of(context)?.settings.arguments as MyArguments;
   if(args == null){
     log('You must provide args');
     return;
   }
   if(args.param1 is! String){
     log('You must provide String args');
     return;
   }
   ref = args.param1;
   refValue = args.param2;
   setState(() {

   });
   super.didChangeDependencies();
 }

 final Dio _dio = Dio();

 Future<void> _sendApplicationForWork(String description) async {
   final String url = 'http://192.168.7.6/MCX_melio_dev_atropin/hs/api/?typerequest=WriteApplicationForWork';
   String username = 'tropin'; // Замените на ваши учетные данные
   String password = '1234'; // Замените на ваши учетные данные

   // Тело запроса
   final Map<String, dynamic> requestBody = {
     "ReclamationSystem": refValue,
     "HydraulicStructure": ref,
     "startDate": "2024-10-26T00:00:00-05:00",
     "startJobDate": "2024-10-26T00:00:00-05:00",
     "endJobDate": "2024-10-30T00:00:00-05:00",
     "description": description,
   };

   try {
     final response = await _dio.post(
       url,
       data: jsonEncode(requestBody), // Отправка тела запроса
       options: Options(
         headers: {
           'Authorization': 'Basic ${base64Encode(utf8.encode('$username:$password'))}',
           'Content-Type': 'application/json', // Указываем тип контента
         },
       ),
     );

     if (response.statusCode == 200) {
       print('Response data: ${response.data}'); // Выводим ответ в консоль
     } else {
       print('Ошибка: ${response.statusCode}'); // Выводим статус ошибки
     }
   } catch (e) {
     print('Ошибка: $e'); // Обработка ошибок
   }
 }

 void _showSnackbar(BuildContext context) {
   final snackBar = SnackBar(
     content: Text('Заявка уже отправлена'),
     action: SnackBarAction(
       label: 'Закрыть',
       onPressed: () {
         // Код, который будет выполнен при нажатии на кнопку
       },
     ),
   );

   // Показать SnackBar
   ScaffoldMessenger.of(context).showSnackBar(snackBar);
 }


 void _selectStartDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != startDate) {
      setState(() {
        startDate = pickedDate;
      });
    }
  }

  void _selectEndDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != endDate) {
      setState(() {
        endDate = pickedDate;
      });
    }
  }

  Future<void> _attachFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        attachedFiles.add(File(result.files.single.path!));
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Новая заявка на работу'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('подсистема $ref системы $refValue'),
              // Поле статуса
              TextField(
                controller: TextEditingController(text: status,),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Статус',
                  border: InputBorder.none,
                ),
              ),
              SizedBox(height: 16),

              // Поле автора
              TextField(
                controller: TextEditingController(text: author),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Автор',
                  border: InputBorder.none,
                ),
              ),
              SizedBox(height: 16),

              // Поле мелиоративного объекта
              TextField(
                controller: TextEditingController(text: meliorativeObject),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Мелиоративный объект',
                  border: InputBorder.none,
                ),
              ),
              SizedBox(height: 16),

              // Поле ЕИН объекта
              TextField(
                controller: TextEditingController(text: ein),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'ЕИН объекта',
                  border: InputBorder.none,
                ),
              ),
              SizedBox(height: 16),

              // Выбор дат
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectStartDate(context),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Период работ с',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          startDate == null
                              ? 'Выберите дату'
                              : DateFormat('yyyy-MM-dd').format(startDate!),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectEndDate(context),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'по',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          endDate == null
                              ? 'Выберите дату'
                              : DateFormat('yyyy-MM-dd').format(endDate!),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Поле для описания
              TextField(
                controller: TextEditingController(text: description),
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Описание',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                   description = value;
                },
              ),
              SizedBox(height: 16),

              // Кнопка прикрепить файл
              ElevatedButton(
                onPressed: _attachFile,
                child: Text('Прикрепить файл'),
              ),
              SizedBox(height: 16),

              // Список прикрепленных файлов
              Text('Прикрепленные файлы:', style: TextStyle(fontWeight: FontWeight.bold)),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: attachedFiles.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(attachedFiles[index].path.split('/').last),
                  );
                },
              ),

              SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.all(5.0),
                child: SizedBox(
                  width: double.infinity, // Задает ширину кнопки на всю ширину экрана
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color.fromARGB(255, 0, 78, 167), backgroundColor: Colors.white, // Цвет текста (синий)
                      side: BorderSide(
                        color: Color.fromARGB(255, 0, 78, 167), // Синяя рамка вокруг кнопки
                        width: 2.0,
                      ),
                      shape:  RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5), // Убираем закругление
                      ),
                    ),
                    onPressed: () {
                      if(isUpdate == false){
                        status = 'В проекте';
                        dbUtilsMelioObject?.addTask(MeliorationObjectModel(meliorativeObject, '1', '1', author, status, ein, startDate.toString(), endDate.toString(), description, 'file.jpeg1', 'techHealth', 'techConditional','','','','',));
                        Navigator.of(context).pop('/list_enter_job_application');
                      }else if (status == 'В проекте'){
                        dbUtilsMelioObject?.updateTask(indexObj!,
                            MeliorationObjectModel(meliorativeObject, '1', '1', author, status, ein, startDate.toString(), endDate.toString(), description, 'file.jpeg1', 'techHealth', 'techConditional','','','','',));
                        Navigator.of(context).pop('/list_enter_job_application');
                      }else{
                        _showSnackbar(context);
                      }
                    },
                    child: Text('Сохранить проект'), // Текст кнопки
                  ),
                ),
              ),

              SizedBox(height: 4),

              Padding(
                padding: const EdgeInsets.all(5.0),
                child: SizedBox(
                  width: double.infinity, // Задает ширину кнопки на всю ширину экрана
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color.fromARGB(255, 0, 78, 167), backgroundColor: Colors.white, // Цвет текста (синий)
                      side: BorderSide(
                        color: Color.fromARGB(255, 0, 78, 167), // Синяя рамка вокруг кнопки
                        width: 2.0,
                      ),
                      shape:  RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5), // Убираем закругление
                      ),
                    ),
                    onPressed: () {
                      if(status == 'В проекте'){
                        status = 'На рассмотрении';
                        dbUtilsMelioObject?.addTask(MeliorationObjectModel(meliorativeObject, '1', '1', author, status, ein, startDate.toString(), endDate.toString(), description, 'file.jpeg1', 'techHealth', 'techConditional','','','','',));
                        _sendApplicationForWork(description);
                        Navigator.of(context).pop('/list_enter_job_application');
                      }else{
                        _showSnackbar(context);
                      }
                    },
                    child: Text('Отправить'),
                  ),
                ),
              ),
            ],),
        ),
      ),
    );
  }
}