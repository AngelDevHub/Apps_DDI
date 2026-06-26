import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../services/ble_service.dart';

class BLEScanScreen extends StatefulWidget {
  const BLEScanScreen({Key? key}) : super(key: key);

  @override
  State<BLEScanScreen> createState() => _BLEScanScreenState();
}

class _BLEScanScreenState extends State<BLEScanScreen> {
  final BLEService _bleService = BLEService();
  bool _isScanning = false;

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Escaneo Wearable BLE'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: Icon(_isScanning ? Icons.stop : Icons.search),
              label: Text(_isScanning ? 'Detener Búsqueda' : 'Buscar dispositivos BLE'),
              onPressed: () {
                setState(() {
                  _isScanning = !_isScanning;
                });
                if (_isScanning) {
                  _bleService.scan();
                } else {
                  _bleService.stopScan();
                }
              },
            ),
          ),
          if (weatherProvider.isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: LinearProgressIndicator(),
            ),
          Expanded(
            child: StreamBuilder<List<ScanResult>>(
              stream: FlutterBluePlus.scanResults,
              initialData: const [],
              builder: (c, snapshot) => ListView(
                children: snapshot.data!
                    .map(
                      (r) => ListTile(
                        title: Text(r.device.platformName.isEmpty
                            ? 'Dispositivo Desconocido'
                            : r.device.platformName),
                        subtitle: Text(r.device.remoteId.str),
                        trailing: Text('${r.rssi} dBm'),
                        onTap: () async {
                          // Detener escaneo al seleccionar
                          await _bleService.stopScan();
                          if (mounted) {
                            setState(() { _isScanning = false; });
                          }
                          
                          // Intentar conectar y leer
                          await weatherProvider.connectAndReadWearable(r.device);
                          
                          if (mounted && weatherProvider.errorMessage == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Conectado y datos leídos')),
                            );
                            Navigator.pop(context);
                          }
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
