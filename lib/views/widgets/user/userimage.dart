import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserImage extends StatelessWidget{
  const UserImage({super.key, this.file, this.width = 40, this.height = 40, this.borderRadius = 6});

  final File? file;
  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      child: Padding(
        padding: const EdgeInsets.only(top: 0.0),
        child: file != null
            ? Image.file(
                file!,
                width: width,
                height: height,
                fit: BoxFit.cover,
              )
            : Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white10, width: 2),
                borderRadius: BorderRadius.circular(6),
              )
            )
      )
    );
  }
}