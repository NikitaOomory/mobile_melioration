import 'package:flutter/material.dart';

class BottomAppBarMain extends StatelessWidget{
  const BottomAppBarMain({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
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
              return null;
            },
          ),
        ), child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.help, color: Colors.grey,),
            Text('Служба поддержки', style: TextStyle(color: Colors.grey),)
          ],),
      ),
    );
  }
}