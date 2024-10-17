import 'package:flutter/material.dart';
import 'package:mobile_melioration/Repositories/crypto_coins_repo.dart';
import 'package:mobile_melioration/Models/crypto_coin_model.dart';

class SupportScreenScaffold extends StatefulWidget{
  const SupportScreenScaffold({super.key});

  @override
  State<StatefulWidget> createState() => _SupportScreenScaffold();
}

class _SupportScreenScaffold extends State<SupportScreenScaffold>{

  final List<String> array = ['Никита', 'Иван', 'Макс'];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: array.length,
        itemBuilder: (context, i) => ListTile(
          leading: Text(array[i]),
        ),
      ),
    );
  }



}

