import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../locator.dart';
import '../services/auth_service.dart';
import '../view_models/feeds_viewmodel.dart';

class StarterScreen extends StatelessWidget{
  const StarterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    locator<AuthService>().listenAuth(context);

    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}