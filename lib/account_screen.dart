import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konto'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Konto-Seite'),
      ),
    );
  }
}