import 'package:dertly/views/widgets/bottomsheet/bottomsheetcontent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/themes/custom_colors.dart';

class BottomSheetWidget extends StatefulWidget {
  const BottomSheetWidget({super.key});

  @override
  State<BottomSheetWidget> createState() => BottomSheetWidgetState();
}

class BottomSheetWidgetState extends State<BottomSheetWidget>{
  final double initialChildSize = 0.08;
  late double currentChildSize;

  @override
  void initState() {
    super.initState();
    currentChildSize = initialChildSize;
  }

  void _onBottomSheetClicked(){
    setState(() {
      // TODO: Navigate to entry view by scrolling to top from bottom
    });
  }

  @override
  Widget build(BuildContext context){
    return DraggableScrollableSheet(
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return InkWell(
          onTap: _onBottomSheetClicked,
          child: const BottomSheetContent()
        );
      },
      minChildSize: initialChildSize,
      initialChildSize: currentChildSize,
      maxChildSize: 1.0,
    );
  }
}