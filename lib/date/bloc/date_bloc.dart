import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'date_event.dart';
part 'date_state.dart';

class DateBloc extends Bloc<DateEvent, DateState> {
  DateBloc() : super(DateInitial()) {
    on<DateEvent>(_onDateInit);
    on<DateChangedButton>(_onDateChangedButton);
  }

  _onDateInit(DateEvent event, Emitter<DateState> emit) {
    emit(DateInitial());
  }

  // _onDateChanged2(DateChanged event, Emitter<DateInitial> emit) {
  //   emit(state.copyWith(date: event.date));
  // }
  _onDateChangedButton(DateChangedButton event, Emitter emit) {
    emit(DateInfo(date: event.date));
  }
}

// _onEmailChanged(EmailChanged event, Emitter<FormsValidate> emit) {
//   emit(state.copyWith(
//     email: event.email,
//     isEmailValid: _isEmailValid(event.email),
//   ));
// }
