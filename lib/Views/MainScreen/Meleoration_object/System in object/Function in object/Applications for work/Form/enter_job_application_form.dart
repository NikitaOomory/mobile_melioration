import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../../Database/JobApplication/db_utils_melio_object.dart';
import '../../../../../../../Models/melioration_object_model.dart';
import '../../../../../../../Models/my_arguments.dart';
import '../list_enter_job_application.dart';

class EnterJobApplicationForm extends StatefulWidget {
  const EnterJobApplicationForm({super.key});

  @override
  State<StatefulWidget> createState() => _EnterJobApplicationForm();
}

class _EnterJobApplicationForm extends State<EnterJobApplicationForm> {

  DBUtilsJobApplications? dbUtilsMelioObject = DBUtilsJobApplications(); //класс для взаимодействия с локальной БД

  MeliorationObjectModel? dat;
  int? indexObj;
  bool isUpdate = false;
  List<String> downloadFiles = [];

  String status = 'В проекте'; //Статус, заполненный заранее
  String author = 'Иван Иванов'; //Автор, заполненный заранее
  String meliorativeObject =
      'Сооружение 1'; // Мелиоративный объект, заполненный  заранее
  String ein = '30Ф-ОРО-0001-ООС-001'; // ЕИН объекта, заполненный заранее
  DateTime? startDate; // Дата начала работ
  DateTime? endDate; // Дата окончания работ
  String description = ''; // Описание работ
  List<File> attachedFiles = []; // Список прикрепленных файлов
  final List<File> _attachedFiles = [];

  String ref = '';
  String refValue = '';
  Application? application;
  String nameOb = '';

  @override
  void didChangeDependencies() {
    final MyArguments args =
        ModalRoute.of(context)?.settings.arguments as MyArguments;
    if (args == null) {
      log('You must provide args');
      return;
    }
    if (args.param1 is! String) {
      log('You must provide String args');
      return;
    }
    application = args.param3 as Application;
    ref = args.param1;
    refValue = args.param2;
    nameOb = args.param4;

    status = application!.status;
    author = application!.owner;
    meliorativeObject = nameOb;
    description = application!.description;

    if (description == null || description.isEmpty || description == '') {
      isUpdate = false;
    } else {
      isUpdate = true;
    }

    setState(() {});
    super.didChangeDependencies();
  }

  final Dio _dio = Dio();

