import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection referance
  final CollectionReference userCollection =
      Firestore.instance.collection('user_info');
  final CollectionReference postCollection =
      Firestore.instance.collection('post');
  final CollectionReference uidpostCollection =
      Firestore.instance.collection('uid_post');

  Future createUserData(String image, String name, String email) async {
    return await userCollection.document(uid).setData({
      'image': image,
      'name': name,
      'email': email,
      'amount-baby': 0,
      'amount-story': 0,
      'notification': false,
    });
  }

  Future createPost(String content, String image) async {
    DateTime time = DateTime.now();
    return await postCollection.add({
      'uid': uid,
      'content': content,
      'image': image,
      'time': time,
    }).then((value) => saveuidpost(value.documentID,time));
  }

  Future saveuidpost(String post,DateTime time) async {
    return await uidpostCollection.document(uid).setData({
      post: time
    }, merge: true);
  }

  Future getUserData() async {
    return await userCollection.document(uid).get();
  }

}
