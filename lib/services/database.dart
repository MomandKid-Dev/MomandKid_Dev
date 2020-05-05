import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class DatabaseService {
  // this is data control of user info
  // create user info collection in firebase
  Future<void> createUserInfo(String name, String email, String image);

  // this is data control of baby info
  // create baby info collection in firebase
  Future createBabyInfo(
      String babyName,
      String babyGender,
      Timestamp babyBirthDate,
      double babyHeight,
      double babyWeight,
      String babyImage);

  Future<void> saveUID_Baby(String babyId, String babyName);

  // this is data control of health page
  // create height log collection in firebase
  createHeightLog(double babyHeight, Timestamp dateHeight, String babyId,
      dynamic subVal, dynamic age, Timestamp lastModified);

  Future<void> saveKID_Height(
      String heightLogId, Timestamp dateHeight, String babyId);

  // create weight log collection in firebase
  createWeightLog(double babyWeight, Timestamp dateWeight, String babyId,
      dynamic subVal, dynamic age, Timestamp lastModified);

  Future<void> saveKID_Weight(
      String weightLogId, Timestamp dateWeight, String babyId);

  // create midicine log collection in firebase
  createMedicineLog(String nameMedicine, Timestamp dateMedicine, String babyId,
      dynamic subVal, dynamic age, Timestamp lastModified);

  Future<void> saveKID_Medicine(
      String medicineLogId, Timestamp dateMedicine, String babyId);

  // create vaccine log collection in firebase
  createVaccineLog(String nameVaccine, Timestamp dateVaccine, String babyId,
      dynamic subVal, dynamic dueDate, dynamic age, Timestamp lastModified);

  Future<void> saveKID_Vaccine(
      String vaccineLogId, Timestamp dateVaccine, String babyId);

  // create develope log collection in firebase
  createDevelopeLog(
      String nameDavelope,
      Timestamp dateDevelope,
      String babyId,
      dynamic subVal,
      dynamic dueDate,
      dynamic age,
      int stat,
      Timestamp lastModified);

  Future<void> saveKID_Develope(
      String developeLogId, Timestamp dateDevelope, String babyId);
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
  final CollectionReference storyCollection =
      Firestore.instance.collection('story');
  final CollectionReference kidstoryCollection =
      Firestore.instance.collection('kid_story');

  // collection health
  final CollectionReference heightCollection =
      Firestore.instance.collection('height_log');
  final CollectionReference kidHeight =
      Firestore.instance.collection('kid_height');
  final CollectionReference weightCollection =
      Firestore.instance.collection('weight_log');
  final CollectionReference kidWeight =
      Firestore.instance.collection('kid_weight');
  final CollectionReference medicineCollection =
      Firestore.instance.collection('medicine_log');
  final CollectionReference kidMedicine =
      Firestore.instance.collection('kid_medicine');
  final CollectionReference vaccineCollection =
      Firestore.instance.collection('vaccine_log');
  final CollectionReference kidVaccine =
      Firestore.instance.collection('kid_vaccine');
  final CollectionReference developeCollection =
      Firestore.instance.collection('develope_log');
  final CollectionReference kidDevelope =
      Firestore.instance.collection('kid_develope');

  final CollectionReference vaccineInfo =
      Firestore.instance.collection('vaccine');
  final CollectionReference vaccineList =
      Firestore.instance.collection('vaccine_list');
  final CollectionReference developeInfo =
      Firestore.instance.collection('develope');
  final CollectionReference developeList =
      Firestore.instance.collection('develope_list');

  // Create user info in firebase (user_info)
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

  // create baby info in firebase (baby_info)
  Future createBabyInfo(
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
      'date': Timestamp.fromDate(DateTime.now()),
    }).then((value) {
      // update amount baby in user info
      userCollection
          .document(userId)
          .updateData({'amount-baby': FieldValue.increment(1)});

      // call function keep KID ane baby name in uid_baby
      saveUID_Baby(value.documentID, babyName);
      return value;
    });
  }

  // keep KID in UID (uid_baby)
  Future<void> saveUID_Baby(String babyId, String babyName) async {
    print('UID: $userId');
    return await uidBaby
        .document(userId)
        .setData({babyId: babyName}, merge: true);
  }

  // get KID from UID (uid_baby)
  getBabyId() async {
    dynamic babyId;
    await uidBaby.document(userId).get().then((val) {
      babyId = val.data.keys.toList();
    });
    return babyId;
  }

  // get baby info from firestore (baby_info)
  getBabyInfo(String babyId) async {
    return await babyCollection.document(babyId).get();
  }

  // map baby info with babyId
  getBaby(List<String> babyId) async {
    return await Future.wait(babyId.map((baby) => getBabyInfo(baby)));
  }

  // update kid data
  updateBaby(
      String babyId, String name, String gender, Timestamp birthDate) async {
    await babyCollection
        .document(babyId)
        .updateData({'name': name, 'gender': gender, 'birthdate': birthDate});
  }

  // delete kid data
  Future deleteBabyInfo(String babyId) async {
    return await babyCollection.document(babyId).delete().then((val) {
      userCollection
          .document(userId)
          .updateData({'amount-baby': FieldValue.increment(-1)});
    }).whenComplete(() => deleteBabyId(babyId));
  }

  // delete kid in uid
  deleteBabyId(String babyId) {
    uidBaby.document(userId).updateData({babyId: FieldValue.delete()});
  }

  Future createPost(String content, String image) async {
    DateTime time = DateTime.now();
    return await postCollection.add({
      'uid': userId,
      'content': content,
      'image': image,
      'time': time,
      'likecount': 0,
      'commentcount': 0,
      'likes': []
    }).then((value) => saveuidpost(value.documentID, time));
  }

  Future createComment(String pid, String content) async {
    DateTime time = DateTime.now();
    return await commentCollection.add({
      'pid': pid,
      'uid': userId,
      'content': content,
      'time': time,
    }).then((value) {
      savepidcomment(pid, value.documentID, time);
      increaseCommentCount(pid);
      return value;
    });
  }

  Future createSchedule(String title, String description, DateTime timeset,
      int color, bool notification) async {
    DateTime time = DateTime.now();
    return await scheduleCollection.add({
      'color': color,
      'description': description,
      'notification': notification,
      'timeset': timeset,
      'title': title,
    }).then((value) {
      saveuidschedule(value.documentID, time);
      return value;
    });
  }

  Future createLike(String pid) async {
    return await postCollection.document(pid).updateData({
      'likecount': FieldValue.increment(1),
      'likes': FieldValue.arrayUnion(List.from([userId]))
    });
  }

  Future removeLike(String pid) async {
    return await postCollection.document(pid).updateData({
      'likecount': FieldValue.increment(-1),
      'likes': FieldValue.arrayRemove(List.from([userId]))
    });
  }

  Future saveuidpost(String post, DateTime time) async {
    return await uidpostCollection
        .document(userId)
        .setData({post: time}, merge: true);
  }

  Future savepidcomment(String post, String comment, DateTime time) async {
    return await pidcommentCollection
        .document(post)
        .setData({comment: time}, merge: true);
  }

  Future saveuidschedule(String schedule, DateTime time) async {
    return await uidscheduleCollection
        .document(userId)
        .setData({schedule: time}, merge: true);
  }

  Future increaseCommentCount(String pid) async {
    return await postCollection
        .document(pid)
        .updateData({'commentcount': FieldValue.increment(1)});
  }

  Future getUserData() async {
    return await userCollection.document(userId).get();
  }

  Future updateUserData(String name) async {
    return await userCollection.document(userId).updateData({'name': name});
  }

  Future updateUserDataNotification(bool notification) async {
    print('noti : $notification');
    return await userCollection
        .document(userId)
        .updateData({'notification': notification});
  }

  Future deleteUserData() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return await userCollection
        .document(userId)
        .delete()
        .then((onValue) => user.delete());
  }

  Future getUserFromPost(DocumentSnapshot post) async {
    return await userCollection.document(post.data['uid']).get();
  }

  Future getPostData(int quantity) async {
    return await postCollection
        .orderBy('time', descending: true)
        .limit(quantity)
        .getDocuments();
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
    return await Future.wait(posts.map((post) => getUserFromPost(post)));
  }

  Future<List<DocumentSnapshot>> getCommentDataFromPost(
      List<String> commentsId) async {
    return await Future.wait(
        commentsId.map((comment) => getCommentData(comment)));
  }

  Future<List<DocumentSnapshot>> getUsersFromComment(
      List<dynamic> comments) async {
    return await Future.wait(
        comments.map((comment) => getUserFromComment(comment)));
  }

  Future<DocumentSnapshot> getScheduleData(String sid) async {
    return await scheduleCollection.document(sid).get();
  }

  Future<DocumentSnapshot> getScheduleFromUser() async {
    return await uidscheduleCollection.document(userId).get();
  }

  Future<List<DocumentSnapshot>> getSchedulesData(
      List<String> schedulesId) async {
    return await Future.wait(
        schedulesId.map((schedule) => getScheduleData(schedule)));
  }

  Future switchNotificationSetting(String sid, bool isSet) async {
    return await scheduleCollection
        .document(sid)
        .updateData({'notification': isSet});
  }

  Future removeSchedule(String sid) async {
    return await scheduleCollection
        .document(sid)
        .delete()
        .whenComplete(() => removeScheduleFromUidSchedule(sid));
  }

  Future removeScheduleFromUidSchedule(String sid) async {
    return await uidscheduleCollection
        .document(userId)
        .updateData({sid: FieldValue.delete()});
  }

  Future updateScheduleDate(String sid, DateTime date) async {
    return await scheduleCollection
        .document(sid)
        .updateData({
          'timeset' : date
        });
  }

  // this is data control of health page
  // create height log collection in firebase (height_log)
  createHeightLog(double babyHeight, Timestamp dateHeight, String babyId,
      dynamic subVal, dynamic age, Timestamp lastModified) async {
    dynamic logId;
    await heightCollection.add({
      'type': 'height',
      'val': babyHeight,
      'subval': subVal,
      'date': dateHeight,
      'year': age.years,
      'month': age.months,
      'day': age.days,
      'last_modified': lastModified,
    }).then((value) {
      saveKID_Height(value.documentID, dateHeight, babyId);
      logId = value.documentID;
    });
    return logId;
  }

  // keep height log id in KID (kid_height)
  Future<void> saveKID_Height(
      String heightLogId, Timestamp dateHeight, String babyId) async {
    return await kidHeight
        .document(babyId)
        .setData({heightLogId: dateHeight}, merge: true);
  }

  // get height log id from KID
  getHeightLogId(String babyId) async {
    dynamic heightLogId;
    await kidHeight.document(babyId).get().then((value) {
      if (value.data == null) {
        return null;
      }
      heightLogId = value.data.keys.toList();
    });
    return heightLogId;
  }

  // get height log data
  getHeightLog(String heightLogId) async {
    return await heightCollection.document(heightLogId).get();
  }

  // update height data
  updateHeight(double babyHeight, String babyId) async {
    await babyCollection.document(babyId).updateData({'height': babyHeight});
  }

  // delete height log data
  deleteHeightLog(String babyId, String logId) async {
    await heightCollection
        .document(logId)
        .delete()
        .whenComplete(() => deleteHeightLogId(babyId, logId));
  }

  // delete height log id from KID
  deleteHeightLogId(String babyId, String logId) async {
    await kidHeight.document(babyId).updateData({logId: FieldValue.delete()});
  }

  // create weight log collection in firebase (weight_log)
  createWeightLog(double babyWeight, Timestamp dateWeight, String babyId,
      dynamic subVal, dynamic age, Timestamp lastModified) async {
    dynamic logId;
    await weightCollection.add({
      'type': 'weight',
      'val': babyWeight,
      'subval': subVal,
      'date': dateWeight,
      'year': age.years,
      'month': age.months,
      'day': age.days,
      'last_modified': lastModified,
    }).then((value) {
      saveKID_Weight(value.documentID, dateWeight, babyId);
      logId = value.documentID;
    });
    return logId;
  }

  // keep weight log id in KID (kid_weight)
  Future<void> saveKID_Weight(
      String weightLogId, Timestamp dateWeight, String babyId) async {
    return await kidWeight
        .document(babyId)
        .setData({weightLogId: dateWeight}, merge: true);
  }

  // get weight log id from KID
  getWeightLogId(String babyId) async {
    dynamic weightLogId;
    await kidWeight.document(babyId).get().then((value) {
      if (value.data == null) {
        return null;
      }
      weightLogId = value.data.keys.toList();
    });
    return weightLogId;
  }

  // get weight log data
  getWeightLog(String weightLogId) async {
    return await weightCollection.document(weightLogId).get();
  }

  // update weight data
  updateWeight(double babyWeight, String babyId) async {
    await babyCollection.document(babyId).updateData({'weight': babyWeight});
  }

  // delete weight log data
  deleteWeightLog(String babyId, String logId) async {
    await weightCollection
        .document(logId)
        .delete()
        .whenComplete(() => deleteWeightLogId(babyId, logId));
  }

  // delete Weight log id from KID
  deleteWeightLogId(String babyId, String logId) async {
    await kidWeight.document(babyId).updateData({logId: FieldValue.delete()});
  }

  // create medicine log collection in firebase (medicine_log)
  createMedicineLog(String nameMedicine, Timestamp dateMedicine, String babyId,
      dynamic subVal, dynamic age, Timestamp lastModified) async {
    dynamic logId;
    await medicineCollection.add({
      'type': 'med',
      'val': nameMedicine,
      'subval': subVal,
      'date': dateMedicine,
      'year': age.years,
      'month': age.months,
      'day': age.days,
      'last_modified': lastModified,
    }).then((value) {
      saveKID_Medicine(value.documentID, dateMedicine, babyId);
      logId = value.documentID;
    });
    return logId;
  }

  // keep medicine log id in KID (kid_medicine)
  Future<void> saveKID_Medicine(
      String medicineLogId, Timestamp dateMedicine, String babyId) async {
    return await kidMedicine
        .document(babyId)
        .setData({medicineLogId: dateMedicine}, merge: true);
  }

  // get medicine log id from KID
  getMedicineLogId(String babyId) async {
    dynamic medicineLogId;
    await kidMedicine.document(babyId).get().then((value) {
      if (value.data == null) {
        return null;
      }
      medicineLogId = value.data.keys.toList();
    });
    return medicineLogId;
  }

  // get medicine log data
  getMedicineLog(String medicineLogId) async {
    return await medicineCollection.document(medicineLogId).get();
  }

  // delete medicine log data
  deleteMedicineLog(String babyId, String logId) async {
    await medicineCollection
        .document(logId)
        .delete()
        .whenComplete(() => deleteMedicineLogId(babyId, logId));
  }

  // delete medicine log id from KID
  deleteMedicineLogId(String babyId, String logId) async {
    await kidMedicine.document(babyId).updateData({logId: FieldValue.delete()});
  }

  // get vaccine data from firebase
  getVaccineData(String vaccineId) async {
    return await vaccineInfo.document(vaccineId).get();
  }

  // get vaccine list from firebase
  getVaccineList(String vaccineDue) async {
    dynamic vaccineListA;
    await vaccineList.document(vaccineDue).get().then((value) {
      if (value.data == null) {
        return null;
      }
      vaccineListA = value.data.keys.toList();
    });
    return vaccineListA;
  }

  // create vaccine log in firebase (vaccine_log)
  Future createVaccineLog(
      String nameVaccine,
      Timestamp dateVaccine,
      String babyId,
      dynamic subVal,
      dynamic dueDate,
      dynamic age,
      Timestamp lastModified) async {
    return await vaccineCollection.add({
      'type': 'vac',
      'val': nameVaccine,
      'subval': subVal,
      'date': dateVaccine,
      'due_date': dueDate,
      'stat': 0,
      'year': age.years,
      'month': age.months,
      'day': age.days,
      'last_modified': lastModified,
    }).then((value) {
      saveKID_Vaccine(value.documentID, dateVaccine, babyId);
      return value;
    });
  }

  Future getAllVaccineData() async {
    return await vaccineInfo
        .orderBy('due_date')
        .getDocuments()
        .then((vaccineIds) {
      return (vaccineIds.documents.map((vaccineId) => vaccineId.data)).toList();
    });
  }

  // keep vaccine log id in KID (kid_vaccine)
  Future<void> saveKID_Vaccine(
      String vaccineLogId, Timestamp dateVaccine, String babyId) async {
    return await kidVaccine
        .document(babyId)
        .setData({vaccineLogId: dateVaccine}, merge: true);
  }

  // get vaccine log id from KID
  getVaccineLogId(String babyId) async {
    dynamic vaccineLogId;
    await kidVaccine.document(babyId).get().then((value) {
      if (value.data == null) {
        return null;
      }
      vaccineLogId = value.data.keys.toList();
    });
    return vaccineLogId;
  }

  // get vaccine log data
  getVaccineLog(String vaccineLogId) async {
    return await vaccineCollection.document(vaccineLogId).get();
  }

  // update stat
  updateVaccineLog(String logId, int val, Timestamp lastModified) async {
    return await vaccineCollection.document(logId).updateData({
      'stat': val,
      'last_modified': lastModified,
    });
  }

  // delete vaccine data
  deleteVaccineLog(String logId) async {
    await vaccineCollection.document(logId).delete();
  }

  // delete vaccine id
  deleteVaccineId(String babyId) async {
    kidVaccine.document(babyId).delete();
  }

  // get develope data from firebase
  getDevelopeData(String developeId) async {
    return await developeInfo.document(developeId).get();
  }

  // get develope list from firebase
  getDevelopeList(String developeDue) async {
    dynamic developeListA;
    await developeList.document(developeDue).get().then((value) {
      if (value.data == null) {
        return null;
      }
      developeListA = value.data.keys.toList();
    });
    return developeListA;
  }

  // create develope log in firebase (develope_log)
  Future createDevelopeLog(
      String nameDevelope,
      Timestamp dateDevelope,
      String babyId,
      dynamic subVal,
      dynamic dueDate,
      dynamic age,
      int stat,
      Timestamp lastModified) async {
    return await developeCollection.add({
      'type': 'evo',
      'val': nameDevelope,
      'subval': subVal,
      'date': dateDevelope,
      'due_date': dueDate,
      'stat': stat,
      'year': age.years,
      'month': age.months,
      'day': age.days,
      'last_modified': lastModified,
    }).then((value) {
      saveKID_Develope(value.documentID, dateDevelope, babyId);
      return value;
    });
  }

  // keep develope log id in KID (kid_develope)
  Future<void> saveKID_Develope(
      String developeLogId, Timestamp dateDevelope, String babyId) async {
    return await kidDevelope
        .document(babyId)
        .setData({developeLogId: dateDevelope}, merge: true);
  }

  Future getAllDevelope() async {
    return await developeInfo
        .orderBy('due_date')
        .getDocuments()
        .then((developeIds) {
      return (developeIds.documents.map((developeId) => developeId.data))
          .toList();
    });
  }

  // get develope log id from KID
  getDevelopeLogId(String babyId) async {
    dynamic developeLogId;
    await kidDevelope.document(babyId).get().then((value) {
      if (value.data == null) {
        return null;
      }
      developeLogId = value.data.keys.toList();
    });
    return developeLogId;
  }

  // get develope log data
  getDevelopeLog(String developeLogId) async {
    return await developeCollection.document(developeLogId).get();
  }

  Future updateKidImage(String kid, String url) async {
    return await babyCollection.document(kid).updateData({
      'image' : url
    });
  }

  Future getStoryFromKid(String kid) async {
    return await kidstoryCollection.document(kid).get();
  }

  Future getStoriesFromKid(List<String> kids) async {
    return await Future.wait(kids.map((kid) => getStoryFromKid(kid)));
  }

  Future getStoryData(String sid) async {
    return await storyCollection.document(sid).get();
  }

  Future getStoriesData(List<String> sids) async {
    return await Future.wait(sids.map((sid) => getStoryData(sid)));
  }

  Future createStory(String kid, String title, String coverImg, DateTime date,
      List<dynamic> images) async {
    return await storyCollection.add({
      'title': title,
      'coverImg': coverImg,
      'content': '',
      'date': date,
      'images': images,
    }).then((value) {
      increaseStoryAmount();
      savekidstory(kid, value.documentID, date);
      return value;
    });
  }

  Future increaseStoryAmount() async {
    return await userCollection
        .document(userId)
        .updateData({
          'amount-story': FieldValue.increment(1)
        });
  }

  Future decreaseStoryAmount() async {
    return await userCollection
        .document(userId)
        .updateData({
          'amount-story': FieldValue.increment(-1)
        });
  }

  Future savekidstory(String kid, String story, DateTime date) async {
    return await kidstoryCollection
        .document(kid)
        .setData({story: date}, merge: true);
  }

  Future removeStory(String sid, String kid) async {
    return await storyCollection
        .document(sid)
        .delete()
        .whenComplete(() {
          decreaseStoryAmount();
          removeStoryFromKidStory(kid, sid);
        });
  }

  Future removeStoryFromKidStory(String kid, String sid) async {
    return await kidstoryCollection
        .document(kid)
        .updateData({sid: FieldValue.delete()});
  }

  Future addImageToStory(String sid, String image) async {
    return await storyCollection.document(sid).updateData({
      'images': FieldValue.arrayUnion(List.from([image]))
    });
  }

  Future removeImageFromStory(String sid, String image) async {
    return await storyCollection.document(sid).updateData({
      'images': FieldValue.arrayRemove(List.from([image]))
    });
  }

  Future updateStoryData(
      String sid, String coverImg, String title, String content) async {
    return await storyCollection
        .document(sid)
        .updateData({'coverImg': coverImg, 'title': title, 'content': content});
  }

  Future uploadFile(File _image) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('images/${Uuid().v1()}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('Image Uploaded');
    return await storageReference.getDownloadURL().then((fileURL) {
      return fileURL;
    });
  }

  // update stat
  updateDevelopeLog(String logId, int val, Timestamp dateDevelope, dynamic age,
      Timestamp lastModified) async {
    return await developeCollection.document(logId).updateData({
      'date': dateDevelope,
      'stat': val,
      'year': age.years,
      'month': age.months,
      'day': age.days,
      'last_modified': lastModified,
    });
  }

  // delete develope data
  deleteDavalopeLog(String logId) async {
    await developeCollection.document(logId).delete();
  }

  // delete develope id
  deleteDevelopeId(String babyId) {
    kidDevelope.document(babyId).delete();
  }

  Future setUserProfile(String url) async {
    return await userCollection.document(userId).updateData({'image': url});
  }
}
