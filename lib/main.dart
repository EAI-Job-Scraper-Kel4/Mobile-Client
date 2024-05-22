import 'package:flutter/material.dart';
import 'package:jobscrapper_mobile/screens/joblist.dart';
import 'package:jobscrapper_mobile/screens/widgets/joblist-view.dart';
import 'screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: JobListScreen(),
      )
    );
  }
}
