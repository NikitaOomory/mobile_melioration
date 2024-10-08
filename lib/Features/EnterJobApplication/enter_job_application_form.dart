
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

class EnterJobApplicationForm extends StatefulWidget{
  const EnterJobApplicationForm({super.key});

  @override
  State<StatefulWidget> createState() => _EnterJobApplicationForm();
}

class _EnterJobApplicationForm extends State<EnterJobApplicationForm>{
  String status = 'В работе'; // Статус, заполненный заранее
  String author = 'Иван Иванов'; // Автор, заполненный заранее
  String meliorativeObject = 'Объект 1'; // Мелиоративный объект, заполненный заранее
  String ein = 'ЕИН: 123456'; // ЕИН объекта, заполненный заранее
  DateTime? startDate; // Дата начала работ
  DateTime? endDate; // Дата окончания работ
  String description = ''; // Описание работ
  List<File> attachedFiles = []; // Список прикрепленных файлов

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
        title: Text('Форма ввода'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Поле статуса
              TextField(
                controller: TextEditingController(text: status),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Статус',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              // Поле автора
              TextField(
                controller: TextEditingController(text: author),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Автор',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              // Поле мелиоративного объекта
              TextField(
                controller: TextEditingController(text: meliorativeObject),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Мелиоративный объект',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              // Поле ЕИН объекта
              TextField(
                controller: TextEditingController(text: ein),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'ЕИН объекта',
                  border: OutlineInputBorder(),
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
                          labelText: 'Период работ (с)',
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
                  SizedBox(width: 16),
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

              ElevatedButton(
                onPressed: (){},
                child: Text('Сохранить проект'),
              ),
              SizedBox(height: 4),

              ElevatedButton(
                onPressed: (){},
                child: Text('Отправить'),
              ),
            ],),
        ),
      ),
    );

  }
}