import 'package:flutter/cupertino.dart';

class UserImage extends StatelessWidget{
  const UserImage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(6)),
      child: Image(
        width: 40,
        height: 40,
        image: AssetImage("assets/images/placeholder.png"),
        fit: BoxFit.cover,
      ),
    );
  }
}