import 'package:flutter/material.dart';
import 'package:mobile_melioration/Widgets/bottom_app_bar_main.dart';

import '../../Models/model_function_card.dart';
import '../../Widgets/app_bar_main_screen.dart';
import '../../Widgets/card_main_fun.dart';

class MainScreenScaffold extends StatefulWidget{
  const MainScreenScaffold({super.key});

  @override
  State<StatefulWidget> createState() => _MainScreenScaffold();

}

class _MainScreenScaffold extends State<MainScreenScaffold>{

  List<FunObject> arrayFunction = [
    FunObject(Icons.settings_outlined, 'Мелиоративные объект', 'Системы / ОР ГТС / ГТС / Объекты', '/list_melioration_systems'),
    FunObject(Icons.contact_page_rounded, 'Заявки на работы', 'Реестр зарегистрированных заявок', '/list_applications'),
    FunObject(Icons.edit, 'Актуализация тех. состояния', 'Реестр зарегистрированных изменений', '/list_technical_conditions'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarMainScreen(),
      body: ListView.builder(
        itemCount: arrayFunction.length,
        itemBuilder: (context, i){
          FunObject index = arrayFunction[i];
          return CardMainFun(icon: index.icon, title: index.title, description: index.description, onTap: (){
            Navigator.of(context).pushNamed(index.pageURL);
          });
        }
      ),
      bottomNavigationBar: const BottomAppBarMain(),
    );
  }
}

