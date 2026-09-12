import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskflow/core/errors/failures.dart';
import 'package:taskflow/features/auth/domain/entities/user.dart';
import 'package:taskflow/features/auth/domain/usecases/get_auth_state.dart';
import 'package:taskflow/features/auth/domain/usecases/login_user.dart';
import 'package:taskflow/features/auth/domain/usecases/logout_user.dart';
import 'package:taskflow/features/auth/domain/usecases/register_user.dart';
import 'package:taskflow/features/auth/domain/usecases/reset_password.dart';
import 'package:taskflow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:taskflow/features/auth/presentation/bloc/auth_event.dart';
import 'package:taskflow/features/auth/presentation/bloc/auth_state.dart';

class MockLoginUser extends Mock implements LoginUser {}

class MockRegisterUser extends Mock implements RegisterUser {}

class MockLogoutUser extends Mock implements LogoutUser {}

class MockGetAuthState extends Mock implements GetAuthState {}

class MockResetPassword extends Mock implements ResetPassword {}

void main() {
  late MockLoginUser mockLoginUser;
  late MockRegisterUser mockRegisterUser;
  late MockLogoutUser mockLogoutUser;
  late MockGetAuthState mockGetAuthState;
  late MockResetPassword mockResetPassword;
  late AuthBloc authBloc;

  // Test user
  // createdAt is intentionally not included because
  // UserEntity does not define a createdAt parameter.
  const testUser = UserEntity(
    id: 'usr_123',
    email: 'worker@taskflow.app',
  );

  setUp(() {
    mockLoginUser = MockLoginUser();
    mockRegisterUser = MockRegisterUser();
    mockLogoutUser = MockLogoutUser();
    mockGetAuthState = MockGetAuthState();
    mockResetPassword = MockResetPassword();

    when(() => mockGetAuthState.call()).thenAnswer(
      (_) => Stream.value(null),
    );

    when(() => mockGetAuthState.getCurrentUser()).thenReturn(null);

    authBloc = AuthBloc(
      loginUser: mockLoginUser,
      registerUser: mockRegisterUser,
      logoutUser: mockLogoutUser,
      getAuthState: mockGetAuthState,
      resetPassword: mockResetPassword,
    );
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc Tests', () {
    test('initial state is AuthInitial', () {
      expect(authBloc.state, equals(AuthInitial()));
    });

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when login succeeds',
      build: () {
        when(
          () => mockLoginUser(
            'worker@taskflow.app',
            'password123',
          ),
        ).thenAnswer((_) async => testUser);

        return authBloc;
      },
      act: (bloc) => bloc.add(
        const LoginRequested(
          email: 'worker@taskflow.app',
          password: 'password123',
        ),
      ),
      expect: () => [
        AuthLoading(),
        const AuthAuthenticated(testUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthFailureState] when login fails',
      build: () {
        when(
          () => mockLoginUser(
            'worker@taskflow.app',
            'wrongpass',
          ),
        ).thenThrow(
          const AuthFailure('Invalid credentials'),
        );

        return authBloc;
      },
      act: (bloc) => bloc.add(
        const LoginRequested(
          email: 'worker@taskflow.app',
          password: 'wrongpass',
        ),
      ),
      expect: () => [
        AuthLoading(),
        const AuthFailureState('Invalid credentials'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when register succeeds',
      build: () {
        when(
          () => mockRegisterUser(
            'new.worker@taskflow.app',
            'securePass123',
          ),
        ).thenAnswer((_) async => testUser);

        return authBloc;
      },
      act: (bloc) => bloc.add(
        const RegisterRequested(
          email: 'new.worker@taskflow.app',
          password: 'securePass123',
        ),
      ),
      expect: () => [
        AuthLoading(),
        const AuthAuthenticated(testUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthUnauthenticated] when logout succeeds',
      build: () {
        when(
          () => mockLogoutUser(),
        ).thenAnswer((_) async {});

        return authBloc;
      },
      act: (bloc) => bloc.add(
        LogoutRequested(),
      ),
      expect: () => [
        AuthLoading(),
        AuthUnauthenticated(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, PasswordResetSent] when reset password succeeds',
      build: () {
        when(
          () => mockResetPassword('worker@taskflow.app'),
        ).thenAnswer((_) async {});

        return authBloc;
      },
      act: (bloc) => bloc.add(
        const PasswordResetRequested(
          'worker@taskflow.app',
        ),
      ),
      expect: () => [
        AuthLoading(),
        const PasswordResetSent(
          'worker@taskflow.app',
        ),
      ],
    );
  });
}
