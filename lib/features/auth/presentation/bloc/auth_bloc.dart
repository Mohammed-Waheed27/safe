import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/register_user.dart';
import '../../../../core/config/app_router.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// BLoC for managing authentication state
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;
  final RegisterUser registerUser;

  /// Constructor
  AuthBloc({required this.loginUser, required this.registerUser})
    : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  /// Handle login requested event
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    print('🎯 BLoC: Login requested for ${event.email}');
    emit(AuthLoading());

    final params = LoginParams(email: event.email, password: event.password);

    print('🎯 BLoC: Calling login use case');
    final result = await loginUser(params);

    await result.fold(
      (failure) async {
        print('❌ BLoC: Login failed - ${failure.message}');
        emit(
          AuthError(message: 'Invalid email or password: ${failure.message}'),
        );
      },
      (user) async {
        print('✅ BLoC: Login successful for user: ${user.fullName}');

        // Save user session to SharedPreferences
        try {
          // Note: In a real app, user.id and user.thirdPartyToken would come from the user entity
          // For now, we'll use email as ID and a mock token
          final userId = user.email; // Using email as user ID for now
          final userToken =
              user.thirdPartyToken ??
              'mock_token_${DateTime.now().millisecondsSinceEpoch}';

          // This would normally be handled by AppRouter.loginUser, but we'll set it here directly
          await _saveUserSession(userId, userToken);

          emit(Authenticated(user: user));
        } catch (e) {
          print('❌ BLoC: Error saving user session: $e');
          emit(AuthError(message: 'Login successful but session save failed'));
        }
      },
    );
  }

  /// Handle register requested event
  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    print('🎯 BLoC: Registration requested for ${event.email}');
    emit(AuthLoading());

    final params = RegisterParams(
      fullName: event.fullName,
      email: event.email,
      phoneNumber: event.phoneNumber,
      password: event.password,
      thirdPartyToken: event.thirdPartyToken,
    );

    print('🎯 BLoC: Calling register use case');
    final result = await registerUser(params);

    await result.fold(
      (failure) async {
        print('❌ BLoC: Registration failed - ${failure.message}');
        emit(AuthError(message: 'Registration failed: ${failure.message}'));
      },
      (user) async {
        print('✅ BLoC: Registration successful for user: ${user.fullName}');

        // Save user session to SharedPreferences
        try {
          final userId = user.email; // Using email as user ID for now
          final userToken =
              user.thirdPartyToken ??
              event.thirdPartyToken ??
              'default_token_${DateTime.now().millisecondsSinceEpoch}';

          await _saveUserSession(userId, userToken);

          emit(Authenticated(user: user));
        } catch (e) {
          print('❌ BLoC: Error saving user session: $e');
          emit(
            AuthError(
              message: 'Registration successful but session save failed',
            ),
          );
        }
      },
    );
  }

  /// Handle logout requested event
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    print('🎯 BLoC: Logout requested');
    emit(AuthLoading());

    try {
      // Clear user session from SharedPreferences
      await _clearUserSession();
      print('✅ BLoC: User session cleared');
      emit(AuthInitial());
    } catch (e) {
      print('❌ BLoC: Error during logout: $e');
      emit(AuthError(message: 'Logout failed'));
    }
  }

  /// Save user session to SharedPreferences
  Future<void> _saveUserSession(String userId, String userToken) async {
    try {
      // For now, we'll just print the session info
      // In a real implementation, this should use SharedPreferences from GetIt
      print(
        '📱 Saving user session: $userId with token length: ${userToken.length}',
      );

      // TODO: Implement actual SharedPreferences saving
      // final prefs = GetIt.I<SharedPreferences>();
      // await prefs.setBool('is_logged_in', true);
      // await prefs.setString('user_id', userId);
      // await prefs.setString('user_token', userToken);
    } catch (e) {
      print('Error saving session: $e');
      rethrow;
    }
  }

  /// Clear user session from SharedPreferences
  Future<void> _clearUserSession() async {
    try {
      print('📱 Clearing user session');

      // TODO: Implement actual SharedPreferences clearing
      // final prefs = GetIt.I<SharedPreferences>();
      // await prefs.remove('is_logged_in');
      // await prefs.remove('user_id');
      // await prefs.remove('user_token');
    } catch (e) {
      print('Error clearing session: $e');
      rethrow;
    }
  }
}
