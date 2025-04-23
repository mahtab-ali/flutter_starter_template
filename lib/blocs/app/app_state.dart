import 'package:equatable/equatable.dart';

class AppState extends Equatable {
  final String appVersion;
  final String buildNumber;
  final String deviceModel;
  final String deviceOS;
  final String deviceOSVersion;
  final bool isLoading;
  final String? error;

  const AppState({
    this.appVersion = 'Unknown',
    this.buildNumber = 'Unknown',
    this.deviceModel = 'Unknown',
    this.deviceOS = 'Unknown',
    this.deviceOSVersion = 'Unknown',
    this.isLoading = false,
    this.error,
  });

  AppState copyWith({
    String? appVersion,
    String? buildNumber,
    String? deviceModel,
    String? deviceOS,
    String? deviceOSVersion,
    bool? isLoading,
    String? error,
  }) {
    return AppState(
      appVersion: appVersion ?? this.appVersion,
      buildNumber: buildNumber ?? this.buildNumber,
      deviceModel: deviceModel ?? this.deviceModel,
      deviceOS: deviceOS ?? this.deviceOS,
      deviceOSVersion: deviceOSVersion ?? this.deviceOSVersion,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  String get fullAppVersion => '$appVersion+$buildNumber';

  String get deviceInfo => '$deviceModel ($deviceOS $deviceOSVersion)';

  @override
  List<Object?> get props => [
    appVersion,
    buildNumber,
    deviceModel,
    deviceOS,
    deviceOSVersion,
    isLoading,
    error,
  ];
}
