import 'package:flutter/material.dart';



class SupportScreenScaffold extends StatefulWidget {
  const SupportScreenScaffold({super.key});

  @override
  _SupportScreenScaffoldState createState() => _SupportScreenScaffoldState();
}
class _SupportScreenScaffoldState extends State<SupportScreenScaffold> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Техническая поддержка', style: TextStyle(color: Colors.black, fontSize: 16),),),
      body: const Center(
        child: Text('Скоро появится!'),
      ),
      );




  }

}



