import 'package:bloc/bloc.dart';
import 'package:diaryx/components/mytextfield.dart';
import 'package:diaryx/constants/routs.dart';
import 'package:diaryx/services/auth/auth_service.dart';
import 'package:diaryx/views/notes/create_update_note_view.dart';
import 'package:diaryx/views/notes/notesview.dart';
import 'package:diaryx/views/login.dart';
import 'package:diaryx/views/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        loginRout: (context) => const LoginView(),
        reigsterRout: (context) => const RegisterationView(),
        notesRout: (context) => const Notesview(),
        createUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
    ),
  );
}

/*class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initializer(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerfied) {
                return const Notesview();
              } else {
                //showError(context, "please verify your Email before loging in");
                return const LoginView();
              }
            } else {
              return const RegisterationView();
            }

          default:
            return const Text("Loading...");
        }
      },
    );
  }
}*/
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("hello!"),
          backgroundColor: Colors.green.shade300,
        ),
        body: BlocConsumer<CounterBloc, CounterState>(
          listener: (context, state) {
            _controller.clear();
          },
          builder: (context, state) {
            final invalidvalue =
                (state is CounterStateInvalid) ? state.invalidValue : "";

            return Column(
              children: [
                Text('current value => ${state.value}'),
                Visibility(
                  visible: state is CounterStateInvalid,
                  child: Text("invalid input $invalidvalue"),
                ),
                MyTextField(
                    controller1: _controller,
                    hinttext: "Enter a number here",
                    obsecuretext: false),
                Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          context
                              .read<CounterBloc>()
                              .add(IncermentEvent(_controller.text));
                        },
                        child: const Text("+")),
                    TextButton(
                        onPressed: () {
                          context
                              .read<CounterBloc>()
                              .add(DecermentEvent(_controller.text));
                        },
                        child: const Text("-"))
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

@immutable
abstract class CounterState {
  final int value;
  const CounterState(this.value);
}

class CounterStateValid extends CounterState {
  const CounterStateValid(int value) : super(value);
}

class CounterStateInvalid extends CounterState {
  final String invalidValue;
  const CounterStateInvalid(
      {required this.invalidValue, required int previousvalue})
      : super(previousvalue);
}

abstract class CounterEvent {
  final String value;
  const CounterEvent(this.value);
}

class IncermentEvent extends CounterEvent {
  const IncermentEvent(String value) : super(value);
}

class DecermentEvent extends CounterEvent {
  const DecermentEvent(String value) : super(value);
}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterStateValid(0)) {
    on<IncermentEvent>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(CounterStateInvalid(
            invalidValue: event.value, previousvalue: state.value));
      } else {
        emit(CounterStateValid(state.value + integer));
      }
    });
    on<DecermentEvent>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(CounterStateInvalid(
            invalidValue: event.value, previousvalue: state.value));
      } else {
        emit(CounterStateValid(state.value - integer));
      }
    });
  }
}
