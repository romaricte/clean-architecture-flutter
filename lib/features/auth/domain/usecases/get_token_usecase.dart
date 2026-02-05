import 'package:testapp/features/auth/domain/repositories/auth_repository.dart';

class GetTokenUseCase {
  final AuthRepository _repository;

  GetTokenUseCase(this._repository);

  Future<String?> call() async {
    return await _repository.getToken();
  }
}
