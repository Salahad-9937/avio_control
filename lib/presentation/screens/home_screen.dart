import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/avio_provider.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AvioProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Avio Control'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
          ],
        ),
        body: Consumer<AvioProvider>(
          builder: (context, provider, child) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    provider.pressure.isEmpty
                        ? 'Подключитесь к ESP8266 (отключите мобильные данные)'
                        : 'Высота: ${provider.pressure} hPa',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => provider.refreshPressure(),
                    child: const Text('Обновить сейчас'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}