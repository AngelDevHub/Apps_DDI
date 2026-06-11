import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/ble_service.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class WeatherProvider extends ChangeNotifier {
  Weather? _weather;
  bool _isLoading = false;
  String? _errorMessage;
  int _tempUnit = 0;

  BluetoothDevice? _connectedDevice;
  bool _isBleConnected = false;

  // Getters
  Weather? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get temperatureUnit => _tempUnit == 0 ? '°C' : '°F';
  bool get isBleConnected => _isBleConnected;
  BluetoothDevice? get connectedDevice => _connectedDevice;

  final BLEService _bleService = BLEService();

  int _reconnectAttempts = 0;
  final int _maxReconnectAttempts = 3;

  Future<void> connectAndReadWearable(BluetoothDevice device) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _establishConnection(device);
    } catch (e) {
      _errorMessage = 'Error BLE: $e';
      _isBleConnected = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _establishConnection(BluetoothDevice device) async {
    _connectedDevice = await _bleService.connect(device.remoteId.str);
    _isBleConnected = true;
    _reconnectAttempts = 0; 
    notifyListeners();

    _connectedDevice!.connectionState.listen((state) async {
      if (state == BluetoothConnectionState.disconnected) {
        _isBleConnected = false;
        if (_reconnectAttempts < _maxReconnectAttempts) {
          _reconnectAttempts++;
          debugPrint('Intentando reconexión $_reconnectAttempts...');
          _establishConnection(device); // Intento de reconexión
        } else {
          _errorMessage = "Sin conexión BLE - Reintentos fallidos";
          notifyListeners();
        }
      }
    });

    await _readData();
  }

  Future<void> _readData() async {
    if (_connectedDevice == null) return;
    
    final data = await _bleService.readCharacteristic(
      _connectedDevice!, 
      "0000180d-0000-1000-8000-00805f9b34fb",
      "00002a37-0000-1000-8000-00805f9b34fb"
    );

    if (data.isNotEmpty) {
      updateTemperature(data[0]);
    }
  }

  Future<void> loadWeather() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      const String nombreCiudad = 'Mexico';
      const int temperaturaManual = 30;

      _weather = Weather(
        city: nombreCiudad,
        temperature: temperaturaManual,
        condition: 'sunny',
        humidity: 65,
      );
    } catch (e) {
      _errorMessage = 'Error loading weather: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleTemperatureUnit() {
    _tempUnit = _tempUnit == 0 ? 1 : 0;
    notifyListeners();
  }

  void updateTemperature(int newTemp) {
    if (_weather != null) {
      if (newTemp >= -50 && newTemp <= 60) {
        _weather = Weather(
          city: _weather!.city,
          temperature: newTemp,
          condition: _weather!.condition,
          humidity: _weather!.humidity,
        );
        notifyListeners();
      }
    }
  }

  void updateWeather(String city, int temp, String condition) {
    _weather = Weather(
      city: city,
      temperature: temp,
      condition: condition,
      humidity: 60,
    );
    notifyListeners();
  }
}
