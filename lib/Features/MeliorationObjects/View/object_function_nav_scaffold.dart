import 'package:flutter/material.dart';

import '../../MainScreen/Modals/model_function_card.dart';
import '../../MainScreen/Widgets/card_main_fun.dart';

class ObjectFunctionNavScaffold extends StatefulWidget{
 const ObjectFunctionNavScaffold({super.key});

 @override
  State<StatefulWidget> createState() => _ObjectFunctionNavScaffold();
}

class _ObjectFunctionNavScaffold extends State<ObjectFunctionNavScaffold>{

  List<FunObject> arrayFunction = [
    FunObject(Icons.contact_page_rounded, 'Заявки на работы', 'Создание заявки на выполнение работ', ''),
    FunObject(Icons.contact_page_rounded, 'Актуализация тех. состояния', 'Внесение изменений о техническом состоянии', ''),
    FunObject(Icons.edit, 'Журнал инструментальных \nнаблюдений', 'Регистрация результатов', ''),
    FunObject(Icons.edit, 'Журнал визуальных осмотров \nи наблюдений', 'Регистрация результатов', ''),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Функции для объекта'),),
      body: ListView.builder(
          itemCount: arrayFunction.length,
          itemBuilder: (context, i){
            FunObject index = arrayFunction[i];
            return CardMainFun(icon: index.icon, title: index.title, description: index.description, onTap: (){
              Navigator.of(context).pushNamed(index.pageURL);
            });
          }
      ),
    );
  }
  
}