import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/in_memory_profile_repository.dart';
import '../../domain/profile_repository.dart';
import '../../domain/user_profile.dart';

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => InMemoryProfileRepository(),
);

final userProfileProvider = FutureProvider<UserProfile>(
  (ref) => ref.watch(profileRepositoryProvider).getProfile(),
);
