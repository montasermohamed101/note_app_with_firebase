import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:note_app/crud/editnotes.dart';
import 'package:note_app/crud/viewnotes.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {



  getUser(){
    var user = FirebaseAuth.instance.currentUser;
    print(user!.email);
  }

  CollectionReference notesRef = FirebaseFirestore.instance.collection('notes');

  var fbm = FirebaseMessaging.instance;

  initialMessage() async{

 RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();

 if(message != null){
   Navigator.of(context).pushNamed('addnotes');
 }
  }


  @override
  void initState() {
    super.initState();
   initialMessage();

    fbm.getToken().then((token) {
      print(token);
    });

    // FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //
    //   Navigator.of(context).pushNamed('addnotes');
    // });

    // FirebaseMessaging.onMessage.listen((event) {
    //   print('============= Data Notification =============');
    //   print(event.notification!.title);
    //   print('==========================');
    //   AwesomeDialog(context: context,title: 'title',body: Text('${event.notification!.body}')).show();
    // });

    getUser();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      // leading: Text(''),
        actions: [
          IconButton(
              onPressed: ()async{
               await FirebaseAuth.instance.signOut();
               Navigator.of(context).pushReplacementNamed('login');
              },
              icon: Icon(Icons.exit_to_app)
          ),
        ],
      ),
      body: Container(
        child: FutureBuilder(
          future: notesRef.where('userid',isEqualTo: FirebaseAuth.instance.currentUser!.uid).get(),
          builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapShot){
            if(snapShot.hasData){
             return ListView.builder(
               itemCount: snapShot.data!.docs.length,
               itemBuilder: (context,i){
                 return Dismissible(
                   onDismissed: (direction)async{
                   await  notesRef.doc(snapShot.data!.docs[i].id).delete();
                   await FirebaseStorage.instance.refFromURL(snapShot.data!.docs[i]['imageurl']).delete().then((value) {
                     print('delete');
                   });
                   },
                     key: UniqueKey(),
                     child: ListNotes(
                   notes: snapShot.data!.docs[i],
                   docid: snapShot.data!.docs[i].id,
                 ));
               },
             );
            }
            else{
              return Center(child: CircularProgressIndicator(),);
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).pushNamed('addnotes');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class ListNotes extends StatelessWidget {
  final notes;
  final docid;
  ListNotes({this.notes,this.docid});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context){
          return ViewNote(notes: notes,);
        }));
      },
      child: Card(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Image.network('${notes['imageurl']}',
                fit: BoxFit.cover,
                height: 80,
              ),
            ),
             Expanded(
              flex: 3,
              child: ListTile(
                title: Text('${notes['title']}'),
                subtitle: Text('${notes['note']}',style: TextStyle(
                  fontSize: 14,
                ),),
                trailing: IconButton(
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context){
                      return EditNotes(docid: docid,list: notes,);
                    }));
                  },
                  icon: Icon(Icons.edit),
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}




