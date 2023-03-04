import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:judgebox/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'note/noteBody.dart';

class WebBody extends StatefulWidget {
  const WebBody({Key? key}) : super(key: key);

  @override
  Future<void> load() => _WebBody()._loadData();

  @override
  State<WebBody> createState() => _WebBody();
}

class _WebBody extends State<WebBody> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late List<String> noteData = [];

  get http => null;

  Future<void> _loadData() async {
    final snapshot = await _firestore.collection("title").doc("title").get();
    //print(snapshot.data()?.values);
    for (var data in snapshot.data()!.values) {
      if (!noteData.contains(data)) {
        noteData.add(data);
      }
    }
    print(noteData);


  }

  late List<dynamic> _futureProblemList;
  Future<void> getProblem() async {
    print('try http request');

    final response = await http.get(Uri.parse('http://localhost:3000/CF'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      _futureProblemList = jsonResponse;
      print(jsonResponse[0]);
      // return jsonResponse;
    } else {
      throw Exception('Request failed with status: ${response.statusCode}.');
    }

    setState(() {});
  }
  
  @override
  void initState() {
    super.initState();
    _futureProblemList = [];

    _loadData();
  }

  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args == true) {
      setState(() {

      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final problemList = getProblem();

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
            Container(
                padding: EdgeInsets.only(left: 50, top: 20, right: 30),
                height: 175,
                child: LayoutBuilder(builder: (context, constraints) {
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: (constraints.maxWidth / 300).toInt(),
                    itemBuilder: (BuildContext context, int index) {
                      if (index >= noteData.length) return Container();
                      String title = noteData[noteData.length - 1 - index];
                      return GestureDetector(
                          onTap: (){
                            var destinationPage = NoteBody(title: title,);
                            NoteBody.pages.clear();
                            // Push the destination page onto the navigation stack
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => destinationPage),
                            );
                          },
                          child: Container(
                            width: 275,
                            decoration: BoxDecoration(
                              color: Colors.deepPurple[300],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Container(
                              child: Text(title),
                          ),
                      ));
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        SizedBox(width: 50),
                  );
                })),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: const Text(
                    "題目列表",
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
            Expanded(child: LayoutBuilder(builder: (context, constraints) {
              return ListView.separated(
                padding: EdgeInsets.only(right: 50),
                shrinkWrap: true,
                itemCount: (constraints.maxHeight / 65).toInt(),
                itemBuilder: (BuildContext context, int index) {
                  if (index >= _futureProblemList.length) {
                    return ListTile(
                      leading: Icon(Icons.add_to_home_screen),
                      title: Text("Loading..."),
                      trailing: Icon(Icons.keyboard_arrow_right),
                    );
                  }
                  return ListTile(
                    leading: Icon(Icons.add_to_home_screen),
                    title: Text(_futureProblemList[index]['Id'].toString() +
                        ": " +
                        _futureProblemList[index]['Name'].toString()),
                    trailing: Icon(Icons.keyboard_arrow_right),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(color: Colors.blue);
                },
              );
            })),
          ])),
    );
  }
}
