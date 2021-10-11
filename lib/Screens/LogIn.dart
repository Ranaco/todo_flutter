import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'SignUp.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  //Keys and FirebaseAuth;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // auto validating state;
  var _autoValidate;
  //Credentials and vars;
  String _email = "";
  String _password = "";

  checkAuthentication() async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    if (_auth.currentUser != null) {
      SchedulerBinding.instance!.addPostFrameCallback((_) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          //
          return HomePage(
            email: _auth.currentUser!.email.toString(),
          );
        }));
      });
    }
  }

  @override
  initState() {
    super.initState();
    this.checkAuthentication();
  }

  showError(String errorMessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(''),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade500,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 150,
              ),
              SingleChildScrollView(
                child: Form(
                  autovalidateMode: _autoValidate,
                  key: _formKey,
                  child: Center(
                    child: SingleChildScrollView(
                        child: Card(
                      color: Colors.grey.shade300,
                      elevation: 20,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade300,
                              image: DecorationImage(
                                  image: AssetImage(
                                    'assets/images/signIn.jpeg',
                                  ),
                                  fit: BoxFit.contain),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          ListTile(
                            leading: Icon(Icons.person),
                            title: TextFormField(
                              validator: (email) {
                                if (email!.isEmpty || email.length < 6) {
                                  return "Email is incorrect";
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'Enter your email',
                                labelText: "Email",
                              ),
                              onChanged: (email) {
                                _email = email;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ListTile(
                            leading: Icon(Icons.password),
                            title: TextFormField(
                              validator: (password) {
                                if (password!.isEmpty || password.length < 6) {
                                  return "Incorrect password";
                                }
                              },
                              onChanged: (password) {
                                _password = password;
                              },
                              decoration: InputDecoration(
                                  hintText: 'Password', labelText: 'Password'),
                              obscureText: true,
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              print(_email + " " + _password);

                              _takeToNextScreen();
                            },
                            child: Text(
                              'Sign In',
                              style: TextStyle(color: Colors.black),
                            ),
                            style: ElevatedButton.styleFrom(
                                elevation: 10,
                                primary: Colors.grey.shade300,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)))),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Don't have an account?"),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                  onTap: _takeToSignUp,
                                  child: Container(
                                    child: Text(
                                      'Sign Up!',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _takeToNextScreen() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      FirebaseAuth _auth = FirebaseAuth.instance;
      await _auth
          .signInWithEmailAndPassword(email: _email, password: _password)
          .then((uid) => {
                Fluttertoast.showToast(
                    msg: "login successful", backgroundColor: Colors.white),
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => HomePage(
                          email: _email,
                        )))
              })
          .catchError((e) {
        Fluttertoast.showToast(msg: 'The account is not registered.');
      });
    } else {
      _autoValidate = AutovalidateMode.always;
    }
  }

  _takeToSignUp() async {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SignUpPage()));
  }
}
