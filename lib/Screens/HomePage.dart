// ignore_for_file: unused_import

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '/data/models/note_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_flutter/CRUDoperaiton.dart';
import 'package:todo_flutter/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'LogIn.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'EditingPage.dart';
import 'dart:async';

final CollectionReference _collectionReference =
    FirebaseFirestore.instance.collection('users');

class HomePage extends StatefulWidget {
  final String? email;
  const HomePage({Key? key, required this.email}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Note> notesData = [];

  var docs;

//
  getData() async {
    print("test");
    CrudFireStore _crud = CrudFireStore();
    notesData = await _crud
        .readNote(); //so you have created the user a global variable, so therfore we can directly access it there
    setState(() {
      isLoading = false;
    });
  }

  deleteRow(int index) {
    _firestore.collection('notes').doc(notesData[index].docId).delete();
  }

// msg me on discord if any help is needed ok
  FirebaseAuth _auth = FirebaseAuth.instance;

  checkLogin() async {
    _auth.authStateChanges().listen((event) {
      if (event == null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return SignIn();
        }));
      }
    });
  }

  String searchres = "";
  @override
  initState() {
    super.initState();
    getData();
    // getUsers();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Phoenix(
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
                elevation: 20,
                collapsedHeight: 200,
                expandedHeight: 200,
                flexibleSpace: Container(
                  height: 500,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      gradient: LinearGradient(
                        colors: [Colors.blue, Colors.red],
                      ),
                      borderRadius: BorderRadius.vertical(
                          bottom: Radius.elliptical(100, 50))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.2,
                      ),
                      Center(
                        child: Text(
                          'Notes',
                          style: GoogleFonts.abhayaLibre(
                              fontSize: 50, color: Colors.grey.shade300),
                        ),
                      )
                    ],
                  ),
                ),
                floating: true,
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                        bottom: Radius.elliptical(400, 900)))),
            if (isLoading)
              SliverToBoxAdapter(
                child: Padding(
                    padding: EdgeInsets.only(top: 250),
                    child: Center(child: CircularProgressIndicator())),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Padding(
                      padding: (index == 0)
                          ? EdgeInsets.only(top: 16.0, bottom: 8)
                          : EdgeInsets.only(top: 8, bottom: 8),
                      child: Dismissible(
                        direction: DismissDirection.horizontal,
                        onDismissed: (left) {
                          deleteRow(index);
                        },
                        key: UniqueKey(),
                        background: Container(
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.09,
                                ),
                                Icon(Icons.delete),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                ),
                                Icon(Icons.delete)
                              ],
                            )),
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddOrEdit(
                                            onUpdate: (Note note) {
                                              if (notesData.any((_note) =>
                                                  _note.docId == note.docId)) {
                                                notesData[(notesData
                                                        .map((e) => e.docId)
                                                        .toList()
                                                        .indexOf(note.docId))] =
                                                    note;
                                              } else {
                                                notesData.add(note);
                                              }
                                              setState(() {});
                                              return null;
                                            },
                                            add: 'Save',
                                            header: 'Edit Note',
                                            del: 1,
                                            note: notesData[index],
                                          )));
                            },
                            child: Center(
                              child: SingleChildScrollView(
                                child: SizedBox(
                                    height:
                                        MediaQuery.of(context).size.width * 0.3,
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: SingleChildScrollView(
                                      child: Card(
                                        elevation: 20,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            ListTile(
                                              title: Center(
                                                child: Text(
                                                    notesData[index].title),
                                              ),
                                              subtitle:
                                                  Text(notesData[index].desc),
                                              isThreeLine: true,
                                              visualDensity:
                                                  VisualDensity.comfortable,
                                            )
                                          ],
                                        ),
                                      ),
                                    )),
                              ),
                            )),
                      ),
                    );
                  },
                  childCount: notesData.length,
                ),
              ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddOrEdit(
                          onUpdate: (Note note) {
                            if (notesData
                                .any((_note) => _note.docId == note.docId)) {
                              notesData[(notesData
                                  .map((e) => e.docId)
                                  .toList()
                                  .indexOf(note.docId))] = note;
                            } else {
                              notesData.add(note);
                            }
                            setState(() {});
                            return null;
                          },
                          add: 'Create',
                          header: 'Create Note!',
                          del: 0,
                          note: null,
                        )));
          },
          elevation: 20,
          backgroundColor: Colors.grey.shade300,
          child: Icon(
            Icons.add,
            color: Colors.black,
            size: 40,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        drawer: Center(
            child: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                      gradient:
                          LinearGradient(colors: [Colors.blue, Colors.red])),
                  accountName: Text(''),
                  accountEmail: Center(
                    child: Text(
                      widget.email!,
                      style: GoogleFonts.abhayaLibre(
                          fontSize: 20, color: Colors.black),
                    ),
                  )),
              SizedBox(
                height: 500,
              ),
              GestureDetector(
                onTap: () {
                  _signOut();
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 40,
                  child: Container(
                    child: Center(
                        child: Text('Log Out', style: TextStyle(fontSize: 20))),
                    decoration:
                        BoxDecoration(color: Colors.grey.shade300, boxShadow: [
                      BoxShadow(
                        offset: Offset(4, 4),
                        blurRadius: 10,
                        spreadRadius: 5,
                        color: Colors.grey.shade600,
                      ),
                      BoxShadow(
                        offset: Offset(-4, -4),
                        blurRadius: 5,
                        spreadRadius: 1,
                        color: Colors.grey.shade200,
                      )
                    ]),
                  ),
                ),
              )
            ],
          ),
        )),
      ),
    );
  }

  _signOut() async {
    await _auth.signOut().then((value) => Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignIn())));
  }
}
