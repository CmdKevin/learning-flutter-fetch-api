import 'package:flutter/material.dart';
import 'package:flutter_user_list_cubit/user_list/view/user_list_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Gamer List",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
      ),
      home: const UserListPage(),
    );
  }
}