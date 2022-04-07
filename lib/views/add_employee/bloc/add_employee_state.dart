part of 'add_employee_bloc.dart';

enum AddEmployeeStatus {
  initial,
  submitting,
  success,
  error,
}

class AddEmployeeState extends Equatable {
  final AddEmployeeStatus addEmployeeStatus;
  final CustomError error;
  const AddEmployeeState({
    required this.addEmployeeStatus,
    required this.error,
  });

  factory AddEmployeeState.initial() {
    return const AddEmployeeState(
      addEmployeeStatus: AddEmployeeStatus.initial,
      error: CustomError(),
    );
  }

  @override
  List<Object> get props => [addEmployeeStatus, error];

  AddEmployeeState copyWith({
    AddEmployeeStatus? addEmployeeStatus,
    CustomError? error,
  }) {
    return AddEmployeeState(
      addEmployeeStatus: addEmployeeStatus ?? this.addEmployeeStatus,
      error: error ?? this.error,
    );
  }

  @override
  String toString() =>
      'AddEmployeeState(addEmployeeStatus: $addEmployeeStatus, error: $error)';
}
