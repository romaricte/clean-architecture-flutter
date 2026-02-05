

import 'package:testapp/features/auth/domain/repositories/auth_repository.dart';

class GetReservation {
  final AuthRepository _repository;

  GetReservation(this._repository);
  Future<Map<String, dynamic>> call() {
    return _repository.getReservation();
  }
}