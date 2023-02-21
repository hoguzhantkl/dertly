import 'package:dertly/view_models/user_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserInformations extends StatelessWidget {
  const UserInformations({super.key});

  @override
  Widget build(BuildContext context) {
    UserViewModel userViewModel = Provider.of<UserViewModel>(context, listen: false);
    var userModel = userViewModel.userModel;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text("${userModel.totalEntries}", style: TextStyle(fontSize: 22)),
            const Text("Entries", style: TextStyle(fontSize: 18)),
          ],
        ),

        Column(
          children: [
            Text("${userModel.totalFollowers}", style: TextStyle(fontSize: 22)),
            const Text("Followers", style: TextStyle(fontSize: 18)),
          ],
        ),

        Column(
          children: [
            Text("${userModel.totalFollowing}", style: TextStyle(fontSize: 22)),
            const Text("Following", style: TextStyle(fontSize: 18)),
          ],
        ),
      ],
    );
  }
}