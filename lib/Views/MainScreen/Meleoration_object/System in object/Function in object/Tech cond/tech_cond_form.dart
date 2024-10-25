import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TechCondForm extends StatefulWidget {
  @override
  _TechCondFormState createState() => _TechCondFormState();
}

class _TechCondFormState extends State<TechCondForm> {
  final TextEditingController _wearController = TextEditingController();
  String? _selectedCondition;
  int num = 0;
  String ref = '';

  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context)?.settings.arguments;
    if(args == null){
      log('You must provide args');
      return;
    }
    if(args is! String){
      log('You must provide String args');
      return;
    }
    ref = args;
    setState(() {

    });
    super.didChangeDependencies();
  }

  final List<String> _conditions = [
    'Нормативное',
    'Работоспособное',
    'Ограниченно работоспособное',
    'Аварийное',
    'Требующее капитального ремонта',
    'Подлежащие ликвидации',
  ];

  final Dio _dio = Dio();

  Future<void> _sendReclamationData(String tech, String num) async {
    final String url =
        'http://192.168.7.6/MCX_melio_dev_atropin/hs/api/?typerequest=WriteReclamationSystem';
    String username = 'tropin'; // Учетные данные
    String password = '1234'; // Учетные данные

    // Тело запроса
    final Map<String, dynamic> requestBody = {
      "ref": ref,
      "TechnicalCondition": tech,
      "ActualWear": num
    };

    try {
      final response = await _dio.post(
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

      if (response.statusCode == 200) {
        print('Response data: ${response.data}'); // Выводим ответ в консоль
      } else {
        print('Ошибка: ${response.statusCode}'); // Выводим статус ошибки
      }
    } catch (e) {
      print('Ошибка: $e'); // Обработка ошибок
    }
  }

  void _showSnackbar(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('Состояние обнавлено'),
      action: SnackBarAction(
        label: 'Закрыть',
        onPressed: () {
          // Код, который будет выполнен при нажатии на кнопку
        },
      ),
    );

    // Показать SnackBar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ref),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [

                TextField(
                  controller: TextEditingController(text: 'Система №1',),
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Мелиоративная система',
                    border: InputBorder.none,
                  ),
                ),
                SizedBox(height: 16),

                TextField(
                  controller: TextEditingController(text: 'Оросительная система'),
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Вид объекта',
                    border: InputBorder.none,
                  ),
                ),
                SizedBox(height: 16),

                // Поле мелиоративного объекта
                TextField(
                  controller: TextEditingController(text: 'Сооружение №3'),
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Сооружение',
                    border: InputBorder.none,
                  ),
                ),
                SizedBox(height: 16),

                TextField(
                  maxLines: 3,
                  controller: TextEditingController(text: 'г. Москва, Октябрьский район, ул. Советская, д.23,1'),
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Местоположение',
                    border: InputBorder.none,
                  ),
                ),

                // Поле ЕИН объекта
                TextField(
                  controller: TextEditingController(text: '30Ф-ОРО-0001-ООС-001'),
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'ЕИН объекта',
                    border: InputBorder.none,
                  ),
                ),

                TextField(
                  controller: _wearController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Фактический износ (1-100)',
                    border: OutlineInputBorder(),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  value: _selectedCondition,
                  decoration: InputDecoration(
                    labelText: 'Оценка технического состояния',
                    border: OutlineInputBorder(),
                  ),
                  items: _conditions.map((String condition) {
                    return DropdownMenuItem<String>(
                      value: condition,
                      child: Text(condition),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCondition = newValue;
                    });
                  },
                  hint: Text('Выберите состояние'),
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.blue, backgroundColor: Colors.white,
                        side: BorderSide(
                          color: Colors.blue,
                          width: 2.0,
                        ),
                        shape:  RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {
                          _sendReclamationData(_selectedCondition.toString(), _wearController.toString());
                          _showSnackbar(context);
                          Navigator.of(context).pop('/object_fun_nav');
                      },
                      child: Text('Обновить'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}