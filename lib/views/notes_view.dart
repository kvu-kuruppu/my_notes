import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:my_notebook/constants/routes.dart';
import 'package:my_notebook/enums/menu_action.dart';
import 'package:my_notebook/services/auth/auth_service.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 185, 185, 185),
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(
              fontSize: 50, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        toolbarHeight: 90,
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogOut = await showLogOutDialog(context);
                  if (shouldLogOut) {
                    await AuthService.firebase().logOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (_) => false,
                    );
                  }
                  devtools.log(shouldLogOut.toString());
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Center(child: Text('Log out')),
                ),
              ];
            },
            icon: const Icon(Icons.person, color: Colors.black),
          )
        ],
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 185, 185, 185),
      ),
      body: ListView(
        children: [
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Row(
              children: const [
                Text(
                  'Hey dude',
                  style: TextStyle(fontSize: 40),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you really wanna log out?'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('No')),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes')),
        ],
      );
    },
  ).then((value) => value ?? false);
}
