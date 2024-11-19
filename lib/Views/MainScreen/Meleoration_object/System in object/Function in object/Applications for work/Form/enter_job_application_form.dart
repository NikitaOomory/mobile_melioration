import 'package:flutter/material.dart';

import '../../../../../../../Models/my_arguments.dart';
import '../list_enter_job_application.dart';

class EnterJobApplicationForm extends StatefulWidget {
  @override
  _EnterJobApplicationFormState createState() => _EnterJobApplicationFormState();
}

class _EnterJobApplicationFormState extends State<EnterJobApplicationForm> {
  Application? application; // Объект заявки
  late TextEditingController _descriptionController; // Контроллер для описания
  DateTime? _startJobApplication; // Начальная дата работы
  DateTime? _endJobApplication; // Конечная дата работы
  bool _initialized = false; // Флаг для отслеживания инициализации
  String nameObject = 'Название объекта отсутствует';

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final MyArguments args = ModalRoute.of(context)?.settings.arguments as MyArguments;

      application = args.param3; // Получаем объект Application
      if (application != null) {
        _descriptionController.text = application!.description;
        _startJobApplication = DateTime.parse(application!.startJobDate);
        _endJobApplication = DateTime.parse(application!.endJobDate);
        _initialized = true;
        nameObject = args.param4;
      }
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? (_startJobApplication ?? DateTime.now()) : (_endJobApplication ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startJobApplication = picked;
        } else {
          _endJobApplication = picked;
        }
      });
    }
  }


  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(application == null ? 'Создать заявку' : 'Редактировать заявку'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: TextEditingController(text: application?.status ?? 'В проекте'),
              decoration: InputDecoration(labelText: 'Статус'),
              readOnly: true,
            ),
            SizedBox(height: 8),
            TextField(
              controller: TextEditingController(text: application?.owner ?? 'Неизвестный автор'),
              decoration: InputDecoration(labelText: 'Автор'),
              readOnly: true,
            ),
            SizedBox(height: 8),
            TextField(
              controller: TextEditingController(text: nameObject),
              decoration: InputDecoration(labelText: 'Мелиоративный объект'),
              readOnly: true,
            ),
            SizedBox(height: 8),
            TextField(
              controller: TextEditingController(text: '30Ф-ОРО-0001-ООС-001'),
              decoration: InputDecoration(labelText: 'ЕИН объекта'),
              readOnly: true,
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Начальная дата: ${_startJobApplication != null ? _startJobApplication!.toLocal().toString().split(' ')[0] : 'Не выбрано'}'),
                TextButton(
                  onPressed: () => _selectDate(context, true),
                  child: Text('Выбрать'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Конечная дата: ${_endJobApplication != null ? _endJobApplication!.toLocal().toString().split(' ')[0] : 'Не выбрано'}'),
                TextButton(
                  onPressed: () => _selectDate(context, false),
                  child: Text('Выбрать'),
                ),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController, // Используем контроллер для описания
              decoration: InputDecoration(labelText: 'Описание'),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: (){},
              child: Text('Сохранить заявку'),
            ),
          ],
        ),
      ),
    );
  }
}
