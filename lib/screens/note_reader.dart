import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../style/app_style.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
class NoteReaderScreen extends StatefulWidget {
  NoteReaderScreen(this.doc, {Key? key}) : super(key: key);
  QueryDocumentSnapshot doc;

  @override
  State<NoteReaderScreen> createState() => _NoteReaderScreenState();
}

class _NoteReaderScreenState extends State<NoteReaderScreen> {
  quill.QuillController _controller = quill.QuillController.basic();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var myjson = jsonDecode(widget.doc['note_description']);
    _controller = quill.QuillController(document: quill.Document.fromJson(myjson), selection: TextSelection.collapsed(offset: 0));
  }

  @override
  Widget build(BuildContext context) {
    int color_id = widget.doc['color_id'];
    return Scaffold(
      backgroundColor: AppStyle.cardsColor[color_id],
      appBar: AppBar(
        backgroundColor: AppStyle.cardsColor[color_id],
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.doc['note_title'],
            style: AppStyle.mainTitle,
            ),
            SizedBox(
              height: 4.0,
            ),
            Text(widget.doc['creation_date'],
              style: AppStyle.dateTitle,
            ),
            SizedBox(
              height: 14.0,
            ),
            widget.doc['image'] != ""?Image.network(
              widget.doc['image'].toString(),
              height: 100,
              width: 100,
            ):Container(),


            SizedBox(
              height: 28,
            ),
            quill.QuillEditor.basic(controller: _controller, readOnly: true)
          ],
        ),
      ),
    );
    
  }
}
