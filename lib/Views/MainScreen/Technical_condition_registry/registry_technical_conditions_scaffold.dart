import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// class ListTechnicalConditionsScaffold extends StatefulWidget{
class ListTechnicalConditionsScaffold extends StatefulWidget {
  @override
  _ListTechnicalConditionsScaffoldState createState() => _ListTechnicalConditionsScaffoldState();
}

class _ListTechnicalConditionsScaffoldState extends State<ListTechnicalConditionsScaffold> {
  List<dynamic> _data = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchData(); // Выполняем запрос сразу при инициализации состояния
  }

  Future<void> _fetchData() async {
    String url = 'http://192.168.7.6/MCX_melio_dev_atropin/hs/api/?typerequest=getHistoryReclamationSystem';
    String username = 'tropin'; // Замените на ваш логин
    String password = '1234'; // Замените на ваш пароль

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
        if (jsonResponse['#value'] != null) {
          // Извлекаем данные из ответа
          List<dynamic> data = jsonResponse['#value'][2]['Value']['#value'];
          setState(() {
            _data = data; // Сохраняем данные
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Ошибка: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Ошибка: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Реестр актуализации'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _errorMessage.isNotEmpty
            ? Center(child: Text(_errorMessage, style: TextStyle(color: Colors.red)))
            : ListView.builder(
          itemCount: _data.length,
          itemBuilder: (context, index) {
            final item = _data[index]['#value'];
            return Card(
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(item[5]['Value']['#value']), // Name
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Номер: ${item[1]['Value']['#value']}'), // Version
                    Text('Дата: ${item[2]['Value']['#value']}'), // VersionDate
                    Text('Автор: ${item[3]['Value']['#value']}'), // VersionAuthor
                    Text('ЕИН: ${item[4]['Value']['#value']}'), // Id
                    Text('Местоположение: ${item[7]['Value']['#value']}'), // Location
                    Text('Фактический износ: ${item[8]['Value']['#value']}%'), // ActualWear
                    Text('Оценка тех. состояния: ${item[9]['Value']['#value']}'), // TechnicalCondition
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}