import 'package:flutter/material.dart';

class AnswerInfos extends StatelessWidget{
  const AnswerInfos({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
        children: [

          Row(
            children: [
              Icon(Icons.arrow_upward_rounded, size: 14, color: Colors.white),
              Text("12", style: TextStyle(fontSize:12, color: Colors.white)),
            ],
          ),
          SizedBox(width: 20),
          Row(
            children: [
              Icon(Icons.arrow_downward_rounded, size: 14, color: Colors.white),
              Text("7", style: TextStyle(fontSize:12, color: Colors.white)),
            ],
          ),
          SizedBox(width: 20),

          Text("04.01.2023, 10:16", style: TextStyle(fontSize: 10, color: Colors.white))

        ]
    );
  }

}