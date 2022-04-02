import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../component/alert.dart';

class Login extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();
}




class _LoginState extends State<Login> {
  var mypassword, myemail;
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();

  signIn() async {
    var formdata = formstate.currentState;
    if (formdata!.validate()) {
      formdata.save();

      try {
       showLoading(context);
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
            email: myemail,
            password: mypassword
        );
        return userCredential;

      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Navigator.of(context).pop();
          AwesomeDialog(
              context: context,
              title: "Error",
              body: Text("No user found for that email")).show();
        } else if (e.code == 'wrong-password') {
          Navigator.of(context).pop();
          AwesomeDialog(
              context: context,
              title: "Error",
              body: Text("Wrong password provided for that user")).show();
        }
      }
    } else {
      print("Not Vaild");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Image.asset("assets/ramadan.jpg")),
            Container(
              padding: EdgeInsets.all(20),
              child: Form(
                  key: formstate,
                  child: Column(
                    children: [
                      TextFormField(
                        onSaved: (val) {
                          myemail = val;
                        },
                        validator: (val) {
                          if (val!.length > 100) {
                            return "Email can't to be larger than 100 letter";
                          }
                          if (val.length < 2) {
                            return "Email can't to be less than 2 letter";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          hintText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(width: 1, color: Colors.blue),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        onSaved: (val) {
                          mypassword = val;
                        },
                        validator: (val) {
                          if (val!.length > 100) {
                            return "Password can't to be larger than 100 letter";
                          }
                          if (val.length < 4) {
                            return "Password can't to be less than 4 letter";
                          }
                          return null;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          hintText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(width: 1, color: Colors.blue),
                          ),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Text("if you havan't accout "),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushReplacementNamed("signup");
                                },
                                child: Text(
                                  "Click Here",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              )
                            ],
                          )),
                      Container(
                          child: ElevatedButton(
                            onPressed: () async {
                              var user = await signIn();
                              if (user != null) {
                              Navigator.of(context).pushReplacementNamed('homepage');
                              }
                            },
                            child: const Text(
                              "Sign in",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ))
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
  // showLoading(context) {
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text("Please Wait"),
  //           content: Container(
  //               height: 50,
  //               child: Center(
  //                 child: CircularProgressIndicator(),
  //               )),
  //         );
  //       });
  // }

}

/*

showLoading(context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Please Wait"),
          content: Container(
              height: 50,
              child: Center(
                child: CircularProgressIndicator(),
              )),
        );
      });
}


*/
