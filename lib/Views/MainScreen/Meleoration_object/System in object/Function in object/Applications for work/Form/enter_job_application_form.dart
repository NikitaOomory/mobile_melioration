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

  final Dio _dio = Dio();

  MeliorationObjectModel? dat;
  int? indexObjInHIVE;
  bool isUpdateApplication = false;

  String status = 'В проекте';
  String author = 'Иван Иванов';
  String nameMeliorativeObject = 'Сооружение 1';
  String ein = '30Ф-ОРО-0001-ООС-001';
  DateTime? startDate;
  DateTime? endDate;
  String description = '';
  final List<File> _attachedFiles = []; //список закреплённых файлов

  String refObject = '';
  String refSystem = '';
  Application? applicationObj;
  String nameObject = '';

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
    applicationObj = args.param3 as Application;
    refObject = args.param1;
    refSystem = args.param2;
    nameObject = args.param4;
    status = applicationObj!.status;
    author = applicationObj!.owner;
    nameMeliorativeObject = nameObject;
    description = applicationObj!.description;

    if (description == null || description.isEmpty || description == '') {
      isUpdateApplication = false;
    } else {
      isUpdateApplication = true;
    }

    setState(() {});
    super.didChangeDependencies();
  }


  Future<void> _sendApplicationForWork(String description) async {
    final String url =
        'http://192.168.7.6/MCX_melio_dev_atropin/hs/api/?typerequest=WriteApplicationForWork';
    String username = 'tropin'; // Замените на ваши учетные данные
    String password = '1234'; // Замените на ваши учетные данные

    // Тело запроса
    final Map<String, dynamic> requestBody = {
      "ReclamationSystem": refSystem,
      "HydraulicStructure": refObject,
      "startDate": "2024-10-28T00:00:00-05:00",
      "startJobDate": "2024-10-28T00:00:00-05:00",
      "endJobDate": "2024-10-30T00:00:00-05:00",
      "description": description,
    };

    try {
      await uploadFiles(refObject, _attachedFiles);
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
        print('--------------------------------------------------------');
        print('Заявка отправлена');
        print('--------------------------------------------------------');
        print('Response data: ${response.data}');
      } else {
        print('--------------------------------------------------------');
        print('Ошибка отправки заявки: ${response.statusCode}');
        print('--------------------------------------------------------');
      }
    } catch (e) {
      print('--------------------------------------------------------');
      print('Ошибка отправки заявки: $e');
      print('--------------------------------------------------------');
    }
  }

  Future<void> uploadFiles(String ref, List<File> files) async {
    final dio = Dio();
    String username = 'tropin';
    String password = '1234';
    String url = 'http://192.168.7.6/MCX_melio_dev_atropin/hs/api/?typerequest=WriteFileApplicationForWork'; // Установите базовую аутентификацию

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
          print('--------------------------------------------------------');
          print('ФАЙЛЫ ОТПРАВИЛИСЬ');
          print('--------------------------------------------------------');
          print('Файл ${file.path.split('/').last} успешно загружен: ${response.data}');
        } else {
          print('--------------------------------------------------------');
          print('Ошибка при загрузке файла ${file.path.split('/').last}: ОТВЕТ 1С ${response.statusCode}');
          print('--------------------------------------------------------');
        }
      } catch (e) {
        print('--------------------------------------------------------');
        print('Произошла ошибка при загрузке файла ${file.path}: $e');
        print('--------------------------------------------------------');
      }
    }
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
              const Text('Выберите способ прикрепления файла',
                  style: TextStyle(fontSize: 18)),
              const SizedBox(height: 16),
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
                child: const Text('Сделать фото'),
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
                child: const Text('Выбрать файл'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Закрыть модальное окно
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
              TextField(
                controller: TextEditingController(
                  text: status,
                ),
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Статус',
                  border: InputBorder.none,
                ),
                style: (const TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
              TextField(
                  controller: TextEditingController(text: author),
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Автор',
                    border: InputBorder.none,
                  ),
                  style: (const TextStyle(fontWeight: FontWeight.bold))),
              const SizedBox(height: 16),
              TextField(
                  controller: TextEditingController(text: nameMeliorativeObject),
                  readOnly: true,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Мелиоративный объект',
                    border: InputBorder.none,
                  ),
                  style: (const TextStyle(fontWeight: FontWeight.bold))),
              const SizedBox(height: 16),
              TextField(
                  controller: TextEditingController(text: ein),
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'ЕИН объекта',
                    border: InputBorder.none,
                  ),
                  style: (const TextStyle(fontWeight: FontWeight.bold))),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectStartDate(context),
                      child: const InputDecorator(
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
                      child: const InputDecorator(
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
              const SizedBox(height: 16),
              //
              // // Поле для описания
              TextField(
                controller: TextEditingController(text: description),
                maxLines: 5,
                decoration: const InputDecoration(
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
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 0, 78, 167),
                    backgroundColor: Colors.white,
                    // Цвет текста (синий)
                    side: const BorderSide(
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
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.download),
                      Text('Прикрепить файл'),
                    ],
                  )
                ),
              ),

              const SizedBox(height: 16),
              //
              ListView.builder(
                shrinkWrap: true,
                // Позволяет ListView занимать только необходимое пространство
                physics: const NeverScrollableScrollPhysics(),
                // Отключите прокрутку, если она не нужна
                itemCount: _attachedFiles.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Row(
                      children: [
                        const Icon(Icons.file_open_rounded, color: Color.fromARGB(255, 0, 78, 167),),
                        Text(_attachedFiles[index].path.split('/').last,
                          style: const TextStyle(color: Color.fromARGB(255, 0, 78, 167)),),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.close, color: Color.fromARGB(255, 0, 78, 167),),
                      onPressed: () => _removeFile(index),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                // Задает ширину кнопки на всю ширину экрана
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 0, 78, 167),
                    backgroundColor: Colors.white,
                    // Цвет текста (синий)
                    side: const BorderSide(
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
                    if (isUpdateApplication == false && status == 'В проекте') {
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
                          refSystem,
                          refObject));
                      Navigator.of(context).pop('/list_enter_job_application');
                      print('$refObject + $refSystem МЫ СОЗДАЛИ НОВУЮ!!!! ');
                    } else if (isUpdateApplication == true && status == 'В проекте') {
                      status == 'В проекте';
                      dbUtilsMelioObject?.updateTask(
                          getIndexByPrevUnit(refObject) as int,
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
                              refSystem,
                              refObject));
                      Navigator.of(context).pop('/list_enter_job_application');
                    } else if (status == 'На рассмотрении') {
                      _showSnackbar(context,
                          'Заявка уже отправлена, её нельзя редактировать.');
                    } else {
                      _showSnackbar(context, 'Ошибка статусной модели.');
                    }
                    //todo: нужно обработать через case весь получаемый словарь статусов.
                  },
                  child: const Text('Сохранить проект'), // Текст кнопки
                ),
              ),

              const SizedBox(height: 4),

              SizedBox(
                width: double.infinity,
                // Задает ширину кнопки на всю ширину экрана
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 0, 78, 167),
                    // Цвет текста (синий)
                    side: const BorderSide(
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
                      deleteByPrevUnit(refObject);

                      Navigator.of(context).pop('/list_enter_job_application');
                    } else if (status == 'На рассмотрении') {
                      _showSnackbar(context, 'Заявка уже отправлена.');
                    } else {
                      _showSnackbar(context, 'Ошибка статусной модели.');
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
