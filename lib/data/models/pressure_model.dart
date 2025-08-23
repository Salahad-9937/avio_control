class PressureModel {
  final double pressure;

  PressureModel({required this.pressure});

  factory PressureModel.fromJson(Map<String, dynamic> json) {
    return PressureModel(pressure: json['pressure'] as double);
  }
}