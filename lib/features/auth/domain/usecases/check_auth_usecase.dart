import 'package:testapp/features/auth/domain/repositories/auth_repository.dart';

class CheckAuthUseCase {
  final AuthRepository _repository;

  CheckAuthUseCase(this._repository);

  Future<bool> call() async {
    return await _repository.isAuthenticated();
  }
}
