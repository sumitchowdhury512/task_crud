import 'dart:math';

import 'package:Note/style/app_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen({Key? key}) : super(key: key);

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  int color_id = Random().nextInt(AppStyle.cardsColor.length);
  String date = DateTime.now().toString();
  TextEditingController _title = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.cardsColor[color_id],
      appBar: AppBar(
        backgroundColor: AppStyle.cardsColor[color_id],
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Add a new Note",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _title,
              decoration: InputDecoration(
                  border: InputBorder.none, helperText: "Note Title"),
              style: AppStyle.mainTitle,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppStyle.accentColor,
        child: Icon(Icons.save),
        onPressed: () {

          var uuid = Uuid();
          FirebaseFirestore.instance.collection("Notes").add({
            "uniq_id": uuid.v1(),
            "check_box": false,
            "note_title": _title.text,
            "creation_date": date,
            "color_id": color_id
          }).then((value) => Navigator.pop(context));

              // .catchError((e) => print("fails" + e.toString()));
        },
      ),
    );
  }
}
