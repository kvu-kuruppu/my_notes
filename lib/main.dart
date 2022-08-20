import 'package:flutter/material.dart';
import 'package:my_notebook/views/home_view.dart';
import 'package:my_notebook/views/login_view.dart';
import 'package:my_notebook/views/register_view.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MaterialApp(
    // home: RegisterView(),
    home: HomePage(),
    // home: LoginView(),
  ));
}

