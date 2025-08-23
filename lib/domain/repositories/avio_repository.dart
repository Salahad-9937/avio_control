import 'package:avio/data/models/pressure_model.dart';

abstract class AvioRepository {
  Future<PressureModel> getPressure();
}