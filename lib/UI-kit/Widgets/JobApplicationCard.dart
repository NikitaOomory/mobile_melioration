import 'package:flutter/material.dart';

class JobApplicationCard extends StatelessWidget {
  final String status;
  final String title;
  final String requestNumber;
  final String requestDate;
  final String author;
  final Function onTap;

  JobApplicationCard({
    required this.status,
    required this.title,
    required this.requestNumber,
    required this.requestDate,
    required this.author,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: () => onTap(),
    child: Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8),),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Статус заявки
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: getStatusColor(status),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(status, style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              ),
            ),
            SizedBox(height: 8), // Отступ между статусом и названием
            // Название заявки
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 4), // Отступ между названием и номером
            // Номер заявки
            Text(
              'Номер: $requestNumber',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 4), // Отступ между номером и датой
            // Дата заявки
            Text(
              'Дата: $requestDate',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 4), // Отступ между датой и автором
            // Автор заявки
            Text(
              'Автор: $author',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    ),
    );
  }

  // Функция для получения цвета статуса
  Color getStatusColor(String status) {
    switch (status) {
      case 'В работе':
        return const Color.fromARGB(211, 248, 169, 0);
      case 'На отправке':
        return const Color.fromARGB(115, 168, 168, 168);
      case 'В проекте':
        return const Color.fromARGB(115, 38, 117, 255);
      case 'На доработке':
        return const Color.fromARGB(166, 255, 255, 0);
      case 'Выполнено (силами организации)':
        return const Color.fromARGB(165, 51, 204, 51);
      case 'Необходимо привлечение федеральных средств':
        return const Color.fromARGB(116, 45, 211, 147);
      case 'На рассмотрении':
        return const Color.fromARGB(255, 175, 219, 255);
      case 'Отклонен':
        return const Color.fromARGB(174, 244, 0, 0);
      default:
        return const Color.fromARGB(115, 129, 129, 129);
    }
  }
}