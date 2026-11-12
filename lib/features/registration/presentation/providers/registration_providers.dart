import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/in_memory_registration_repository.dart';
import '../../domain/registration_repository.dart';

final registrationRepositoryProvider = Provider<RegistrationRepository>(
  (ref) => InMemoryRegistrationRepository(),
);

final registeredEventIdsProvider = FutureProvider<List<String>>(
  (ref) => ref.watch(registrationRepositoryProvider).getRegisteredEventIds(),
);
