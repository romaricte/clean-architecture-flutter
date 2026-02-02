import 'package:testapp/features/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository _repo;

  LogoutUseCase(this._repo);

  Future<void> call() async {
    await _repo.logout();
  }
}
