import 'package:flutter/material.dart';
import 'package:mobile_melioration/MainScreen/Widgets/app_bar_main_screen.dart';
import 'package:mobile_melioration/MainScreen/Widgets/card_main_fun.dart';

class MainScreenScaffold extends StatefulWidget{
  const MainScreenScaffold({super.key});

  @override
  State<StatefulWidget> createState() => _MainScreenScaffold();
}

class _MainScreenScaffold extends State<MainScreenScaffold>{

  List<FunObject> arrayFunction = [
    FunObject(Icons.settings_outlined, 'Мелиоративные объекты', 'Системы / ОР ГТС / ГТС / Объекты', 'url'),
    FunObject(Icons.contact_page_rounded, 'Заявки на работы', 'Реестр зарегистрированных заявок', 'url'),
    FunObject(Icons.edit, 'Актуализация тех. состояния', 'Реестр зарегистрированных изменений', 'url'),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: ListView.builder(
        itemCount: arrayFunction.length,
        itemBuilder: (context, i){
          FunObject index = arrayFunction[i];
          return CardMainFun(icon: index.icon, title: index.title, description: index.description, onTap: (){});
        }
      ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          color: Colors.transparent,
          child: TextButton(onPressed: (){}, child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
            Icon(Icons.help, color: Colors.grey,),
            Text(' Служба поддержки', style: TextStyle(color: Colors.grey),)
            ],),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return const Color.fromARGB(29, 120, 120, 120); // Цвет фона при нажатии
                }
                return null; // Цвет фона по умолчанию (или null для прозрачного фона)
              },
            ),
          ),
        ),
      ),
    );
  }
}

class FunObject{
  IconData icon;
  String title;
  String description;
  String pageURL;

  FunObject(this.icon, this.title, this.description, this.pageURL);
}