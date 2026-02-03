import 'package:testapp/features/auth/domain/entities/user.dart';
import 'package:testapp/features/auth/domain/repositories/auth_repository.dart';

class GetMeUseCase {
  final AuthRepository _repository;

  GetMeUseCase(this._repository);

  Future<User> call() async {
    return await _repository.getMe();
  }
}
