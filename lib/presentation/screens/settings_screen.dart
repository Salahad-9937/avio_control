import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  double _targetAltitude = 1000.0;
  double _speed = 50.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Целевая высота (m)'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _targetAltitude = double.tryParse(value) ?? 1000.0;
                });
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Скорость (km/h)'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _speed = double.tryParse(value) ?? 50.0;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Здесь можно отправить настройки на ESP (будет реализовано позже)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Настройки сохранены')),
                );
              },
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}