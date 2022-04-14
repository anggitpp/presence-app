part of 'home_cubit.dart';

enum SignOutStatus {
  initial,
  submitting,
  success,
  error,
}

class HomeState extends Equatable {
  final SignOutStatus signOutStatus;
  final CustomError error;
  const HomeState({
    required this.signOutStatus,
    required this.error,
  });

  factory HomeState.initial() {
    return HomeState(
        signOutStatus: SignOutStatus.initial, error: const CustomError());
  }

  HomeState copyWith({
    SignOutStatus? signOutStatus,
    CustomError? error,
  }) {
    return HomeState(
      signOutStatus: signOutStatus ?? this.signOutStatus,
      error: error ?? this.error,
    );
  }

  @override
  String toString() =>
      'HomeState(signOutStatus: $signOutStatus, error: $error)';

  @override
  List<Object> get props => [signOutStatus, error];
}
