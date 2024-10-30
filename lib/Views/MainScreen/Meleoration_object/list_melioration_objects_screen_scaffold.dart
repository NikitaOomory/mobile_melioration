import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile_melioration/Widgets/search_widget.dart';

import '../../../Models/my_arguments.dart';
import '../../../Widgets/card_melio_objects.dart';

class ListMeliorationObjectsScreenScaffold extends StatefulWidget {
  const ListMeliorationObjectsScreenScaffold({super.key});

  @override
  _ListMeliorationObjectsScreenScaffoldState createState() =>
      _ListMeliorationObjectsScreenScaffoldState();
}

class _ListMeliorationObjectsScreenScaffoldState
    extends State<ListMeliorationObjectsScreenScaffold> {
  final Dio _dio = Dio();
  List<dynamic> _reclamations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReclamations();
  }

  Future<void> _fetchReclamations() async {
    final String url =
        'http://192.168.7.6/MCX_melio_dev_atropin/hs/api/?typerequest=getReclamationSystem';
    String username = 'tropin';
    String password = '1234';

    try {
      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Authorization':
                'Basic ${base64Encode(utf8.encode('$username:$password'))}',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Response data: ${response.data}');
        Map<String, dynamic> data = response.data;

        // Проверка наличия данных
        var dataObject = data['#value']?.firstWhere(
            (item) => item['name']['#value'] == 'data',
            orElse: () => null);

        if (dataObject != null && dataObject['Value']['#value'] != null) {
          var valueArray = dataObject['Value']['#value'];
          setState(() {
            _reclamations = valueArray; // Сохраняем данные для отображения
            _isLoading = false; // Останавливаем индикатор загрузки
          });
        } else {
          print('Данные отсутствуют или имеют неверную структуру');
          setState(() {
            _isLoading = false; // Останавливаем индикатор загрузки
          });
        }
      } else {
        print('Ошибка: ${response.statusCode}');
        setState(() {
          _isLoading = false; // Останавливаем индикатор загрузки
        });
      }
    } catch (e) {
      print('Ошибка: $e');
      setState(() {
        _isLoading = false; // Останавливаем индикатор загрузки
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Мелиоративные объекты'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _reclamations.isEmpty
              ? Center(child: Text('Нет доступных систем'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(children: [
                    SearchWidget(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _reclamations.length,
                        itemBuilder: (context, index) {
                          final reclamation = _reclamations[index];
                          final properties = reclamation['#value'];

                          // Извлечение значений из структуры
                          String refSystem = properties.firstWhere(
                              (p) => p['name']['#value'] == 'Ref',
                              orElse: () => {
                                    'Value': {'#value': 'N/A'}
                                  })['Value']['#value'];
                          String id = properties.firstWhere(
                              (p) => p['name']['#value'] == 'Id',
                              orElse: () => {
                                    'Value': {'#value': 'N/A'}
                                  })['Value']['#value'];
                          String nameSystem = properties.firstWhere(
                              (p) => p['name']['#value'] == 'Name',
                              orElse: () => {
                                    'Value': {'#value': 'N/A'}
                                  })['Value']['#value'];
                          String type = properties.firstWhere(
                              (p) => p['name']['#value'] == 'Type',
                              orElse: () => {
                                    'Value': {'#value': 'N/A'}
                                  })['Value']['#value'];
                          String location = properties.firstWhere(
                              (p) => p['name']['#value'] == 'Location',
                              orElse: () => {
                                    'Value': {'#value': 'N/A'}
                                  })['Value']['#value'];
                          String actualWear = properties
                                  .firstWhere(
                                      (p) =>
                                          p['name']['#value'] == 'ActualWear',
                                      orElse: () => {
                                            'Value': {'#value': 'N/A'}
                                          })['Value']['#value']
                                  ?.toString() ??
                              'N/A';
                          String technicalCondition = properties.firstWhere(
                              (p) =>
                                  p['name']['#value'] == 'TechnicalCondition',
                              orElse: () => {
                                    'Value': {'#value': 'N/A'}
                                  })['Value']['#value'];
                          return CardMelioObjects(
                              title: nameSystem,
                              ein: id,
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    '/list_object_in_melio',
                                    arguments: MyArguments(refSystem, nameSystem, '', ''));
                              },
                              ref: refSystem);
                        },
                      ),
                    ),
                  ]),
                ),
    );
  }
}
