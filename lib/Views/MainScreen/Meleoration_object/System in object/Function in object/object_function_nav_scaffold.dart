import 'dart:developer';

import 'package:flutter/material.dart';

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

  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context)?.settings.arguments;
    if(args == null){
      log('You must provide args');
      return;
    }
    if(args is! String){
      log('You must provide String args');
      return;
    }
    ref = args;
    setState(() {

    });
    super.didChangeDependencies();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(ref),),
      body: ListView.builder(
          itemCount: arrayFunction.length,
          itemBuilder: (context, i){
            FunObject index = arrayFunction[i];
            return CardMainFun(icon: index.icon, title: index.title, description: index.description, onTap: (){
              Navigator.of(context).pushNamed( index.pageURL, arguments: ref.toString());
            });
          }
      ),
    );
  }
  
}