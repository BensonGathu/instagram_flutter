import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';



class StorageMethods{

  //instantiating 
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //adding image to firebase storage
  Future<String> uploadImageToStorage(String childName, Uint8List file, bool isPost) async {

    // creating location to our firebase storage
    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);

        if(isPost){
          String id = const Uuid().v1();
          ref = ref.child(id);
        }

    // putting in uint8list format -> Upload task like a future but not future
    UploadTask uploadTask = ref.putData(
      file
    );

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }


  //adding post to firebase storage
  // Future<String> uploadPostToStorage(String childName, Uint8List file, bool isPost, String description) async {

  //   //creating location in our firebase storage
  //   Reference ref = _storage.ref().child(childName).child(_auth.currentUser!.uid);

  //   UploadTask uploadTask = ref.putData(file);

  //   TaskSnapshot snapshot = await uploadTask;
  //   String downloadUrl = await snapshot.ref.getDownloadURL();
  //   return downloadUrl;

  // }

}

