import 'dart:io';

/// Interface for network connectivity information
abstract class NetworkInfo {
  /// Check if the device is connected to the internet
  Future<bool> get isConnected;
}

/// Implementation of NetworkInfo that checks connectivity by making a request
class NetworkInfoImpl implements NetworkInfo {
  /// Timeout for connection check in seconds
  final int timeoutSeconds;

  /// List of hosts to check connectivity against
  final List<String> hosts;

  /// Creates a NetworkInfoImpl with optional timeout and hosts
  NetworkInfoImpl({this.timeoutSeconds = 5, List<String>? hosts})
    : hosts = hosts ?? ['google.com', 'cloudflare.com', '1.1.1.1'];

  @override
  Future<bool> get isConnected async {
    for (final host in hosts) {
      try {
        final result = await InternetAddress.lookup(
          host,
        ).timeout(Duration(seconds: timeoutSeconds));
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          return true;
        }
      } catch (_) {
        continue;
      }
    }
    return false;
  }
}
