import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'test_event.dart';
part 'test_state.dart';

class TestBloc extends Bloc<TestEvent, TestState> {
  TestBloc() : super(TestInitial()) {
    on<TestEvent>(_onTest1);
    on<LoginButtonTappedEvent>(_loginButtonTapped);
    on<ShowSnackBarButtonTappedEvent>(_showSnackBarTapped);
  }

  _onTest1(TestEvent event, Emitter emit) {
    emit(TestInitial());
  }

  Future<void> _loginButtonTapped(
      LoginButtonTappedEvent event, Emitter emit) async {
    emit(UpdateTextState(text: event.date));
  }

  Future<void> _showSnackBarTapped(
      ShowSnackBarButtonTappedEvent e, Emitter emit) async {
    emit(ShowSnackbarState());
  }
}
