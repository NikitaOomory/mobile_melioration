class ServerRoutes{

  static const String SERVER_ROUTE = 'https://melio.mcx.ru/melio/hs/api/?typerequest=';

  static const String LOGIN_ROUTE = '${SERVER_ROUTE}login';
  static const String GET_APPLICATIONS_FOR_WORK = '${SERVER_ROUTE}getApplicationsForWork';
  static const String GET_RECLAMATION_SYSTEM = '${SERVER_ROUTE}getReclamationSystem';
  static const String GET_OBJECTS_OF_RECLAMATION_SYSTEM = '${SERVER_ROUTE}getObjectsOfReclamationSystem';
  static const String WRITE_APPLICATION_FOR_WORK = '${SERVER_ROUTE}WriteApplicationForWork';
  static const String WRITE_FILE_APPLICATION_FOR_WORK = '${SERVER_ROUTE}WriteFileApplicationForWork';
  static const String WRITE_RECLAMATION_SYSTEM = '${SERVER_ROUTE}WriteReclamationSystem';
}