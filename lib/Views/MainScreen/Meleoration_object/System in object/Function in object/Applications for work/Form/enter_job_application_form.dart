import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mobile_melioration/Widgets/show_snack_bar.dart';

import '../../../../../../../Database/JobApplication/db_utils_melio_object.dart';
import '../../../../../../../Models/melioration_object_model.dart';
import '../../../../../../../Models/my_arguments.dart';
import '../list_enter_job_application.dart';
/*
Как должен работать класс?
  Получить данные для предзаполнения формы в didChangeDependencies().
  1) Установить полученные данные для отображения в форме.
  2) Сохранить введённые данные в форме в переменные формы.
  3) Сохранение проекта:
    3.1) Мы должны сохранить проект формы в БД HIVE.
    3.2) Вернуться на экран списка заявок.
  4) Отправить проект:
    4.1) Мы должны отправить заявку с заполненными ранее данными.
    4.2) Если ранее, по этой заявке был такой проект - то удалить его из БД HIVE.
  5) Удалить проект:
    5.1)Если заявка была в стадии проект то мы должны удалить её из БД HIVE.
*/
class EnterJobApplicationForm extends StatefulWidget {
  const EnterJobApplicationForm({super.key});

  @override
  State<StatefulWidget> createState() => _EnterJobApplicationForm();
}


class _EnterJobApplicationForm extends State<EnterJobApplicationForm> {

  //параметры отображения элементов интерфейса
  bool isButtonVisible = false;
  ShowSnackBar _showSnackBar = ShowSnackBar();

  //параметры работы с сетью
  final Dio _dio = Dio();

  //параметры работы с БД
  DBUtilsJobApplications? dbUtilsMelioObject = DBUtilsJobApplications();
  Application? applicationObjectByPrevScreen;
  bool isUpdateApplication = false;

  //параметры для отображения информации в форме
  late String status = 'В проекте';
  late String author = '';
  String nameMeliorativeObject = '';
  String ein = '';
  String startDate = '07.11.2024';
  String endDate = '';
  String startJobDate = '';
  String endJobDate = '';
  String description = '';
  String refObject = '';
  String refSystem = '';
  String nameObject = '';
  DateTimeRange? selectedDateRange; //диапазон дат
  late TextEditingController _controller = TextEditingController();
  final List<File> _attachedFiles = []; //список закреплённых файлов


  @override
  void dispose() {
    _controller.dispose(); // Освобождаем ресурсы контроллера
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    final MyArguments args = ModalRoute.of(context)?.settings.arguments as MyArguments;
    //получаем данные с прошлого экрана
    applicationObjectByPrevScreen = args.param3 as Application;

    //назначаем ссылки для дальнейшей отправки заявки
    refObject = args.param1;
    refSystem = args.param2;
    nameObject = args.param4;

    //назначаем переменные для предзаполнения формы
    status = applicationObjectByPrevScreen!.status;
    author = applicationObjectByPrevScreen!.owner;
    nameMeliorativeObject = nameObject;
    ein = '30Ф-ОРО-0001-ООС-001'; //todo: нужно сделать получение ЕИН
    startDate = '07.11.2024'; //todo: сделать присвоение даты создания DateTimeNow
    endDate = '';
    startJobDate = ''; //todo: сделать присвоение с прошлого экрана
    endJobDate = ''; //todo: сделать присвоение с прошлого экрана
    description = applicationObjectByPrevScreen!.description;

    //условие для проставления флага на обновление или создания новой
    if (description == null || description.isEmpty || description == '') {
      isUpdateApplication = false;
    } else {
      isUpdateApplication = true;
    }

    //проверка на условие видимости кнопки удаления
    setState(() {
      _controller = TextEditingController(text: description);
      if(status == 'В проекте'){
        isButtonVisible = true;
      }
    });
    super.didChangeDependencies();
  }

