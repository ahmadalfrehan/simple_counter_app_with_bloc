import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:such/bloc/bloc.dart';
import 'package:such/bloc/events.dart';

import 'bloc/states.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocProvider(
            create: (BuildContext context) {
              return CounterBloc();
            },
            child: BlocConsumer<CounterBloc, CounterStates>(
                listener: (context, state) {},
                builder: (context, state) {
                  final CounterBloc counterBloc =
                      BlocProvider.of<CounterBloc>(context);
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          counterBloc.add(CounterIncrementEvent());
                        },
                        child: Text(counterBloc.counter.toString()),
                      ),
                      TextButton(
                        onPressed: () {
                          counterBloc.add(CounterDecrementEvent());
                        },
                        child: Text(counterBloc.counter.toString()),
                      ),
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }
}