  //todo: встроить в метод для отправки;
  Future<void> uploadFiles(String ref, List<File> files) async {
    final dio = Dio();
    String username = 'tropin'; // Замените на ваши учетные данные
    String password = '1234'; // Замените на ваши учетные данные
    String url = 'http://192.168.7.6/MCX_melio_dev_atropin/hs/api/?typerequest=WriteFileApplicationForWork'; // Установите базовую аутентификацию

    // Установите базовую аутентификацию
    dio.options.headers["Authorization"] = "Basic " + base64Encode(utf8.encode('$username:$password'));

    for (File file in files) {
      try {
        // Создаем FormData для отправки
        FormData formData = FormData.fromMap({
          'ref': 'd7b0af7c-96be-11ef-9db5-005056907678', // Используем переданный ref
          'file': await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
             // Указываем Content-Type

          ),
        });

        // Отправляем POST-запрос
        final response = await dio.post(url, data: formData);
        print(formData.fields); // Выводит поля формы


        // Обрабатываем ответ
        if (response.statusCode == 200) {
          print('Файл ${file.path.split('/').last} успешно загружен: ${response.data}');
        } else {
          print('Ошибка при загрузке файла ${file.path.split('/').last}: ОТВЕТ 1С ${response.statusCode}');
        }
      } catch (e) {
        print('Произошла ошибка при загрузке файла ${file.path}: $e');
      }
    }
  }

  Future<void> _sendApplicationForWork(String description) async {
    final String url =
        'http://192.168.7.6/MCX_melio_dev_atropin/hs/api/?typerequest=WriteApplicationForWork';
    String username = 'tropin'; // Замените на ваши учетные данные
    String password = '1234'; // Замените на ваши учетные данные

    // Тело запроса
    final Map<String, dynamic> requestBody = {
      "ReclamationSystem": refValue,
      "HydraulicStructure": ref,
      "startDate": "2024-10-28T00:00:00-05:00",
      "startJobDate": "2024-10-28T00:00:00-05:00",
      "endJobDate": "2024-10-30T00:00:00-05:00",
      "description": description,
    };

    try {
      final response = await _dio.post(
        url,
        data: jsonEncode(requestBody), // Отправка тела запроса
        options: Options(
          headers: {
            'Authorization':
                'Basic ${base64Encode(utf8.encode('$username:$password'))}',
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

  void _showSnackbar(BuildContext context, String massage) {
    final snackBar = SnackBar(
      content: Text(massage),
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
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Выберите способ прикрепления файла',
                  style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              TextButton(
                onPressed: () async {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? photo =
                      await _picker.pickImage(source: ImageSource.camera);
                  if (photo != null) {
                    setState(() {
                      _attachedFiles.add(File(photo.path));
                    });
                  }
                  Navigator.of(context).pop(); // Закрыть модальное окно
                },
                child: Text('Сделать фото'),
              ),
              TextButton(
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    allowMultiple: false,
                    type: FileType.any,
                  );
                  if (result != null && result.files.isNotEmpty) {
                    setState(() {
                      _attachedFiles.add(File(result.files.single.path!));
                    });
                  }
                  Navigator.of(context).pop(); // Закрыть модальное окно
                },
                child: Text('Выбрать файл'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Закрыть модальное окно
                },
                child: Text('Отмена'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Заявка на работу'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: TextEditingController(
                  text: status,
                ),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Статус',
                  border: InputBorder.none,
                ),
                style: (TextStyle(fontWeight: FontWeight.bold)),
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
                  style: (TextStyle(fontWeight: FontWeight.bold))),
              SizedBox(height: 16),

              // Поле мелиоративного объекта
              TextField(
                  controller: TextEditingController(text: meliorativeObject),
                  readOnly: true,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Мелиоративный объект',
                    border: InputBorder.none,
                  ),
                  style: (TextStyle(fontWeight: FontWeight.bold))),
              SizedBox(height: 16),

              // Поле ЕИН объекта
              TextField(
                  controller: TextEditingController(text: ein),
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'ЕИН объекта',
                    border: InputBorder.none,
                  ),
                  style: (TextStyle(fontWeight: FontWeight.bold))),
              SizedBox(height: 16),

              // Выбор дат
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectStartDate(context),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'c',
                          // Цвет рамки, когда поле активно
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue), // Цвет рамки при фокусе
                          ),
                          // Цвет рамки, когда поле не активно
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey), // Цвет рамки при неактивном состоянии
                          ),
                        ),
                        child: Text('Выберите дату'),
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
                          // Цвет рамки, когда поле активно
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue), // Цвет рамки при фокусе
                          ),
                          // Цвет рамки, когда поле не активно
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey), // Цвет рамки при неактивном состоянии
                          ),
                        ),
                        child: Text('Выберите дату'),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              //
              // // Поле для описания
              TextField(
                controller: TextEditingController(text: description),
                maxLines: 5,
                decoration: InputDecoration(
                labelText: 'Описание',
                // Цвет рамки, когда поле активно
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue), // Цвет рамки при фокусе
                ),
                // Цвет рамки, когда поле не активно
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey), // Цвет рамки при неактивном состоянии
                ),
              ),
                onChanged: (value) {
                  description = value;
                },
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Color.fromARGB(255, 0, 78, 167),
                    backgroundColor: Colors.white,
                    // Цвет текста (синий)
                    side: BorderSide(
                      color: Color.fromARGB(255, 0, 78, 167),
                      // Синяя рамка вокруг кнопки
                      width: 2.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(5), // Убираем закругление
                    ),
                  ),
                  onPressed: _attachFile,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.download),
                      Text('Прикрепить файл'),
                    ],
                  )
                ),
              ),

              SizedBox(height: 16),
              //
              ListView.builder(
                shrinkWrap: true,
                // Позволяет ListView занимать только необходимое пространство
                physics: NeverScrollableScrollPhysics(),
                // Отключите прокрутку, если она не нужна
                itemCount: _attachedFiles.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Row(
                      children: [
                        Icon(Icons.file_open_rounded, color: Color.fromARGB(255, 0, 78, 167),),
                        Text(_attachedFiles[index].path.split('/').last,
                          style: TextStyle(color: Color.fromARGB(255, 0, 78, 167)),),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.close, color: Color.fromARGB(255, 0, 78, 167),),
                      onPressed: () => _removeFile(index),
                    ),
                  );
                },
              ),

              SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                // Задает ширину кнопки на всю ширину экрана
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Color.fromARGB(255, 0, 78, 167),
                    backgroundColor: Colors.white,
                    // Цвет текста (синий)
                    side: BorderSide(
                      color: Color.fromARGB(255, 0, 78, 167),
                      // Синяя рамка вокруг кнопки
                      width: 2.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(5), // Убираем закругление
                    ),
                  ),
                  onPressed: () {
                    if (isUpdate == false && status == 'В проекте') {
                      status = 'В проекте';
                      dbUtilsMelioObject?.addTask(MeliorationObjectModel(
                          '',
                          '',
                          '',
                          '',
                          status,
                          '',
                          '',
                          '',
                          description,
                          'downloadFiles',
                          '',
                          '',
                          "2024-10-26T00:00:00-05:00",
                          '',
                          refValue,
                          ref));
                      Navigator.of(context).pop('/list_enter_job_application');
                      print('$ref + $refValue МЫ СОЗДАЛИ НОВУЮ!!!! ');
                    } else if (isUpdate == true && status == 'В проекте') {
                      status == 'В проекте';
                      dbUtilsMelioObject?.updateTask(
                          getIndexByPrevUnit(ref) as int,
                          MeliorationObjectModel(
                              '',
                              '',
                              '',
                              '',
                              status,
                              '',
                              '',
                              '',
                              description,
                              'downloadFiles',
                              '',
                              '',
                              "2024-10-26T00:00:00-05:00",
                              '',
                              refValue,
                              ref));
                      Navigator.of(context).pop('/list_enter_job_application');
                    } else if (status == 'На рассмотрении') {
                      _showSnackbar(context,
                          'Заявка уже отправлена, её нельзя редактировать.');
                    } else {
                      _showSnackbar(context, 'Ошибка статусной модели.');
                    }
                    //todo: нужно обработать через case весь получаемый словарь статусов.
                  },
                  child: Text('Сохранить проект'), // Текст кнопки
                ),
              ),

              SizedBox(height: 4),

              SizedBox(
                width: double.infinity,
                // Задает ширину кнопки на всю ширину экрана
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color.fromARGB(255, 0, 78, 167),
                    // Цвет текста (синий)
                    side: BorderSide(
                      color: Color.fromARGB(255, 0, 78, 167),
                      // Синяя рамка вокруг кнопки
                      width: 2.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(5), // Убираем закругление
                    ),
                  ),
                  onPressed: () {
                    uploadFiles(ref, _attachedFiles);
                  },
                  child: Text('Отправить файлы'),
                ),
              ),

              SizedBox(
                width: double.infinity,
                // Задает ширину кнопки на всю ширину экрана
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color.fromARGB(255, 0, 78, 167),
                    // Цвет текста (синий)
                    side: BorderSide(
                      color: Color.fromARGB(255, 0, 78, 167),
                      // Синяя рамка вокруг кнопки
                      width: 2.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(5), // Убираем закругление
                    ),
                  ),
                  onPressed: () {
                    if (status == 'В проекте') {
                      status = 'На рассмотрении';
                      _sendApplicationForWork(description);
                      deleteByPrevUnit(ref);
                      print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
                      print('ОТПРАВКА ОБЪЕКТА НА СЕРВЕЕЕЕЕЕР!!!!!');

                      Navigator.of(context).pop('/list_enter_job_application');
                    } else if (status == 'На рассмотрении') {
                      _showSnackbar(context, 'Заявка уже отправлена.');
                    } else {
                      _showSnackbar(context, 'Ошибка статусной модели.');
                    }
                  },
                  child: Text('Отправить'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<int?> getIndexByPrevUnit(String prevUnit) async {
    final box = Hive.box<MeliorationObjectModel>('tasks');
    List<MeliorationObjectModel> allObjects = box.values.toList();

    // Находим индекс объекта с переданным prevUnit
    for (int i = 0; i < allObjects.length; i++) {
      if (allObjects[i].prevUnit == prevUnit) {
        return i; // Возвращаем индекс, если найден
      }
    }
    return null; // Возвращаем null, если объект не найден
  }

  // Метод для удаления задачи по prevUnit
  Future<void> deleteByPrevUnit(String prevUnit) async {
    int? index = await getIndexByPrevUnit(prevUnit);
    if (index != null) {
      await dbUtilsMelioObject?.deleteTask(index);
    } else {
      print('Объект с prevUnit $prevUnit не найден.');
    }
  }
}
