import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListTechnicalConditionsScaffold extends StatefulWidget {
  @override
  _ListTechnicalConditionsScaffoldState createState() => _ListTechnicalConditionsScaffoldState();
}

class _ListTechnicalConditionsScaffoldState extends State<ListTechnicalConditionsScaffold> {
  List<dynamic> _data = [];
  List<dynamic> _filteredData = [];
  bool _isLoading = true;
  String _errorMessage = '';
  Timer? _debounce; // Таймер для debounce

  @override
  void initState() {
    super.initState();
    _fetchData(); // Выполняем запрос сразу при инициализации состояния
  }

  Future<void> _fetchData() async {
    String url = 'https://melio.mcx.ru/melio/hs/api/?typerequest=getHistoryReclamationSystem';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? password = prefs.getString('password');

    if (username == null || password == null) {
      setState(() {
        _errorMessage = 'Логин или пароль не найдены.';
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await Dio().get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Basic ${base64Encode(utf8.encode('$username:$password'))}',
          },
        ),
      );

      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        print('Полученный ответ: $jsonResponse'); // Для отладки

        if (jsonResponse['#value'] != null && jsonResponse['#value'] is List) {
          List<dynamic> data = jsonResponse['#value'][2]['Value']['#value'];
          setState(() {
            _data = data; // Сохраняем данные
            _filteredData = data; // Изначально показываем все данные
          });
        } else {
          setState(() {
            _errorMessage = 'Нет данных для отображения.';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Ошибка: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Нет данных для отображения.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterData(String query) {
// Если таймер существует, отменяем его
    if (_debounce?.isActive ?? false) _debounce!.cancel();
// Устанавливаем новый таймер
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final filtered = _data.where((item) {
        final itemValue = item['#value'];

// Преобразуем значения в строки, если они не строки
        String name = itemValue[5]['Value']['#value'].toString().toLowerCase(); // Name
        String version = itemValue[1]['Value']['#value'].toString().toLowerCase(); // Version
        String versionDate = itemValue[2]['Value']['#value'].toString().toLowerCase(); // VersionDate
        String versionAuthor = itemValue[3]['Value']['#value'].toString().toLowerCase(); // VersionAuthor
        String id = itemValue[4]['Value']['#value'].toString().toLowerCase(); // Id
        String location = itemValue[7]['Value']['#value'].toString().toLowerCase(); // Location
        String actualWear = itemValue[8]['Value']['#value'].toString().toLowerCase(); // ActualWear
        String technicalCondition = itemValue[9]['Value']['#value'].toString().toLowerCase(); // TechnicalCondition

        return name.contains(query.toLowerCase()) ||
            version.contains(query.toLowerCase()) ||
            versionDate.contains(query.toLowerCase()) ||
            versionAuthor.contains(query.toLowerCase()) ||
            id.contains(query.toLowerCase()) ||
            location.contains(query.toLowerCase()) ||
            actualWear.contains(query.toLowerCase()) ||
            technicalCondition.contains(query.toLowerCase());
      }).toList();

      setState(() {
        _filteredData = filtered; // Обновляем отфильтрованные данные
      });

// Дополнительный вывод для отладки
      print('Filtered Data: $_filteredData');
    });
  }

  @override
  void dispose() {
    _debounce?.cancel(); // Отменяем таймер при удалении виджета
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Список актуализаций'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: _filterData,
              decoration: const InputDecoration(
                hintText: 'Поиск...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                ),
              ),
            ),
            SizedBox(height: 16), // Отступ между полем поиска и списком
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : _errorMessage.isNotEmpty
                ? Center(child: Text(_errorMessage))
                : Expanded(
              child: ListView.builder(
                itemCount: _filteredData.length,
                itemBuilder: (context, index) {
                  final item = _filteredData[index]['#value'];
                  return Card(
                    color: Colors.white,
                    elevation: 5, // Добавьте тень к карточкам
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Закругленные углы
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0), // Внутренний отступ для карточки
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${item[5]['Value']['#value']}', // Name
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(height: 5), // Отступ между строками
                          Text('Номер: ${item[1]['Value']['#value']}', // Version
                              style: TextStyle(fontSize: 14)),
                          Text('Дата: ${item[2]['Value']['#value']}', // VersionDate
                              style: TextStyle(fontSize: 14)),
                          Text('Автор: ${item[3]['Value']['#value']}', // VersionAuthor
                              style: TextStyle(fontSize: 14)),
                          Text('ЕИН: ${item[4]['Value']['#value']}', // Id
                              style: TextStyle(fontSize: 14)),
                          Text('Местоположение: ${item[7]['Value']['#value']}', // Location
                              style: TextStyle(fontSize: 14)),
                          Text('Фактический износ: ${item[8]['Value']['#value']}%', // ActualWear
                              style: TextStyle(fontSize: 14)),
                          Text('Оценка тех. состояния: ${item[9]['Value']['#value']}', // TechnicalCondition
                              style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
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