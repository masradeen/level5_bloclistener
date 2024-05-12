import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = false;

  final ThemeData dark = ThemeData.dark();

  final ThemeData light = ThemeData.light();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CounterBloc(),
        ),
        BlocProvider(
          create: (context) => ThemeBloc(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<CounterBloc, int>(
            listener: (context, state) {
              if (state > 10) {
                setState(() {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Lebih dari 10"),
                      duration: Duration(milliseconds: 500),
                    ),
                  );
                });
              }
              if (state % 1 == 0) {
                setState(() {
                  isDark = !isDark;
                });
              }
            },
          ),
        ],
        child: BlocBuilder<ThemeBloc, bool>(
          builder: (context, state) => MaterialApp(
            theme: state == isDark ? dark : light,
            home: HomePage(),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => context.read<ThemeBloc>().changeTheme(),
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Center(
        child: BlocBuilder<CounterBloc, int>(
          builder: (context, state) => Text(
            "$state",
            style: TextStyle(
              fontSize: 25,
            ),
          ),
        ),
        /* tanpa bloc listener
        child: BlocBuilder<CounterBloc, int>(
          builder: (context, state) => Text(
            "$state",
            style: TextStyle(
              fontSize: 25,
            ),
          ),
        ),
        */
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<CounterBloc>().increment(),
      ),
    );
  }
}

class CounterBloc extends Cubit<int> {
  CounterBloc() : super(0);

  void increment() => emit(state + 1);
}

class ThemeBloc extends Cubit<bool> {
  ThemeBloc() : super(false);

  void changeTheme() => emit(!state);
}
