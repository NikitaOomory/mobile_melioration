import 'package:flutter/material.dart';

import '../Modals/model_function_card.dart';
import '../Widgets/app_bar_main_screen.dart';
import '../Widgets/card_main_fun.dart';


class MainScreenScaffold extends StatefulWidget{
  const MainScreenScaffold({super.key});

  @override
  State<StatefulWidget> createState() => _MainScreenScaffold();
}

class _MainScreenScaffold extends State<MainScreenScaffold>{

  List<FunObject> arrayFunction = [
    FunObject(Icons.settings_outlined, 'Мелиоративные объекты', 'Системы / ОР ГТС / ГТС / Объекты', '/list_melioration_systems'),
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
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          color: Colors.transparent,
          child: TextButton(onPressed: (){
            Navigator.of(context).pushNamed('/support');
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                if (states.contains(WidgetState.pressed)) {
                  return const Color.fromARGB(29, 120, 120, 120); // Цвет фона при нажатии
                }
                return null; // Цвет фона по умолчанию (или null для прозрачного фона)
              },
            ),
          ), child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
            Icon(Icons.help, color: Colors.grey,),
            Text(' Служба поддержки', style: TextStyle(color: Colors.grey),)
            ],),
        ),
      ),
    );
  }
}

