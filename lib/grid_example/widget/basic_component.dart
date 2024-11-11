import 'package:flutter/material.dart';

class BasicComponent extends StatelessWidget {
  const BasicComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 2,
            color: Colors.black,
          )),
    );
  }
}
