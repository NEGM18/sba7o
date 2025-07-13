import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  
  bool _isConnected = true;
  bool get isConnected => _isConnected;

  void initialize() {
    _checkConnectivity();
    _setupConnectivityListener();
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    _isConnected = connectivityResult.isNotEmpty && !connectivityResult.contains(ConnectivityResult.none);
  }

  void _setupConnectivityListener() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        _isConnected = results.isNotEmpty && !results.contains(ConnectivityResult.none);
      },
    );
  }

  void dispose() {
    _connectivitySubscription?.cancel();
  }

  Future<bool> checkInternetConnection() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    _isConnected = connectivityResult.isNotEmpty && !connectivityResult.contains(ConnectivityResult.none);
    return _isConnected;
  }
} 