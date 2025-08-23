import 'package:avio/data/api/api_service.dart';
import 'package:avio/data/models/pressure_model.dart';
import 'package:avio/domain/repositories/avio_repository.dart';

class AvioRepositoryImpl implements AvioRepository {
  final ApiService _apiService = ApiService();

  @override
  Future<PressureModel> getPressure() async {
    final data = await _apiService.fetchPressure();
    return PressureModel.fromJson(data);
  }
}