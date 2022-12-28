import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instagram/models/user.dart' as model;
import 'storage_methods.dart';
//create a class
class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  
  //signup method inside the class
  Future<String> signUpUser({
    // arguments
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file
  }) async{
    String res = "Some error occurred";

    try{
      if(email.isNotEmpty || password.isNotEmpty || username.isNotEmpty || bio.isNotEmpty || file!=null ){
        //register user
       UserCredential cred = await  _auth.createUserWithEmailAndPassword(email: email, password: password);

     
       // uploading image to storage... we first get the uploadimage function

       String profilePicURL = await StorageMethods().uploadImageToStorage('profilePics',file, false);
       //add user to database
        model.User user = model.User( username:username,
        uid:cred.user!.uid,
        email:email,
        bio:bio,
        followers:[],
        following:[],
        profilePicURL:profilePicURL
        );

       await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
       res = "success";

      }

    }catch(err){
      res = err.toString();
    }
    return res;
  }


  Future<String> signInUser({
    required String email,
    required String password,
  }) async {
    String res = "success";

    try{
      if(email.isNotEmpty || password.isNotEmpty){
        _auth.signInWithEmailAndPassword(email: email, password: password);
      }else{
        res = "Please enter the correct credentials";
      }

    }catch(err){
      res = err.toString();
    }
    return res;
  }



}