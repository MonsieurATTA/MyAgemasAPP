import 'package:flutter/material.dart';

class PageFamssur extends StatelessWidget {
  const PageFamssur({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Famssur')),
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
              'Contenu Famssur à venir',
              style: TextStyle(fontSize: 25),
            ),
          ],
        ),
      ),
    );
  }
}
