import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:avio/domain/usecases/get_pressure_use_case.dart';
import 'package:avio/data/repositories/avio_repository_impl.dart';
import 'package:http/http.dart' as http;

class AvioProvider extends ChangeNotifier {
  String _pressure = '';
  String _errorMessage = 'Подключитесь к Wi-Fi сети ESP8266 и проверьте доступность устройства';
  bool _isConnected = false;
  bool _isConnectionLost = false;
  bool _isConnectionLostFlowActive = false;
  late GetPressureUseCase _getPressureUseCase;
  Timer? _timer;
  Timer? _connectionLostTimer;

  AvioProvider() {
    _getPressureUseCase = GetPressureUseCase(AvioRepositoryImpl());
    _checkConnectivity();
    _startAutoUpdate();
  }

  String get pressure => _pressure;
  String get errorMessage => _errorMessage;
  bool get isConnected => _isConnected;
  bool get isConnectionLost => _isConnectionLost;

  void _startAutoUpdate() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isConnected && !_isConnectionLostFlowActive) {
        _fetchPressure();
      } else if (!_isConnectionLostFlowActive) {
        _checkConnectivity();
      }
    });
  }

  Future<void> _checkConnectivity() async {
    await _handleConnectionAttempt((wasConnected) async {
      final response = await http.get(Uri.parse('http://192.168.4.1/data')).timeout(const Duration(seconds: 2));
      return response.statusCode == 200;
    }, fetchOnSuccess: true);
  }

  Future<void> _fetchPressure() async {
    await _handleConnectionAttempt((wasConnected) async {
      final pressureValue = await _getPressureUseCase.execute();
      _pressure = pressureValue.toStringAsFixed(2);
      return true;
    });
  }

  Future<void> _handleConnectionAttempt(Future<bool> Function(bool) attempt, {bool fetchOnSuccess = false}) async {
    if (_isConnectionLostFlowActive) return;
    final wasConnected = _isConnected;
    try {
      _isConnected = await attempt(wasConnected);
      if (_isConnected) {
        _isConnectionLost = false;
        _isConnectionLostFlowActive = false;
        _errorMessage = '';
        _connectionLostTimer?.cancel();
        if (fetchOnSuccess && _pressure.isEmpty) {
          await _fetchPressure();
        }
      } else if (wasConnected) {
        _startConnectionLostFlow();
      } else {
        _isConnectionLost = false;
        _isConnectionLostFlowActive = false;
        _errorMessage = 'Подключитесь к Wi-Fi сети ESP8266 и проверьте доступность устройства';
        _pressure = '';
      }
    } catch (e) {
      if (wasConnected) {
        _startConnectionLostFlow();
      } else {
        _isConnectionLost = false;
        _isConnectionLostFlowActive = false;
        _errorMessage = 'Подключитесь к Wi-Fi сети ESP8266 и проверьте доступность устройства';
        _pressure = '';
      }
    }
    notifyListeners();
  }

  void _startConnectionLostFlow() {
    if (_isConnectionLostFlowActive) return;
    _isConnectionLost = true;
    _isConnectionLostFlowActive = true;
    _errorMessage = 'Соединение с ESP8266 потеряно';
    _isConnected = false;
    _pressure = '';
    _connectionLostTimer?.cancel();
    if (kDebugMode) {
      print('Connection lost flow started at ${DateTime.now()}');
    }
    _connectionLostTimer = Timer(const Duration(seconds: 10), () {
      if (!_isConnected) {
        _isConnectionLost = false;
        _isConnectionLostFlowActive = false;
        _errorMessage = 'Подключитесь к Wi-Fi сети ESP8266 и проверьте доступность устройства';
        if (kDebugMode) {
          print('Connection lost flow ended at ${DateTime.now()}');
        }
        notifyListeners();
      }
    });
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _connectionLostTimer?.cancel();
    super.dispose();
  }
}