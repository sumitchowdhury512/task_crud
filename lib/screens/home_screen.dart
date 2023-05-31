import 'package:Note/style/app_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'note_editor.dart';
import 'note_reader.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  update(note, value) async {
    QuerySnapshot<Map<String, dynamic>> collection =
        await FirebaseFirestore.instance
            .collection("Notes")
            .where("uniq_id", isEqualTo: note['uniq_id']).get();
    if(collection.docs.isNotEmpty){
      String docID = collection.docs.first.id;
      FirebaseFirestore.instance.collection("Notes").doc(docID).update({
        "check_box": value
      });
    }else{
      print("error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.mainColor,
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Notes"),
        centerTitle: true,
        backgroundColor: AppStyle.mainColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Your Recent Notes",
                style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12)),
            SizedBox(
              height: 20.0,
            ),
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("Notes")
                      .orderBy("creation_date", descending: true)
                      .snapshots(),
              // instance.collection("Notes").snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (child, index) {
                        var note = snapshot.data!.docs[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>NoteReaderScreen(note)));
                          },
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            margin: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                color: AppStyle.cardsColor[note['color_id']],
                                borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      activeColor: AppStyle.mainColor,
                                        value: note['check_box'],
                                        onChanged: (value) {
                                          update(note, value);
                                        }),
                                    Text(note['note_title'],
                                    style: AppStyle.mainTitle.copyWith(
                                      decoration: note['check_box'] == true? TextDecoration.lineThrough:TextDecoration.none
                                    ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      });
                }
                return Text(
                  "There's no Notes",
                  style: GoogleFonts.nunito(color: Colors.white),
                );
              },
            )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NoteEditorScreen()));
        },
        backgroundColor: AppStyle.bgColor,
        icon: Icon(
          Icons.add,
          color: AppStyle.mainColor,
        ),
        label: Text(
          "Add Note",
          style: TextStyle(color: AppStyle.mainColor),
        ),
      ),
    );
  }
}
