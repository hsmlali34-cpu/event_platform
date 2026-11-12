import '../domain/registration.dart';
import '../domain/registration_repository.dart';

class InMemoryRegistrationRepository implements RegistrationRepository {
  final Map<String, Registration> _registrations = {};

  @override
  Future<List<String>> getRegisteredEventIds() async =>
      List.unmodifiable(_registrations.keys);

  @override
  Future<Registration?> getRegistration(String eventId) async =>
      _registrations[eventId];

  @override
  Future<void> register(Registration registration) async {
    _registrations[registration.eventId] = registration;
  }

  @override
  Future<void> cancelRegistration(String eventId) async {
    _registrations.remove(eventId);
  }
}
