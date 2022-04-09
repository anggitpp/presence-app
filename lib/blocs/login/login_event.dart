part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class SubmitLoginEvent extends LoginEvent {
  final String email;
  final String password;
  const SubmitLoginEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class VerificationEmailEvent extends LoginEvent {
  final UserCredential userCredential;
  const VerificationEmailEvent({
    required this.userCredential,
  });

  @override
  List<Object> get props => [userCredential];
}
