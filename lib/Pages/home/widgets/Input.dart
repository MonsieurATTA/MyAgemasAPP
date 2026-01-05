import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final String label;
  final String indication;
  final TextEditingController? controller;
  final bool obscureText;
  
  const Input({
    super.key,
    required this.label,
    required this.indication,
    this.controller,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(fontSize: 10),
        decoration: InputDecoration(
          label: Text(label),
          hintText: indication,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "veuillez saisir votre " + label;
          }
          return null;
        },
      ),
    );
  }
}
