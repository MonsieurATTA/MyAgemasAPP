import 'package:flutter/material.dart';

class PageSante extends StatelessWidget {
  const PageSante({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Moka Sante')),
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
            const Text('Moka Santé à venir', style: TextStyle(fontSize: 25)),
          ],
        ),
      ),
    );
  }
}
