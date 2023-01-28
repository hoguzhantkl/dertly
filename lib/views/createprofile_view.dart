import 'package:dertly/view_models/createprofile_viewmodel.dart';
import 'package:dertly/view_models/user_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/routes/router.dart' as router;
import '../locator.dart';

class CreateProfileScreen extends StatefulWidget{
  const CreateProfileScreen({Key? key}) : super(key: key);

  @override
  State<CreateProfileScreen> createState() => CreateProfileScreenState();
}

class CreateProfileScreenState extends State<CreateProfileScreen>{
  late CreateProfileViewModel createProfileViewModel;

  @override
  void initState(){
    createProfileViewModel = CreateProfileViewModel();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Create Profile Screen'),
            ElevatedButton(
              onPressed: () {
                createProfileViewModel.createUserProfile().then((value) =>
                    Provider.of<UserViewModel>(context, listen: false).fetchUserData()
                        .then((value) => locator<router.Router>().navigateHomeScreen())
                );
              },
              child: const Text('Create Profile'),
            ),
          ],
        ),
      ),
    );
  }
}