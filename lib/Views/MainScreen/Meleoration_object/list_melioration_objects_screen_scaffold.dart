import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

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
  List<MelObjects> _reclamations = []; // Список объектов
  List<MelObjects> _filteredReclamations = []; // Отфильтрованный список
  bool _isLoading = true; // Статус загрузки
  String _searchQuery = ''; // Поисковый запрос
  final Dio _dio = Dio(); // Инициализация Dio

  @override
  void initState() {
    super.initState();
    _fetchReclamations(); // Загружаем данные при инициализации
  }

  Future<void> _fetchReclamations() async {
    final String url = 'https://melio.mcx.ru/melio_pmi_login/hs/api/?typerequest=getReclamationSystem';
    String username = 'ИТР ФГБУ 2';
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
          orElse: () => null,
        );

        if (dataObject != null && dataObject['Value']['#value'] != null) {
          var valueArray = dataObject['Value']['#value'];

          // Убедитесь, что valueArray является списком
          if (valueArray is List) {
            setState(() {
              // Преобразование данных в список MelObjects
              _reclamations =
                  valueArray.map((item) => MelObjects.fromJson(item)).toList();
              _filteredReclamations =
                  _reclamations; // Изначально показываем все
              _isLoading = false; // Останавливаем индикатор загрузки
            });
          } else {
            print('valueArray не является списком');
            setState(() {
              _isLoading = false; // Останавливаем индикатор загрузки
            });
          }
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

  void _filterReclamations(String query) {
    setState(() {
      _searchQuery = query;
      _filteredReclamations = _reclamations.where((reclamation) {
        return reclamation.name.toLowerCase().contains(query.toLowerCase()) ||
            reclamation.id.toLowerCase().contains(query.toLowerCase()) ||
            reclamation.type.toLowerCase().contains(query.toLowerCase()) ||
            reclamation.location.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text('Мелиоративные объекты'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              child: TextField(
                onChanged: _filterReclamations,
                decoration: InputDecoration(
                  hintText: 'Поиск...',
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  // Добавление иконки поиска
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _filteredReclamations.isEmpty
              ? Center(child: Text('Нет доступных систем'))
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 16),
                  child: ListView.builder(
                    itemCount: _filteredReclamations.length,
                    itemBuilder: (context, index) {
                      final reclamation = _filteredReclamations[index];
                      return CardMelioObjects(
                        title: reclamation.name,
                        ein: reclamation.id,
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            '/list_object_in_melio',
                            arguments: MyArguments(reclamation.refSystem,
                                reclamation.name, '', ''),
                          );
                        },
                        ref: '',
                      );
                    },
                  ),
                ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: ClipOval(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromARGB(255, 0, 78, 167), // Цвет кнопки
          ),
          child: SizedBox(
            width: 56, // Ширина кнопки
            height: 56, // Высота кнопки
            child: FloatingActionButton(
              onPressed: () {Navigator.of(context).pushNamedAndRemoveUntil('/main_screen', (Route<dynamic> route) => false,);},
              backgroundColor: Colors.transparent, // Прозрачный фон для FAB
              elevation: 0, // Убираем стандартное свечение
              child: Icon(Icons.home, color: Colors.white), // Иконка кнопки
            ),
          ),
        ),
      ),
    );
  }
}

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
