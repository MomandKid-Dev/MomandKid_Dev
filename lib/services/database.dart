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
  final CollectionReference uidBaby = 
      Firestore.instance.collection('uid_baby');
  final CollectionReference postCollection =
      Firestore.instance.collection('post');
  final CollectionReference uidpostCollection =
      Firestore.instance.collection('uid_post');
  final CollectionReference commentCollection =
      Firestore.instance.collection('comment');
  final CollectionReference pidcommentCollection =
      Firestore.instance.collection('pid_comment');
  final CollectionReference scheduleCollection =
      Firestore.instance.collection('schedule');
  final CollectionReference uidscheduleCollection =
      Firestore.instance.collection('uid_schedule');

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
  Future createPost(String content, String image) async {
    DateTime time = DateTime.now();
    return await postCollection.add({
      'uid': userId,
      'content': content,
      'image': image,
      'time': time,
      'likecount' : 0,
      'commentcount' : 0,
      'likes' : []
    }).then((value) => saveuidpost(value.documentID,time));
  }

  Future createComment(String pid, String content) async {
    DateTime time = DateTime.now();
    return await commentCollection.add({
      'pid': pid,
      'uid': userId,
      'content': content,
      'time': time,
    }).then((value){
      savepidcomment(pid,value.documentID,time);
      increaseCommentCount(pid);
      return value;
    });
  }

  Future createSchedule(String title, String description, DateTime timeset, int color, bool notification) async {
    DateTime time = DateTime.now();
    return await scheduleCollection.add({
      'color': color,
      'description': description,
      'notification': notification,
      'timeset': timeset,
      'title' : title,
    }).then((value) {
      saveuidschedule(value.documentID,time);
      return value;
    });
  }

  Future createLike(String pid) async {
    return await postCollection.document(pid).updateData(
      {
        'likecount' : FieldValue.increment(1),
        'likes': FieldValue.arrayUnion(List.from([userId]))
      }
    );
  }

  Future removeLike(String pid) async {
    return await postCollection.document(pid).updateData(
      {
        'likecount' : FieldValue.increment(-1),
        'likes': FieldValue.arrayRemove(List.from([userId]))
      }
    );
  }

  Future saveuidpost(String post,DateTime time) async {
    return await uidpostCollection.document(userId).setData({
      post: time
    }, merge: true);
  }

  Future savepidcomment(String post,String comment,DateTime time) async {
    return await pidcommentCollection.document(post).setData({
      comment: time
    }, merge: true);
  }

  Future saveuidschedule(String schedule,DateTime time) async {
    return await uidscheduleCollection.document(userId).setData({
      schedule: time
    }, merge: true);
  }

  Future increaseCommentCount(String pid) async {
    return await postCollection.document(pid).updateData(
      {
        'commentcount': FieldValue.increment(1)
      }
    );
  }

  Future getUserData() async {
    return await userCollection.document(userId).get();
  }

  Future getUserFromPost(DocumentSnapshot post) async {
    return await userCollection.document(post.data['uid']).get();
  }

  Future getPostData(int quantity) async {
    return await postCollection.orderBy('time', descending: true).limit(quantity).getDocuments();
  }

  Future getCommentFromPost(String pid) async {
    return await pidcommentCollection.document(pid).get();
  }

  Future<DocumentSnapshot> getCommentData(String cid) async {
    return await commentCollection.document(cid).get();
  }

  Future<DocumentSnapshot> getUserFromComment(DocumentSnapshot comment) async {
    return await userCollection.document(comment.data['uid']).get();
  }

  Future getUserDataFromPost(List<DocumentSnapshot> posts) async {
    return await Future.wait(posts.map((post)=>getUserFromPost(post)));
  }

  Future<List<DocumentSnapshot>> getCommentDataFromPost(List<String> commentsId) async { 
    return await Future.wait(commentsId.map((comment)=>getCommentData(comment)));
  }

  Future<List<DocumentSnapshot>> getUsersFromComment(List<dynamic> comments) async {
    return await Future.wait(comments.map((comment)=>getUserFromComment(comment)));
  }

  Future<DocumentSnapshot> getScheduleData(String sid) async {
    return await scheduleCollection.document(sid).get();
  }

  Future<DocumentSnapshot> getScheduleFromUser() async {
    return await uidscheduleCollection.document(userId).get();
  }

  Future<List<DocumentSnapshot>> getSchedulesData(List<String> schedulesId) async {
    return await Future.wait(schedulesId.map((schedule)=>getScheduleData(schedule)));
  }

  Future switchNotificationSetting(String sid, bool isSet) async {
    return await scheduleCollection.document(sid).updateData(
      {
        'notification': isSet
      }
    );
  }

  Future removeSchedule(String sid) async {
    return await scheduleCollection.document(sid).delete().whenComplete(() => removeScheduleFromUidSchedule(sid));
  }

  Future removeScheduleFromUidSchedule(String sid) async {
    return await uidscheduleCollection.document(userId).updateData({
      sid : FieldValue.delete()
      }
    );
  }
}
