import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_flutter/CRUDoperaiton.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_flutter/Screens/HomePage.dart';
import 'package:todo_flutter/data/models/note_model.dart';
import 'package:firebase_core/firebase_core.dart';

class AddOrEdit extends StatefulWidget {
  final String header;
  final int del;
  final String add;
  final Note? note;
  final Function(Note) onUpdate;
  AddOrEdit({
    Key? key,
    required this.note,
    required this.onUpdate,
    required this.header,
    required this.del,
    required this.add,
  }) : super(key: key);

  _AddOrEditState createState() => _AddOrEditState();
}

class _AddOrEditState extends State<AddOrEdit> {
  String _description = "";
  String _title = "";

  CrudFireStore _crudFireStore = CrudFireStore();

  Map<String, dynamic> userInput = {};

  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  deleteDatabase() async {
    _firebaseFirestore
        .collection('notes')
        .doc(widget.note!.docId)
        .delete()
        .then((value) {
      Navigator.pop(context);
    });
  }

  addDataToDb(Note note) async {
    Note newNote = await CrudFireStore.addNote(note);
    Navigator.pop(context);
    widget.onUpdate(newNote);
  }

  updateDb(String title, String desc) async {
    widget.note!.title = title;
    widget.note!.desc = desc;
    await CrudFireStore.updateNote(widget.note!);
    widget.onUpdate(widget.note!);
    Navigator.pushReplacement(
        //another problem when the useer add data he returns to the homescreen but the data shown is updated only when he reloads the app how to make it happen at realtime? its simple, call a callback function onUpdate in the paramters of this class, there update the model by class you meant the model class that we made right?okay
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(
                  email: '',
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          //The neumorphic effect
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(4, 4),
                                blurRadius: 15,
                                spreadRadius: 3,
                                color: Colors.grey.shade500),
                            BoxShadow(
                                offset: Offset(-4, -4),
                                blurRadius: 15,
                                spreadRadius: 3,
                                color: Colors.grey.shade300)
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(70))),
                      child: Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    widget.header,
                    style: GoogleFonts.allerta(
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.2,
              ),
              SingleChildScrollView(
                  child: SizedBox(
                height: MediaQuery.of(context).size.width * 0.8,
                width: MediaQuery.of(context).size.width * 0.8,
                child: SingleChildScrollView(
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 20,
                    child: SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: MediaQuery.of(context).size.width * 0.1,
                            ),
                            ListTile(
                              leading: Icon(Icons.title),
                              title: TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'Enter title',
                                ),
                                onChanged: (title) {
                                  _title = title;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ListTile(
                              leading: Icon(Icons.description),
                              title: TextFormField(
                                decoration: InputDecoration(
                                    hintText: 'Enter description'),
                                onChanged: (desc) {
                                  _description = desc;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            widget.del == 1
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      ElevatedButton(
                                        onPressed: () {
                                          updateDb(
                                            _title,
                                            _description,
                                          );
                                        },
                                        child: Text(
                                          widget.add,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            elevation: 10,
                                            primary: Colors.grey.shade200,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10))),
                                      ),
                                      (ElevatedButton(
                                        onPressed: () {
                                          deleteDatabase();
                                        },
                                        child: Text(
                                          'Delete',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            elevation: 10,
                                            primary: Colors.red.shade200,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10))),
                                      ))
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: //okay it is working but therre is some other bugs I that is because
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                        ElevatedButton(
                                          onPressed: () {
                                            addDataToDb(Note(
                                              //ENTER THE DATA HERE
                                              desc: _description,
                                              title: _title,
                                              docId: null,
                                              uid: user!.uid, //it looks fine
                                            ));
                                          },
                                          child: Text(
                                            widget.add,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                              elevation: 10,
                                              primary: Colors.grey.shade200,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10))),
                                        )
                                      ]),
                          ]),
                    ),
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
