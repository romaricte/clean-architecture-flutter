

import 'package:testapp/core/errors/failures.dart';
import 'package:testapp/features/home/data/datasources/reservation_remote_data.dart';

class ReservationRepositoryImpl {

  ReservationRepositoryImpl({
    required ReservationRemoteDataSource remoteDataSource
    
    
    }) : _remoteDataSource = remoteDataSource;

  final ReservationRemoteDataSource _remoteDataSource;
  

   @override
  Future<Map<String, dynamic>> getReservation() async {
   
    try {
      final reservation = await _remoteDataSource.getReservation();
      return reservation;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
  
