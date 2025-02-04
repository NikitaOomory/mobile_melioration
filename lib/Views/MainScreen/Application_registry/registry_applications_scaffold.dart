import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile_melioration/Models/my_arguments.dart';
import 'package:mobile_melioration/server_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../Models/user.dart';
import '../../../Models/application.dart';
import '../../../UI-kit/Widgets/JobApplicationCard.dart';


class RegestryApplication extends StatefulWidget {
  @override
  _RegestryApplicationState createState() => _RegestryApplicationState();
}

class _RegestryApplicationState extends State<RegestryApplication> {
  final Dio _dio = Dio();
  List<Application> _applications = [];
  List<Application> _filteredApplications = [];
  bool _isLoading = true;
  String _error = '';
  String ref2 = '';
  String refValue2 = '';
  String refObject = '';
  String refSystem = '';
  String objectName = '';
  User user = User(status: '', name: '', role: '');
  String userData = 'Загрузка...';


  Future<void> _refreshData() async {
    _applications = [];
    _fetchApplications();
    await Future.delayed(Duration(seconds: 1));
  }

  Future<void> loadUserData() async {
    User? loadedUser = await getUserFromPreferences();
    if (loadedUser != null) {
      setState(() {
        user = loadedUser; // Обновляем состояние виджета
        userData = 'Статус: ${user.status}, Имя: ${user.name}, Роль: ${user.role}';
      });
    } else {
      setState(() {
        userData = 'Данные пользователя не найдены.';
      });
    }
  }

  Future<User?> getUserFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('userData');
    if (userData != null) {
      Map<String, dynamic> json = jsonDecode(userData);
      return User.fromJson(json);
    }
    return null; // Если данных нет, возвращаем null
  }

  @override
  void initState() {
    super.initState();
    _fetchApplications();
    loadUserData();
  }


  Future<void> _fetchApplications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? password = prefs.getString('password');
    try {
      final response = await _dio.get(ServerRoutes.GET_APPLICATIONS_FOR_WORK, options: Options(
        headers: {
          'Authorization': 'Basic ${base64Encode(utf8.encode('$username:$password'))}',
        },
      ));

      if (response.statusCode == 200) {
        print('Response data: ${response.data}'); // Отладочное сообщение
        Map<String, dynamic> data = response.data; // Извлекаем массив данных из ответа
        var dataObject = data['#value']?.firstWhere((item) => item['name']['#value'] == 'data', orElse: () => null);

        if (dataObject != null && dataObject['Value']['#value'] != null) {
          var valueArray = dataObject['Value']['#value']; // Парсим данные в объекты Application

          for (var item in valueArray) {
            String ref = '';
            String owner = '';
            String reclamationSystem = '';
            String hydraulicStructure = '';
            String objectName = '';
            String startDate = '';
            String startJobDate = '';
            String endJobDate = '';
            String description = '';
            String number = '';
            String status = '';

            for (var field in item['#value']) {
              switch (field['name']['#value']) {
                case 'Ref':
                  ref = field['Value']['#value'];
                  break;
                case 'Owner':
                  owner = field['Value']['#value'];
                  break;
                case 'ReclamationSystem':
                  reclamationSystem = field['Value']['#value'];
                  break;
                case 'HydraulicStructure':
                  hydraulicStructure = field['Value']['#value'];
                  break;
                case 'objectName':
                  objectName = field['Value']['#value'];
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

            // Создаем новый объект Application и добавляем его в список
            _applications.add(Application(
              ref: ref,
              owner: owner,
              reclamationSystem: reclamationSystem,
              hydraulicStructure: hydraulicStructure,
              objectName: objectName,
              startDate: startDate,
              startJobDate: startJobDate,
              endJobDate: endJobDate,
              description: description,
              number: number,
              status: status,
            ));
            print('ref - $ref, owner - $owner, description - $description, number - $number');
          }

          // Копируем все данные в _filteredApplications
          _filteredApplications = List.from(_applications);

          setState(() {
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
        title: const Text('Список заявок на работы'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Вернуться на предыдущий экран
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                filterApplications(value);
              },
              decoration: const InputDecoration(
                hintText: 'Поиск...',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
          ? const Center(child: Text('Объекты отсутствуют'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: ListView.builder(
            itemCount: _filteredApplications.length,
            itemBuilder: (context, index) {
              var application = _filteredApplications[index];
              return JobApplicationCard(
                status: application.status,
                title: application.objectName,
                requestNumber: application.number,
                requestDate: application.startDate,
                author: application.owner,
                onTap: () {
                  Navigator.of(context).pushNamed('/enter_job_application_form',
                      arguments: MyArguments('','', Application(
                        ref:'',
                        owner: application.owner,
                        reclamationSystem: '',
                        hydraulicStructure: '',
                        objectName: application.objectName,
                        startDate: application.startDate,
                        startJobDate: application.startJobDate,
                        endJobDate: application.endJobDate,
                        description:  application.description,
                        number: application.number,
                        status: application.status,),
                    application.objectName));
                },
                //todo: проверить переход из реестра на форму заполнения заявки (условие - чтобы с ними ничего нельзя было сделать, т.к. эти заявки уже на сервере)
              );
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Первая кнопка FAB
          Positioned(
            bottom: 10,
            child: ClipOval(
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 0, 78, 167), // Цвет кнопки
                ),
                child: SizedBox(
                  width: 56, // Ширина кнопки
                  height: 56, // Высота кнопки
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/main_screen',
                            (Route<dynamic> route) => false,
                      );
                    },
                    backgroundColor: Colors.transparent,
                    // Прозрачный фон для FAB
                    elevation: 0,
                    // Убираем стандартное свечение
                    child: const Icon(Icons.home, color: Colors.white), // Иконка кнопки
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void filterApplications(String query) {
    setState(() {
      if (query.isEmpty) {
        // Если строка поиска пуста, показываем все заявки
        _filteredApplications = List.from(_applications);
      } else {
        // Фильтруем заявки по введенному запросу
        _filteredApplications = _applications.where((app) {
          return app.owner.toLowerCase().contains(query.toLowerCase()) ||
              app.number.toLowerCase().contains(query.toLowerCase()) ||
              app.reclamationSystem.toLowerCase().contains(query.toLowerCase()) ||
              app.hydraulicStructure.toLowerCase().contains(query.toLowerCase()) ||
              app.startDate.toLowerCase().contains(query.toLowerCase()) ||
              app.endJobDate.toLowerCase().contains(query.toLowerCase()) ||
              app.description.toLowerCase().contains(query.toLowerCase()) ||
              app.objectName.toLowerCase().contains(query.toLowerCase()) ||
              app.status.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }
}
