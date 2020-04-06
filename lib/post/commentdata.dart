class Commentdata{
  Commentdata(){

  }
  var comments=[
    {
      'postID':1,
      // 'image':'https://pbs.twimg.com/profile_images/1168928962917097472/gD5uWGj3_400x400.jpg',
      'userID':1,
      'comment':'Kuay rai edok',
      'like':true
    }
  ];

  List getComment(int id){
    var temp = new List();
    for(var i = 0; i < comments.length; i++){
      if(comments[i]['postID'] == id){
        // print(comments[i]);
        temp.add(comments[i]);
      }
    }
    return temp;
  }
}

class User{
  var users=[
    {
      'userID':1,
      'profileImg':'https://sketchok.com/images/articles/01-cartoons/002-family-guy/02/08.jpg',
      'profileName':'Yedmae Nguang isus',

    }
  ];
  getUsers(int id){
    for(var i = 0; i < users.length; i++){
      if(users[i]['userID'] == id){
        return users[i];
      }
    }
    return null;
  }
  getProfilePic(int id){
    return getUsers(id)['profileImg'];
  }
  getProfileName(int id){
    return getUsers(id)['profileName'];
  }
}

class Post{
  var posts=[
    {
      'id':1,
      'image':'https://pbs.twimg.com/profile_images/1168928962917097472/gD5uWGj3_400x400.jpg',
      'userID':1,
      'postWord':'มีมฮาๆครับวันนี้'
    }
  ];
}


