import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UtilsForm{

  Future<void> sendApplicationForWork(String refSystem, String refObject,
      String startJobDate, String endJobDate, String description, Dio dio,
      List<File> attachedFiles) async {

    const String url = 'https://melio.mcx.ru/melio_pmi_login//hs/api/?typerequest=WriteApplicationForWork';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? password = prefs.getString('password');

    DateTime startDate = DateTime.now();

    final Map<String, dynamic> requestBody = {
      "ref": "",
      "ReclamationSystem": refSystem,
      "HydraulicStructure": refObject,
      "startDate": formatDate(startDate),
      "startJobDate": startJobDate,
      "endJobDate": endJobDate,
      "description": description,
    };

    try {
      final response = await dio.post(
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
        print('${formatDate(startDate)}, $startJobDate, $endJobDate');
        print('--------------------------------------------------------');
        print('Response data: ${response.data}');

        // Извлекаем значение Ref из ответа
        String ref = _extractRefFromResponse(response.data);
        if (ref.isNotEmpty) {
          // Вызываем метод uploadFiles с полученным ref
          await uploadFiles(ref, attachedFiles);
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? password = prefs.getString('password');
    String url = 'https://melio.mcx.ru/melio_pmi_login/hs/api/?typerequest=WriteFileApplicationForWork'; // Установите базовую аутентификацию

    dio.options.headers["Authorization"] = "Basic " + base64Encode(utf8.encode('$username:$password'));

    for (File file in files) {
      try {
        // Создаем FormData для отправки
        FormData formData = FormData.fromMap({
          'ref': ref, // Используем переданный ref
          'file': await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last, // Указываем Content-Type
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

  String formatDate(DateTime date) {
// Преобразуем в строку формата ISO 8601
    return '${date.toIso8601String().split('T')[0]}T00:00:00-05:00';
  }

}