import 'registration.dart';

abstract interface class RegistrationRepository {
  Future<List<String>> getRegisteredEventIds();

  Future<Registration?> getRegistration(String eventId);

  Future<void> register(Registration registration);

  Future<void> cancelRegistration(String eventId);
}
