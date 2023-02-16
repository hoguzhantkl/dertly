import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0).copyWith(top: 32),
        child: Column(
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(onPressed: (){Navigator.of(context).pop();}, icon: const Icon(Icons.arrow_back_rounded, size: 28)),

                  IconButton(onPressed: (){}, icon: const Icon(Icons.more_vert_rounded, size: 26)),
                ]
            ),
          ],
        )
      )
    );
  }
}
