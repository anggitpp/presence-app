part of 'login_bloc.dart';

enum LoginStatus {
  initial,
  submitting,
  unverified,
  success,
  error,
}

class LoginState extends Equatable {
  final LoginStatus loginStatus;
  final CustomError error;
  late UserCredential? userCredential;
  LoginState({
    required this.loginStatus,
    required this.error,
    this.userCredential,
  });

  factory LoginState.inital() {
    return LoginState(
      loginStatus: LoginStatus.initial,
      error: const CustomError(),
    );
  }

  LoginState copyWith({
    LoginStatus? loginStatus,
    CustomError? error,
    UserCredential? userCredential,
  }) {
    return LoginState(
      loginStatus: loginStatus ?? this.loginStatus,
      error: error ?? this.error,
      userCredential: userCredential ?? this.userCredential,
    );
  }

  @override
  String toString() =>
      'LoginState(loginStatus: $loginStatus, customError: $error, userCredential: $userCredential,)';

  @override
  List<Object> get props => [loginStatus, error];
}
