import 'package:flutter/material.dart';
import 'package:judgebox/constants.dart';

class NoteBody extends StatefulWidget {
  const NoteBody({Key? key}) : super(key: key);

  @override
  State<NoteBody> createState() => _NoteBody();
}

bool _TypeDraw = false;

//文字方塊
class _NoteBody extends State<NoteBody> {
  final buttonKey = GlobalKey();
  final textBoxKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      Column(children: [
        IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            setState(() {
              _TypeDraw = !_TypeDraw;
            });
          },
        ),
      ]),
      Container(
          padding: EdgeInsets.only(left: 250, right: 250),
          child: _TypeDraw
              ? Stack(children: [
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Container(
                          width: double.infinity,
                          child: TextField(),
                        );
                      },
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                  )
                ])
              : Stack(children: [
                  Container(
                    child: Text("ouo"),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                  )
                ]))
    ]));
  }
}

class TextBoxContainer extends StatefulWidget {
  TextBoxContainer({required Key key}) : super(key: key);

  @override
  _TextBoxContainerState createState() => _TextBoxContainerState();
}

class _TextBoxContainerState extends State<TextBoxContainer> {
  // Use a List to store the positions of the text boxes
  List<Offset> textBoxPositions = [];

  void createTextBox(Offset position) {
    // Add the position to the list
    setState(() {
      textBoxPositions.add(position);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Use the Stack widget to overlay the text boxes on top of each other
      child: Stack(
        children: textBoxPositions.map((position) {
          return Positioned(
            // Use the position to position the text box on the screen
            left: position.dx,
            top: position.dy,
            child: TextBox(),
          );
        }).toList(),
      ),
    );
  }
}

class TextBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: TextField(),
    );
  }
}
