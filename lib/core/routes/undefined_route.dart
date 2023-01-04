import 'package:flutter/material.dart';

class UndefinedRouteView extends StatelessWidget{
  const UndefinedRouteView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Undefined view. Please press the back button.')),
    );
  }
}