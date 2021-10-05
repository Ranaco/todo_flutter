import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'LogIn.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          SliverList(delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            return ListTile(
              title: Text('hello'),
            );
          }))
        ],
      ),
      drawer: Center(child: Drawer()),
    );
  }
}
