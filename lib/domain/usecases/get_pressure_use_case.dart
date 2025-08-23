import 'package:avio/domain/repositories/avio_repository.dart';

class GetPressureUseCase {
  final AvioRepository repository;

  GetPressureUseCase(this.repository);

  Future<double> execute() async {
    final pressureModel = await repository.getPressure();
    return pressureModel.pressure;
  }
}