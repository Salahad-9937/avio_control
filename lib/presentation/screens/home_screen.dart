import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:avio/providers/avio_provider.dart';
import 'connection_guide_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AvioProvider(),
      child: Consumer<AvioProvider>(
        builder: (context, provider, child) {
          if (!provider.isConnected || provider.isConnectionLost) {
            return ConnectionGuideScreen(isConnectionLost: provider.isConnectionLost);
          }
          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              title: const Text(
                'Avio Control',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              backgroundColor: Colors.blueGrey[800],
              foregroundColor: Colors.white,
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
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: provider.pressure.isNotEmpty
                      ? _buildPressureCard(provider.pressure)
                      : _buildInfoCard(provider.errorMessage),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPressureCard(String pressure) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.height_rounded,
              size: 48,
              color: Colors.blueGrey,
            ),
            const SizedBox(height: 16),
            Text(
              'Давление: $pressure hPa',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String message) {
    return Card(
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
              message.isEmpty ? 'Подключитесь к Wi-Fi сети ESP8266' : message,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.blueGrey,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}