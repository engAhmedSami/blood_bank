// ignore_for_file: file_names

import 'package:flutter/material.dart';

class BloodInstructionsView extends StatelessWidget {
  const BloodInstructionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Blood Instructions'),
      ),
      body: Column(
        children: const [
          Text(
            'Additional tips before donating:',
            style: TextStyle(
              color: Color(0xff800000),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    );
  }
}
