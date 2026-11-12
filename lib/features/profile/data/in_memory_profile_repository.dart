import '../domain/profile_repository.dart';
import '../domain/user_profile.dart';

class InMemoryProfileRepository implements ProfileRepository {
  UserProfile _profile = const UserProfile(
    fullName: 'Alex Morgan',
    email: 'alex.morgan@example.com',
    phone: '',
    organization: '',
  );

  @override
  Future<UserProfile> getProfile() async => _profile;

  @override
  Future<void> saveProfile(UserProfile profile) async {
    _profile = profile;
  }
}