  Future<void> _sendApplicationForWork() async {
    const String url = 'https://melio.mcx.ru/melio_pmi_login//hs/api/?typerequest=WriteApplicationForWork';
    String username = 'ИТР ФГБУ 2';
    String password = '1234';

    //формируем данные для отправки
    final Map<String, dynamic> requestBody = {
      "ReclamationSystem": refSystem,
      "HydraulicStructure": refObject,
      "startDate": startDate,
      "startJobDate": startJobDate,
      "endJobDate": endJobDate,
      "description": description,
    };

    try {
      final response = await _dio.post(
        url,
        data: jsonEncode(requestBody),
        options: Options(
          headers: {
            'Authorization': 'Basic ${base64Encode(utf8.encode('$username:$password'))}',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Заявка отправлена');
        print('Response data: ${response.data}');

        // Извлекаем значение Ref из ответа
        String ref = _extractRefFromResponse(response.data);

        if (ref.isNotEmpty) {
          // Вызываем метод uploadFiles с полученным ref
          await uploadFiles(ref, _attachedFiles);
        } else {
          print('Не удалось извлечь Ref из ответа');
        }
      } else {
        print('Ошибка отправки заявки: ${response.statusCode}');
      }
    } catch (e) {
      print('Ошибка отправки заявки: $e');
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
    String username = 'ИТР ФГБУ 2';
    String password = '12345';
    String url = 'https://melio.mcx.ru/melio_pmi_login/hs/api/?typerequest=WriteFileApplicationForWork';

    dio.options.headers["Authorization"] = "Basic ${base64Encode(utf8.encode('$username:$password'))}";

    for (File file in files) {
      try {
        FormData formData = FormData.fromMap({
          'ref': ref,
          'file': await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
            // Указываем Content-Type
          ),
        });

        final response = await dio.post(url, data: formData);

        if (response.statusCode == 200) {
          print('ФАЙЛЫ ОТПРАВИЛИСЬ');
        } else {
          print('Ошибка при загрузке файла ${file.path.split('/').last}: ОТВЕТ 1С ${response.statusCode}');
        }
      } catch (e) {
        print('Произошла ошибка при загрузке файла ${file.path}: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Заявка на работу')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              TextField(
                controller: TextEditingController(text: status),
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
                        child: Row(children: [
                          const Icon(Icons.calendar_month, color: Colors.grey),
                          Text(
                            selectedDateRange != null
                                ? ' $startJobDate - $endJobDate'
                                : 'Выберите период',
                            style: const TextStyle(
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
                controller: TextEditingController(text: description),
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Описание',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 0, 78, 167)),),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.grey),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    description = value; // Обновляем значение переменной при изменении текста
                  });
                },
                onSubmitted: (value) {
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
                      side: const BorderSide(
                        color: Color.fromARGB(255, 0, 78, 167),
                        width: 2.0,),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(5),
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
                                const Icon(
                                  Icons.file_open_rounded,
                                  color: Color.fromARGB(255, 0, 78, 167),
                                ),
                                const SizedBox(width: 8),
                                // Отступ между иконкой и текстом
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
                              icon: const Icon(Icons.close, color: Color.fromARGB(255, 0, 78, 167),),
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
                      Navigator.of(context).pushReplacementNamed('/list_enter_job_application',arguments: MyArguments(refObject, refObject, nameObject, 'param4'));
                      print(
                          '--------------------------------------------------------');
                      print(
                          'МЫ СОЗДАЛИ НОВУЮ ЗАЯВКУ!!!!  $refObject + $refSystem ');
                      print(
                          '--------------------------------------------------------');
                    } else if (isUpdateApplication == true &&
                        status == 'В проекте') {
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
                      Navigator.of(context).pushReplacementNamed('/list_enter_job_application', arguments: MyArguments(refObject, refObject, nameObject, 'param4'));
                    } else if (isUpdateApplication == true &&
                        status == 'На рассмотрении') {
                      _showSnackBar.showSnackBar(context,
                          'Заявка уже отправлена, её нельзя редактировать.');
                    } else {
                      _showSnackBar.showSnackBar(context, 'Ошибка статусной модели.');
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
                      _sendApplicationForWork();
                      //todo: надо сначала сохранить новый description
                      deleteByDescription(description);
                      Navigator.of(context).pushReplacementNamed('/list_enter_job_application', arguments: MyArguments(refObject, refObject, nameObject, 'param4'));
                    } else if (status == 'На рассмотрении') {
                      _showSnackBar.showSnackBar(context, 'Заявка уже отправлена.');
                    } else {
                      _showSnackBar.showSnackBar(context, 'Ошибка статусной модели.');
                    }
                  },
                  child: const Text('Отправить'),
                ),
              ),
              const SizedBox(height: 2),
              isButtonVisible?
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                      side: const BorderSide(
                        color: Colors.red,
                        width: 2.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: (){
                      if(isUpdateApplication == true){
                        //update -> delete
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
                        deleteByDescription(description);
                        Navigator.of(context).pushReplacementNamed('/list_enter_job_application', arguments: MyArguments(refObject, refObject, nameObject, 'param4'));
                      }else{
                        //add -> delete
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
                        deleteByDescription(description);
                        Navigator.of(context).pushReplacementNamed('/list_enter_job_application',arguments: MyArguments(refObject, refObject, nameObject, 'param4'));
                      }
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete_forever),
                        Text('Удалить проект'),
                      ],
                    )),
              ) : Container()
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
      return i;
    }
  }
  print('--------------------------------------------------------');
  print('Не найден объект из HIVE');
  print('--------------------------------------------------------');
  return null; 
}

Future<void> deleteByDescription(String des) async {
  DBUtilsJobApplications? dbUtilsMelioObject = DBUtilsJobApplications();
  final box = Hive.box<MeliorationObjectModel>('tasks');
  List<MeliorationObjectModel> allObjects = box.values.toList();

  for (int i = 0; i < allObjects.length; i++) {
    bool isDelete = false;
    if (allObjects[i].description == des) {
      await dbUtilsMelioObject?.deleteTask(i);
      print('--------------------------------------------------------');
      print('Удалили из HIVE');
      print('--------------------------------------------------------');
      isDelete = true;
    }
    if(isDelete == false){
      print('--------------------------------------------------------');
      print('ОБЪЕКТ В HIVE  НЕ НАЙДЕН И НЕ УДАЛЁН');
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
