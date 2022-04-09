import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:presence_app/models/custom_error.dart';
import 'package:presence_app/repositories/login_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository loginRepository;
  LoginBloc({required this.loginRepository}) : super(LoginState.inital()) {
    on<SubmitLoginEvent>((event, emit) async {
      emit(state.copyWith(loginStatus: LoginStatus.submitting));

      try {
        UserCredential userCredential = await loginRepository.login(
            email: event.email, password: event.password);

        if (userCredential.user!.emailVerified == false) {
          emit(state.copyWith(
              loginStatus: LoginStatus.unverified,
              userCredential: userCredential));
        } else {
          emit(state.copyWith(loginStatus: LoginStatus.success));
        }
      } on CustomError catch (e) {
        emit(state.copyWith(loginStatus: LoginStatus.error, error: e));
      }
    });

    on<VerificationEmailEvent>((event, emit) async {
      try {
        await loginRepository.verificationEmail(
            userCredential: event.userCredential);
      } catch (e) {
        throw CustomError(
          code: 'Exception',
          message: e.toString(),
          plugin: 'flutter_error/server_error',
        );
      }
    });
  }
}
