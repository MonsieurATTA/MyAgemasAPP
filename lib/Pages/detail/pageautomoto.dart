import 'package:flutter/material.dart';

class PageAutoMoto extends StatelessWidget {
  const PageAutoMoto({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Auto-Moto')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/404.png',
              width: 280,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 30),
            const Text(
              'Contenu Auto-Moto à venir',
              style: TextStyle(fontSize: 25),
            ),
          ],
        ),
      ),
    );
  }
}

