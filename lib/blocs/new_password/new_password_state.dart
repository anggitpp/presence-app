part of 'new_password_cubit.dart';

enum NewPasswordStatus {
  initial,
  submitting,
  success,
  error,
}

class NewPasswordState extends Equatable {
  final NewPasswordStatus newPasswordStatus;
  final CustomError error;
  const NewPasswordState({
    required this.newPasswordStatus,
    required this.error,
  });

  factory NewPasswordState.initial() {
    return const NewPasswordState(
        newPasswordStatus: NewPasswordStatus.initial, error: CustomError());
  }

  @override
  List<Object> get props => [newPasswordStatus, error];

  NewPasswordState copyWith({
    NewPasswordStatus? newPasswordStatus,
    CustomError? error,
  }) {
    return NewPasswordState(
      newPasswordStatus: newPasswordStatus ?? this.newPasswordStatus,
      error: error ?? this.error,
    );
  }

  @override
  String toString() =>
      'NewPasswordState(newPasswordStatus: $newPasswordStatus, error: $error)';
}
