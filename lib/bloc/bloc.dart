import 'package:bloc/bloc.dart';
import 'package:such/bloc/events.dart';
import 'package:such/bloc/states.dart';

class CounterBloc extends Bloc<CounterEvent, CounterStates> {
  int counter = 0;
  CounterBloc() : super(CounterInitialStates()) {
    on<CounterIncrementEvent>((event, emit) {
      counter++;
      emit(CounterIncrementStates());
    });
    on<CounterDecrementEvent>((event, emit) {
      counter--;
      emit(CounterDecrementStates());
    });
  }
}
