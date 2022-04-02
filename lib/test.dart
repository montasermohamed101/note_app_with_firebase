import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {


  File? file;
  var imagePicker = ImagePicker();
  var imagePicked;
  uploadImages()async{
     imagePicked = await imagePicker.pickImage(source: ImageSource.gallery);
    if(imagePicked != null){

      file = File(imagePicked.path);

      var nameimage = basename(imagePicked.path);

      var random = Random().nextInt(100000000);

      nameimage = '$random$nameimage';

      var ref = await FirebaseStorage.instance.ref('images/$nameimage');

      await ref.putFile(file!);

      var url = await ref.getDownloadURL();
    }else{
      print('Please Choose Image');
    }
  }

  getImages() async {

    var refImage = await FirebaseStorage.instance.ref().list();

    refImage.items.forEach((element) {
      print('===============');
      print(element.fullPath);
    });
    refImage.prefixes.forEach((element) {
      print('===============');
      print(element.name);
    });

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: ElevatedButton(
            onPressed: () async {
             await uploadImages();
            },
            child: const Text('Upload Image'),
          ),
        ),
      ],
      ),
    );
  }
}
