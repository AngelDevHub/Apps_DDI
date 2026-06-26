import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/ble_service.dart';
import '../services/weather_service.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final BLEService _bleService = BLEService();

  Weather? _weather;
  bool _isLoading = false;
  String? _errorMessage;
  int _tempUnit = 0; 
  
  BluetoothDevice? _connectedDevice;
  bool _isBleConnected = false;
  int _reconnectAttempts = 0;
  final int _maxReconnectAttempts = 3;

  Weather? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get temperatureUnit => _tempUnit == 0 ? '°C' : '°F';
  bool get isBleConnected => _isBleConnected;
  BluetoothDevice? get connectedDevice => _connectedDevice;

  Future<void> fetchWeather(String city) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _weather = await _weatherService.getWeather(city);
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadWeatherManual() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      
      const String nombreCiudad = 'Medellín'; 
      const int temperaturaManual = 30;

      _weather = Weather(
        city: nombreCiudad,
        temperature: temperaturaManual,
        condition: 'Sunny',
        description: 'soleado',
        humidity: 65,
        windSpeed: 2.5,
      );
    } catch (e) {
      _errorMessage = 'Error loading manual weather: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
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
          _establishConnection(device);
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
    
    try {
      final data = await _bleService.readCharacteristic(
        _connectedDevice!, 
        "0000180d-0000-1000-8000-00805f9b34fb",
        "00002a37-0000-1000-8000-00805f9b34fb"
      );

      if (data.isNotEmpty) {
        updateTemperature(data[0]);
      }
    } catch (e) {
      debugPrint('Error: $e');
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
          description: _weather!.description,
          humidity: _weather!.humidity,
          windSpeed: _weather!.windSpeed,
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
      description: 'Condición manual',
      humidity: 60,
      windSpeed: 0.0,
    );
    notifyListeners();
  }
}
