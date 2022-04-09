part of 'add_employee_bloc.dart';

abstract class AddEmployeeEvent extends Equatable {
  const AddEmployeeEvent();

  @override
  List<Object?> get props => [];
}

class SubmitEmployeeEvent extends AddEmployeeEvent {
  final String nip;
  final String name;
  final String email;
  const SubmitEmployeeEvent({
    required this.nip,
    required this.name,
    required this.email,
  });

  @override
  List<Object?> get props => [nip, name, email];
}
