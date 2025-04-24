import 'package:equatable/equatable.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

class AppInitialized extends AppEvent {
  const AppInitialized();
}

class AppVersionRequested extends AppEvent {
  const AppVersionRequested();
}

class AppDeviceInfoRequested extends AppEvent {
  const AppDeviceInfoRequested();
}
