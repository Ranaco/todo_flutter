import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'LogIn.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  //Text edititng controllers for email and password;
  String _email = "";
  String _password = "";
  String _confPassword = "";
  TextEditingController _confPass = TextEditingController();
  //A global key for the form;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //Creating the firebase instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 30,
                      color: Colors.grey,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Card(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 250,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AssetImage(
                                  'assets/images/signUp.jpeg',
                                ),
                                fit: BoxFit.fill)),
                      ),
                      SizedBox(height: 20),
                      ListTile(
                        leading: Icon(Icons.email),
                        title: TextFormField(
                          validator: (email) {
                            if (email!.length < 6) {
                              return 'Enter a valid email';
                            }
                          },
                          onChanged: (email) {
                            _email = email;
                          },
                          decoration: InputDecoration(
                              hintText: 'Enter your email', labelText: 'Email'),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.vpn_key),
                        title: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Enter a password',
                            labelText: 'Password',
                          ),
                          validator: (password) {
                            if (password!.length < 6) {
                              return 'The password is too short';
                            }
                          },
                          obscureText: true,
                          onChanged: (password) {
                            _password = password;
                            _confPass.text = password;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ListTile(
                        leading: Icon(Icons.vpn_key),
                        title: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Cofirm password',
                            labelText: 'Confirm Password',
                          ),
                          obscureText: true,
                          validator: (cpassword) {
                            if (cpassword != _password ||
                                _confPass.text != cpassword) {
                              return 'Passwords do not match';
                            }
                          },
                          onChanged: (password) {
                            _confPassword = password;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          print(_email + " " + _password);

                          _confirmSignUp()();
                        },
                        child: Text(
                          'Sign Up',
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
                    ],
                  ),
                  elevation: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _confirmSignUp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await _auth
          .createUserWithEmailAndPassword(email: _email, password: _password)
          .then((value) => {
                Fluttertoast.showToast(msg: 'Sign Up successfull'),
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => SignIn()))
              });
    }
  }
}
