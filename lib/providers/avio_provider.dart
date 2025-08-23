import 'dart:async';
import 'package:flutter/material.dart';
import 'package:avio/domain/usecases/get_pressure_use_case.dart';
import 'package:avio/data/repositories/avio_repository_impl.dart';
import 'package:http/http.dart' as http;

class AvioProvider extends ChangeNotifier {
  String _pressure = '';
  String _errorMessage = '';
  bool _isConnected = false;
  late GetPressureUseCase _getPressureUseCase;
  Timer? _timer;

  AvioProvider() {
    _getPressureUseCase = GetPressureUseCase(AvioRepositoryImpl());
    _checkConnectivity();
    _startAutoUpdate();
  }

  String get pressure => _pressure;
  String get errorMessage => _errorMessage;
  bool get isConnected => _isConnected;

  void _startAutoUpdate() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isConnected) {
        _fetchPressure();
      } else {
        _checkConnectivity();
      }
    });
  }

  Future<void> _checkConnectivity() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.4.1/data')).timeout(const Duration(seconds: 2));
      _isConnected = response.statusCode == 200;
      if (!_isConnected) {
        _errorMessage = 'Подключитесь к Wi-Fi сети ESP8266 и проверьте доступность устройства';
        _pressure = '';
        notifyListeners();
      } else if (_pressure.isEmpty) {
        _fetchPressure(); // Запрашиваем давление сразу после подключения
      }
    } catch (e) {
      _isConnected = false;
      _errorMessage = 'Подключитесь к Wi-Fi сети ESP8266 и проверьте доступность устройства';
      _pressure = '';
      notifyListeners();
    }
  }

  Future<void> _fetchPressure() async {
    try {
      final pressureValue = await _getPressureUseCase.execute();
      _pressure = pressureValue.toStringAsFixed(2);
      _errorMessage = '';
      _isConnected = true;
      notifyListeners();
    } catch (e) {
      _isConnected = false;
      _errorMessage = 'Подключитесь к Wi-Fi сети ESP8266 и проверьте доступность устройства';
      _pressure = '';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}