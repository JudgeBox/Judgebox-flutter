import 'package:flutter/material.dart';
import 'package:judgebox/constants.dart';

class WebBody extends StatefulWidget {
  const WebBody({Key? key}) : super(key: key);

  @override
  State<WebBody> createState() => _WebBody();
}

class _WebBody extends State<WebBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.only(left: 200, right: 250),
          child: Column(children: [
            // Text
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: const Text(
                    "過去筆記",
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                Row(children: [
                  Container(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        icon: Icon(Icons.arrow_left), onPressed: () {}),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        icon: Icon(Icons.arrow_right), onPressed: () {}),
                  ),
                  SizedBox(width: 30),
                ])
              ],
            ),

            Row(children: [
              Container(
                width: 300,
                height: 150,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.deepPurple[300],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(),
              ),
              SizedBox(width: 50),
              Container(
                width: 300,
                height: 150,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(),
              ),
              SizedBox(width: 50),
              Container(
                width: 300,
                height: 150,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(),
              )
            ]),
          ])),
    );
  }
}
