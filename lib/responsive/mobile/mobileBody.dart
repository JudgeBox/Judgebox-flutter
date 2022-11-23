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
        children: [ // Text
          Container(
            padding: const EdgeInsets.only(left: 15, top: 10),
            child: const Text("過去筆記", style: TextStyle(fontSize: 22),),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.deepPurple[300],
              border: Border.all(color: Colors.white70, width: 5),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text("owo")
              ],
            ),
          )
        ],
      ),
    );
  }
}