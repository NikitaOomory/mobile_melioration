import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile_melioration/Models/my_arguments.dart';
import 'package:mobile_melioration/Widgets/search_widget.dart';

import '../../../../Widgets/card_melio_objects.dart';

class ListObjectsInMelioScreenScaffold extends StatefulWidget {
  @override
  _ListObjectsInMelioScreenScaffoldState createState() => _ListObjectsInMelioScreenScaffoldState();
}

class _ListObjectsInMelioScreenScaffoldState extends State<ListObjectsInMelioScreenScaffold> {
  final Dio _dio = Dio();
  List<dynamic> _objects = [];
  bool _isLoading = true;
  String? refValue;
  String nameS = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Получаем значение ref из аргументов
    MyArguments? myArguments = ModalRoute.of(context)?.settings.arguments as MyArguments?;

    // Проверяем, получили ли мы значение ref
    if (myArguments != null) {
      refValue = myArguments.param1;
      nameS = myArguments.param2;
      _fetchObjectsOfReclamationSystem(); // Вызываем метод для получения данных
      print('-----------------------------');
      print(refValue);
    } else {
      setState(() {
        _isLoading = false; // Останавливаем индикатор загрузки, если ref не получен
      });
    }
  }

  Future<void> _fetchObjectsOfReclamationSystem() async {
    final String url = 'http://192.168.7.6/MCX_melio_dev_atropin/hs/api/?typerequest=getObjectsOfReclamationSystem';
    String username = 'tropin'; // Замените на ваши учетные данные
    String password = '1234'; // Замените на ваши учетные данные

    // Тело запроса
    final Map<String, dynamic> requestBody = {
      "ref": refValue, // Используем значение ref
    };

    try {
      final response = await _dio.post(
        url,
        data: jsonEncode(requestBody),
        options: Options(
          headers: {
            'Authorization': 'Basic ${base64Encode(utf8.encode('$username:$password'))}',
            'Content-Type': 'application/json', // Указываем тип контента
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Response data: ${response.data}'); // Отладочное сообщение

        // Извлечение данных из ответа
        var dataObject = response.data['#value']?.firstWhere(
              (item) => item['name']['#value'] == 'data',
          orElse: () => null,
        );

        if (dataObject != null) {
          var valueArray = dataObject['Value']['#value'];
          setState(() {
            _objects = valueArray; // Сохраняем данные для отображения
            _isLoading = false; // Останавливаем индикатор загрузки
          });
        } else {
          setState(() {
            _isLoading = false; // Останавливаем индикатор загрузки
          });
        }
      } else {
        print('Ошибка: ${response.statusCode}'); // Выводим статус ошибки
        setState(() {
          _isLoading = false; // Останавливаем индикатор загрузки
        });
      }
    } catch (e) {
      print('Ошибка: $e'); // Обработка ошибок
      setState(() {
        _isLoading = false; // Останавливаем индикатор загрузки
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Сооружения и объекты:\n$nameS',
        maxLines: 2,
        textAlign: TextAlign.start, style: TextStyle(fontSize: 18),),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _objects.isEmpty
          ? Center(child: Text('В данной системе нет объектов', style: TextStyle(fontSize: 18),))
          : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SearchWidget(),
                const SizedBox(height: 16),
                Expanded( child: ListView.builder(
                  itemCount: _objects.length,
                  itemBuilder: (context, index) {
                    final object = _objects[index]['#value'];
                    String ref = object.firstWhere(
                          (p) => p['name']['#value'] == 'ref',
                      orElse: () => {'Value': {'#value': 'N/A'}},
                    )['Value']['#value'];
                    String type = object.firstWhere(
                          (p) => p['name']['#value'] == 'type',
                      orElse: () => {'Value': {'#value': 'N/A'}},
                    )['Value']['#value'];
                    String name = object.firstWhere(
                          (p) => p['name']['#value'] == 'Name',
                      orElse: () => {'Value': {'#value': 'N/A'}},
                    )['Value']['#value'];
                    String ein = object.firstWhere(
                          (p) => p['name']['#value'] == 'EIN',
                      orElse: () => {'Value': {'#value': 'N/A'}},
                    )['Value']['#value'];
                    return CardMelioObjects(title: name, ein: ein, onTap:(){
                      Navigator.of(context).pushNamed('/object_fun_nav', arguments: MyArguments(ref, refValue!, nameS, name));
                    }, ref: ref);
        },
      ),
    ),
    ]),
    ),
    );
  }
}
