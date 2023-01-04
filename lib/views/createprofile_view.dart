import 'package:dertly/view_models/createprofile_viewmodel.dart';
import 'package:dertly/views/home_view.dart';
import 'package:flutter/material.dart';

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
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen(title: 'Home Screen'),
                        ),
                    ),
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