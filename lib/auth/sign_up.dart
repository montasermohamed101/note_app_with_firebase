import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_app/auth/log_in.dart';
import 'package:note_app/component/alert.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var username;
  var email;
  var password;

  final formkey = GlobalKey<FormState>();

  signUp() async {
    var formData = formkey.currentState;
    if (formData!.validate()) {
      formData.save();
      try {
        showLoading(context);
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        return userCredential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Navigator.of(context).pop();
          AwesomeDialog(
              context: context,
              title: 'Error',
              body: Text('Password Is to weak'))..show();
        } else if (e.code == 'email-already-in-use') {
          Navigator.of(context).pop();
          AwesomeDialog(
              context: context,
              title: 'Error',
              body: Text('The account already exists for that email.'))..show();
        }
      } catch (e) {
        print(e);
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/ramadan.jpg'),
            Container(
              padding: EdgeInsets.all(20),
              child: Form(
                key: formkey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        hintText: 'User Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(width: 1, color: Colors.blue),
                        ),
                      ),
                      onSaved: (val) {
                        username = val;
                      },
                      validator: (val) {
                        if (val!.length > 100) {
                          return 'Username cant be larger than 100';
                        } else if (val.length < 2) {
                          return 'Username cant be less than 2';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      onSaved: (val) {
                        email = val;
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email_outlined),
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
                      validator: (val) {
                        if (val!.length > 100) {
                          return 'Email cant be larger than 100';
                        } else if (val.length < 2) {
                          return 'Email cant be less than 2';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      onSaved: (val) {
                        password = val;
                      },
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
                      validator: (val) {
                        if (val!.length > 100) {
                          return 'Password cant be larger than 100';
                        } else if (val.length < 2) {
                          return 'Password cant be less than 2';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'if you have Account  ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => Login()));
                            },
                            child: const Text(
                              'Click Here',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ))
                      ],
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () async{
                        UserCredential response =  await signUp();
                      print('=======================');
                      if(response != null){

                        await FirebaseFirestore.instance.collection('users').add({
                          'username':username,
                          'email':email,
                        });
                        Navigator.of(context).pushReplacementNamed('homepage');
                      }else{
                        print('Sign Up Faild');
                        AwesomeDialog(context: context,title: 'Sign Up Faild',
                            body: Text('Sign Up Faild'))..show();
                      }
                        print('=======================');
                      },
                      child: Text('Sign Up',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
