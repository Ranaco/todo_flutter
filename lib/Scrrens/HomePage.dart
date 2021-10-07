import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'LogIn.dart';
import 'EditingPage.dart';
import 'dart:async';

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
  FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference _col = FirebaseFirestore.instance.collection('notes');

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

  String _search = "";
  String searchres = "";

  @override
  initState() {
    super.initState();
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
          SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              return Dismissible(
                onDismissed: (left) {
                  setState(() {});
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
                            title: 'Edit Note',
                            del: 1,
                          ),
                        ));
                  },
                  child: ListTile(
                    title: Center(child: Text(searchres)),
                    subtitle: Center(child: Text('Roll')),
                  ),
                ),
              );
            }, childCount: 4),
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
                        title: 'Create New!',
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
