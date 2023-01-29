import 'package:dertly/core/routes/routing_constants.dart';
import 'package:dertly/locator.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dertly/view_models/feeds_viewmodel.dart';

import '../core/routes/router.dart' as rtr;
import '../core/themes/custom_colors.dart';
import '../services/auth_service.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => LandingScreenState();
}

class LandingScreenState extends State<LandingScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final router = locator<rtr.Router>();

    return Scaffold(
      backgroundColor: CustomColors.black,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Dertly",
                    style: TextStyle(fontSize: 40, color: CustomColors.beige),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "An App without Text just Audio, talk how you like!",
                    style: TextStyle(fontSize: 14, color: CustomColors.beige),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
              child: SizedBox(
                width: 300,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    router.navigateTo(signInRoute);
                    // Perform some action here
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xFF118275)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0))),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.only(left: 20, right: 20)),
                  ),
                  child: const Text(
                    'Log In',
                    style: TextStyle(color: CustomColors.beige, fontSize: 20),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(5.0),
              child: Text(
                "Log into an existing Account!",
                style: TextStyle(fontSize: 14, color: CustomColors.beige),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: SizedBox(
                width: 300,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    // Perform some action here
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xFF118275)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0))),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.only(left: 20, right: 20)),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(color: CustomColors.beige, fontSize: 20),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(5.0),
              child: Text(
                "You do not have an account?",
                style: TextStyle(fontSize: 14, color: CustomColors.beige),
                textAlign: TextAlign.center,
              ),
            ),
            const Text(
              "Create an account now!",
              style: TextStyle(fontSize: 14, color: CustomColors.beige),
              textAlign: TextAlign.center,
            ),
            IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        //make google auth here!
                      },
                      icon: const Image(
                        image: AssetImage('assets/images/google_icon.png'),
                        width: 50,
                        height: 50,
                      ),
                    ),
                    /*const VerticalDivider(
                      color: Colors.white,
                      thickness: 1,
                    ), */ //Vertical Line between signin variants
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
