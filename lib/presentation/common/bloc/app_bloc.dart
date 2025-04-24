import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'app_event.dart';
import 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  AppBloc() : super(const AppState()) {
    on<AppInitialized>(_onAppInitialized);
    on<AppVersionRequested>(_onAppVersionRequested);
    on<AppDeviceInfoRequested>(_onAppDeviceInfoRequested);

    // Initialize app information when the bloc is created
    add(const AppInitialized());
  }

  Future<void> _onAppInitialized(
    AppInitialized event,
    Emitter<AppState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      // Load app version information
      await _loadAppVersionInfo(emit);

      // Load device information
      await _loadDeviceInfo(emit);

      // Reset loading state and clear any errors
      emit(state.copyWith(isLoading: false, error: null));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Failed to initialize app information: $e',
        ),
      );
    }
  }

  Future<void> _onAppVersionRequested(
    AppVersionRequested event,
    Emitter<AppState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      await _loadAppVersionInfo(emit);
      emit(state.copyWith(isLoading: false, error: null));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Failed to load app version information: $e',
        ),
      );
    }
  }

  Future<void> _onAppDeviceInfoRequested(
    AppDeviceInfoRequested event,
    Emitter<AppState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      await _loadDeviceInfo(emit);
      emit(state.copyWith(isLoading: false, error: null));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Failed to load device information: $e',
        ),
      );
    }
  }

  Future<void> _loadAppVersionInfo(Emitter<AppState> emit) async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    emit(
      state.copyWith(
        appVersion: packageInfo.version,
        buildNumber: packageInfo.buildNumber,
      ),
    );
  }

  Future<void> _loadDeviceInfo(Emitter<AppState> emit) async {
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      emit(
        state.copyWith(
          deviceModel: androidInfo.model,
          deviceOS: 'Android',
          deviceOSVersion: androidInfo.version.release,
        ),
      );
    } else if (Platform.isIOS) {
      final iosInfo = await _deviceInfo.iosInfo;
      emit(
        state.copyWith(
          deviceModel: iosInfo.model,
          deviceOS: 'iOS',
          deviceOSVersion: iosInfo.systemVersion,
        ),
      );
    } else if (Platform.isMacOS) {
      final macOsInfo = await _deviceInfo.macOsInfo;
      emit(
        state.copyWith(
          deviceModel: macOsInfo.model,
          deviceOS: 'macOS',
          deviceOSVersion: macOsInfo.osRelease,
        ),
      );
    } else if (Platform.isWindows) {
      final windowsInfo = await _deviceInfo.windowsInfo;
      emit(
        state.copyWith(
          deviceModel: windowsInfo.productName,
          deviceOS: 'Windows',
          deviceOSVersion: windowsInfo.displayVersion,
        ),
      );
    } else if (Platform.isLinux) {
      final linuxInfo = await _deviceInfo.linuxInfo;
      emit(
        state.copyWith(
          deviceModel: linuxInfo.prettyName,
          deviceOS: 'Linux',
          deviceOSVersion: linuxInfo.version ?? 'Unknown',
        ),
      );
    } else {
      emit(
        state.copyWith(
          deviceModel: 'Unknown',
          deviceOS: Platform.operatingSystem,
          deviceOSVersion: Platform.operatingSystemVersion,
        ),
      );
    }
  }
}
