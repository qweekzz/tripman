import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'counter_event.dart';
part 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<CounterIncEvent>(_increment);
    on<CounterDecEvent>(_decrement);
  }

  _increment(CounterIncEvent event, Emitter emit) {
    emit(state + 1);
  }

  _decrement(CounterDecEvent event, Emitter emit) {
    if (state == 0) {
      return;
    } else {
      emit(state - 1);
    }
  }
}
