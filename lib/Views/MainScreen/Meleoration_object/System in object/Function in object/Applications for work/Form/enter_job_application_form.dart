import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mobile_melioration/Views/MainScreen/Meleoration_object/System%20in%20object/Function%20in%20object/Applications%20for%20work/Form/utils_form.dart';
import 'dart:io';

import '../../../../../../../Database/JobApplication/db_utils_melio_object.dart';
import '../../../../../../../Models/melioration_object_model.dart';
import '../../../../../../../Models/my_arguments.dart';
import '../../../../../../../UI-kit/Widgets/show_snack_bar.dart';
import '../list_enter_job_application.dart';

class EnterJobApplicationForm extends StatefulWidget {
  const EnterJobApplicationForm({super.key});

  @override
  State<StatefulWidget> createState() => _EnterJobApplicationForm();
}

class _EnterJobApplicationForm extends State<EnterJobApplicationForm> {
  final ShowSnackBar showSnackBar = ShowSnackBar();
  final DBUtilsJobApplications? dbUtilsMelioObject = DBUtilsJobApplications();
  final Dio _dio = Dio();
  late TextEditingController _controller; // Инициализация контроллера
  MeliorationObjectModel? dat;
  int? indexObjInHIVE;
  bool isUpdateApplication = false;
  String status = 'В проекте';
  String author = 'Иван Иванов';
  String nameMeliorativeObject = 'Сооружение 1';
  String ein = '30Ф-ОРО-0001-ООС-001';
  String startJobDate = '';
  String endJobDate = '';
  final List<File> _attachedFiles = [];
  String refObject = '';
  String refSystem = '';
  Application? applicationObj;
  DateTimeRange? selectedDateRange;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(); // Инициализация контроллера
  }

  @override
  void dispose() {
    _controller.dispose(); // Освобождение ресурсов контроллера
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final MyArguments? args = ModalRoute.of(context)?.settings.arguments as MyArguments?;
    if (args == null) {
      log('You must provide args');
      return;
    }
    if (args.param1 is! String) {
      log('You must provide String args');
      return;
    }
    applicationObj = args.param3 as Application;
    refObject = args.param1;
    refSystem = args.param2;
    status = applicationObj!.status;
    author = applicationObj!.owner;
    nameMeliorativeObject = args.param4;
    _controller.text = applicationObj!.description ?? ''; // Установка текста контроллера

    // Установка диапазона дат
    if (applicationObj!.description != null && applicationObj!.description.isNotEmpty) {
      isUpdateApplication = true;
      selectedDateRange = DateTimeRange(
        start: DateTime(2024, 10, 31),
        end: DateTime(2024, 11, 7),
      );
      startJobDate = '31.10.2024';
      endJobDate = '07.11.2024';
    } else {
      isUpdateApplication = false;
      selectedDateRange = null;
      startJobDate = '';
      endJobDate = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Заявка на работу'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Поля для отображения информации
              TextField(
                controller: TextEditingController(text: status),
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Статус',
                  border: InputBorder.none,
                ),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: TextEditingController(text: author),
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Автор',
                  border: InputBorder.none,
                ),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: TextEditingController(text: nameMeliorativeObject),
                readOnly: true,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Мелиоративный объект',
                  border: InputBorder.none,
                ),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: TextEditingController(text: ein),
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'ЕИН объекта',
                  border: InputBorder.none,
                ),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDateRange(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_month, color: Colors.grey),
                            Text(
                              selectedDateRange != null
                                  ? '${DateFormat('dd.MM.yyyy').format(selectedDateRange!.start)} - ${DateFormat('dd.MM.yyyy').format(selectedDateRange!.end)}'
                                  : 'Выберите период',
                              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controller, // Используем один контроллер
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Описание',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 0, 78, 167)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 0, 78, 167),
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Color.fromARGB(255, 0, 78, 167), width: 2.0),
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
                              const Icon(Icons.file_open_rounded, color: Color.fromARGB(255, 0, 78, 167)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${truncateText(_attachedFiles[index].path.split('/').last, 25)}',
                                  style: const TextStyle(color: Color.fromARGB(255, 0, 78, 167)),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.close, color: Color.fromARGB(255, 0, 78, 167)),
                            onPressed: () => _removeFile(index),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
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
                    // Сохраняем значение description
                    if (isUpdateApplication == false && status == 'В проекте') {
                      status = 'В проекте';
                      dbUtilsMelioObject?.addTask(
                        MeliorationObjectModel(
                          '',
                          '',
                          '',
                          '',
                          status,
                          '',
                          '',
                          '',
                          _controller.text,
                          'downloadFiles',
                          '',
                          '',
                          "2024-10-26T00:00:00-05:00",
                          '',
                          refSystem,
                          refObject,
                        ),
                      );
                      Navigator.of(context).pop('/list_enter_job_application');
                      print('--------------------------------------------------------');
                      print('Мы создали новую заявку!!!! $refObject + $refSystem');
                      print('--------------------------------------------------------');
                    } else if (isUpdateApplication == true && status == 'В проекте') {
                      Navigator.of(context).pop('/list_enter_job_application');
                    } else if (isUpdateApplication == true && status == 'На рассмотрении') {
                      showSnackBar.showSnackBar(context, 'Заявка уже отправлена, её нельзя редактировать.');
                    } else {
                      showSnackBar.showSnackBar(context, 'Ошибка статусной модели.');
                    }
                  },
                  child: const Text('Сохранить проект'),
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
                    if (status == 'В проекте') {
                      status = 'На рассмотрении';
                      UtilsForm util = UtilsForm();
                      util.sendApplicationForWork(refSystem, refObject, startJobDate, endJobDate, _controller.text, _dio, _attachedFiles);
                      Navigator.of(context).pop('/list_enter_job_application');
                    } else if (status == 'На рассмотрении') {
                      showSnackBar.showSnackBar(context, 'Заявка уже отправлена.');
                    } else {
                      showSnackBar.showSnackBar(context, 'Ошибка статусной модели.');
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
                  final ImagePicker _picker = ImagePicker();
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

  void _selectDateRange(BuildContext context) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: selectedDateRange,
      firstDate: DateTime(2024),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDateRange = picked;
        startJobDate = DateFormat('dd.MM.yyyy').format(selectedDateRange!.start);
        endJobDate = DateFormat('dd.MM.yyyy').format(selectedDateRange!.end);
      });
    }
  }

  String truncateText(String text, int maxLength) {
    if (text.length > maxLength) {
      return '${text.substring(0, maxLength)}...';
    }
    return text;
  }
}