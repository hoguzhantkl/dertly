import 'package:dertly/locator.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dertly/view_models/feeds_viewmodel.dart';

import '../core/routes/router.dart' as rtr;

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => LandingScreenState();
}

class LandingScreenState extends State<LandingScreen>
{
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final router = locator<rtr.Router>();

    // TODO: write a more proper way to clear all model data (for auth and userViewModels too)
    Provider.of<FeedsViewModel>(context, listen: false).clearModelData();

    // TODO: add a landing view
    return Container();
  }
}