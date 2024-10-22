import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_melioration/Models/melioration_object_model.dart';

class TechCondForm extends StatefulWidget {
  @override
  _TechCondFormState createState() => _TechCondFormState();
}

class _TechCondFormState extends State<TechCondForm> {
  final TextEditingController _wearController = TextEditingController();
  String? _selectedCondition;

  final List<String> _conditions = [
    'Нормативное',
    'Работоспособное',
    'Ограниченно работоспособное',
    'Аварийное',
    'Требующее капитального ремонта',
    'Подлежащие ликвидации',
  ];

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
        title: Text('Актуализация тех. состояния'),
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
                    width: double.infinity, // Задает ширину кнопки на всю ширину экрана
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.blue, backgroundColor: Colors.white, // Цвет текста (синий)
                        side: BorderSide(
                          color: Colors.blue, // Синяя рамка вокруг кнопки
                          width: 2.0,
                        ),
                        shape:  RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5), // Убираем закругление
                        ),
                      ),
                      onPressed: () {
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