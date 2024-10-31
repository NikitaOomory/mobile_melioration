import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../Widgets/JobApplicationCard.dart';

class ListApplicationsScaffold extends StatefulWidget {
  @override
  _ListApplicationsScaffoldState createState() => _ListApplicationsScaffoldState();
}

class _ListApplicationsScaffoldState extends State<ListApplicationsScaffold> {
  final Dio _dio = Dio();
  List<dynamic> _applications = [];
  bool _isLoading = true;
  String _error = '';
  String ref2 = '';
  String refValue2 = '';
  String newRef = '';
  String newRefValue ='';


  @override
  void initState() {
    super.initState();
    _fetchApplications();
  }

  Future<void> _fetchApplications() async {
    final String url =
        'http://192.168.7.6/MCX_melio_dev_atropin/hs/api/?typerequest=getApplicationsForWork';
    String username = 'tropin'; // Замените на ваши учетные данные
    String password = '1234'; // Замените на ваши учетные данные

    try {
      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Basic ${base64Encode(utf8.encode('$username:$password'))}',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Response data: ${response.data}'); // Отладочное сообщение
        Map<String, dynamic> data = response.data; // Извлекаем массив данных из ответа
        var dataObject = data['#value']?.firstWhere(
              (item) => item['name']['#value'] == 'data',
          orElse: () => null,
        );

        if (dataObject != null && dataObject['Value']['#value'] != null) {
          var valueArray = dataObject['Value']['#value'];
          setState(() {
            _applications = valueArray; // Сохраняем данные для отображения
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
          _error = 'Ошибка: ${response.statusCode}';
          _isLoading = false; // Останавливаем индикатор загрузки
        });
      }
    } catch (e) {
      print('Ошибка: $e');
      setState(() {
        _error = 'Ошибка: $e';
        _isLoading = false; // Останавливаем индикатор загрузки
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Заявки на работы'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
          ? Center(child: Text('В системе отсутствуют заявки'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _applications.length,
          itemBuilder: (context, index) {
            var application = _applications[index]['#value'];

            // Извлекаем данные из заявки
            String ref = '';
            String owner = '';
            String reclamationSystem = '';
            String hydraulicStructure = '';
            String startDate = '';
            String startJobDate = '';
            String endJobDate = '';
            String description = '';
            String number = '';
            String status = '';

            // Заполняем переменные данными из заявки
            for (var field in application) {
              switch (field['name']['#value']) {
                case 'Ref':
                  ref = field['Value']['#value'];
                  refValue2 = ref;
                  break;
                case 'Owner':
                  owner = field['Value']['#value'];
                  break;
                case 'ReclamationSystem':
                  reclamationSystem = field['Value']['#value'];
                  break;
                case 'HydraulicStructure':
                  hydraulicStructure = field['Value']['#value'];
                  ref2 = hydraulicStructure;
                  break;
                case 'startDate':
                  startDate = field['Value']['#value'];
                  break;
                case 'startJobDate':
                  startJobDate = field['Value']['#value'];
                  break;
                case 'endJobDate':
                  endJobDate = field['Value']['#value'];
                  break;
                case 'description':
                  description = field['Value']['#value'];
                  break;
                case 'number':
                  number = field['Value']['#value'];
                  break;
                case 'status':
                  status = field['Value']['#value'];
                  break;
              }
            }
            return JobApplicationCard(status: status, title: 'Заявка $number', requestNumber: number, requestDate: startDate, author: owner, onTap: (){
            });
          },
        ),
      ),
    );
  }
}