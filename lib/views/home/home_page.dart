import 'package:flutter/material.dart';
import 'package:presence_app/config/routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home View'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, Routes.addEmployee),
            icon: const Icon(Icons.person),
          )
        ],
      ),
      body: const Center(),
    );
  }
}
