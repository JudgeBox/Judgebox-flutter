import 'package:flutter/material.dart';
import 'package:judgebox/constants.dart';
import 'package:judgebox/responsive/web/webBody.dart';
import 'package:judgebox/responsive/web/note/noteBody.dart';

class WebScaffold extends StatefulWidget {
  const WebScaffold({Key? key}) : super(key: key);

  @override
  State<WebScaffold> createState() => _WebScaffoldState();
}

class _WebScaffoldState extends State<WebScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black26,
        title: Container(
            child: Row(
              children: [
                SizedBox(width: 30,),
                Text("JudgeBox"),
                SizedBox(width: 20,),
                TextButton(
                  onPressed: () {
                    // This is the callback that will be called when the user taps on the text
                    var destinationPage = NoteBody(title: "");
                    // Push the destination page onto the navigation stack
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => destinationPage),
                    );
                  },
                  child: Text('New Note', style: TextStyle(color: Colors.white70,),),

                )
              ],
            )
        ),
      ),
      backgroundColor: judgeBackground,
      body: WebBody(),
    );
  }
}