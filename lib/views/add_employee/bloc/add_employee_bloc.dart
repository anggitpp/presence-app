import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../repositories/repositories.dart';
import '/models/custom_error.dart';

part 'add_employee_event.dart';
part 'add_employee_state.dart';

class AddEmployeeBloc extends Bloc<AddEmployeeEvent, AddEmployeeState> {
  final AddEmployeRepository addEmployeRepository;

  AddEmployeeBloc({required this.addEmployeRepository})
      : super(AddEmployeeState.initial()) {
    on<SubmitEmployeeEvent>((event, emit) async {
      emit(state.copyWith(addEmployeeStatus: AddEmployeeStatus.submitting));

      try {
        await addEmployeRepository.addEmployee(
            email: event.email, nip: event.nip, name: event.name);

        emit(state.copyWith(addEmployeeStatus: AddEmployeeStatus.success));
      } on CustomError catch (e) {
        emit(state.copyWith(
            addEmployeeStatus: AddEmployeeStatus.error, error: e));
      }
    });
  }
}
