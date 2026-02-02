import 'package:testapp/features/auth/domain/entities/user.dart';
import 'package:testapp/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  LoginUseCase(this._repo);
  final AuthRepository _repo;

  Future<User> call({required String email, required String password}) async {
    return await _repo.login(email: email, password: password);
  }
}