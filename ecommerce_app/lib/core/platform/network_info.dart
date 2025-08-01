import 'package:internet_connection_checker/internet_connection_checker.dart';

/// Abstract class for NetworkInfo
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

/// Concrete implementation using InternetConnectionChecker
class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
