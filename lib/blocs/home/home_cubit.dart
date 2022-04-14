import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:presence_app/repositories/home_repository.dart';

import '../../models/custom_error.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository homeRepository;
  HomeCubit({
    required this.homeRepository,
  }) : super(HomeState.initial());

  void signOut() async {
    emit(state.copyWith(signOutStatus: SignOutStatus.submitting));

    try {
      await homeRepository.signOut();
      emit(state.copyWith(signOutStatus: SignOutStatus.success));
    } on CustomError catch (e) {
      emit(state.copyWith(signOutStatus: SignOutStatus.error, error: e));
    }
  }
}
