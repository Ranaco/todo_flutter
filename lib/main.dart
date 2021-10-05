import 'package:flutter/material.dart';
import 'Scrrens/LogIn.dart';
import 'package:firebase_core/firebase_core.dart';

main(List<String> args) {
  runApp((MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Todo_firebase',
    home: MyApp(),
  )));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return error();
        } else if (snapshot.connectionState == ConnectionState.done) {
          return SignIn();
        } else {
          return loading();
        }
      },
    );
  }
}

//Loading class
class loading extends StatelessWidget {
  const loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: CircularProgressIndicator(),
    ));
  }
}

//Error class
class error extends StatelessWidget {
  const error({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.error,
              size: 30,
            ),
            Text('Something went wrong!')
          ],
        ),
      ),
    ));
  }
}
