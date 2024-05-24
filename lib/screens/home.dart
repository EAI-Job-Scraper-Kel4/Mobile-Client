import 'package:flutter/material.dart';
import 'package:jobscrapper_mobile/screens/widgets/joblist-view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: JobListView(),
    );
  }
}
