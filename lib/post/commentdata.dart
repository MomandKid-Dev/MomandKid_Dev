
import 'package:cloud_firestore/cloud_firestore.dart';

class Commentdata{
  Commentdata(){

  }
  List<Map<String,dynamic>> comments=[
    {
      'pid':'testpost',
      'uid':'testuser',
      'content':'',
      'time': Timestamp.now()
    }
  ];

  List getComment(String id){
    comments.sort((a,b) => a['time'].compareTo(b['time']));
    return comments;
  }

}

class User{
  List<dynamic> users=[
    {
      'uid':'testuser',
      'userprofile':'https://i.pinimg.com/236x/ae/9f/73/ae9f732d6094233e902ca2bfdc8e2a84.jpg',
      'username':'Loading Comments...',

    }
  ];
  getUsers(String id){
    for(var i = 0; i < users.length; i++){
      if(users[i]['uid'] == id){
        return users[i];
      }
    }
    return null;
  }
  getProfilePic(String id){
    String pic = getUsers(id)['userprofile'];
    if (pic == 'image path' || pic == null || pic == '') return 'https://sketchok.com/images/articles/01-cartoons/002-family-guy/02/08.jpg';
    else return pic;
  }
  getProfileName(String id){
    return getUsers(id)['username'];
  }
}

// class Post{
//   var posts=[
//     {
//       'id':1,
//       'image':'https://pbs.twimg.com/profile_images/1168928962917097472/gD5uWGj3_400x400.jpg',
//       'userID':1,
//       'postWord':'มีมฮาๆครับวันนี้'
//     }
//   ];
// }


