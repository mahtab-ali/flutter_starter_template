import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/app_config.dart';

class SupabaseService {
  static SupabaseService? _instance;
  late final SupabaseClient client;

  // Singleton pattern
  factory SupabaseService() {
    _instance ??= SupabaseService._internal();
    return _instance!;
  }

  SupabaseService._internal() {
    client = Supabase.instance.client;
  }

  // Initialize Supabase from .env file
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
    );
  }

  // Authentication methods
  Future<AuthResponse> signUp(String email, String password) async {
    return await client.auth.signUp(email: email, password: password);
  }

  Future<AuthResponse> signIn(String email, String password) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> resetPassword(String email) async {
    await client.auth.resetPasswordForEmail(email);
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  // Get current user
  User? get currentUser => client.auth.currentUser;

  // Check if user is logged in
  bool get isAuthenticated => currentUser != null;

  // Session state changes stream
  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;
}
