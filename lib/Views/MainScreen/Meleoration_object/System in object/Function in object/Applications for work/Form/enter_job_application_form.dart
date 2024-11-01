import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

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
  DBUtilsJobApplications? dbUtilsMelioObject =
      DBUtilsJobApplications(); //класс для взаимодействия с локальной БД

  final Dio _dio = Dio();

  late TextEditingController _controller = TextEditingController();

  MeliorationObjectModel? dat;
  int? indexObjInHIVE;
  bool isUpdateApplication = false;

  String status = 'В проекте';
  String author = 'Иван Иванов';
  String nameMeliorativeObject = 'Сооружение 1';
  String ein = '30Ф-ОРО-0001-ООС-001';
  String startDate = '31.10.2024';
  String endDate = '';
  String startJobDate = '';
  String endJobDate = '';
  String description = '';
  final List<File> _attachedFiles = []; //список закреплённых файлов
  String refObject = '';
  String refSystem = '';
  Application? applicationObj;
  String nameObject = '';
  DateTimeRange? selectedDateRange; //диапазон дат


  @override
  void dispose() {
    _controller.dispose(); // Освобождаем ресурсы контроллера
    super.dispose();
  }

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
      selectedDateRange = DateTimeRange(
        start: DateTime(2024, 10, 31), // 31 октября 2024 года
        end: DateTime(2024, 11, 7),    // 7 ноября 2024 года
      );
    }

    setState(() {
      _controller = TextEditingController(text: description);
      if (description == null || description.isEmpty || description == '') {

      } else {
        startJobDate = '31.10.2024';
        endJobDate = '07.11.2024';
      }
    });
    super.didChangeDependencies();
  }

  Future<void> _sendApplicationForWork(String description) async {
    final String url = 'https://melio.mcx.ru/melio_pmi_login//hs/api/?typerequest=WriteApplicationForWork';
    String username = 'ИТР ФГБУ'; // Замените на ваши учетные данные
    String password = '1234'; // Замените на ваши учетные данные

    // Тело запроса
    final Map<String, dynamic> requestBody = {
      "ReclamationSystem": refSystem,
      "HydraulicStructure": refObject,
      "startDate": "2024-10-31T00:00:00-05:00",
      "startJobDate": "2024-10-31T00:00:00-05:00",
      "endJobDate": "2024-11-07T00:00:00-05:00",
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

      // Обрабатываем ответ
      if (response.statusCode == 200) {
        print('--------------------------------------------------------');
        print('Заявка отправлена');
        print('--------------------------------------------------------');
        print('Response data: ${response.data}');

        // Извлекаем значение Ref из ответа
        String ref = _extractRefFromResponse(response.data);
        if (ref.isNotEmpty) {
          // Вызываем метод uploadFiles с полученным ref
          await uploadFiles(ref, _attachedFiles);
        } else {
          print('--------------------------------------------------------');
          print('Не удалось извлечь Ref из ответа');
          print('--------------------------------------------------------');
        }
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

  String _extractRefFromResponse(dynamic responseData) {
    try {
      // Проверяем, что ответ имеет ожидаемую структуру
      if (responseData != null && responseData['#value'] is List) {
        for (var item in responseData['#value']) {
          if (item['name']['#value'] == 'Ref') {
            return item['Value']['#value'];
          }
        }
      }
    } catch (e) {
      print('Ошибка при извлечении Ref: $e');
    }
    return '';
  }

  Future<void> uploadFiles(String ref, List<File> files) async {
    final dio = Dio();
    String username = 'ИТР ФГБУ';
    String password = '1234';
    String url = 'https://melio.mcx.ru/melio_pmi_login/hs/api/?typerequest=WriteFileApplicationForWork'; // Установите базовую аутентификацию

    dio.options.headers["Authorization"] =
        "Basic " + base64Encode(utf8.encode('$username:$password'));

    for (File file in files) {
      try {
        // Создаем FormData для отправки
        FormData formData = FormData.fromMap({
          'ref': ref,
          // Используем переданный ref
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
          print(
              'Файл ${file.path.split('/').last} успешно загружен: ${response.data}');
        } else {
          print('--------------------------------------------------------');
          print(
              'Ошибка при загрузке файла ${file.path.split('/').last}: ОТВЕТ 1С ${response.statusCode}');
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

  void _selectDateRange(BuildContext context) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: selectedDateRange,
      firstDate: DateTime(2024),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDateRange) {
      setState(() {
        selectedDateRange = picked;
        startJobDate = '${DateFormat('dd.MM.yyyy').format(selectedDateRange!.start)}';
        endJobDate = '${DateFormat('dd.MM.yyyy').format(selectedDateRange!.end)}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('        Заявка на работу'),
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
                  controller:
                      TextEditingController(text: nameMeliorativeObject),
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
                      onTap: () => _selectDateRange(context),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        child: Row(children: [
                          Icon(Icons.calendar_month, color: Colors.grey),
                          Text(
                            selectedDateRange != null
                                ? ' $startJobDate - $endJobDate'
                                : 'Выберите период',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Описание',
                  // Цвет рамки, когда поле активно
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 0, 78, 167)), // Цвет рамки при фокусе
                  ),
                  // Цвет рамки, когда поле не активно
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color:
                            Colors.grey), // Цвет рамки при неактивном состоянии
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    description = value; // Обновляем значение переменной при изменении текста
                  });
                },
                onSubmitted: (value) {
                  // Если хотите, чтобы значение обновлялось и при нажатии Enter
                  setState(() {
                    description = value;
                  });
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
                    )),
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
                    return Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            title: Row(
                              children: [
                                const Icon(
                                  Icons.file_open_rounded,
                                  color: Color.fromARGB(255, 0, 78, 167),
                                ),
                                const SizedBox(width: 8),
                                // Отступ между иконкой и текстом
                                Expanded(
                                  child: Text(
                                    '${truncateText(_attachedFiles[index].path.split('/').last, 25)}',
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 0, 78, 167)),
                                    overflow: TextOverflow
                                        .ellipsis, // Добавляем многоточие, если текст слишком длинный
                                  ),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Color.fromARGB(255, 0, 78, 167),
                              ),
                              onPressed: () => _removeFile(index),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 0, 78, 167),
                    backgroundColor: Colors.white,
                    side: const BorderSide(
                      color: Color.fromARGB(255, 0, 78, 167),
                      width: 2.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
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
                      print(
                          '--------------------------------------------------------');
                      print(
                          'МЫ СОЗДАЛИ НОВУЮ ЗАЯВКУ!!!!  $refObject + $refSystem ');
                      print(
                          '--------------------------------------------------------');
                    } else if (isUpdateApplication == true &&
                        status == 'В проекте') {
                      status == 'В проекте';
                      updeteTaskByDescription(
                          description,
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
                    } else if (isUpdateApplication == true &&
                        status == 'На рассмотрении') {
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
                      deleteByDescription(refObject);
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
}

Future<int?> updeteTaskByDescription(
    String description, MeliorationObjectModel objUp) async {
  DBUtilsJobApplications? dbUtilsMelioObject = DBUtilsJobApplications();
  final box = Hive.box<MeliorationObjectModel>('tasks');
  List<MeliorationObjectModel> allObjects = box.values.toList();

  // Находим индекс объекта с переданным prevUnit
  for (int i = 0; i < allObjects.length; i++) {
    if (allObjects[i].description == description) {
      dbUtilsMelioObject?.updateTask(i, objUp);
      print('--------------------------------------------------------');
      print('Обновили из HIVE');
      print('--------------------------------------------------------');
      return i; // Возвращаем индекс, если найден
    }
  }
  print('--------------------------------------------------------');
  print('Не найден объект из HIVE');
  print('--------------------------------------------------------');
  return null; // Возвращаем null, если объект не найден
}

Future<void> deleteByDescription(String des) async {
  DBUtilsJobApplications? dbUtilsMelioObject = DBUtilsJobApplications();
  final box = Hive.box<MeliorationObjectModel>('tasks');
  List<MeliorationObjectModel> allObjects = box.values.toList();

  for (int i = 0; i < allObjects.length; i++) {
    if (allObjects[i].description == des) {
      await dbUtilsMelioObject?.deleteTask(i);
      print('--------------------------------------------------------');
      print('Удалили из HIVE');
      print('--------------------------------------------------------');
    } else {
      print('--------------------------------------------------------');
      print('Объект с DES не найден.');
      print('--------------------------------------------------------');
    }
  }
}

// Метод для обрезки текста до определенного количества символов
String truncateText(String text, int maxLength) {
  if (text.length > maxLength) {
    return text.substring(0, maxLength) + '...'; // Добавляем многоточие
  }
  return text;
}
