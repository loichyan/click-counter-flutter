import 'package:flutter_bloc/flutter_bloc.dart';

typedef CountersMap = Map<int, CounterCubit>;

class CounterViewState {
  int countersNum = 0;
  final CountersMap countersMap;

  CounterViewState({CountersMap? countersMap, this.countersNum = 0})
      : countersMap = countersMap ?? {};

  CounterViewState copyWith({CountersMap? countersMap, int? countersNum}) {
    return CounterViewState(
        countersNum: countersNum ?? this.countersNum,
        countersMap: countersMap ?? this.countersMap);
  }
}

class CounterViewCubit extends Cubit<CounterViewState> {
  CounterViewCubit() : super(CounterViewState());

  void addCounter() {
    final countersNum = state.countersNum + 1;
    emit(state.copyWith(countersNum: countersNum)
      ..countersMap.putIfAbsent(
          countersNum, () => CounterCubit('Counter #$countersNum', [])));
  }
}

class CounterState {
  final RecordsCubit records;
  final TitleCubit title;

  CounterState(String title, Records records)
      : records = RecordsCubit(records),
        title = TitleCubit(title);
}

class CounterCubit extends Cubit<CounterState> {
  CounterCubit(String title, Records records)
      : super(CounterState(title, records));
}

typedef Records = List<DateTime>;

class RecordsCubit extends Cubit<Records> {
  RecordsCubit(Records records) : super(records);

  void pushRecord(DateTime time) => emit(List.of(state)..add(time));

  void popRecord() => emit(List.of(state)..removeLast());
}

class TitleCubit extends Cubit<String> {
  TitleCubit(String title) : super(title);

  void setTitle(String title) => emit(title);
}
