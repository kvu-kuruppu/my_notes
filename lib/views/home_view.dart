import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notebook/services/auth/auth_service.dart';
import 'package:my_notebook/views/login_view.dart';
import 'package:my_notebook/views/notes/notes_view.dart';
import 'package:my_notebook/views/verify_email_view.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 185, 185, 185),
//       body: FutureBuilder(
//           future: AuthService.firebase().initialize(),
//           builder: (context, snapshot) {
//             switch (snapshot.connectionState) {
//               case ConnectionState.done:
//                 final user = AuthService.firebase().currentUser;
//                 if (user != null) {
//                   if (user.isEmailVerified) {
//                     return const NotesView();
//                   } else {
//                     return const VerificationView();
//                   }
//                 } else {
//                   return const LoginView();
//                 }
//               // print('hey $user');
//               // if (user?.emailVerified ?? false) {
//               // } else {
//               //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//               //     Navigator.of(context).push(MaterialPageRoute(
//               //         builder: (context) => const VerificationView()));
//               //   });
//               // }
//               default:
//                 return const Center(child: Text('Loading...'));
//             }
//           }),
//     );
//   }
// }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

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
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 25,
          ),
          child: Column(
            children: [
              Row(
                children: const [
                  Text(
                    'Testing Bloc',
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Divider(),
              BlocConsumer<CounterBloc, CounterState>(
                listener: (context, state) {
                  _controller.clear();
                },
                builder: (context, state) {
                  final invalidValue = (state is CounterStateInvalidNumber)
                      ? state.invalidValue
                      : '';
                  return Column(
                    children: [
                      Text('Current value = ${state.value}'),
                      Visibility(
                        visible: state is CounterStateInvalidNumber,
                        child: Text('Invalid input: $invalidValue'),
                      ),
                      TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                            hintText: 'Enter a number here'),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: () {
                                context
                                    .read<CounterBloc>()
                                    .add(IncrementEvent(_controller.text));
                              },
                              icon: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black),
                            ),
                            child: IconButton(
                              onPressed: () {
                                context
                                    .read<CounterBloc>()
                                    .add(DecrementEvent(_controller.text));
                              },
                              icon: const Icon(Icons.remove),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
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

class CounterStateInvalidNumber extends CounterState {
  final String invalidValue;

  const CounterStateInvalidNumber({
    required this.invalidValue,
    required int previousValue,
  }) : super(previousValue);
}

@immutable
abstract class CounterEvent {
  final String value;
  const CounterEvent(this.value);
}

class IncrementEvent extends CounterEvent {
  const IncrementEvent(String value) : super(value);
}

class DecrementEvent extends CounterEvent {
  const DecrementEvent(String value) : super(value);
}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterStateValid(0)) {
    on<IncrementEvent>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(
          CounterStateInvalidNumber(
            invalidValue: event.value,
            previousValue: state.value,
          ),
        );
      } else {
        emit(
          CounterStateValid(state.value + integer),
        );
      }
    });

    on<DecrementEvent>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(
          CounterStateInvalidNumber(
            invalidValue: event.value,
            previousValue: state.value,
          ),
        );
      } else {
        emit(
          CounterStateValid(state.value - integer),
        );
      }
    });
  }
}
