import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile_melioration/Models/my_arguments.dart';
import 'package:mobile_melioration/Widgets/search_widget.dart';

import '../../../../Widgets/card_main_fun.dart';
import '../../../../Widgets/card_melio_objects.dart';

class MelObjects {
  final String refSystem;
  final String id;
  final String name;
  final String type;
  final String location;
  final String actualWear;
  final String technicalCondition;

  MelObjects({
    required this.refSystem,
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    required this.actualWear,
    required this.technicalCondition,
  });

  factory MelObjects.fromJson(Map<String, dynamic> json) {
    final properties = json['#value'];
    return MelObjects(
      refSystem: properties.firstWhere((p) => p['name']['#value'] == 'Ref',
          orElse: () => {
                'Value': {'#value': 'N/A'}
              })['Value']['#value'],
      id: properties.firstWhere((p) => p['name']['#value'] == 'Id',
          orElse: () => {
                'Value': {'#value': 'N/A'}
              })['Value']['#value'],
      name: properties.firstWhere((p) => p['name']['#value'] == 'Name',
          orElse: () => {
                'Value': {'#value': 'N/A'}
              })['Value']['#value'],
      type: properties.firstWhere((p) => p['name']['#value'] == 'Type',
          orElse: () => {
                'Value': {'#value': 'N/A'}
              })['Value']['#value'],
      location: properties.firstWhere((p) => p['name']['#value'] == 'Location',
          orElse: () => {
                'Value': {'#value': 'N/A'}
              })['Value']['#value'],
      actualWear: properties
              .firstWhere((p) => p['name']['#value'] == 'ActualWear',
                  orElse: () => {
                        'Value': {'#value': 'N/A'}
                      })['Value']['#value']
              ?.toString() ??
          'N/A',
      technicalCondition: properties.firstWhere(
          (p) => p['name']['#value'] == 'TechnicalCondition',
          orElse: () => {
                'Value': {'#value': 'N/A'}
              })['Value']['#value'],
    );
  }
}

class ListObjectsInMelioScreenScaffold extends StatefulWidget {
  @override
  _ListObjectsInMelioScreenScaffoldState createState() =>
      _ListObjectsInMelioScreenScaffoldState();
}

