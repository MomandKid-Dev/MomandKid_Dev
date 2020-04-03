import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection referance
  final CollectionReference userCollection =
      Firestore.instance.collection('user_info');

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

  Future getUserData() async {
    return await userCollection.document(uid).get();
  }
}
