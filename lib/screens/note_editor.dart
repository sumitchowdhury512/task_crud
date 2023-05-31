import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:Note/style/app_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen({Key? key}) : super(key: key);

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  int color_id = Random().nextInt(AppStyle.cardsColor.length);
  String date = DateTime.now().toString();
  quill.QuillController _controller = quill.QuillController.basic();
  TextEditingController _title = TextEditingController();
  late File _image;
  String image2 = "";
  pickimage() async {
    ImagePicker picker = ImagePicker();
    PickedFile? pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(()  {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        uploadimage(_image);
      }
    });
  }

  Future<String> uploadimage(File image) async {
    String downloadurl;
    var uuid = Uuid();
    final ref =
        FirebaseStorage.instance.ref().child("image/${uuid.v1()}");
    await ref.putFile(image);
    downloadurl = await ref.getDownloadURL();
    image2 = downloadurl;
    return downloadurl;
  }

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              child: TextField(
                controller: _title,
                decoration: InputDecoration(
                    border: InputBorder.none, helperText: "Note Title"),
                style: AppStyle.mainTitle,
              ),
            ),
            SizedBox(
              height: 28,
            ),
            InkWell(
              onTap: () {
                pickimage();
              },
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: image2 != ""
                    ? Image.file(
                        _image,
                        height: 100,
                        width: 100,
                      )
                    : Center(
                        child: Text(
                        "Upload image",
                        style: TextStyle(color: Colors.white),
                      )),
              ),
            ),
            SizedBox(
              height: 18,
            ),
            quill.QuillToolbar.basic(
              controller: _controller,
              toolbarIconSize: 15,
              iconTheme: quill.QuillIconTheme(
                  borderRadius: 10, iconSelectedFillColor: Colors.orange),
            ),
            SizedBox(
              height: 18,
            ),
            Container(
                color: Colors.white,
                child: quill.QuillEditor.basic(
                    controller: _controller, readOnly: false))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: AppStyle.accentColor,
          child: Icon(Icons.save),
          onPressed: () {
            if (_title.text.isEmpty) {
              // Fluttertoast.showToast(msg: "Enter Title",
              //     backgroundColor:Colors.white
              // );
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Enter Title")));
            } else {
              var uuid = Uuid();
              var json = jsonEncode(_controller.document.toDelta().toJson());
              FirebaseFirestore.instance.collection("Notes").add({
                "uniq_id": uuid.v1(),
                "check_box": false,
                "note_title": _title.text,
                "note_description": json,
                "creation_date": date,
                "color_id": color_id,
                "image": image2
              }).then((value) => Navigator.pop(context));

              // .catchError((e) => print("fails" + e.toString()));
            }
          }),
    );
  }
}
