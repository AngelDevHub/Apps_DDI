import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BLEService {
  // Singleton para acceder desde cualquier parte
  static final BLEService _instance = BLEService._internal();
  factory BLEService() => _instance;
  BLEService._internal();

  /// Escanea dispositivos BLE cercanos.
  Stream<List<ScanResult>> scan() {
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    return FlutterBluePlus.scanResults;
  }

  /// Detiene el escaneo actual.
  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
  }

  /// Conecta a un dispositivo específico por su ID.
  Future<BluetoothDevice> connect(String deviceId) async {
    final device = BluetoothDevice.fromId(deviceId);
    await device.connect();
    return device;
  }

  /// Descubre los servicios de un dispositivo conectado.
  Future<List<BluetoothService>> discoverServices(BluetoothDevice device) async {
    return await device.discoverServices();
  }

  /// Busca una característica específica y lee su valor.
  /// Retorna una lista de enteros (bytes).
  Future<List<int>> readCharacteristic(
      BluetoothDevice device, String serviceUuid, String charUuid) async {
    List<BluetoothService> services = await device.discoverServices();
    
    for (var service in services) {
      if (service.uuid.toString() == serviceUuid) {
        for (var char in service.characteristics) {
          if (char.uuid.toString() == charUuid) {
            // Lee el valor de la característica
            return await char.read();
          }
        }
      }
    }
    throw Exception('Característica no encontrada');
  }

  /// Stream para monitorear el estado de conexión.
  Stream<BluetoothConnectionState> connectionState(BluetoothDevice device) {
    return device.connectionState;
  }

  /// Desconecta el dispositivo.
  Future<void> disconnect(BluetoothDevice device) async {
    await device.disconnect();
  }
}
