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
  List<MeliorObject> _objects = [];
  List<MeliorObject> _searchResults = []; // Список для результатов поиска
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
    final String url = 'https://melio.mcx.ru/melio_pmi_login/hs/api/?typerequest=getObjectsOfReclamationSystem';
    String username = 'ИТР ФГБУ';
    String password = '1234';
    final Map<String, dynamic> requestBody = {
      "ref": refSystem,
    };
    setState(() {
      _isLoading = true;
    });
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
      print('Response data: ${response.data}'); // Логирование ответа
      if (response.statusCode == 200 && response.data != null) {
        var dataObject = response.data['#value']?.firstWhere(
              (item) => item['name']['#value'] == 'data',
          orElse: () => null,
        );
        if (dataObject != null) {
          var valueArray = dataObject['Value']['#value'];
          List<MeliorObject> objects = [];
          for (var item in valueArray) {
            if (item['#type'] == 'jv8:Structure') {
              String ref = item['#value'].firstWhere((p) => p['name']['#value'] == 'ref')['Value']['#value'];
              String type = item['#value'].firstWhere((p) => p['name']['#value'] == 'type')['Value']['#value'];
              String ein = item['#value'].firstWhere((p) => p['name']['#value'] == 'EIN')['Value']['#value'];
              String name = item['#value'].firstWhere((p) => p['name']['#value'] == 'Name')['Value']['#value'];
              objects.add(MeliorObject(ref: ref, type: type, ein: ein, name: name));
            }
          }
          setState(() {
            _objects = objects; // Сохраняем объекты
            _searchResults = _objects; // Изначально показываем все объекты
            _isLoading = false; // Останавливаем индикатор загрузки
          });
        } else {
          print('Ошибка: dataObject равно null');
          setState(() {
            _isLoading = false; // Останавливаем индикатор загрузки
          });
        }
      } else {
        print('Ошибка: ${response.statusCode} или ответ пустой');
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

  void _searchObjects(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = _objects; // Если запрос пустой, показываем все объекты
      });
    } else {
      setState(() {
        _searchResults = _objects.where((object) {
          return object.ref.toLowerCase().contains(query.toLowerCase()) ||
              object.type.toLowerCase().contains(query.toLowerCase()) ||
              object.ein.toLowerCase().contains(query.toLowerCase()) ||
              object.name.toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Сооружения и объекты:\n$nameSystem', maxLines: 2, textAlign: TextAlign.start, style: TextStyle(fontSize: 18)),
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator()) : _objects.isEmpty ? Column(
        children: [
          CardMainFun(
            icon: Icons.contact_page_rounded,
            title: 'Актуализация тех. состояния',
            description: 'Внесение изменений от техническом состоянии',
            onTap: () {
              Navigator.of(context).pushNamed('/tech_cond_form', arguments: MyArguments(refSystem!, refSystem!, nameSystem, '1'));
            },
          ),
          const SizedBox(height: 40),
          Text('В данной системе нет объектов', style: TextStyle(fontSize: 18)),
        ],
      ) : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Поиск...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search, color: Colors.grey), // Иконка поиска внутри поля
              ),
              onChanged: (query) {
                _searchObjects(query); // Вызов метода поиска при изменении текста
              },
            ),
            const SizedBox(height: 16),
            CardMainFun(
              icon: Icons.contact_page_rounded,
              title: 'Актуализация тех. состояния',
              description: 'Внесение изменений от техническом состоянии',
              onTap: () {
                Navigator.of(context).pushNamed('/tech_cond_form', arguments: MyArguments(refSystem!, refSystem!, nameSystem, '1'));
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final object = _searchResults[index];
                  return CardMelioObjects(
                    title: object.name,
                    ein: object.ein,
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        '/object_fun_nav',
                        arguments: MyArguments(object.ref, refSystem!, nameSystem, object.name),
                      );
                    },
                    ref: object.ref,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MeliorObject {
  final String ref;
  final String type;
  final String ein;
  final String name;

  MeliorObject({
    required this.ref,
    required this.type,
    required this.ein,
    required this.name,
  });

  factory MeliorObject.fromJson(Map<String, dynamic> json) {
    String ref = json['Value']['#value'].firstWhere(
          (item) => item['name']['#value'] == 'ref',
      orElse: () => {'Value': {'#value': 'N/A'}},
    )['Value']['#value'];

    String type = json['Value']['#value'].firstWhere(
          (item) => item['name']['#value'] == 'type',
      orElse: () => {'Value': {'#value': 'N/A'}},
    )['Value']['#value'];

    String ein = json['Value']['#value'].firstWhere(
          (item) => item['name']['#value'] == 'EIN',
      orElse: () => {'Value': {'#value': 'N/A'}},
    )['Value']['#value'];

    String name = json['Value']['#value'].firstWhere(
          (item) => item['name']['#value'] == 'Name',
      orElse: () => {'Value': {'#value': 'N/A'}},
    )['Value']['#value'];

    return MeliorObject(ref: ref, type: type, ein: ein, name: name);
  }
}