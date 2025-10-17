import 'package:flutter/material.dart';
import 'package:money_management/Moneymanagement.dart';

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Money Management',
      home: Moneymanagement(),

    );

  }
}


