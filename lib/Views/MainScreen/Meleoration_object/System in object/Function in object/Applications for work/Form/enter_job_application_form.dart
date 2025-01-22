import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mobile_melioration/Database/JobApplication/db_utils_melio_object.dart';
import 'package:mobile_melioration/Models/melioration_object_model.dart';
import 'package:mobile_melioration/Views/MainScreen/Meleoration_object/System%20in%20object/Function%20in%20object/Applications%20for%20work/Form/utils_form.dart';

import '../../../../../../../Models/application.dart';
import '../../../../../../../Models/my_arguments.dart';
import '../../../../../../../UI-kit/Widgets/show_snack_bar.dart';

class EnterJobApplicationForm extends StatefulWidget {
  @override
  _EnterJobApplicationFormState createState() => _EnterJobApplicationFormState();
}

class _EnterJobApplicationFormState extends State<EnterJobApplicationForm> {
  DBUtilsJobApplications dbUtilsJobApplications = DBUtilsJobApplications();
  final Dio _dio = Dio();
  bool isUpdate = false;
  int? indexObjectFromDB = -1;

  Application? application; // Объект заявки
  late TextEditingController _descriptionController; // Контроллер для описания
  DateTimeRange? selectedDateRange; // Диапазон выбранных дат
  bool _initialized = false; // Флаг для отслеживания инициализации
  String nameObject = 'Название объекта отсутствует';
  final List<File> _attachedFiles = []; //список прикреплённых файлов
  String refSystem ='';
  String refObject ='';

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    if (!_initialized) {
      final MyArguments args = ModalRoute
          .of(context)
          ?.settings
          .arguments as MyArguments;
      refObject = args.param1;
      refSystem = args.param2;
      application = args.param3; // Получаем объект Application
      if (application != null) {
        _descriptionController.text = application!.description;
        // Устанавливаем начальный диапазон если они известны
        selectedDateRange = DateTimeRange(
          start: parseDate(application!.startJobDate), // Преобразуем формат
          end: parseDate(application!.endJobDate), // Преобразуем формат
        );
        _initialized = true;
        nameObject = args.param4;
        someAsyncMethod();
      }
    }
  }

  Future<void> someAsyncMethod() async {
    indexObjectFromDB = await dbUtilsJobApplications.findTaskIndex(
      status: application!.status,
      description: _descriptionController.text,
      startJobDate: DateFormat('dd.MM.yyyy').format(selectedDateRange!.start),
      endJobDate: DateFormat('dd.MM.yyyy').format(selectedDateRange!.end),
      prevUnit: refSystem,
      nextUnit: refObject,
    );

    setState(() {
      isUpdate = indexObjectFromDB != -1; // Устанавливаем флаг обновления
    });

    if (isUpdate) {
      print('Нашли такой объект с индексом $indexObjectFromDB');
    } else {
      print('Не нашли такой объект $indexObjectFromDB');
    }
  }

  // Функция для парсинга даты из строкового значения
  DateTime parseDate(String dateString) {
    try {
// Пробуем парсить в формате ISO 8601
      return DateTime.parse(dateString);
    } catch (e) {
// Если не удается, пробуем парсить в формате dd.MM.yyyy
      final parts = dateString.split('.');
      if (parts.length == 3) {
        return DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
      }
      throw FormatException("Неверный формат даты. Ожидается dd.MM.yyyy или ISO 8601");
    }
  }

  Future<void> _selectDateRange(BuildContext context) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: selectedDateRange,
      firstDate: DateTime(2024),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        selectedDateRange = picked;
