import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eco Adventure'),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Text('Welcome'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.replace('/');
                },
                child: const Text('Logout'),
              ),
            ]
          )
        ),
      ),
    );
  }
}
