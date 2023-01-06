import 'dart:typed_data';

import 'package:instagram/models/post.dart';
import 'package:instagram/models/user.dart' as model;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';
import '../models/user.dart';

class FirestoreMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    Uint8List file,
    String description,
    String uid,
    String username,
    String profImage,
  ) async {
    String res = "Some error occurred";
    // User currentUser = _auth.currentUser!;

    try {
      // uploading image to storage... we first get the uploadimage function
      String phototUrl =
          await StorageMethods().uploadImageToStorage("Posts", file, true);

      String postID = const Uuid().v1();

      //add post to database
      Post post = Post(
          description: description,
          uid: uid,
          username: username,
          postId: postID,
          datePublished: DateTime.now(),
          postUrl: phototUrl,
          profImage: profImage,
          likes: []);

      await _firestore.collection('posts').doc(postID).set(post.toJson());

      res = "sucess";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
       await _firestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayRemove([uid])
        });
      } else {
      await  _firestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
