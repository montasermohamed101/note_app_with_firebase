






/*
method to get data and orderBy anything i want
getData() async {
  CollectionReference usersref =
  FirebaseFirestore.instance.collection('users');

  await usersref.orderBy('age').get().then((value) {
    value.docs.forEach((element) {
      print(element.get('username'));
      print(element.get('age'));
      print('==========================================');

    });
  });
*/


////////////////////////////




/*

 method to get data from firebase
  getData()async{
    DocumentReference doc = FirebaseFirestore.instance
        .collection('users').doc('M2oAURUzQc37Az7Edo3P');

        await doc.get().then((value) {
          print(value.id);
        });

    //this way to get all docs in the collection
    // CollectionReference usersref =
    // FirebaseFirestore.instance.collection('users');
    //
    // await usersref.get().then((value) {
    //   value.docs.forEach((element) {
    //     print(element.data());
    //     print("=======================================");
    //   });
    // });

     de tary2a ageb byha el data mn fire base
     FirebaseFirestore
        .instance.collection('users').get().then((value) {
          value.docs.forEach((element) {
            print(element.data());
          });
    });

    //de tary2a ageb byha el data mn fire base
    // QuerySnapshot querySnapshot  = await usersref.get();
    //
    // List<QueryDocumentSnapshot> listdocs =  querySnapshot.docs;
    //
    // listdocs.forEach((element) {
    //   print(element.data());
    //   print("=======================================");
    // });
  }
 */










////////////////////////////////////







/*
method to get data with where
  getData() async {
    var usersref = FirebaseFirestore.instance.collection('users');

    await usersref.where('lang',arrayContainsAny: ['ar','fr']).get().then((value) {
      value.docs.forEach((element) {
        print(element.data()['username']);
        print('==================================================');
      });
    });
  }
 */