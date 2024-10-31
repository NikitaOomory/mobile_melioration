import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_melioration/Database/JobApplication/db_utils_melio_object.dart';
import 'package:mobile_melioration/Database/MeliorationObjects/db_utils_melio_objects.dart';
import 'package:mobile_melioration/Widgets/JobApplicationCard.dart';

import '../../../../../../Models/melioration_object_model.dart';
import '../../../../../../Models/my_arguments.dart';

class Application {
  String ref;
  String owner;
  String reclamationSystem;
  String hydraulicStructure;
  String startDate;
  String startJobDate;
  String endJobDate;
  String description;
  String number;
  String status;

  Application({
    required this.ref,
    required this.owner,
    required this.reclamationSystem,
    required this.hydraulicStructure,
    required this.startDate,
    required this.startJobDate,
    required this.endJobDate,
    required this.description,
    required this.number,
    required this.status,
  });
}

class ListEnterJobApplication extends StatefulWidget {
  @override
  _ListEnterJobApplicationState createState() => _ListEnterJobApplicationState();
}

class _ListEnterJobApplicationState extends State<ListEnterJobApplication> {
  final Dio _dio = Dio();
  List<Application> _applications = [];
  List<Application> _filteredApplications = [];
  bool _isLoading = true;
  String _error = '';
  String ref2 = '';
  String refValue2 = '';
  String refObject = '';
  String refSystem ='';
  String nameObject ='';

    @override
  void didChangeDependencies() {
    final MyArguments args = ModalRoute.of(context)?.settings.arguments as MyArguments;
    if(args == null){
      log('You must provide args');
      return;
    }
    if(args.param1 is! String){
      log('You must provide String args');
      return;
    }
    refObject = args.param1;
    refSystem = args.param2;
    nameObject = args.param3;
    setState(() {

    });
    super.didChangeDependencies();
  }

  void _addApplicationsFromMeliorationObjects() {
    List<MeliorationObjectModel> meliorationObjects = DBUtilsJobApplications().getTasks();

    for (var meliorationObject in meliorationObjects) {
      // Создаем Application на основе MeliorationObjectModel
      Application application = Application(
        ref: meliorationObject.prevUnit, // Или другое соответствующее поле
        owner: 'Тропин Александр Александрович',
        reclamationSystem: '', // Например, тип объекта
        hydraulicStructure: meliorationObject.nextUnit, // Например, адрес
        startDate: '2024-10-26',
        startJobDate: meliorationObject.startJobDate,
        endJobDate: meliorationObject.endJobDate,
        description: meliorationObject.description,
        number: '',
        status: meliorationObject.status,
      );

      // Добавляем объект Application в список
      _applications.add(application);
      print('${application.status} + ${application.reclamationSystem}');
    }
  }

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
            'Authorization':
            'Basic ${base64Encode(utf8.encode('$username:$password'))}',
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

          // Парсим данные в объекты Application
          for (var item in valueArray) {
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
              startDate: startDate,
              startJobDate: startJobDate,
              endJobDate: endJobDate,
              description: description,
              number: number,
              status: status,
            ));
          }

          // Фильтрация по параметру HydraulicStructure

          _addApplicationsFromMeliorationObjects();

          String filterValue = refObject; // Установите значение для фильтрации
          _filteredApplications = _applications.where((app) =>
          app.hydraulicStructure == filterValue).toList();

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
        title: Text('Заявки на работы $nameObject', maxLines: 3, style: TextStyle(fontSize: 16),),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
          ? Center(child: Text('На данный объект заявки отсутствуют'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child:
      ListView.builder(
        itemCount: _filteredApplications.length,
        itemBuilder: (context, index) {
          var application = _filteredApplications[index];
          return JobApplicationCard(
            status: application.status,
                  title: 'Заявка ${application.number}',
                  requestNumber: application.number,
                  requestDate: application.startDate,
                  author: application.owner,
                  onTap: (){
                    Navigator.of(context).pushNamed('/enter_job_application_form', arguments: MyArguments(refObject, refSystem, application, nameObject));
                  },
            );
        },
      ),
      ),
        floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.of(context).pushNamed('/enter_job_application_form', arguments: MyArguments(refObject, refSystem,
            Application(
            ref: '',
            owner: 'Тропин Александр Флександрович',
            reclamationSystem: '',
            hydraulicStructure: refObject,
            startDate: '',
            startJobDate: 'startJobDate',
            endJobDate: 'endJobDate',
            description: '',
            number: 'number',
            status: 'В проекте'), nameObject));},
          child: Icon(Icons.add, color: Colors.white,),
        backgroundColor: Color.fromARGB(255, 0, 78, 167),
      ),
    );
  }
}