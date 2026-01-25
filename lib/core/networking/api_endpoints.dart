class ApiEndpoints {
  // Auth
  static const String signIn = '/auth/sign-in';
  
  // Appointments
  static const String appointmentsTest = '/test1';
  static const String appointments = '/core/owner/appointments';
  static const String appointmentsFilters = '/core/owner/appointments/filters';
  static const String appointmentsCreate = '/appointments';
  static const String appointmentUpdate = '/appointments'; // + id
  static const String appointmentDelete = '/appointments'; // + id
  
  // Services (CORRECTO: /core/owner/services)
  static const String services = '/core/owner/services';
  
  //common/catalogues con filtro type
  static const String cataloguesCommon = '/common/catalogues';
  // Customers
  static const String customers = '/core/owner/customers';

}
