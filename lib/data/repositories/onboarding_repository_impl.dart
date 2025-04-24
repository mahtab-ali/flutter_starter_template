import '../../core/errors/result.dart';
import '../../core/network/network_info.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../datasources/local/preferences_local_datasource.dart';
import 'base_repository.dart';

/// Implementation of [OnboardingRepository]
class OnboardingRepositoryImpl extends BaseRepository
    implements OnboardingRepository {
  final PreferencesLocalDataSource localDataSource;

  /// Create a new instance with the required dependencies
  OnboardingRepositoryImpl({
    required this.localDataSource,
    required NetworkInfo networkInfo,
  }) : super(networkInfo);

  @override
  Future<Result<bool>> isOnboardingCompleted() async {
    return safeLocalCall(() => localDataSource.isOnboardingCompleted());
  }

  @override
  Future<Result<void>> setOnboardingCompleted(bool completed) async {
    return safeLocalCall(
      () => localDataSource.setOnboardingCompleted(completed),
    );
  }
}
