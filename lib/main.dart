import 'package:flutter/material.dart';

import 'routes/home.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Note",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 167, 163, 163),
          scaffoldBackgroundColor: const Color.fromARGB(255, 37, 37, 37),
        ),
        home: const Home());
  }
}
