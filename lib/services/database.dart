import 'package:cloud_firestore/cloud_firestore.dart';

abstract class DatabaseService {
  Future<void> createUserInfo(String name, String email, String image);

  Future<void> createBabyInfo(
      String babyName,
      String babyGender,
      Timestamp babyBirthDate,
      double babyHeight,
      double babyWeight,
      String babyImage);

  Future<void> saveUID_baby(String babyId, String babyName);

  Future<dynamic> getBabyId();

  Future<dynamic> getBabyInfo(String babyId);

  Future<dynamic> getBaby(List<String> babyId);
}

class Database extends DatabaseService {
  // class object
  Database({this.userId});
  final String userId;

  // collection referance
  final CollectionReference userCollection =
      Firestore.instance.collection('user_info');
  final CollectionReference babyCollection =
      Firestore.instance.collection('baby_info');
  final CollectionReference uidBaby = Firestore.instance.collection('uid_baby');

  // Create user info
  Future<void> createUserInfo(String name, String email, String image) async {
    return await userCollection.document(userId).setData({
      'image': image,
      'name': name,
      'email': email,
      'amount-baby': 0,
      'amount-story': 0,
      'notification': false,
    });
  }

  // Create baby info
  Future<void> createBabyInfo(
      String babyName,
      String babyGender,
      Timestamp babyBirthDate,
      double babyHeight,
      double babyWeight,
      String babyImage) async {
    return await babyCollection.add({
      'name': babyName,
      'gender': babyGender,
      'birthdate': babyBirthDate,
      'height': babyHeight,
      'weight': babyWeight,
      'image': babyImage,
    }).then((value) => saveUID_baby(value.documentID, babyName));
  }

  // keep KID in UID <userId>
  Future<void> saveUID_baby(String babyId, String babyName) async {
    print('UID: $userId');
    return await uidBaby
        .document(userId)
        .setData({babyId: babyName}, merge: true);
  }

  // get KID from UID <userId>
  Future<dynamic> getBabyId() async {
    dynamic babyId;
    await uidBaby.document(userId).get().then((val) {
      babyId = val.data.keys.toList();
    });
    return babyId;
  }

  // get baby info from firestore
  Future<dynamic> getBabyInfo(String babyId) async {
    return await babyCollection.document(babyId).get();
  }

  // map data
  Future<dynamic> getBaby(List<String> babyId) async {
    return await Future.wait(babyId.map((baby) => getBabyInfo(baby)));
  }
}
