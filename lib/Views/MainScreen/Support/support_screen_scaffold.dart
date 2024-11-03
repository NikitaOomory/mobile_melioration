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
      appBar: AppBar(title: Text('Тех. поддержка'),),
      body: Center(child: Text('Скоро появится!'),),
    );
  }

}



