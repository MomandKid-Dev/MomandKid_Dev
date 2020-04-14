import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:momandkid/model/baby_model.dart';
import 'package:momandkid/services/database.dart';

class dataTest {
  var _type;
  List getli() {
    return ls;
  }

  var ls;
  var lit;

  var _keys, _values, _title, _val, _subval, _img, _n;
  // list variable for keep baby info in userId
  List<dynamic> kiddo = new List();

  // get baby info (get babyId -> list babyId -> search in table baby info -> return list baby info)
  Future getBabyInfo(String userId) async {
    dynamic val = await Database(userId: userId).getBabyId();
    return Database(userId: userId).getBaby(val);
  }

  // restructuring object (instance DocumentSnapshot -> object data in DocumentSnapshot)
  List<dynamic> mapBaby(List<dynamic> babyInfo) {
    return (babyInfo.map((baby) => baby.data)).toList();
  }

  List<dynamic> mapBabyForm(List<dynamic> babyInfo) {
    return babyInfo
        .map((data) => BabyInfoModel.formMap(data).getData())
        .toList();
  }

  // initail kiddo in class
  getKiddo(String userId) {
    // getBabyInfo(userId).then((val) {
    //   this.kiddo = (mapBaby(val));

    //   print('Baby info: ${kiddo}');
    // });

    // dynamic babyInfoRaw = getBabyInfo(userId);
    // dynamic babyInfo = mapBaby(babyInfoRaw);
    // kiddo = mapBabyForm(babyInfo);
    // print('Test Data: $kiddo');

    getBabyInfo(userId).then((value) {
      dynamic babyInfo = mapBaby(value);
      print('baby info not form: ${babyInfo}');
      kiddo = mapBabyForm(babyInfo);
      print('Baby info form: ${kiddo}');
    });
  }

  // TO change Data display on page change datas according to kid
  // add method to change data in [ setSelectedKid() !!!!]method
  //this is just sample data to simulate when i got the data from ...;
  var datas = [
    {
      'id': 1,
      'kidID': '1',
      'type': 'vac',
      'val': 'วัคซีนป้องกันวัณโรค',
      'subval': 'ช่วงอายุ แรกเกิด',
      'stat': '1',
      'range': 'แรกเกิด',
      'Date': '12012021'
    },
    {
      'id': 2,
      'kidID': '1',
      'type': 'med',
      'val': 'Para',
      'subval': '',
      'stat': '1',
      'ยา': 'Para',
      'Date': '12012021'
    },
    {
      'id': 3,
      'kidID': '1',
      'type': 'evo',
      'val': 'ส่งเสียงอ้อแอ้',
      'subval': 'พัฒนาการด้านภาษา',
      'stat': '1',
      'range': 'แรกเกิด',
      'Date': '12012021'
    },
    {
      'id': 4,
      'kidID': '1',
      'type': 'weight',
      'val': '10kg',
      'subval': '',
      'stat': '1',
      'Weight': '10kg',
      'Date': '12012021'
    },
    {
      'id': 5,
      'kidID': '1',
      'type': 'height',
      'val': '100cm',
      'subval': '',
      'stat': '1',
      'Height': '100cm',
      'Date': '12012021'
    },
    {
      'id': 6,
      'kidID': '1',
      'type': 'height',
      'val': '100cm',
      'subval': '',
      'stat': '1',
      'Height': '100cm',
      'Date': '02012022'
    },
    {
      'id': 7,
      'kidID': '1',
      'type': 'height',
      'val': '100cm',
      'subval': '',
      'stat': '1',
      'Height': '100cm',
      'Date': '02012022'
    }
  ];

  var recent = new List();
  int _age = 2;
  getSelectedKid() {
    for (var i = 0; i < kiddo.length; i++) {
      if (kiddo[i]['sel'] == 1) {
        return kiddo[i];
      }
    }
    return null;
  }

  setSelectedKid(int id) {
    for (var i = 0; i < kiddo.length; i++) {
      if (id == i + 1) {
        if (kiddo[i]['sel'] == 0) {
          kiddo[i]['sel'] = 1;
        }
      } else if (id != i + 1) {
        kiddo[i]['sel'] = 0;
      }
    }
  }

  reKidID() {
    if (kiddo.length > 0) {
      for (var i = 0; i < kiddo.length; i++) {
        kiddo[i]['id'] = (i + 1);
      }
    }
  }

  setSelectedKidAny() {
    reKidID();
    bool haveSelectedKid = false;
    if (kiddo.length > 0) {
      for (var i = 0; i < kiddo.length; i++) {
        if (kiddo[i]['sel'] == 1) {
          haveSelectedKid = true;
        }
      }
      if (!haveSelectedKid) {
        kiddo[0]['sel'] = 1;
      }
    }
  }

  List getKeys() {
    return _keys;
  }

  List getValues() {
    return _values;
  }

  Map getLit() {
    return lit;
  }

  getDatas() {
    return datas;
  }

  getKids() {
    print('call getKid: $kiddo');
    return kiddo;
  }

