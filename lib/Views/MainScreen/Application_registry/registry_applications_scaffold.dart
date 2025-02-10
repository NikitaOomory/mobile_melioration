import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile_melioration/data/repositories/meliorative_repository.dart';
import 'package:mobile_melioration/data/repositories/meliorative_repository_impl.dart';
import 'package:mobile_melioration/data/meliorative_data_source.dart';
import 'package:mobile_melioration/Models/application.dart';
import 'package:mobile_melioration/Models/my_arguments.dart';
import 'package:mobile_melioration/UI-kit/Widgets/JobApplicationCard.dart';


class RegestryApplication extends StatefulWidget {
  @override
  _RegestryApplicationState createState() => _RegestryApplicationState();
}

class _RegestryApplicationState extends State<RegestryApplication> {
  List<Application> _applications = [];
  List<Application> _filteredApplications = [];
  bool _isLoading = true;
  String _error = '';
  late MeliorativeRepository _repository;

  @override
  void initState() {
    super.initState();
    final dio = Dio();
    final dataSource = MeliorativeDataSourceImpl(dio);
    _repository = MeliorativeRepositoryImpl(dataSource);
    _fetchApplications();
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });
    await _fetchApplications();
  }

  Future<void> _fetchApplications() async {
    try {
      final applications = await _repository.getApplications();
      setState(() {
        _applications = applications;
        _filteredApplications = applications;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Ошибка: $e';
        _isLoading = false;
      });
    }
  }

  void filterApplications(String query) {
    setState(() {
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
    });
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
            Navigator.pop(context);
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: filterApplications,
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
          ? Center(child: Text(_error))
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
                  Navigator.of(context).pushNamed(
                    '/enter_job_application_form',
                    arguments: MyArguments(
                      '',
                      '',
                      application,
                      application.objectName,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/main_screen',
                (Route<dynamic> route) => false,
          );
        },
        child: const Icon(Icons.home),
      ),
    );
  }
}