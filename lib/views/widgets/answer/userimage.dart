import 'package:flutter/cupertino.dart';

class UserImage extends StatelessWidget{
  const UserImage({super.key, this.width = 40, this.height = 40, this.borderRadius = 6});

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      child: Image(
        width: width,
        height: height,
        image: AssetImage("assets/images/placeholder.png"),
        fit: BoxFit.cover,
      ),
    );
  }
}