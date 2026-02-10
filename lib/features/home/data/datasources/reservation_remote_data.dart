

import 'package:dio/dio.dart';
import 'package:testapp/features/home/domain/usecases/getReservation.dart';

class ReservationRemoteDataSource {
  ReservationRemoteDataSource({required Dio dio}) : _dio = dio;

  final Dio _dio;

   Future<Map<String, dynamic>> GetReservation() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(api_endpoints.reservation);
      print(
        'AuthRemoteDataSource: getMe response status: ${response.statusCode}',
      );
      print('AuthRemoteDataSource: getMe response data: ${response}');

      final data = response.data;
      if (data == null) {
        print('AuthRemoteDataSource: getMe data is null');
        // throw const ParseException('Empty response');
      }

    
      return data;
    } on DioException catch (e) {
      print(
        'AuthRemoteDataSource: DioException in getMe: ${e.message}, status: ${e.response?.statusCode}',
      );
      print('AuthRemoteDataSource: Response data: ${e.response?.data}');
      // throw _handleDioError(e);
    } catch (e) {
      print('AuthRemoteDataSource: Generic Exception in getMe: $e');
      rethrow;
    }
  }
}