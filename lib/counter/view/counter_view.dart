import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;

import '../counter.dart';

class CounterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Click Counter"),
        actions: [
          IconButton(
              onPressed: () =>
                  export(context.read<CounterViewCubit>().state.countersMap),
              icon: Icon(Icons.share))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 30, right: 30, top: 10),
          child: BlocBuilder<CounterViewCubit, CounterViewState>(
            builder: (context, state) => Wrap(
              children: state.countersMap.entries
                  .map((e) => BlocProvider<CounterCubit>(
                        create: (context) => context
                            .read<CounterViewCubit>()
                            .state
                            .countersMap[e.key]!,
                        child: Counter('Counter #${e.key}'),
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<CounterViewCubit>().addCounter(),
        child: Icon(Icons.add),
      ),
    );
  }

  void export(CountersMap countersMap) {
    print(countersMap.entries
        .map((e) =>
            '#${e.key}(${e.value.state.title.state}): ${e.value.state.records.state}')
        .toList());
  }
}

class Counter extends StatelessWidget {
  final String defaultTitle;

  Counter(title) : defaultTitle = title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RecordsCubit>(
      create: (context) => context.read<CounterCubit>().state.records,
      child: BlocProvider<TitleCubit>(
        create: (context) => context.read<CounterCubit>().state.title,
        child: SizedBox(
          width: 150,
          child: Card(
            child: Column(
              children: [CounterShow()],
            ),
          ),
        ),
      ),
    );
  }
}

class CounterShow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(
        children: [
          CounterNum(),
          CounterHistory(),
        ],
      ),
      Positioned.fill(
          child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () =>
                    context.read<RecordsCubit>().pushRecord(DateTime.now()),
              )))
    ]);
  }
}

class CounterNum extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.teal[400],
      textStyle: TextStyle(color: Colors.white),
      child: SizedBox(
          height: 50,
          child: Center(
              child: BlocBuilder<RecordsCubit, Records>(
                  builder: (context, state) => Text(
                        '${state.length}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 35),
                      )))),
    );
  }
}

class CounterHistory extends StatelessWidget {
  static intl.DateFormat dateFormat = intl.DateFormat.Hms();

  CounterHistory();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 3),
                  child: BlocBuilder<TitleCubit, String>(
                      builder: (context, title) => Text(
                            title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                ),
                BlocBuilder<RecordsCubit, Records>(
                    builder: (context, records) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: records
                              .asMap()
                              .entries
                              .skip(
                                  records.length <= 3 ? 0 : records.length - 3)
                              .map((e) => Text(
                                  '${dateFormat.format(e.value)} #${e.key}'))
                              .toList(),
                        ))
              ],
            )));
  }
}
