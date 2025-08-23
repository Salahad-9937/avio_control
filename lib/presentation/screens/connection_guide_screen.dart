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
                  crossAxisAlignment: CrossAxisAlignment.start, // Выравнивание по левому краю
                  children: [
                    const Icon(
                      Icons.wifi_off_rounded,
                      size: 48,
                      color: Colors.blueGrey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isConnectionLost
                          ? 'Соединение с ESP8266 потеряно'
                          : 'Подключение к устройству',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    isConnectionLost
                        ? const Text(
                            'Проверьте подключение к Wi-Fi сети ESP8266.',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.blueGrey,
                              height: 1.5,
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Для работы приложения выполните следующие шаги:',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.blueGrey,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildInstructionItem(
                                '1',
                                'Подключитесь к Wi-Fi сети ESP8266.',
                              ),
                              const SizedBox(height: 8),
                              _buildInstructionItem(
                                '2',
                                'Отключите мобильные данные, чтобы избежать автоматического переключения.',
                              ),
                              const SizedBox(height: 8),
                              _buildInstructionItem(
                                '3',
                                'Дождитесь загрузки данных.',
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionItem(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$number. ',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        ),
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
    );
  }
}