import 'package:flutter/material.dart';



class SupportScreenScaffold extends StatefulWidget {
  const SupportScreenScaffold({super.key});

  @override
  _SupportScreenScaffoldState createState() => _SupportScreenScaffoldState();
}
class _SupportScreenScaffoldState extends State<SupportScreenScaffold> {
  int i = 10;

  // String test(){
  //   if(i == 10){
  //     return 'работает правильно!';
  //   }else{
  //     return 'работает неправильно!';
  //   }
  // }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Наш новый экран!', style: TextStyle(color: Colors.black, fontSize: 16),),),
      body: Text('test'),
      );




  }

}