  reDatasID() {
    if (kiddo.length > 0) {
      for (var i = 0; i < datas.length; i++) {
        for (var j = 0; j < recent.length; j++) {
          if (datas[i]['id'] == recent[j]) {
            recent[i] = i;
          }
        }
        datas[i]['id'] = i;
      }
    }
  }

  setDatas(int id, String type) {
    // print('deleted');
    for (var i = 0; i < datas.length; i++) {
      if (datas[i]['id'] == id && datas[i]['type'] == type) {
        datas.removeAt(i);
        break;
      }
    }
    reDatasID();
  }

  addData(String kidID, String type, String val, String date) {
    var temp;
    temp = {
      'id': datas.length,
      'kidID': kidID,
      'type': type,
      'title': getTitle(type),
      'val': val,
      'subval': '',
      'stat': '1',
      'img': getImg(type),
      'a': {getTitle(type): val, 'Date': date}
    };
    datas.add(temp);
  }

  setDatasStat(int id, String type) {
    // print('deleted');
    for (var i = 0; i < datas.length; i++) {
      if (datas[i]['id'] == id && datas[i]['type'] == type) {
        datas[i]['stat'] = 0.toString();
        break;
      }
    }
  }

  isContain(String type) {
    for (var i = 0; i < datas.length; i++) {
      if (datas[i]['type'] == type) {
        return true;
      }
    }
    return false;
  }

  String getTitle(String type) {
    if (type == 'vac') {
      return 'วัคซีน';
    } else if (type == 'med') {
      return 'แพ้ยา';
    } else if (type == 'evo') {
      return 'พัฒนาการ';
    } else if (type == 'height') {
      return 'Height';
    } else if (type == 'weight') {
      return 'Weight';
    }
    return 'No Data';
  }

  getVal(String type) {
    return (getData(type)[0][0])['val'];
  }

  getSubval(String type) {
    return (getData(type)[0][0])['subval'];
  }

  String getImg(String type) {
    if (type == 'vac') {
      return 'assets/icons/011-vaccine.png';
    } else if (type == 'med') {
      return 'assets/icons/044-contraceptive-pills.png';
    } else if (type == 'evo') {
      return 'assets/icons/020-hat.png';
    } else if (type == 'height') {
      return 'assets/icons/height.png';
    } else if (type == 'weight') {
      return 'assets/icons/weight.png';
    }
    return 'assets/icons/404.png';
  }

  getAge() {
    return _age;
  }

  getRecent() {
    var out = new List();
    for (var i = 0; i < recent.length; i++) {
      for (var j = 0; j < datas.length; j++) {
        if (recent[i] == datas[j]['id']) {
          out.add(datas[j]);
        }
      }
    }
    return out;
  }

  setRecent(int id) {
    if (isInRecent(id)) {
      recent.remove(id);
      recent.insert(0, id);
    } else {
      recent.insert(0, id);
    }
  }

  isInRecent(int id) {
    for (var i = 0; i < recent.length; i++) {
      if (recent[i] == id) {
        return true;
      }
    }
    return false;
  }

  List getDataWithType(String type, int stat) {
    this._type = type;
    List<Map<dynamic, dynamic>> temp = new List();
    List<dynamic> out = new List();
    for (var i = 0; i < datas.length; i++) {
      if ((datas[i])['type'] == type && datas[i]['stat'] == stat.toString()) {
        temp.add(datas[i]);
      }
    }
    out = genData(temp);
    return out;
  }

  List getData(String type) {
    List<Map<dynamic, dynamic>> temp = new List();
    List<dynamic> out = new List();
    for (var i = 0; i < datas.length; i++) {
      if ((datas[i])['type'] == type) {
        temp.add(datas[i]);
      }
    }
    out = genData(temp);
    return out;
  }
}

evalDate(String date) {
  String val = '';
  val += (date.substring(4, 8));
  val += (date.substring(2, 4));
  val += (date.substring(0, 2));
  return val;
}

genData(List<Map<dynamic, dynamic>> temp) {
  for (var j = 0; j < temp.length; j++) {
    for (var k = 0; k < temp.length; k++) {
      if (int.parse(evalDate((temp[j])['Date'])) >
          int.parse(evalDate(temp[k]['Date']))) {
        var tempList = temp[j];
        temp[j] = temp[k];
        temp[k] = tempList;
      }
    }
  }
  // print(temp);
  List eiei = new List.from(temp);
  List temp1 = new List();
  List<Map<dynamic, dynamic>> temp2 = new List();
  while (eiei.length > 1) {
    temp2.add(eiei[0]);
    int j = 1;
    while (int.parse(evalDate((eiei[0])['Date'])) ==
        int.parse(evalDate(eiei[j]['Date']))) {
      temp2.add(eiei[j]);
      j++;
      if (j >= eiei.length) {
        break;
      }
    }
    temp1.add(temp2);
    temp2 = new List();
    while (j > 0) {
      eiei.removeAt(0);
      j -= 1;
    }
  }
  while (eiei.length > 0) {
    temp2.add(eiei[0]);
    temp1.add(temp2);
    eiei.removeAt(0);
  }
  return temp1;
}
