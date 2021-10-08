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
import 'LogIn.dart';
import 'EditingPage.dart';
import '';
import 'dart:async';

final CollectionReference _collectionReference =
    FirebaseFirestore.instance.collection('users');

class HomePage extends StatefulWidget {
  final String title;
  final String desc;
  final int? n;
  const HomePage({Key? key, required this.title, required this.desc, this.n})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? user = FirebaseAuth.instance.currentUser;

  List<Note> notesData = [];

  var docs;

//
  getData() async {
    print("test");
    CrudFireStore _crud = CrudFireStore();
    notesData = await _crud.readNote();
    setState(() {
      isLoading = false;
    });
  }

  deleteRow(int index) {
    final docId = _firestore.collection('notes').doc().id[index.toInt()];

    _firestore.collection('notes').doc(docId).delete();
  }

// msg me on discord if any help is needed ok
  FirebaseAuth _auth = FirebaseAuth.instance;

  var i = 5;

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

//TODO: complete the crud class;

  String _search = ""; //can you print somedata on the console
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
    return Scaffold(
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
                child: Center(
                  child: Opacity(
                    opacity: 0.5,
                    child: Container(
                      height: MediaQuery.of(context).size.width * 0.129,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Center(
                        child: ListTile(
                          leading: Icon(Icons.search),
                          title: TextFormField(
                            decoration: InputDecoration(hintText: 'Search'),
                            onChanged: (search) {
                              searchres = search;
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              floating: true,
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                      bottom: Radius.elliptical(400, 900)))),
          if (isLoading)
            SliverToBoxAdapter(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Dismissible(
                    direction: DismissDirection.horizontal,
                    onDismissed: (left) {
                      deleteRow(index);
                    },
                    key: UniqueKey(),
                    background: Container(
                      color: Colors.grey.shade400,
                      child: Icon(Icons.delete),
                    ),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddOrEdit(
                                  add: 'Save',
                                  header: 'Edit Note',
                                  del: 1,
                                ),
                              ));
                        },
                        child: Center(
                          child: SizedBox(
                              height: MediaQuery.of(context).size.width * 0.3,
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Card(
                                elevation: 20,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    ListTile(
                                      title: Center(
                                        child: Text(
                                            notesData.toList()[index].title),
                                      ),
                                      subtitle:
                                          Text(notesData.toList()[index].desc),
                                      isThreeLine: true,
                                      visualDensity: VisualDensity.comfortable,
                                    )
                                  ],
                                ),
                              )),
                        )),
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
                        add: 'Create',
                        header: 'Create New!',
                        del: 0,
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
            ElevatedButton(onPressed: _signOut, child: Text('Log Out'))
          ],
        ),
      )),
    );
  }

  _signOut() async {
    await _auth.signOut().then((value) => Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignIn())));
  }
}
