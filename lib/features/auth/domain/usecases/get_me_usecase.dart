import 'package:testapp/features/auth/domain/entities/user.dart';
import 'package:testapp/features/auth/domain/repositories/auth_repository.dart';

class GetMeUseCase {
  final AuthRepository _repo;

  GetMeUseCase(this._repo);

  Future<User> call() async {
    return await _repo.getMe();
  }
}
