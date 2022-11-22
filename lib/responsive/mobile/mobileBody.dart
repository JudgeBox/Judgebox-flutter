import 'package:flutter/material.dart';
import 'package:judgebox/constants.dart';

class MobileBody extends StatefulWidget {
  const MobileBody({Key? key}) : super(key: key);

  @override
  State<MobileBody> createState() => _MobileBody();
}

class _MobileBody extends State<MobileBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),

          )
        ],
      ),
    );
  }
}