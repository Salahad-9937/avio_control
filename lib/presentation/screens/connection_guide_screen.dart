import 'package:flutter/material.dart';

class ConnectionGuideScreen extends StatelessWidget {
  final bool isConnectionLost;

  const ConnectionGuideScreen({super.key, this.isConnectionLost = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Avio Control',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blueGrey[800],
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Card(
              key: ValueKey(isConnectionLost),
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.wifi_off_rounded,
                      size: 48,
                      color: Colors.blueGrey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isConnectionLost ? 'Соединение с ESP8266 потеряно' : 'Подключение к устройству',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isConnectionLost
                          ? 'Проверьте подключение'
                          : 'Для работы приложения выполните следующие шаги:',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.blueGrey,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (!isConnectionLost) ...[
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildStep('1.', 'Подключитесь к Wi-Fi сети ESP8266.'),
                            _buildStep('2.', 'Отключите мобильные данные, чтобы избежать автоматического переключения.'),
                            _buildStep('3.', 'Дождитесь загрузки данных.'),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.blueGrey,
              height: 1.5,
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.blueGrey,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}