class _ListObjectsInMelioScreenScaffoldState
    extends State<ListObjectsInMelioScreenScaffold> {
  List<MelObjects> _objects = []; // Список объектов
  List<MelObjects> _filteredObjects = []; // Отфильтрованный список
  bool _isLoading = true; // Статус загрузки
  String _searchQuery = ''; // Поисковый запрос
  final Dio _dio = Dio(); // Инициализация Dio

  String? refSystem;
  String nameSystem = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MyArguments? myArguments =
        ModalRoute.of(context)?.settings.arguments as MyArguments?;

    if (myArguments != null) {
      refSystem = myArguments.param1;
      nameSystem = myArguments.param2;
      _fetchObjectsOfReclamationSystem(); // Вызываем метод для получения данных
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchObjectsOfReclamationSystem(); // Загружаем данные при инициализации
  }

  Future<void> _fetchObjectsOfReclamationSystem() async {
    final String url =
        'http://192.168.7.6/MCX_melio_dev_atropin/hs/api/?typerequest=getObjectsOfReclamationSystem';
    String username = 'tropin';
    String password = '1234';
    final Map<String, dynamic> requestBody = {
      "ref": refSystem, // Замените на актуальное значение
    };

    try {
      final response = await _dio.post(
        url,
        data: jsonEncode(requestBody),
        options: Options(
          headers: {
            'Authorization':
                'Basic ${base64Encode(utf8.encode('$username:$password'))}',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Response data: ${response.data}');
        var dataObject = response.data['#value']?.firstWhere(
          (item) => item['name']['#value'] == 'data',
          orElse: () => null,
        );

        if (dataObject != null) {
          var valueArray = dataObject['Value']['#value'];

          // Проверяем, является ли valueArray списком или пустым массивом
          if (valueArray is List) {
            setState(() {
              _objects =
                  valueArray.map((item) => MelObjects.fromJson(item)).toList();
              _filteredObjects = _objects; // Изначально показываем все
              _isLoading = false; // Останавливаем индикатор загрузки
            });
          } else if (valueArray is Map && valueArray.isEmpty) {
            // Если valueArray - пустой массив
            setState(() {
              _objects = []; // Устанавливаем пустой список
              _filteredObjects = _objects; // Изначально показываем все
              _isLoading = false; // Останавливаем индикатор загрузки
            });
          } else {
            print('valueArray не является списком');
            setState(() {
              _isLoading = false; // Останавливаем индикатор загрузки
            });
          }
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

  void _filterObjects(String query) {
    setState(() {
      _searchQuery = query;
      _filteredObjects = _objects.where((object) {
        return object.name.toLowerCase().contains(query.toLowerCase()) ||
            object.id.toLowerCase().contains(query.toLowerCase()) ||
            object.type.toLowerCase().contains(query.toLowerCase()) ||
            object.location.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Объекты рекламационной системы'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: _filterObjects, // Здесь вызываем метод
                    decoration: InputDecoration(
                      hintText: 'Поиск...',
                      prefixIcon:
                          Icon(Icons.search), // Добавление иконки поиска
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: _filteredObjects.isEmpty
                      ? Column(
                          children: [
                            CardMainFun(
                              icon: Icons.contact_page_rounded,
                              title: 'Актуализация тех. состояния',
                              description:
                                  'Внесение изменений о техническом состоянии',
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  '/tech_cond_form',
                                  arguments: MyArguments(
                                      refSystem!, refSystem!, nameSystem, '1'),
                                );
                              },
                            ),
                            Center(child: Text('Нет доступных объектов'))
                          ],
                        )
                      : ListView.builder(
                          itemCount: _filteredObjects.length + 1,
                          // Увеличиваем на 1 для карточки
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              // Первая карточка - CardMainFun
                              return CardMainFun(
                                icon: Icons.contact_page_rounded,
                                title: 'Актуализация тех. состояния',
                                description:
                                    'Внесение изменений о техническом состоянии',
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    '/tech_cond_form',
                                    arguments: MyArguments(refSystem!,
                                        refSystem!, nameSystem, '1'),
                                  );
                                },
                              );
                            } else {
                              final MelObjects object = _filteredObjects[
                                  index - 1]; // Смещаем индекс на 1
                              String refObject = object
                                  .refSystem; // или другое поле, если нужно
                              String ein =
                                  object.id; // Предположим, это идентификатор
                              String nameObject =
                                  object.name; // Название объекта
                              String nameSystem = object
                                  .type; // Или любое другое поле, если нужно
                              return CardMelioObjects(
                                title: nameObject,
                                ein: ein,
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    '/object_fun_nav',
                                    arguments: MyArguments(
                                        refObject,
                                        refSystem!,
                                        nameSystem,
                                        nameObject), // Замените на актуальное значение
                                  );
                                },
                                ref: refObject,
                              );
                            }
                          },
                        ),
                ),
              ],
            ),
    );
  }
}

// final Dio _dio = Dio();
// List<dynamic> _objects = [];
// bool _isLoading = true;
// String? refSystem;
// String nameSystem = '';
//
// @override
// void didChangeDependencies() {
//   super.didChangeDependencies();
//   MyArguments? myArguments = ModalRoute.of(context)?.settings.arguments as MyArguments?;
//
//   if (myArguments != null) {
//     refSystem = myArguments.param1;
//     nameSystem = myArguments.param2;
//     _fetchObjectsOfReclamationSystem(); // Вызываем метод для получения данных
//   } else {
//     setState(() {
//       _isLoading = false;
//     });
//   }
// }

// arguments: MyArguments(
// refObject, refSystem!, nameSystem, nameObject));
