import 'dart:async';

import 'package:flutter/material.dart';
import 'package:avio/domain/usecases/get_pressure_use_case.dart';
import 'package:avio/data/repositories/avio_repository_impl.dart';

class AvioProvider extends ChangeNotifier {
  String _pressure = '';
  late GetPressureUseCase _getPressureUseCase;

  AvioProvider() {
    _getPressureUseCase = GetPressureUseCase(AvioRepositoryImpl());
    _startAutoUpdate();
  }

  String get pressure => _pressure;

  void _startAutoUpdate() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _fetchPressure();
    });
  }

  Future<void> _fetchPressure() async {
    try {
      final pressureValue = await _getPressureUseCase.execute();
      if (_pressure != pressureValue.toString()) {
        _pressure = pressureValue.toString();
        notifyListeners();
      }
    } catch (e) {
      _pressure = 'Ошибка: $e';
      notifyListeners();
    }
  }

  void refreshPressure() {
    _fetchPressure();
  }

  @override
  void dispose() {
    // Таймер не останавливаем здесь, т.к. он управляется вручную
    super.dispose();
  }
}