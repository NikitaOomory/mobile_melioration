class ServerRoutes{

  static const String SERVER_ROUTE = 'https://melio.mcx.ru/melio/hs/api/?typerequest=';
  //главный роут

  static const String LOGIN_ROUTE = '${SERVER_ROUTE}login';
  //авторизация
  static const String GET_APPLICATIONS_FOR_WORK = '${SERVER_ROUTE}getApplicationsForWork';
  //получение всех заявок на работы доступных ФГБУ пользователя
  static const String GET_RECLAMATION_SYSTEM = '${SERVER_ROUTE}getReclamationSystem';
  //получение всех систем доступных ФГБУ пользователя
  static const String GET_OBJECTS_OF_RECLAMATION_SYSTEM = '${SERVER_ROUTE}getObjectsOfReclamationSystem';
  //получение всех объектов указанных в системе
  static const String WRITE_APPLICATION_FOR_WORK = '${SERVER_ROUTE}WriteApplicationForWork';
  //отправка заявки на работы на сервер
  static const String WRITE_FILE_APPLICATION_FOR_WORK = '${SERVER_ROUTE}WriteFileApplicationForWork';
  //запись файла в заявку
  static const String WRITE_RECLAMATION_SYSTEM = '${SERVER_ROUTE}WriteReclamationSystem';
  //запись актуализации технического состояния
}