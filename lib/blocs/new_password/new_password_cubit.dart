import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:presence_app/repositories/new_password_repository.dart';

import '../../models/custom_error.dart';

part 'new_password_state.dart';

class NewPasswordCubit extends Cubit<NewPasswordState> {
  final NewPasswordRepository newPasswordRepository;
  NewPasswordCubit({
    required this.newPasswordRepository,
  }) : super(NewPasswordState.initial());

  void changePassword(password) async {
    emit(state.copyWith(newPasswordStatus: NewPasswordStatus.submitting));

    try {
      await newPasswordRepository.changePassword(password);
      emit(state.copyWith(newPasswordStatus: NewPasswordStatus.success));
    } on CustomError catch (e) {
      emit(
          state.copyWith(newPasswordStatus: NewPasswordStatus.error, error: e));
    }
  }
}
