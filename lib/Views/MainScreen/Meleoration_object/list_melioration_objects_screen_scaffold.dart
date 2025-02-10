import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile_melioration/data/repositories/meliorative_repository.dart';
import 'package:mobile_melioration/data/repositories/meliorative_repository_impl.dart';
import 'package:mobile_melioration/data/meliorative_data_source.dart';
import 'package:mobile_melioration/Models/my_arguments.dart';
import 'package:mobile_melioration/UI-kit/Widgets/card_melio_objects.dart';
import 'package:mobile_melioration/data/services/cache_service.dart'; // Импортируем CacheService

class ListMeliorationObjectsScreenScaffold extends StatefulWidget {
  const ListMeliorationObjectsScreenScaffold({super.key});

  @override
  _ListMeliorationObjectsScreenScaffoldState createState() =>
      _ListMeliorationObjectsScreenScaffoldState();
}

class _ListMeliorationObjectsScreenScaffoldState
    extends State<ListMeliorationObjectsScreenScaffold> {
  List<MelObjects> _reclamations = [];
  List<MelObjects> _filteredReclamations = [];
  bool _isLoading = true;
  String _searchQuery = '';
  late MeliorativeRepository _repository;

  @override
  void initState() {
    super.initState();
    final dio = Dio();
    final dataSource = MeliorativeDataSourceImpl(dio);
    _repository = MeliorativeRepositoryImpl(dataSource);
    _fetchReclamations();
  }

  Future<void> _fetchReclamations() async {
    try {
      final isOnline = await CacheService.isOnline();

      if (isOnline) {
        // Если есть интернет, загружаем данные с сервера
        final systems = await _repository.getSystems();
        setState(() {
          _reclamations = systems.map((system) => MelObjects.fromJson(system.toJson())).toList();
          _filteredReclamations = _reclamations;
          _isLoading = false;
        });

        // Сохраняем данные в кэш
        await CacheService.saveData('systems', _reclamations.map((e) => e.toJson()).toList());
      } else {
        // Если интернета нет, загружаем данные из кэша
        final cached = await CacheService.getData('systems');
        setState(() {
          _reclamations = cached.map<MelObjects>((e) => MelObjects.fromJson(e)).toList();
          _filteredReclamations = _reclamations;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
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
        title: const Text('Мелиоративные объекты'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            child: TextField(
              onChanged: _filterReclamations,
              decoration: const InputDecoration(
                hintText: 'Поиск...',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _filteredReclamations.isEmpty
          ? const Center(child: Text('Нет доступных систем'))
          : Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
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
                  arguments: MyArguments(
                    reclamation.refSystem,
                    reclamation.name,
                    '',
                    '',
                  ),
                );
              },
              ref: '',
            );
          },
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

  Map<String, dynamic> toJson() {
    return {
      'refSystem': refSystem,
      'id': id,
      'name': name,
      'type': type,
      'location': location,
      'actualWear': actualWear,
      'technicalCondition': technicalCondition,
    };
  }
}