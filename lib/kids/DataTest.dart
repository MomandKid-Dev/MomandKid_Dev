import 'package:age/age.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    return (babyInfo.map((baby) {
      Map babyInfo = baby.data;
      babyInfo['kid'] = baby.documentID;
      return babyInfo;
    })).toList();
  }

  // map babyInfo to baby model
  List<dynamic> mapBabyForm(List<dynamic> babyInfo) {
    return babyInfo
        .map((data) => BabyInfoModel.formMap(data).getData())
        .toList();
  }

  // initail kiddo in class
  Future getKiddo(String userId) async {
    // new version (map baby model)
    await getBabyInfo(userId).then((value) {
      dynamic babyInfo = mapBaby(value);
      print('Baby info not form: ${babyInfo}');

      kiddo = mapBabyForm(babyInfo);
      // AgeDuration age = kiddo[0]['age'];
      // print('Age: ${age.years}');
      kiddo.sort((a, b) => a['date'].compareTo(b['date']));
      kiddo[kiddo.length - 1]['sel'] = 1;
      print('Baby info form: ${kiddo}');
    });
  }

  // TO change Data display on page change datas according to kid
  // add method to change data in [ setSelectedKid() !!!!]method
  //this is just sample data to simulate when i got the data from ...;
  List<dynamic> datas_raw = new List();
  List<dynamic> datas = new List();
  // List<dynamic> datas = [
  //   {
  //     'id': 1,
  //     'kidID': '1',
  //     'type': 'vac',
  //     'val': 'วัคซีนป้องกันวัณโรค',
  //     'subval': 'ช่วงอายุ แรกเกิด',
  //     'stat': '1',
  //     'range': 'แรกเกิด',
  //     'Date': '12012021'
  //   },
  // ]

  List<dynamic> mapLog(List<dynamic> logList) {
    return (logList.map((log) {
      Map logData = log.data;
      logData['logId'] = log.documentID;
      return logData;
    })).toList();
  }

  getHeightLog(String babyId) async {
    List<dynamic> listHeight = await Database().getHeightLogId(babyId);
    // get height log data
    if (listHeight != null) {
      for (var i = 0; i < listHeight.length; i++) {
        dynamic data;
        await Database().getHeightLog(listHeight[i]).then((val) {
          data = val;
        });
        this.datas_raw.add(data);
      }
    }
  }

  getWeightLog(String babyId) async {
    List<dynamic> listWeight = await Database().getWeightLogId(babyId);
    // get weight log data
    if (listWeight != null) {
      for (var i = 0; i < listWeight.length; i++) {
        dynamic data;
        await Database().getWeightLog(listWeight[i]).then((val) {
          data = val;
        });
        this.datas_raw.add(data);
      }
    }
  }

  getMedicineLog(String babyId) async {
    List<dynamic> listMedicine = await Database().getMedicineLogId(babyId);
    // get medicine log data
    if (listMedicine != null) {
      for (var i = 0; i < listMedicine.length; i++) {
        dynamic data;
        await Database().getMedicineLog(listMedicine[i]).then((val) {
          data = val;
        });
        this.datas_raw.add(data);
      }
    }
  }

  getVaccineLog(String babyId) async {
    List<dynamic> listVaccine = await Database().getVaccineLogId(babyId);
    // get vaccine log data
    if (listVaccine != null) {
      for (var i = 0; i < listVaccine.length; i++) {
        dynamic data;
        await Database().getVaccineLog(listVaccine[i]).then((val) {
          data = val;
        });
        this.datas_raw.add(data);
      }
    }
  }

  getDevelopeLog(String babyId) async {
    List<dynamic> listDevelope = await Database().getDevelopeLogId(babyId);
    // get develope log data
    if (listDevelope != null) {
      for (var i = 0; i < listDevelope.length; i++) {
        dynamic data;
        await Database().getDevelopeLog(listDevelope[i]).then((val) {
          data = val;
        });
        this.datas_raw.add(data);
      }
    }
  }

  // List<dynamic> mapData(List<dynamic> dataList) {
  //   return (dataList.map((dataList) => dataList.data)).toList();
  // }

  Future getDataLogAll() async {
    datas_raw = [];
    datas = [];
    dynamic babyId = getSelectedKid()['kid'];
    print('babyId: ${babyId}');

    // list log
    await getHeightLog(babyId);
    await getWeightLog(babyId);
    await getMedicineLog(babyId);
    await getVaccineLog(babyId);
    await getDevelopeLog(babyId);

    print('data_raw log: ${this.datas_raw}');

    datas = mapLog(datas_raw);

    print('data log: ${datas}');
  }

  // male
  maleHeightText(dynamic babyHeight, dynamic babyAge) {
    if (babyAge.years > 0) {
      if (babyAge.years > 4) {
        if (babyHeight < 102.0) {
          return 'ต่ำกว่าเกณฑ์';
        } else if (babyHeight >= 102.0 && babyHeight <= 115.1) {
          return 'ตามเกณฑ์';
        } else {
          return 'สูงกว่าเกณฑ์';
        }
      } else if (babyAge.years > 3) {
        if (babyHeight < 95.5) {
          return 'ต่ำกว่าเกณฑ์';
        } else if (babyHeight >= 95.5 && babyHeight <= 108.2) {
          return 'ตามเกณฑ์';
        } else {
          return 'สูงกว่าเกณฑ์';
        }
      } else if (babyAge.years > 2) {
        if (babyHeight < 89.4) {
          return 'ต่ำกว่าเกณฑ์';
        } else if (babyHeight >= 89.4 && babyHeight <= 100.8) {
          return 'ตามเกณฑ์';
        } else {
          return 'สูงกว่าเกณฑ์';
        }
      } else if (babyAge.years > 1) {
        if (babyHeight < 82.5) {
          return 'ต่ำกว่าเกณฑ์';
        } else if (babyHeight >= 82.5 && babyHeight <= 91.5) {
          return 'ตามเกณฑ์';
        } else {
          return 'สูงกว่าเกณฑ์';
        }
      } else {
        if (babyHeight < 71.5) {
          return 'ต่ำกว่าเกณฑ์';
        } else if (babyHeight >= 71.5 && babyHeight <= 79.7) {
          return 'ตามเกณฑ์';
        } else {
          return 'สูงกว่าเกณฑ์';
        }
      }
    } else {
      if (babyAge.months > 10) {
        if (babyHeight < 70.2) {
          return 'ต่ำกว่าเกณฑ์';
        } else if (babyHeight >= 70.2 && babyHeight <= 78.2) {
          return 'ตามเกณฑ์';
        } else {
          return 'สูงกว่าเกณฑ์';
        }
      } else if (babyAge.months > 9) {
        if (babyHeight < 68.9) {
          return 'ต่ำกว่าเกณฑ์';
        } else if (babyHeight >= 68.9 && babyHeight <= 76.7) {
          return 'ตามเกณฑ์';
        } else {
          return 'สูงกว่าเกณฑ์';
        }
      } else if (babyAge.months > 8) {
        if (babyHeight < 67.4) {
          return 'ต่ำกว่าเกณฑ์';
        } else if (babyHeight >= 67.4 && babyHeight <= 75.0) {
          return 'ตามเกณฑ์';
        } else {
          return 'สูงกว่าเกณฑ์';
        }
      } else if (babyAge.months > 7) {
        if (babyHeight < 65.9) {
          return 'ต่ำกว่าเกณฑ์';
        } else if (babyHeight >= 65.9 && babyHeight <= 73.2) {
          return 'ตามเกณฑ์';
        } else {
          return 'สูงกว่าเกณฑ์';
        }
      } else if (babyAge.months > 6) {
        if (babyHeight < 64.2) {
          return 'ต่ำกว่าเกณฑ์';
        } else if (babyHeight >= 64.2 && babyHeight <= 71.3) {
          return 'ตามเกณฑ์';
        } else {
          return 'สูงกว่าเกณฑ์';
        }
      } else if (babyAge.months > 5) {
        if (babyHeight < 62.4) {
          return 'ต่ำกว่าเกณฑ์';
        } else if (babyHeight >= 62.4 && babyHeight <= 69.2) {
          return 'ตามเกณฑ์';
        } else {
          return 'สูงกว่าเกณฑ์';
        }
      } else if (babyAge.months > 4) {
        if (babyHeight < 60.4) {
          return 'ต่ำกว่าเกณฑ์';
        } else if (babyHeight >= 60.4 && babyHeight <= 67.1) {
          return 'ตามเกณฑ์';
        } else {
          return 'สูงกว่าเกณฑ์';
        }
      } else if (babyAge.months > 3) {
        if (babyHeight < 58.1) {
          return 'ต่ำกว่าเกณฑ์';
        } else if (babyHeight >= 58.1 && babyHeight <= 64.6) {
          return 'ตามเกณฑ์';
        } else {
          return 'สูงกว่าเกณฑ์';
        }
      } else if (babyAge.months > 2) {
        if (babyHeight < 55.7) {
          return 'ต่ำกว่าเกณฑ์';
        } else if (babyHeight >= 55.7 && babyHeight <= 61.9) {
          return 'ตามเกณฑ์';
        } else {
          return 'สูงกว่าเกณฑ์';
        }
      } else if (babyAge.months > 1) {
        if (babyHeight < 53.2) {
          return 'ต่ำกว่าเกณฑ์';
        } else if (babyHeight >= 53.2 && babyHeight <= 59.1) {
          return 'ตามเกณฑ์';
        } else {
          return 'สูงกว่าเกณฑ์';
        }
      } else if (babyAge.months > 0) {
        if (babyHeight < 50.4) {
          return 'ต่ำกว่าเกณฑ์';
        } else if (babyHeight >= 50.4 && babyHeight <= 56.2) {
          return 'ตามเกณฑ์';
        } else {
          return 'สูงกว่าเกณฑ์';
        }
      } else {
        if (babyHeight < 47.6) {
          return 'ต่ำกว่าเกณฑ์';
        } else if (babyHeight >= 47.6 && babyHeight <= 53.1) {
          return 'ตามเกณฑ์';
        } else {
          return 'สูงกว่าเกณฑ์';
        }
      }
    }
  }

  maleHeightColor(dynamic babyHeight, dynamic babyAge) {
    if (babyAge.years > 0) {
      if (babyAge.years > 4) {
        if (babyHeight < 102.0) {
          return Colors.redAccent;
        } else if (babyHeight >= 102.0 && babyHeight <= 115.1) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.years > 3) {
        if (babyHeight < 95.5) {
          return Colors.redAccent;
        } else if (babyHeight >= 95.5 && babyHeight <= 108.2) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.years > 2) {
        if (babyHeight < 89.4) {
          return Colors.redAccent;
        } else if (babyHeight >= 89.4 && babyHeight <= 100.8) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.years > 1) {
        if (babyHeight < 82.5) {
          return Colors.redAccent;
        } else if (babyHeight >= 82.5 && babyHeight <= 91.5) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else {
        if (babyHeight < 71.5) {
          return Colors.redAccent;
        } else if (babyHeight >= 71.5 && babyHeight <= 79.7) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      }
    } else {
      if (babyAge.months > 10) {
        if (babyHeight < 70.2) {
          return Colors.redAccent;
        } else if (babyHeight >= 70.2 && babyHeight <= 78.2) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.months > 9) {
        if (babyHeight < 68.9) {
          return Colors.redAccent;
        } else if (babyHeight >= 68.9 && babyHeight <= 76.7) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.months > 8) {
        if (babyHeight < 67.4) {
          return Colors.redAccent;
        } else if (babyHeight >= 67.4 && babyHeight <= 75.0) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.months > 7) {
        if (babyHeight < 65.9) {
          return Colors.redAccent;
        } else if (babyHeight >= 65.9 && babyHeight <= 73.2) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.months > 6) {
        if (babyHeight < 64.2) {
          return Colors.redAccent;
        } else if (babyHeight >= 64.2 && babyHeight <= 71.3) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.months > 5) {
        if (babyHeight < 62.4) {
          return Colors.redAccent;
        } else if (babyHeight >= 62.4 && babyHeight <= 69.2) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.months > 4) {
        if (babyHeight < 60.4) {
          return Colors.redAccent;
        } else if (babyHeight >= 60.4 && babyHeight <= 67.1) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.months > 3) {
        if (babyHeight < 58.1) {
          return Colors.redAccent;
        } else if (babyHeight >= 58.1 && babyHeight <= 64.6) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.months > 2) {
        if (babyHeight < 55.7) {
          return Colors.redAccent;
        } else if (babyHeight >= 55.7 && babyHeight <= 61.9) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.months > 1) {
        if (babyHeight < 53.2) {
          return Colors.redAccent;
        } else if (babyHeight >= 53.2 && babyHeight <= 59.1) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.months > 0) {
        if (babyHeight < 50.4) {
          return Colors.redAccent;
        } else if (babyHeight >= 50.4 && babyHeight <= 56.2) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else {
        if (babyHeight < 47.6) {
          return Colors.redAccent;
        } else if (babyHeight >= 47.6 && babyHeight <= 53.1) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      }
    }
  }

  maleWeightText(dynamic babyWeight, dynamic babyAge) {
    if (babyAge.years > 0) {
      if (babyAge.years > 4) {
        if (babyWeight < 15.0) {
          return 'น้อยกว่าเกณฑ์';
        } else if (babyWeight >= 15.0 && babyWeight <= 22.6) {
          return 'ตามเกณฑ์';
        } else {
          return 'มากกว่าเกณฑ์';
        }
      } else if (babyAge.years > 3) {
        if (babyWeight < 13.6) {
          return 'น้อยกว่าเกณฑ์';
        } else if (babyWeight >= 13.6 && babyWeight <= 19.9) {
          return 'ตามเกณฑ์';
        } else {
          return 'มากกว่าเกณฑ์';
        }
      } else if (babyAge.years > 2) {
        if (babyWeight < 12.1) {
          return 'น้อยกว่าเกณฑ์';
        } else if (babyWeight >= 12.1 && babyWeight <= 17.2) {
          return 'ตามเกณฑ์';
        } else {
          return 'มากกว่าเกณฑ์';
        }
      } else if (babyAge.years > 1) {
        if (babyWeight < 10.5) {
          return 'น้อยกว่าเกณฑ์';
        } else if (babyWeight >= 10.5 && babyWeight <= 14.4) {
          return 'ตามเกณฑ์';
        } else {
          return 'มากกว่าเกณฑ์';
        }
      } else {
        if (babyWeight < 8.3) {
          return 'น้อยกว่าเกณฑ์';
        } else if (babyWeight >= 8.3 && babyWeight <= 11.0) {
          return 'ตามเกณฑ์';
        } else {
          return 'มากกว่าเกณฑ์';
        }
      }
    } else {
      if (babyAge.months > 10) {
        if (babyWeight < 8.1) {
          return 'น้อยกว่าเกณฑ์';
        } else if (babyWeight >= 8.1 && babyWeight <= 10.6) {
          return 'ตามเกณฑ์';
        } else {
          return 'มากกว่าเกณฑ์';
        }
      } else if (babyAge.months > 9) {
        if (babyWeight < 7.9) {
          return 'น้อยกว่าเกณฑ์';
        } else if (babyWeight >= 7.9 && babyWeight <= 10.3) {
          return 'ตามเกณฑ์';
        } else {
          return 'มากกว่าเกณฑ์';
        }
      } else if (babyAge.months > 8) {
        if (babyWeight < 7.6) {
          return 'น้อยกว่าเกณฑ์';
        } else if (babyWeight >= 7.6 && babyWeight <= 9.9) {
          return 'ตามเกณฑ์';
        } else {
          return 'มากกว่าเกณฑ์';
        }
      } else if (babyAge.months > 7) {
        if (babyWeight < 7.2) {
          return 'น้อยกว่าเกณฑ์';
        } else if (babyWeight >= 7.2 && babyWeight <= 9.5) {
          return 'ตามเกณฑ์';
        } else {
          return 'มากกว่าเกณฑ์';
        }
      } else if (babyAge.months > 6) {
        if (babyWeight < 6.8) {
          return 'น้อยกว่าเกณฑ์';
        } else if (babyWeight >= 6.8 && babyWeight <= 9.0) {
          return 'ตามเกณฑ์';
        } else {
          return 'มากกว่าเกณฑ์';
        }
      } else if (babyAge.months > 5) {
        if (babyWeight < 6.3) {
          return 'น้อยกว่าเกณฑ์';
        } else if (babyWeight >= 6.3 && babyWeight <= 8.4) {
          return 'ตามเกณฑ์';
        } else {
          return 'มากกว่าเกณฑ์';
        }
      } else if (babyAge.months > 4) {
        if (babyWeight < 5.8) {
          return 'น้อยกว่าเกณฑ์';
        } else if (babyWeight >= 5.8 && babyWeight <= 7.8) {
          return 'ตามเกณฑ์';
        } else {
          return 'มากกว่าเกณฑ์';
        }
      } else if (babyAge.months > 3) {
        if (babyWeight < 5.3) {
          return 'น้อยกว่าเกณฑ์';
        } else if (babyWeight >= 5.3 && babyWeight <= 7.1) {
          return 'ตามเกณฑ์';
        } else {
          return 'มากกว่าเกณฑ์';
        }
      } else if (babyAge.months > 2) {
        if (babyWeight < 4.8) {
          return 'น้อยกว่าเกณฑ์';
        } else if (babyWeight >= 4.8 && babyWeight <= 6.4) {
          return 'ตามเกณฑ์';
        } else {
          return 'มากกว่าเกณฑ์';
        }
      } else if (babyAge.months > 1) {
        if (babyWeight < 4.2) {
          return 'น้อยกว่าเกณฑ์';
        } else if (babyWeight >= 4.2 && babyWeight <= 5.5) {
          return 'ตามเกณฑ์';
        } else {
          return 'มากกว่าเกณฑ์';
        }
      } else if (babyAge.months > 0) {
        if (babyWeight < 3.4) {
          return 'ต่ำกว่าเกณฑ์';
        } else if (babyWeight >= 3.4 && babyWeight <= 4.7) {
          return 'ตามเกณฑ์';
        } else {
          return 'มากกว่าเกณฑ์';
        }
      } else {
        if (babyWeight < 2.3) {
          return 'น้อยกว่าเกณฑ์';
        } else if (babyWeight >= 2.3 && babyWeight <= 3.9) {
          return 'ตามเกณฑ์';
        } else {
          return 'มากกว่าเกณฑ์';
        }
      }
    }
  }

  maleWeightColor(dynamic babyWeight, dynamic babyAge) {
    if (babyAge.years > 0) {
      if (babyAge.years > 4) {
        if (babyWeight < 15.0) {
          return Colors.redAccent;
        } else if (babyWeight >= 15.0 && babyWeight <= 22.6) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.years > 3) {
        if (babyWeight < 13.6) {
          return Colors.redAccent;
        } else if (babyWeight >= 13.6 && babyWeight <= 19.9) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.years > 2) {
        if (babyWeight < 12.1) {
          return Colors.redAccent;
        } else if (babyWeight >= 12.1 && babyWeight <= 17.2) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.years > 1) {
        if (babyWeight < 10.5) {
          return Colors.redAccent;
        } else if (babyWeight >= 10.5 && babyWeight <= 14.4) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else {
        if (babyWeight < 8.3) {
          return Colors.redAccent;
        } else if (babyWeight >= 8.3 && babyWeight <= 11.0) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      }
    } else {
      if (babyAge.months > 10) {
        if (babyWeight < 8.1) {
          return Colors.redAccent;
        } else if (babyWeight >= 8.1 && babyWeight <= 10.6) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.months > 9) {
        if (babyWeight < 7.9) {
          return Colors.redAccent;
        } else if (babyWeight >= 7.9 && babyWeight <= 10.3) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.months > 8) {
        if (babyWeight < 7.6) {
          return Colors.redAccent;
        } else if (babyWeight >= 7.6 && babyWeight <= 9.9) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.months > 7) {
        if (babyWeight < 7.2) {
          return Colors.redAccent;
        } else if (babyWeight >= 7.2 && babyWeight <= 9.5) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.months > 6) {
        if (babyWeight < 6.8) {
          return Colors.redAccent;
        } else if (babyWeight >= 6.8 && babyWeight <= 9.0) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.months > 5) {
        if (babyWeight < 6.3) {
          return Colors.redAccent;
        } else if (babyWeight >= 6.3 && babyWeight <= 8.4) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.months > 4) {
        if (babyWeight < 5.8) {
          return Colors.redAccent;
        } else if (babyWeight >= 5.8 && babyWeight <= 7.8) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.months > 3) {
        if (babyWeight < 5.3) {
          return Colors.redAccent;
        } else if (babyWeight >= 5.3 && babyWeight <= 7.1) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.months > 2) {
        if (babyWeight < 4.8) {
          return Colors.redAccent;
        } else if (babyWeight >= 4.8 && babyWeight <= 6.4) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.months > 1) {
        if (babyWeight < 4.2) {
          return Colors.redAccent;
        } else if (babyWeight >= 4.2 && babyWeight <= 5.5) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.months > 0) {
        if (babyWeight < 3.4) {
          return Colors.redAccent;
        } else if (babyWeight >= 3.4 && babyWeight <= 4.7) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else {
        if (babyWeight < 2.3) {
          return Colors.redAccent;
        } else if (babyWeight >= 2.3 && babyWeight <= 3.9) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      }
    }
  }

  // female
  femaleHeightText(dynamic babyHeight, dynamic babyAge) {
    if (babyAge.years > 0) {
      if (babyAge.years > 4) {
        if (babyHeight < 101.1) {
          return 'ต่ำกว่าเกณฑ์';
        } else if (babyHeight >= 101.1 && babyHeight <= 113.9) {
          return 'ตามเกณฑ์';
        } else {
          return 'สูงกว่าเกณฑ์';
        }
      } else if (babyAge.years > 3) {
        if (babyHeight < 95.0) {
          return 'ต่ำกว่าเกณฑ์';
        } else if (babyHeight >= 95.0 && babyHeight <= 106.9) {
          return 'ตามเกณฑ์';
        } else {
          return 'สูงกว่าเกณฑ์';
        }
      } else if (babyAge.years > 2) {
        if (babyHeight < 88.1) {
          return 'ต่ำกว่าเกณฑ์';
        } else if (babyHeight >= 88.1 && babyHeight <= 99.2) {
          return 'ตามเกณฑ์';
        } else {
          return 'สูงกว่าเกณฑ์';
        }
      } else if (babyAge.years > 1) {
        if (babyHeight < 80.8) {
          return 'ต่ำกว่าเกณฑ์';
        } else if (babyHeight >= 80.8 && babyHeight <= 89.9) {
          return 'ตามเกณฑ์';
        } else {
          return 'สูงกว่าเกณฑ์';
        }
      } else {
        if (babyHeight < 68.8) {
          return 'ต่ำกว่าเกณฑ์';
        } else if (babyHeight >= 68.8 && babyHeight <= 78.9) {
          return 'ตามเกณฑ์';
        } else {
          return 'สูงกว่าเกณฑ์';
        }
      }
    } else {
      if (babyAge.months > 10) {
        if (babyHeight < 67.7) {
          return 'ต่ำกว่าเกณฑ์';
        } else if (babyHeight >= 67.7 && babyHeight <= 77.6) {
          return 'ตามเกณฑ์';
        } else {
          return 'สูงกว่าเกณฑ์';
        }
      } else if (babyAge.months > 9) {
        if (babyHeight < 66.7) {
          return 'ต่ำกว่าเกณฑ์';
        } else if (babyHeight >= 66.7 && babyHeight <= 76.1) {
          return 'ตามเกณฑ์';
        } else {
          return 'สูงกว่าเกณฑ์';
        }
      } else if (babyAge.months > 8) {
        if (babyHeight < 65.5) {
          return 'ต่ำกว่าเกณฑ์';
        } else if (babyHeight >= 65.5 && babyHeight <= 74.5) {
          return 'ตามเกณฑ์';
        } else {
          return 'สูงกว่าเกณฑ์';
        }
      } else if (babyAge.months > 7) {
        if (babyHeight < 64.2) {
          return 'ต่ำกว่าเกณฑ์';
        } else if (babyHeight >= 64.2 && babyHeight <= 72.8) {
          return 'ตามเกณฑ์';
        } else {
          return 'สูงกว่าเกณฑ์';
        }
      } else if (babyAge.months > 6) {
        if (babyHeight < 62.6) {
          return 'ต่ำกว่าเกณฑ์';
        } else if (babyHeight >= 62.6 && babyHeight <= 71.1) {
          return 'ตามเกณฑ์';
        } else {
          return 'สูงกว่าเกณฑ์';
        }
      } else if (babyAge.months > 5) {
        if (babyHeight < 60.9) {
          return 'ต่ำกว่าเกณฑ์';
        } else if (babyHeight >= 60.9 && babyHeight <= 69.1) {
          return 'ตามเกณฑ์';
        } else {
          return 'สูงกว่าเกณฑ์';
        }
      } else if (babyAge.months > 4) {
        if (babyHeight < 58.9) {
          return 'ต่ำกว่าเกณฑ์';
        } else if (babyHeight >= 58.9 && babyHeight <= 66.9) {
          return 'ตามเกณฑ์';
        } else {
          return 'สูงกว่าเกณฑ์';
        }
      } else if (babyAge.months > 3) {
        if (babyHeight < 56.8) {
          return 'ต่ำกว่าเกณฑ์';
        } else if (babyHeight >= 56.8 && babyHeight <= 64.5) {
          return 'ตามเกณฑ์';
        } else {
          return 'สูงกว่าเกณฑ์';
        }
      } else if (babyAge.months > 2) {
        if (babyHeight < 54.4) {
          return 'ต่ำกว่าเกณฑ์';
        } else if (babyHeight >= 54.4 && babyHeight <= 61.8) {
          return 'ตามเกณฑ์';
        } else {
          return 'สูงกว่าเกณฑ์';
        }
      } else if (babyAge.months > 1) {
        if (babyHeight < 52.0) {
          return 'ต่ำกว่าเกณฑ์';
        } else if (babyHeight >= 52.0 && babyHeight <= 59.0) {
          return 'ตามเกณฑ์';
        } else {
          return 'สูงกว่าเกณฑ์';
        }
      } else if (babyAge.months > 0) {
        if (babyHeight < 49.4) {
          return 'ต่ำกว่าเกณฑ์';
        } else if (babyHeight >= 49.4 && babyHeight <= 56.0) {
          return 'ตามเกณฑ์';
        } else {
          return 'สูงกว่าเกณฑ์';
        }
      } else {
        if (babyHeight < 46.8) {
          return 'ต่ำกว่าเกณฑ์';
        } else if (babyHeight >= 46.8 && babyHeight <= 52.9) {
          return 'ตามเกณฑ์';
        } else {
          return 'สูงกว่าเกณฑ์';
        }
      }
    }
  }

  femaleHeightColor(dynamic babyHeight, dynamic babyAge) {
    if (babyAge.years > 0) {
      if (babyAge.years > 4) {
        if (babyHeight < 101.1) {
          return Colors.redAccent;
        } else if (babyHeight >= 101.1 && babyHeight <= 113.9) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.years > 3) {
        if (babyHeight < 95.0) {
          return Colors.redAccent;
        } else if (babyHeight >= 95.0 && babyHeight <= 106.9) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.years > 2) {
        if (babyHeight < 88.1) {
          return Colors.redAccent;
        } else if (babyHeight >= 88.1 && babyHeight <= 99.2) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.years > 1) {
        if (babyHeight < 80.8) {
          return Colors.redAccent;
        } else if (babyHeight >= 80.8 && babyHeight <= 89.9) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else {
        if (babyHeight < 68.8) {
          return Colors.redAccent;
        } else if (babyHeight >= 68.8 && babyHeight <= 78.9) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      }
    } else {
      if (babyAge.months > 10) {
        if (babyHeight < 67.7) {
          return Colors.redAccent;
        } else if (babyHeight >= 67.7 && babyHeight <= 77.6) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.months > 9) {
        if (babyHeight < 66.7) {
          return Colors.redAccent;
        } else if (babyHeight >= 66.7 && babyHeight <= 76.1) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.months > 8) {
        if (babyHeight < 65.5) {
          return Colors.redAccent;
        } else if (babyHeight >= 65.5 && babyHeight <= 74.5) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.months > 7) {
        if (babyHeight < 64.2) {
          return Colors.redAccent;
        } else if (babyHeight >= 64.2 && babyHeight <= 72.8) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.months > 6) {
        if (babyHeight < 62.6) {
          return Colors.redAccent;
        } else if (babyHeight >= 62.6 && babyHeight <= 71.1) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.months > 5) {
        if (babyHeight < 60.9) {
          return Colors.redAccent;
        } else if (babyHeight >= 60.9 && babyHeight <= 69.1) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.months > 4) {
        if (babyHeight < 58.9) {
          return Colors.redAccent;
        } else if (babyHeight >= 58.9 && babyHeight <= 66.9) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.months > 3) {
        if (babyHeight < 56.8) {
          return Colors.redAccent;
        } else if (babyHeight >= 56.8 && babyHeight <= 64.5) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.months > 2) {
        if (babyHeight < 54.4) {
          return Colors.redAccent;
        } else if (babyHeight >= 54.4 && babyHeight <= 61.8) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.months > 1) {
        if (babyHeight < 52.0) {
          return Colors.redAccent;
        } else if (babyHeight >= 52.0 && babyHeight <= 59.0) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.months > 0) {
        if (babyHeight < 49.4) {
          return Colors.redAccent;
        } else if (babyHeight >= 49.4 && babyHeight <= 56.0) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else {
        if (babyHeight < 46.8) {
          return Colors.redAccent;
        } else if (babyHeight >= 46.8 && babyHeight <= 52.9) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      }
    }
  }

  femaleWeightText(dynamic babyWeight, dynamic babyAge) {
    if (babyAge.years > 0) {
      if (babyAge.years > 4) {
        if (babyWeight < 14.4) {
          return 'น้อยกว่าเกณฑ์';
        } else if (babyWeight >= 14.4 && babyWeight <= 21.7) {
          return 'ตามเกณฑ์';
        } else {
          return 'มากกว่าเกณฑ์';
        }
      } else if (babyAge.years > 3) {
        if (babyWeight < 13.0) {
          return 'น้อยกว่าเกณฑ์';
        } else if (babyWeight >= 13.0 && babyWeight <= 19.2) {
          return 'ตามเกณฑ์';
        } else {
          return 'มากกว่าเกณฑ์';
        }
      } else if (babyAge.years > 2) {
        if (babyWeight < 11.5) {
          return 'น้อยกว่าเกณฑ์';
        } else if (babyWeight >= 11.5 && babyWeight <= 16.5) {
          return 'ตามเกณฑ์';
        } else {
          return 'มากกว่าเกณฑ์';
        }
      } else if (babyAge.years > 1) {
        if (babyWeight < 9.7) {
          return 'น้อยกว่าเกณฑ์';
        } else if (babyWeight >= 9.7 && babyWeight <= 13.7) {
          return 'ตามเกณฑ์';
        } else {
          return 'มากกว่าเกณฑ์';
        }
      } else {
        if (babyWeight < 7.7) {
          return 'น้อยกว่าเกณฑ์';
        } else if (babyWeight >= 7.7 && babyWeight <= 10.5) {
          return 'ตามเกณฑ์';
        } else {
          return 'มากกว่าเกณฑ์';
        }
      }
    } else {
      if (babyAge.months > 10) {
        if (babyWeight < 7.5) {
          return 'น้อยกว่าเกณฑ์';
        } else if (babyWeight >= 7.5 && babyWeight <= 10.2) {
          return 'ตามเกณฑ์';
        } else {
          return 'มากกว่าเกณฑ์';
        }
      } else if (babyAge.months > 9) {
        if (babyWeight < 7.2) {
          return 'น้อยกว่าเกณฑ์';
        } else if (babyWeight >= 7.2 && babyWeight <= 9.8) {
          return 'ตามเกณฑ์';
        } else {
          return 'มากกว่าเกณฑ์';
        }
      } else if (babyAge.months > 8) {
        if (babyWeight < 6.9) {
          return 'น้อยกว่าเกณฑ์';
        } else if (babyWeight >= 6.9 && babyWeight <= 9.3) {
          return 'ตามเกณฑ์';
        } else {
          return 'มากกว่าเกณฑ์';
        }
      } else if (babyAge.months > 7) {
        if (babyWeight < 6.6) {
          return 'น้อยกว่าเกณฑ์';
        } else if (babyWeight >= 6.6 && babyWeight <= 9.0) {
          return 'ตามเกณฑ์';
        } else {
          return 'มากกว่าเกณฑ์';
        }
      } else if (babyAge.months > 6) {
        if (babyWeight < 6.2) {
          return 'น้อยกว่าเกณฑ์';
        } else if (babyWeight >= 6.2 && babyWeight <= 8.5) {
          return 'ตามเกณฑ์';
        } else {
          return 'มากกว่าเกณฑ์';
        }
      } else if (babyAge.months > 5) {
        if (babyWeight < 5.8) {
          return 'น้อยกว่าเกณฑ์';
        } else if (babyWeight >= 5.8 && babyWeight <= 7.9) {
          return 'ตามเกณฑ์';
        } else {
          return 'มากกว่าเกณฑ์';
        }
      } else if (babyAge.months > 4) {
        if (babyWeight < 5.3) {
          return 'น้อยกว่าเกณฑ์';
        } else if (babyWeight >= 5.3 && babyWeight <= 7.3) {
          return 'ตามเกณฑ์';
        } else {
          return 'มากกว่าเกณฑ์';
        }
      } else if (babyAge.months > 3) {
        if (babyWeight < 4.9) {
          return 'น้อยกว่าเกณฑ์';
        } else if (babyWeight >= 4.9 && babyWeight <= 6.7) {
          return 'ตามเกณฑ์';
        } else {
          return 'มากกว่าเกณฑ์';
        }
      } else if (babyAge.months > 2) {
        if (babyWeight < 4.4) {
          return 'น้อยกว่าเกณฑ์';
        } else if (babyWeight >= 4.4 && babyWeight <= 6.0) {
          return 'ตามเกณฑ์';
        } else {
          return 'มากกว่าเกณฑ์';
        }
      } else if (babyAge.months > 1) {
        if (babyWeight < 3.8) {
          return 'น้อยกว่าเกณฑ์';
        } else if (babyWeight >= 3.8 && babyWeight <= 5.2) {
          return 'ตามเกณฑ์';
        } else {
          return 'มากกว่าเกณฑ์';
        }
      } else if (babyAge.months > 0) {
        if (babyWeight < 3.3) {
          return 'น้อยกว่าเกณฑ์';
        } else if (babyWeight >= 3.3 && babyWeight <= 4.4) {
          return 'ตามเกณฑ์';
        } else {
          return 'มากกว่าเกณฑ์';
        }
      } else {
        if (babyWeight < 2.7) {
          return 'น้อยกว่าเกณฑ์';
        } else if (babyWeight >= 2.7 && babyWeight <= 3.7) {
          return 'ตามเกณฑ์';
        } else {
          return 'มากกว่าเกณฑ์';
        }
      }
    }
  }

  femaleWeightColor(dynamic babyWeight, dynamic babyAge) {
    if (babyAge.years > 0) {
      if (babyAge.years > 4) {
        if (babyWeight < 14.4) {
          return Colors.redAccent;
        } else if (babyWeight >= 14.4 && babyWeight <= 21.7) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.years > 3) {
        if (babyWeight < 13.0) {
          return Colors.redAccent;
        } else if (babyWeight >= 13.0 && babyWeight <= 19.2) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.years > 2) {
        if (babyWeight < 11.5) {
          return Colors.redAccent;
        } else if (babyWeight >= 11.5 && babyWeight <= 16.5) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.years > 1) {
        if (babyWeight < 9.7) {
          return Colors.redAccent;
        } else if (babyWeight >= 9.7 && babyWeight <= 13.7) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else {
        if (babyWeight < 7.7) {
          return Colors.redAccent;
        } else if (babyWeight >= 7.7 && babyWeight <= 10.5) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      }
    } else {
      if (babyAge.months > 10) {
        if (babyWeight < 7.5) {
          return Colors.redAccent;
        } else if (babyWeight >= 7.5 && babyWeight <= 10.2) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.months > 9) {
        if (babyWeight < 7.2) {
          return Colors.redAccent;
        } else if (babyWeight >= 7.2 && babyWeight <= 9.8) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.months > 8) {
        if (babyWeight < 6.9) {
          return Colors.redAccent;
        } else if (babyWeight >= 6.9 && babyWeight <= 9.3) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.months > 7) {
        if (babyWeight < 6.6) {
          return Colors.redAccent;
        } else if (babyWeight >= 6.6 && babyWeight <= 9.0) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.months > 6) {
        if (babyWeight < 6.2) {
          return Colors.redAccent;
        } else if (babyWeight >= 6.2 && babyWeight <= 8.5) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.months > 5) {
        if (babyWeight < 5.8) {
          return Colors.redAccent;
        } else if (babyWeight >= 5.8 && babyWeight <= 7.9) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.months > 4) {
        if (babyWeight < 5.3) {
          return Colors.redAccent;
        } else if (babyWeight >= 5.3 && babyWeight <= 7.3) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.months > 3) {
        if (babyWeight < 4.9) {
          return Colors.redAccent;
        } else if (babyWeight >= 4.9 && babyWeight <= 6.7) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.months > 2) {
        if (babyWeight < 4.4) {
          return Colors.redAccent;
        } else if (babyWeight >= 4.4 && babyWeight <= 6.0) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.months > 1) {
        if (babyWeight < 3.8) {
          return Colors.redAccent;
        } else if (babyWeight >= 3.8 && babyWeight <= 5.2) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else if (babyAge.months > 0) {
        if (babyWeight < 3.3) {
          return Colors.redAccent;
        } else if (babyWeight >= 3.3 && babyWeight <= 4.4) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      } else {
        if (babyWeight < 2.7) {
          return Colors.redAccent;
        } else if (babyWeight >= 2.7 && babyWeight <= 3.7) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      }
    }
  }

  getStandardText(dynamic type) {
    if (type == 'height') {
      if (getSelectedKid()['gender'] == 'Male') {
        return maleHeightText(
            getSelectedKid()['height'], getSelectedKid()['age']);
      } else if (getSelectedKid()['gender'] == 'Female') {
        return femaleHeightText(
            getSelectedKid()['height'], getSelectedKid()['age']);
      } else {
        return 'not data';
      }
    } else {
      if (getSelectedKid()['gender'] == 'Male') {
        return maleWeightText(
            getSelectedKid()['weight'], getSelectedKid()['age']);
      } else if (getSelectedKid()['gender'] == 'Female') {
        return femaleWeightText(
            getSelectedKid()['weight'], getSelectedKid()['age']);
      } else {
        return 'not data';
      }
    }
  }

  getStandardColor(dynamic type) {
    if (type == 'height') {
      if (getSelectedKid()['gender'] == 'Male') {
        return maleHeightColor(
            getSelectedKid()['height'], getSelectedKid()['age']);
      } else if (getSelectedKid()['gender'] == 'Female') {
        return femaleHeightColor(
            getSelectedKid()['height'], getSelectedKid()['age']);
      } else {
        return Colors.redAccent;
      }
    } else {
      if (getSelectedKid()['gender'] == 'Male') {
        return maleWeightColor(
            getSelectedKid()['weight'], getSelectedKid()['age']);
      } else if (getSelectedKid()['gender'] == 'Female') {
        return femaleWeightColor(
            getSelectedKid()['weight'], getSelectedKid()['age']);
      } else {
        return Colors.redAccent;
      }
    }
  }

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

  List<Map<dynamic, dynamic>> getRecent() {
    List<Map<dynamic, dynamic>> out = new List();
    var tempDatas = new List.from(datas);
    if (tempDatas.length > 0) {
      tempDatas
          .sort((a, b) => a['last_modified'].compareTo(b['last_modified']));
      print('temp datas : $tempDatas');

      for (var i = 0; i < tempDatas.length; i++) {
        out.add(tempDatas[i]);
        if ((tempDatas[i]['type'] == 'vac' && tempDatas[i]['stat'] == 0) ||
            (tempDatas[i]['type'] == 'evo' && tempDatas[i]['stat'] != 0)) {
          out.removeLast();
        }
      }
    }
    out = out.reversed.toList();
    return out;
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
      if ((datas[i])['type'] == type && datas[i]['stat'] == stat) {
        temp.add(datas[i]);
      }
    }
    out = genData(temp);
    return out;
  }

  List getData(String type) {
    List<Map<dynamic, dynamic>> temp = new List();
    List<dynamic> out = new List();
    // print('datas : $datas');
    for (var i = 0; i < datas.length; i++) {
      if ((datas[i])['type'] == type) {
        temp.add(datas[i]);
      }
    }
    out = genData(temp);
    return out;
  }

  // Vaccine
  List vaccineDue = [0, 1, 2, 4, 6, 9, 12, 13, 18, 24, 30, 48];
  List vaccineRaw = List();
  List vaccine = List();

  // add vaccine for first time
  getVaccineListFirst(dynamic birthDate, String babyId) async {
    AgeDuration age =
        Age.dateDifference(fromDate: birthDate, toDate: DateTime.now());
    int sumAge = (age.years * 12) + age.months;
    vaccineRaw = [];
    vaccine = [];

    List<dynamic> listVaccine = await Database().getAllVaccineData();
    print(listVaccine);

    for (int i = 0; i < listVaccine.length; i++) {
      if (listVaccine[i]['due_date'] > sumAge) {
        break;
      }
      vaccine.add(listVaccine[i]);
    }

    for (var i = 0; i < vaccine.length; i++) {
      createVaccine(
          vaccine[i]['val'],
          DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day),
          babyId,
          vaccine[i]['subval'],
          vaccine[i]['due_date'],
          age,
          Timestamp.fromDate(DateTime.now()));
    }
  }

  // add vaccine each month
  // getVaccine(String babyId,dynamic age) async {
  //   int index;
  //   int sumAge = (age.years * 12) + age.months;
  //   vaccineRaw = [];
  //   vaccine = [];

  //   for (index = 0; index < vaccineDue.length; index++) {
  //     if (sumAge < vaccineDue[index]) {
  //       break;
  //     }
  //   }

  //   List<dynamic> listVaccine =
  //       await Database().getVaccineList('${vaccineDue[index - 1]}_month');
  //   if (listVaccine != null) {
  //     for (var i = 0; i < listVaccine.length; i++) {
  //       dynamic data;
  //       await Database().getVaccineData(listVaccine[i]).then((val) {
  //         data = val;
  //       });
  //       this.vaccineRaw.add(data);
  //     }
  //   }

  //   vaccine = mapVaccine(vaccineRaw);

  //   for (var i = 0; i < vaccine.length; i++) {
  //     createVaccine(
  //         vaccine[i]['val'],
  //         DateTime(
  //             DateTime.now().year, DateTime.now().month, DateTime.now().day),
  //         babyId,
  //         vaccine[i]['subval'],
  //         vaccine[i]['due_date'],
  //         age,
  //         Timestamp.fromDate(DateTime.now()));
  //   }
  // }

  // add vaccine for edit kid data
  getvaccineEdit(dynamic birthDate, String babyId) async {
    print('delete vaccinee');

    List<dynamic> listVaccineDelete = await Database().getVaccineLogId(babyId);
    Database().deleteVaccineId(babyId);

    if (listVaccineDelete != null) {
      for (int i = 0; i < listVaccineDelete.length; i++) {
        Database().deleteVaccineLog((listVaccineDelete[i]));
      }

      datas.removeWhere((item) => item['type'] == 'vac');

      print('delete vaccine complete');
      getVaccineListFirst(birthDate, babyId);
    }
  }

  List<dynamic> mapVaccine(List<dynamic> dataList) {
    return (dataList.map((dataList) => dataList.data)).toList();
  }

  createVaccine(dynamic value, DateTime dateTime, String babyId, dynamic subVal,
      int dueDate, dynamic age, Timestamp lastModified) async {
    dynamic logId;
    // create weight log on firebase
    await Database()
        .createVaccineLog(value, Timestamp.fromDate(dateTime), babyId, subVal,
            dueDate, age, lastModified)
        .then((val) {
      logId = val.documentID;
    });
    // update on divice

    addVaccineDatas(value, Timestamp.fromDate(dateTime), babyId, subVal, logId,
        dueDate, age, lastModified);
  }

  addVaccineDatas(
      dynamic value,
      Timestamp dateTime,
      String babyId,
      dynamic subVal,
      dynamic logId,
      int dueDate,
      dynamic age,
      Timestamp lastModified) {
    datas.add({
      'logId': logId,
      'type': 'vac',
      'val': value,
      'subval': subVal,
      'date': dateTime,
      'due_date': dueDate,
      'stat': 0,
      'year': age.years,
      'month': age.months,
      'day': age.days,
      'last_modified': lastModified,
    });
  }

  // develope
  List developeDue = [
    0,
    1,
    3,
    5,
    7,
    9,
    10,
    16,
    18,
    19,
    25,
    30,
    31,
    37,
    42,
    43,
    49,
    55,
    60,
    61,
    67,
    73
  ];
  List developeRaw = List();
  List develope = List();

  // add develope first time
  getDevelopeListFirst(dynamic birthDate, String babyId) async {
    AgeDuration age =
        Age.dateDifference(fromDate: birthDate, toDate: DateTime.now());
    int sumAge = (age.years * 12) + age.months;
    int index;
    developeRaw = [];
    develope = [];

    for (index = 0; index < developeDue.length; index++) {
      if (sumAge < developeDue[index]) {
        break;
      }
    }

    List<dynamic> listDevelope = await Database().getAllDevelope();
    print(listDevelope);

    for (int i = 0; i < listDevelope.length; i++) {
      if (listDevelope[i]['due_date'] > sumAge) {
        break;
      }
      develope.add(listDevelope[i]);
    }

    for (var i = 0; i < develope.length; i++) {
      if (develope[i]['due_date'] < developeDue[index - 1]) {
        createDevelope(
            develope[i]['val'],
            DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day),
            babyId,
            develope[i]['subval'],
            develope[i]['due_date'],
            age,
            2,
            Timestamp.fromDate(DateTime.now()));
      } else {
        createDevelope(
            develope[i]['val'],
            DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day),
            babyId,
            develope[i]['subval'],
            develope[i]['due_date'],
            age,
            1,
            Timestamp.fromDate(DateTime.now()));
      }
    }
  }

  // add develope from edit
  getDevelopeEdit(dynamic birthDate, String babyId) async {
    print('delete develope');
    List<dynamic> listDevelopeDelete =
        await Database().getDevelopeLogId(babyId);
    Database().deleteDevelopeId(babyId);

    if (listDevelopeDelete != null) {
      for (int i = 0; i < listDevelopeDelete.length; i++) {
        Database().deleteDavalopeLog(listDevelopeDelete[i]);
      }

      datas.removeWhere((item) => item['type'] == 'evo');

      print('delete develope complete');
      getDevelopeListFirst(birthDate, babyId);
    }
  }

  List<dynamic> mapDevelope(List<dynamic> dataList) {
    return (dataList.map((dataList) => dataList.data)).toList();
  }

  createDevelope(
      dynamic value,
      DateTime dateTime,
      String babyId,
      dynamic subVal,
      int dueDate,
      dynamic age,
      int stat,
      Timestamp lastModified) async {
    dynamic logId;
    // create weight log on firebase
    await Database()
        .createDevelopeLog(value, Timestamp.fromDate(dateTime), babyId, subVal,
            dueDate, age, stat, lastModified)
        .then((val) {
      logId = val.documentID;
    });
    // update on divice
    if (babyId == getSelectedKid()['kid']) {
      addDevelopeDatas(value, Timestamp.fromDate(dateTime), babyId, subVal,
          logId, dueDate, age, stat, lastModified);
    }
  }

  addDevelopeDatas(
      dynamic value,
      Timestamp dateTime,
      String babyId,
      dynamic subVal,
      dynamic logId,
      int dueDate,
      dynamic age,
      int stat,
      Timestamp lastModified) {
    datas.add({
      'logId': logId,
      'type': 'evo',
      'val': value,
      'subval': subVal,
      'date': dateTime,
      'stat': stat,
      'year': age.years,
      'month': age.months,
      'day': age.days,
      'last_modified': lastModified,
    });
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
  print('temp na : ${temp}');
  for (var j = 0; j < temp.length; j++) {
    for (var k = 0; k < temp.length; k++) {
      if ((temp[j]['date'].millisecondsSinceEpoch) >
          (temp[k]['date'].millisecondsSinceEpoch)) {
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
    while ((eiei[0])['date'].millisecondsSinceEpoch ==
        (eiei[j]['date'].millisecondsSinceEpoch)) {
      print(eiei[j]['date'].millisecondsSinceEpoch);
      temp2.add(eiei[j]);
      j++;
      if (j >= eiei.length) {
        break;
      }
    }
    temp2 = temp2.reversed.toList();
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
