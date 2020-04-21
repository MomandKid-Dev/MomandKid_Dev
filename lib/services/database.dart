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
  final CollectionReference commentCollection =
      Firestore.instance.collection('comment');
  final CollectionReference pidcommentCollection =
      Firestore.instance.collection('pid_comment');

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
      'likecount' : 0,
      'commentcount' : 0,
      'likes' : []
    }).then((value) => saveuidpost(value.documentID,time));
  }

  Future createComment(String pid, String content) async {
    DateTime time = DateTime.now();
    return await commentCollection.add({
      'pid': pid,
      'uid': uid,
      'content': content,
      'time': time,
    }).then((value){
      savepidcomment(pid,value.documentID,time);
      increaseCommentCount(pid);
    });
  }

  Future createLike(String pid) async {
    return await postCollection.document(pid).updateData(
      {
        'likecount' : FieldValue.increment(1),
        'likes': FieldValue.arrayUnion(List.from([uid]))
      }
    );
  }

  Future removeLike(String pid) async {
    return await postCollection.document(pid).updateData(
      {
        'likecount' : FieldValue.increment(-1),
        'likes': FieldValue.arrayRemove(List.from([uid]))
      }
    );
  }

  Future saveuidpost(String post,DateTime time) async {
    return await uidpostCollection.document(uid).setData({
      post: time
    }, merge: true);
  }

  Future savepidcomment(String post,String comment,DateTime time) async {
    return await pidcommentCollection.document(post).setData({
      comment: time
    }, merge: true);
  }

  Future getUserData() async {
    return await userCollection.document(uid).get();
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

  Future getCommentData(String cid) async {
    return await commentCollection.document(cid).get();
  }

  Future getUserFromComment(DocumentSnapshot comment) async {
    return await userCollection.document(comment.data['uid']).get();
  }

  Future increaseCommentCount(String pid) async {
    return await postCollection.document(pid).updateData(
      {
        'commentcount': FieldValue.increment(1)
      }
    );
  }

  
}
