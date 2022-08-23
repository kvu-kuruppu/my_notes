import 'package:flutter/material.dart';
import 'package:my_notebook/constants/routes.dart';
import 'package:my_notebook/views/home_view.dart';
import 'package:my_notebook/views/login_view.dart';
import 'package:my_notebook/views/notes_view.dart';
import 'package:my_notebook/views/register_view.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    home: const HomePage(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      notesRoute: (context) => const NotesView(),
    },
  ));
}

