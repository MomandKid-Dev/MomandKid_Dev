import 'dart:io';

class StoryData{
  File _coverImg;
  String _title;
  var datas = [
    // {
    //   'id': 0,
    //   'title' : 'I love you',
    //   'coverImg':'assets/icons/cover.jpg',
    //   'images': [],
    //   'content': '20 may 2018 bayern munich lost to real madrid',
    //   'date':'02012022' //and that morning was the worst day in my life you tell me that it\'s time to go you found someome you love'
    // },

  ];
  StoryData(){

  }

  setCoverImg(File img){
    this._coverImg = img;
  }
  setTiltle(String title){
    this._title = title;
  }

  getTitle(int id){
    return getStory(id)['id'];
  }
  getCoverImg(int id){
    if (getStory(id)['coverImg'] == 'image path') return 'assets/icons/cover.jpg';
    return getStory(id)['coverImg'];
  }
  getImages(int id){
    return getStory(id)['images'];
  }
  getContent(int id){
    return getStory(id)['content'];
  }
  getDate(int id){
    return getStory(id)['date'];
  }

  

  addStory(int id,String sid,String title,String coverImg, List<dynamic> images,String content,DateTime date){
    var storyTemp = 
      {
        'id': id,
        'sid' : sid,
        'title' : title,
        'coverImg':coverImg,
        'images':images,
        'content': content,
        'date':date
      };

    datas.add(storyTemp);
  }

  getStory(int id){
    return datas[id];
  }

   getAllStory(){
     return datas;
   }

}