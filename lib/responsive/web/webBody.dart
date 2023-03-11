import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:judgebox/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'note/noteBody.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/services.dart' show rootBundle;

class WebBody extends StatefulWidget {
  const WebBody({Key? key}) : super(key: key);

  @override
  Future<void> load() => _WebBody()._loadData();

  @override
  State<WebBody> createState() => _WebBody();
}

class _WebBody extends State<WebBody> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _stream;
  late List<String> noteData = [];
  late List<dynamic> _futureProblemList;

  Future<void> getProblem() async {
    print("trying request");

    final value = await rootBundle.loadString('json/problem.json');
    _futureProblemList = json.decode(value);
    print(_futureProblemList.length);
    setState(() {});
    return;

    final response = await http.get(Uri.parse('http://localhost:3000/CF'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      _futureProblemList = jsonResponse;
      print(jsonResponse.length);
      // return jsonResponse;
    } else {
      throw Exception('Request failed with status: ${response.statusCode}.');
    }

    setState(() {});
  }

  Future<void> _loadData() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection("title").doc("title").get();
    final List<dynamic> titles = snapshot.data()?['title'] ?? [];

    noteData = List<String>.from(titles.map((e) => e.toString()));
    //print(noteData);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getProblem();
    _futureProblemList = [];
    _stream =
        FirebaseFirestore.instance.collection('title').doc('title').snapshots();
  }

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
            Container(
                padding: EdgeInsets.only(left: 50, top: 20, right: 30),
                height: 175,
                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: _stream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      } else {
                        final List<dynamic> titles =
                            snapshot.data!?['title'] ?? [];
                        noteData =
                            List<String>.from(titles.map((e) => e.toString()));
                        return LayoutBuilder(builder: (context, constraints) {
                          return ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: (constraints.maxWidth / 300).toInt(),
                            itemBuilder: (BuildContext context, int index) {
                              print(noteData);
                              if (index >= noteData.length) return Container();
                              String title =
                                  noteData[noteData.length - index - 1];
                              return GestureDetector(
                                  onTap: () {
                                    var destinationPage =
                                        NoteBody(title: title, New: false);
                                    NoteBody.pages.clear();
                                    // Push the destination page onto the navigation stack
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              destinationPage),
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
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    SizedBox(width: 50),
                          );
                        });
                      }
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
                      print("Loading");
                      return const ListTile(
                        leading: Icon(Icons.add_to_home_screen),
                        title: Text("Loading..."),
                        trailing: Icon(Icons.keyboard_arrow_right),
                      );
                    } else {
                      return ListTile(
                        leading: Icon(Icons.add_to_home_screen),
                        title: Text(_futureProblemList[index]['Id'].toString() +
                            ": " +
                            _futureProblemList[index]['Name'].toString()),
                        onTap: () =>
                            launch(_futureProblemList[index]['URL'].toString()),
                        trailing: IconButton(
                          icon: Icon(Icons.keyboard_arrow_right),
                          onPressed: () {
                            var destinationPage = NoteBody(
                                title: _futureProblemList[index]['Id'],
                                New: false);
                            NoteBody.pages.clear();
                            // Push the destination page onto the navigation stack
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => destinationPage),
                            );
                          },
                        ),
                      );
                    }
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(color: Colors.blue);
                  });
            })),
          ])),
    );
  }
}
