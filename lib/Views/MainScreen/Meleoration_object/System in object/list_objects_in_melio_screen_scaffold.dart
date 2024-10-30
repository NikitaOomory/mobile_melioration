import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile_melioration/Models/my_arguments.dart';
import 'package:mobile_melioration/Widgets/search_widget.dart';

import '../../../../Widgets/card_main_fun.dart';
import '../../../../Widgets/card_melio_objects.dart';

class ListObjectsInMelioScreenScaffold extends StatefulWidget {
  @override
  _ListObjectsInMelioScreenScaffoldState createState() =>
      _ListObjectsInMelioScreenScaffoldState();
}

class _ListObjectsInMelioScreenScaffoldState extends State<ListObjectsInMelioScreenScaffold> {
  final Dio _dio = Dio();
  List<dynamic> _objects = [];
  bool _isLoading = true;
  String? refSystem;
  String nameSystem = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MyArguments? myArguments = ModalRoute.of(context)?.settings.arguments as MyArguments?;

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

  Future<void> _fetchObjectsOfReclamationSystem() async {
    final String url = 'http://192.168.7.6/MCX_melio_dev_atropin/hs/api/?typerequest=getObjectsOfReclamationSystem';
    String username = 'tropin';
    String password = '1234';

    final Map<String, dynamic> requestBody = {
      "ref": refSystem,
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
        print('Response data: ${response.data}');

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
          'Сооружения и объекты:\n$nameSystem',
          maxLines: 2,
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _objects.isEmpty
              ? Column(
                  children: [
                    CardMainFun(
                        icon: Icons.contact_page_rounded,
                        title: 'Актуализация тех. состояния',
                        description:
                            'Внесение изменений о техническом состоянии',
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed('/tech_cond_form', arguments: '');
                        }),
                    const SizedBox(height: 40),
                    Text(
                      'В данной системе нет объектов',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(children: [
                    Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8  ),
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8),),
                        padding: const EdgeInsets.all(20),
                        child:Column(children: [
                          Row(children: [Icon(Icons.contact_page_rounded, size: 30, color: const Color.fromARGB(255, 0, 78, 167),),],),
                          const SizedBox(height: 4),
                          Row(children: [Text('Актуализация тех. состояния', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),],),
                          const SizedBox(height: 4),
                          Row(children: [Text('Внесение изменений о техническом состоянии', style: const TextStyle(color: Colors.grey),),],),
                        ],),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SearchWidget(),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _objects.length,
                        itemBuilder: (context, index) {
                          final object = _objects[index]['#value'];
                          String ref = object.firstWhere(
                            (p) => p['name']['#value'] == 'ref',
                            orElse: () => {
                              'Value': {'#value': 'N/A'}
                            },
                          )['Value']['#value'];
                          String type = object.firstWhere(
                            (p) => p['name']['#value'] == 'type',
                            orElse: () => {
                              'Value': {'#value': 'N/A'}
                            },
                          )['Value']['#value'];
                          String name = object.firstWhere(
                            (p) => p['name']['#value'] == 'Name',
                            orElse: () => {
                              'Value': {'#value': 'N/A'}
                            },
                          )['Value']['#value'];
                          String ein = object.firstWhere(
                            (p) => p['name']['#value'] == 'EIN',
                            orElse: () => {
                              'Value': {'#value': 'N/A'}
                            },
                          )['Value']['#value'];
                          return CardMelioObjects(
                              title: name,
                              ein: ein,
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    '/object_fun_nav',
                                    arguments: MyArguments(
                                        ref, refSystem!, nameSystem, name));
                              },
                              ref: ref);
                        },
                      ),
                    ),
                  ]),
                ),
    );
  }
}
