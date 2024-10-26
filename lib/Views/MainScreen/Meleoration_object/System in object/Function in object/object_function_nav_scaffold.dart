import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobile_melioration/Models/my_arguments.dart';

import '../../../../../Models/model_function_card.dart';
import '../../../../../Widgets/card_main_fun.dart';

class ObjectFunctionNavScaffold extends StatefulWidget{
 const ObjectFunctionNavScaffold({super.key});

 @override
  State<StatefulWidget> createState() => _ObjectFunctionNavScaffold();
}

class _ObjectFunctionNavScaffold extends State<ObjectFunctionNavScaffold>{

  List<FunObject> arrayFunction = [
    FunObject(Icons.contact_page_rounded, 'Заявки на работы', 'Создание заявки на выполнение работ', '/list_enter_job_application'),
    FunObject(Icons.contact_page_rounded, 'Актуализация тех. состояния', 'Внесение изменений о техническом состоянии', '/tech_cond_form'),
  ];

  String ref = '';
  String refValue = '';

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
    ref = args.param1;
    refValue = args.param2;
    setState(() {

    });
    super.didChangeDependencies();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Сооружение $ref, системы $refValue',
      maxLines: 3, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),),
      body: ListView.builder(
          itemCount: arrayFunction.length,
          itemBuilder: (context, i){
            FunObject index = arrayFunction[i];
            return CardMainFun(icon: index.icon, title: index.title, description: index.description, onTap: (){
              Navigator.of(context).pushNamed( index.pageURL, arguments: MyArguments(ref, refValue, '', ''));
            });
          }
      ),
    );
  }
  
}