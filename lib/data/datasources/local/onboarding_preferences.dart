import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPreferences {
  static const String _onboardingCompletedKey = 'onboarding_completed';

  // Save onboarding status
  static Future<void> setOnboardingCompleted(bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompletedKey, completed);
  }

  // Check if onboarding is completed
  static Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    // Returns false if not found, meaning onboarding should be shown
    return prefs.getBool(_onboardingCompletedKey) ?? false;
  }
}