// Здесь вы можете обновлять ставя значение в другие переменные
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
        title: Text(
            'Заявка на работу'),
      ),
      body: SingleChildScrollView( child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: TextEditingController(
                  text: application?.status ?? 'В проекте'),
              decoration: const InputDecoration(
                labelText: 'Статус', border: InputBorder.none,),
              style: const TextStyle(fontWeight: FontWeight.bold),
              readOnly: true,
            ),
            SizedBox(height: 8),
            TextField(
              controller: TextEditingController(
                  text: application?.owner ?? 'Неизвестный автор'),
              decoration: InputDecoration(
                labelText: 'Автор', border: InputBorder.none,),
              style: const TextStyle(fontWeight: FontWeight.bold),
              readOnly: true,
            ),
            SizedBox(height: 8),
            TextField(
              controller: TextEditingController(text: nameObject),
              decoration: InputDecoration(
                labelText: 'Мелиоративный объект', border: InputBorder.none,),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              readOnly: true,
              maxLines: 2,
            ),
            SizedBox(height: 8),
            TextField(
              controller: TextEditingController(text: '30Ф-ОРО-0001-ООС-001'),
              decoration: InputDecoration(
                labelText: 'ЕИН объекта', border: InputBorder.none,),
              style: const TextStyle(fontWeight: FontWeight.bold),
              readOnly: true,
            ),
            SizedBox(height: 8),
            // Отображение диапазона дат
            GestureDetector(
              onTap: () => _selectDateRange(context),
              child: InputDecorator(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Выбранный диапазон дат',
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(selectedDateRange != null
                        ? '${DateFormat('dd.MM.yyyy').format(
                        selectedDateRange!.start)} - ${DateFormat('dd.MM.yyyy')
                        .format(selectedDateRange!.end)}'
                        : 'Выберите диапазон'),
                    Icon(Icons.calendar_today, color: Colors.grey),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Описание',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 0, 78, 167)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 0, 78, 167),
                  backgroundColor: Colors.white,
                  side: const BorderSide(
                      color: Color.fromARGB(255, 0, 78, 167), width: 2.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: _attachFile,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.download),
                    Text('Прикрепить файл'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _attachedFiles.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: Row(
                          children: [
                            const Icon(Icons.file_open_rounded,
                                color: Color.fromARGB(255, 0, 78, 167)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${truncateText(_attachedFiles[index].path.split('/').last, 25)}',
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 0, 78, 167)),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.close,
                              color: Color.fromARGB(255, 0, 78, 167)),
                          onPressed: () => _removeFile(index),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Color.fromARGB(255, 0, 78, 167), width: 2.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: () {
                  MeliorationObjectModel object = MeliorationObjectModel(
                    '',
                    '',
                    '',
                    application!.owner,
                    application!.status,
                    '',
                    application!.startDate,
                    '',
                    _descriptionController.text,
                    'files',
                    '',
                    '',
                    DateFormat('dd.MM.yyyy').format(selectedDateRange!.start).toString(),
                    DateFormat('dd.MM.yyyy').format(selectedDateRange!.end).toString(),
                    refSystem,
                    refObject,
                  );
                  if (application!.status == 'В проекте' && isUpdate == false) {
                    dbUtilsJobApplications.addTask(object);
                    print('Мы создали новую заявку! ${_descriptionController.text} + ${application!.startDate}');
                    Navigator.of(context).pop('/list_enter_job_application');
                  }else if(application!.status == 'В проекте' && isUpdate == true){
                    dbUtilsJobApplications.updateTask(indexObjectFromDB!, object);
                    print('Мы обновили заявку с индексом $indexObjectFromDB');
                    Navigator.of(context).pop('/list_enter_job_application');
                  }
                  else{
                    ShowSnackBar.showSnackBar(context, 'Заявка уже отправлена, её нельзя редактировать.');
                  }
                },
                child: const Text('Сохранить проект', style: TextStyle(color: Color.fromARGB(255, 0, 78, 167)),),
              ),
            ),
            if (application?.status == 'В проекте' && isUpdate == true) // Проверка статуса
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    dbUtilsJobApplications.deleteTask(indexObjectFromDB!);
                    print('Мы удалили заявку с индексом $indexObjectFromDB');
                    Navigator.of(context).pop('/list_enter_job_application');
                  },
                  child: const Text('Удалить проект'),
                ),
              ),
            const SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 0, 78, 167),
                  side: const BorderSide(color: Color.fromARGB(255, 0, 78, 167), width: 2.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: () {
                  if (application!.status == 'В проекте') {
                    application!.status = 'На рассмотрении';
                    UtilsForm util = UtilsForm();
                    util.sendApplicationForWork(
                        refSystem,
                        refObject,
                        '${formatDate(selectedDateRange!.start)}',
                        '${formatDate(selectedDateRange!.end)}',
                        _descriptionController.text,
                        _dio,
                        _attachedFiles);
                    dbUtilsJobApplications.deleteTask(indexObjectFromDB!);
                    print('Мы удалили заявку с индексом $indexObjectFromDB из БД');
                    Navigator.of(context).pop('/list_enter_job_application');
                  } else{
                    ShowSnackBar.showSnackBar(context, 'Заявка уже отправлена.');
                  }
                },
                child: const Text('Отправить'),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  String formatDate(DateTime date) {
// Преобразуем в строку формата ISO 8601
    return '${date.toIso8601String().split('T')[0]}T00:00:00-05:00';
  }

  Future<void> _attachFile() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Выберите способ прикрепления файла', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () async {
                  final ImagePicker _picker = ImagePicker(); // Создаем экземпляр ImagePicker
                  final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
                  if (photo != null) {
                    setState(() {
                      _attachedFiles.add(File(photo.path));
                    });
                  }
                  Navigator.of(context).pop();
                },
                child: const Text('Сделать фото'),
              ),
              TextButton(
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: false, type: FileType.any);
                  if (result != null && result.files.isNotEmpty) {
                    setState(() {
                      _attachedFiles.add(File(result.files.single.path!));
                    });
                  }
                  Navigator.of(context).pop();
                },
                child: const Text('Выбрать файл'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Отмена'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _removeFile(int index) {
    setState(() {
      _attachedFiles.removeAt(index);
    });
  }

  String truncateText(String text, int maxLength) {
    if (text.length > maxLength) {
      return '${text.substring(0, maxLength)}...';
    }
    return text;
  }
}




