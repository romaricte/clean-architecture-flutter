


import 'package:testapp/features/home/domain/repositories/reservation.repository.dart';

class GetReservation {
  final ReservationRepository _repository;

  GetReservation(this._repository);
  Future<Map<String, dynamic>> call() {
    return _repository.getReservation();
  }
}