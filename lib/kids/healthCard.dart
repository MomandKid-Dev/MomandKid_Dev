import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:momandkid/services/database.dart';
import 'package:momandkid/shared/style.dart';
import 'DataTest.dart';

DateTime selectedDated =
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
var valued;

class healthCard extends StatefulWidget {
  healthCard({this.data, this.type, this.list});
  dataTest data;
  DateTime date;
  String type;
  Map<dynamic, dynamic> list;
  @override
  _healthCardState createState() => _healthCardState();
}

class _healthCardState extends State<healthCard> {
  updateData(String type, String babyId) {
    List list = List();
    list = widget.data.getData(type);

    print('list: $list');

    if (list.length > 0) {
      if (list[0].length > 0) {
        if (type == 'weight') {
          // update on firebase
          Database().updateWeight(list[0][0]['val'], babyId);
          // update on divice (kiddo)
          widget.data.getSelectedKid()['weight'] = list[0][0]['val'];
        } else {
          // update on firebase
          Database().updateHeight(list[0][0]['val'], babyId);
          // update on divice (kiddo)
          widget.data.getSelectedKid()['height'] = list[0][0]['val'];
        }
      }
    }
  }

  deleteHeight(String babyId, String logId) {
    Database().deleteHeightLog(babyId, logId);
    widget.data.setDatas(widget.list['id'], widget.list['type']);
    updateData('height', babyId);
  }

  deleteWeight(String babyId, String logId) {
    Database().deleteWeightLog(babyId, logId);
    widget.data.setDatas(widget.list['id'], widget.list['type']);
    updateData('weight', babyId);
  }

  deleteMedicine(String babyId, String logId) {
    Database().deleteMedicineLog(babyId, logId);
    widget.data.setDatas(widget.list['id'], widget.list['type']);
  }

  updateVaccine(String logId, bool check, Timestamp lastModified) {
    if (check) {
      Database().updateVaccineLog(logId, 1, lastModified);
      widget.list['stat'] = 1;
    } else {
      Database().updateVaccineLog(logId, 0, lastModified);
      widget.list['stat'] = 0;
    }
    widget.list['last_modified'] = lastModified;
  }

  updateDevelope(
      String logId, bool check, dynamic age, Timestamp lastModified) {
    if (check) {
      Database().updateDevelopeLog(
          logId,
          0,
          Timestamp.fromDate(DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)),
          age,
          lastModified);
      updateDataDevice(
          0,
          Timestamp.fromDate(DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)),
          age,
          lastModified);
    } else {
      int sumAge = (age.years * 12) + age.months;
      if (widget.list['due_date'] < sumAge) {
        Database().updateDevelopeLog(
            logId,
            2,
            Timestamp.fromDate(DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day)),
            age,
            lastModified);
        updateDataDevice(
            2,
            Timestamp.fromDate(DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day)),
            age,
            lastModified);
      } else {
        Database().updateDevelopeLog(
            logId,
            1,
            Timestamp.fromDate(DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day)),
            age,
            lastModified);
        updateDataDevice(
            1,
            Timestamp.fromDate(DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day)),
            age,
            lastModified);
      }
    }
  }

  updateDataDevice(
      int stat, Timestamp dateDevelope, dynamic age, Timestamp lastModified) {
    widget.list['date'] = dateDevelope;
    widget.list['stat'] = stat;
    widget.list['year'] = age.years;
    widget.list['month'] = age.months;
    widget.list['day'] = age.days;
    widget.list['last_modified'] = lastModified;
  }

  @override
  void initState() {
    super.initState();
    widget.date =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  }

  @override
  Widget build(BuildContext context) {
    var trashIcon;
    if (widget.type == 'vac' || widget.type == 'evo') {
      trashIcon = Icon(
        Icons.highlight_off,
        size: 80,
        color: Color(0xff131048).withOpacity(0.6),
      );
    } else {
      trashIcon = Icon(
        Icons.delete_outline,
        size: 80,
        color: Color(0xff131048).withOpacity(0.6),
      );
    }
    var cardHeight = 0.0;
    if (widget.type == 'evo') {
      cardHeight = 2;
    } else if (widget.type == 'vac') {
      cardHeight = 1;
    }
    callback(var1, var2) {}
    dataTest card = widget.data;
    bool exit = false;
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Color.fromRGBO(255, 226, 241, 1),
                Color.fromRGBO(233, 242, 255, 1)
              ])),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    GestureDetector(
                      onTapDown: (TapDownDetails details) {
                        exit = true;
                      },
                      onTapCancel: () {
                        if (exit) {
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            top: 20, left: 20, right: 20, bottom: 20),
                        width: MediaQuery.of(context).size.width / 1.13,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Image.asset(
                                  card.getImg(widget.type),
                                  height: 56,
                                  width: 56,
                                ),
                                Container(
                                  child: Text(
                                    card.getTitle(widget.type),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'Segoe UI',
                                        fontSize: 20,
                                        color: Color(0xff131048),
                                        fontWeight: FontWeight.normal),
                                  ),
                                  padding: EdgeInsets.only(bottom: 30),
                                ),
                                Text(
                                  widget.list['val'].toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Segoe UI',
                                      fontSize: 30,
                                      color: Color(0xff131048),
                                      fontWeight: FontWeight.w700),
                                ),
                                Container(
                                  child: Text(
                                    widget.list['subval'],
                                    style: TextStyle(
                                        fontFamily: 'Segoe UI',
                                        fontSize: 20,
                                        color: Color(0xff131048),
                                        fontWeight: FontWeight.normal),
                                  ),
                                  padding: EdgeInsets.only(bottom: 20),
                                ),
                                table(
                                  type: widget.type,
                                  card: card,
                                  list: widget.list,
                                  date: widget.date,
                                  callbacks: callback,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 30),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: SizedBox(),
                          ),
                          Expanded(
                            flex: 2,
                            child: RawMaterialButton(
                              child: Container(
                                  child: Icon(
                                Icons.check_circle_outline,
                                size: 100,
                                color: Color(0xff131048).withOpacity(0.6),
                              )),
                              onPressed: () {
                                switch (widget.type) {
                                  case 'vac':
                                    updateVaccine(widget.list['logId'], true,
                                        Timestamp.fromDate(DateTime.now()));
                                    break;
                                  case 'evo':
                                    updateDevelope(
                                        widget.list['logId'],
                                        true,
                                        widget.data.getSelectedKid()['age'],
                                        Timestamp.fromDate(DateTime.now()));
                                    break;
                                  default:
                                    break;
                                }

                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Expanded(
                              flex: 4,
                              child: Container(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(left: 50, right: 20),
                                child: RawMaterialButton(
                                  child: Container(child: trashIcon),
                                  onPressed: () {
                                    switch (widget.type) {
                                      case 'height':
                                        deleteHeight(
                                            widget.data.getSelectedKid()['kid'],
                                            widget.list['logId']);

                                        break;
                                      case 'weight':
                                        deleteWeight(
                                            widget.data.getSelectedKid()['kid'],
                                            widget.list['logId']);
                                        break;
                                      case 'med':
                                        deleteMedicine(
                                            widget.data.getSelectedKid()['kid'],
                                            widget.list['logId']);
                                        break;
                                      case 'vac':
                                        updateVaccine(
                                            widget.list['logId'],
                                            false,
                                            Timestamp.fromDate(DateTime.now()));
                                        break;
                                      case 'evo':
                                        updateDevelope(
                                            widget.list['logId'],
                                            false,
                                            widget.data.getSelectedKid()['age'],
                                            Timestamp.fromDate(DateTime.now()));
                                        break;
                                      default:
                                        break;
                                    }
                                    Navigator.pop(context);
                                  },
                                ),
                              ))
                        ],
                      ),
                    )
                  ],
                )
              ]),
        ));
  }
}

class table extends StatefulWidget {
  table({this.type, this.card, this.list, this.date, this.callbacks});
  String type;
  dataTest card;
  Map<dynamic, dynamic> list;
  Function(dynamic, DateTime) callbacks;
  DateTime date;
  @override
  _tableState createState() => _tableState();
}

class _tableState extends State<table> {
  callback(newVal, newDate) {
    setState(() {
      print(newVal.toString() + ' ' + newDate.toString());
      widget.callbacks(newVal, newDate);
    });
  }

  Widget build(BuildContext cotext) {
    List temp = new List();
    var tableList;
    if (widget.list != null) {
      if ((widget.type == 'evo'.toString())) {
        tableList = [
          tab(
            keys: 'ช่วงอายุ',
            value: widget.list['subval'],
            date: widget.date,
            callback: callback,
          ),
          Divider(
            height: 30,
          ),
          tab(
            keys: 'Date',
            value: toDate(widget.list['date'].toDate().toUtc()),
            date: widget.date,
            callback: callback,
          )
        ];
      } else if (widget.type == 'vac') {
        tableList = [
          tab(
            keys: 'ช่วงอายุ',
            value: widget.list['subval'],
            date: widget.date,
            callback: callback,
          ),
          Divider(
            height: 30,
          ),
          tab(
            keys: 'Date',
            value: toDate(widget.list['date'].toDate()),
            date: widget.date,
            callback: callback,
          )
        ];
      } else {
        tableList = [
          tab(
            keys: widget.card.getTitle(widget.type),
            value: widget.list['val'].toString(),
            date: widget.date,
            callback: callback,
          ),
          Divider(
            height: 30,
          ),
          tab(
            keys: 'Date',
            value: toDate(widget.list['date'].toDate().toUtc()),
            date: widget.date,
            callback: callback,
          )
        ];
      }
    } else {
      tableList = [
        tab(
          keys: widget.card.getTitle(widget.type),
          value: null,
          date: widget.date,
          callback: callback,
        ),
        Divider(
          height: 30,
        ),
        tab(
          keys: 'Date',
          value: null,
          date: widget.date,
          callback: callback,
        )
      ];
    }
    Widget tables() => Column(children: tableList);
    return tables();
  }
}

class tab extends StatefulWidget {
  tab({this.keys, this.value, this.date, this.type, this.callback});
  String keys, value, type;
  DateTime date;
  DateTime selectedDate = DateTime.now();
  Function(dynamic, DateTime) callback;

  @override
  _tabState createState() => _tabState();
}

class _tabState extends State<tab> {
  int day, mon, year;

  // DateTime selectedDate;
  TextEditingController textController;
  var temp;
  List month = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  @override
  void initState() {
    super.initState();
    textController = new TextEditingController();
    if (widget.date == null) {
      widget.date = DateTime.now();
    }
    day = widget.date.day;
    mon = widget.date.month;
    year = widget.date.year;
    widget.selectedDate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    valued = textController.text;
  }

  setVal(var val) {
    setState(() {
      valued = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(widget.keys,
                style: TextStyle(fontSize: 20, color: Color(0xff131048))),
            widget.value == null
                ? Container(
                    width: 100,
                    child: widget.keys == 'Date'
                        ? GestureDetector(
                            onTap: () {
                              showDatePicker(
                                      context: context,
                                      initialDate: DateTime(year, mon, day),
                                      firstDate:
                                          DateTime(DateTime.now().year - 1),
                                      lastDate: DateTime.now())
                                  .then((newDate) {
                                setState(() {
                                  day = newDate.day;
                                  mon = newDate.month;
                                  year = newDate.year;
                                  selectedDated = newDate;
                                  temp = newDate.month;
                                  widget.callback(valued, selectedDated);
                                });
                              });
                            },
                            child: Text('${day.toString()}' +
                                ' ${month[mon - 1]} ' +
                                '${year.toString()}'))
                        : TextFormField(
                            controller: textController,
                            onChanged: (text) {
                              setVal(text);
                              setState(() {
                                widget.callback(valued, selectedDated);
                              });
                            },
                          ))
                : Text(
                    widget.value,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 18, color: Color(0xff625BD4)),
                    overflow: TextOverflow.fade,
                  ),
          ],
        ));
  }
}

toDate(DateTime date) {
  String newDate = '';
  List month = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  newDate += date.day.toString();
  newDate += ' ';
  newDate += month[date.month];
  newDate += ' ';
  newDate += date.year.toString();
  return newDate;
}

class editCard extends StatefulWidget {
  editCard({this.data, this.type, this.userId});
  dataTest data;
  String type;
  String userId;
  @override
  _editCardState createState() => _editCardState();
}

class _editCardState extends State<editCard> {
  DateTime date;
  DateTime selectedDate;
  var value;
  @override
  void initState() {
    super.initState();
    date = DateTime.now();
    selectedDated =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  }

  callback(newVal, newDate) {
    setState(() {
      selectedDate = newDate;
      value = newVal;
    });
  }

  createHeight(dynamic value, DateTime dateTime, String babyId, dynamic subVal,
      dynamic age, Timestamp lastModified) async {
    dynamic logId;
    // create height log on firebase
    logId = await Database().createHeightLog(double.parse(value),
        Timestamp.fromDate(dateTime), babyId, subVal, age, lastModified);
    // create hieght log on device (datas)
    addHeight(double.parse(value), Timestamp.fromDate(dateTime), babyId, subVal,
        age, logId, lastModified);

    dynamic oldDate =
        widget.data.getData('height')[0][0]['date'].millisecondsSinceEpoch;
    if (oldDate == Timestamp.fromDate(dateTime).millisecondsSinceEpoch) {
      // update on firebase
      Database().updateHeight(double.parse(value), babyId);
      // update on device (kiddo)
      widget.data.getSelectedKid()['height'] = double.parse(value);
    }
  }

  addHeight(double value, Timestamp dateTime, String babyId, dynamic subVal,
      dynamic age, dynamic logId, Timestamp lastModified) {
    widget.data.datas.add({
      'logId': logId,
      'type': 'height',
      'val': value,
      'subval': subVal,
      'date': dateTime,
      'year': age.years,
      'month': age.months,
      'day': age.days,
      'last_modified': lastModified,
    });
  }

  createWeight(dynamic value, DateTime dateTime, String babyId, dynamic subVal,
      dynamic age, Timestamp lastModified) async {
    dynamic logId;
    // create weight log on firebase
    logId = await Database().createWeightLog(double.parse(value),
        Timestamp.fromDate(dateTime), babyId, subVal, age, lastModified);
    // create wieght log on device (datas)
    addWeight(double.parse(value), Timestamp.fromDate(dateTime), babyId, subVal,
        age, logId, lastModified);

    dynamic oldDate =
        widget.data.getData('weight')[0][0]['date'].millisecondsSinceEpoch;
    if (oldDate == Timestamp.fromDate(dateTime).millisecondsSinceEpoch) {
      // update on firebase
      Database().updateWeight(double.parse(value), babyId);
      // update on divice (kiddo)
      widget.data.getSelectedKid()['weight'] = double.parse(value);
    }
  }

  addWeight(double value, Timestamp dateTime, String babyId, dynamic subVal,
      dynamic age, dynamic logId, Timestamp lastModified) {
    widget.data.datas.add({
      'logId': logId,
      'type': 'weight',
      'val': value,
      'subval': subVal,
      'date': dateTime,
      'year': age.years,
      'month': age.months,
      'day': age.days,
      'last_modified': lastModified,
    });
  }

  createMedicine(dynamic value, DateTime dateTime, String babyId,
      dynamic subVal, dynamic age, Timestamp lastModified) async {
    dynamic logId;
    // create weight log on firebase
    logId = Database().createMedicineLog(
        value, Timestamp.fromDate(dateTime), babyId, subVal, age, lastModified);
    // update on divice
    addMedicineDatas(value, Timestamp.fromDate(dateTime), babyId, subVal, age,
        logId, lastModified);
  }

  addMedicineDatas(dynamic value, Timestamp dateTime, String babyId,
      dynamic subVal, dynamic age, dynamic logId, Timestamp lastModified) {
    widget.data.datas.add({
      'logId': logId,
      'type': 'med',
      'val': value,
      'subval': subVal,
      'date': dateTime,
      'year': age.years,
      'month': age.months,
      'day': age.days,
      'last_modified': lastModified,
    });
  }

  createLog(String type, dynamic value, DateTime dateTime, String babyId,
      dynamic subVal, dynamic age, Timestamp lastModified) {
    switch (type) {
      case 'height':
        return createHeight(value, dateTime, babyId, subVal, age, lastModified);
        break;
      case 'weight':
        return createWeight(value, dateTime, babyId, subVal, age, lastModified);
        break;
      case 'med':
        return createMedicine(
            value, dateTime, babyId, subVal, age, lastModified);
        break;
      case 'vac':
        break;
      case 'evo':
        break;
      default:
        break;
    }
  }

  deleteLog(String type, String babyId, String logId) {}

  @override
  Widget build(BuildContext context) {
    var cardHeight = 0;
    if (widget.type == 'evo') {
      cardHeight = 1;
    } else if (widget.type == 'vac') {
      cardHeight = 1;
    }

    dataTest card = widget.data;
    bool exit = false;
    return Scaffold(
        body: ListView(
            physics: BouncingScrollPhysics(),
            padding: edgeAll(0),
            children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Color.fromRGBO(255, 226, 241, 1),
                  Color.fromRGBO(233, 242, 255, 1)
                ])),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      GestureDetector(
                        child: Container(
                          height: (220 + 56 * (2 + cardHeight)).toDouble(),
                          padding:
                              EdgeInsets.only(top: 20, left: 20, right: 20),
                          width: MediaQuery.of(context).size.width / 1.13,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Image.asset(
                                    card.getImg(widget.type),
                                    height: 56,
                                    width: 56,
                                  ),
                                  Container(
                                    child: Text(
                                      card.getTitle(widget.type),
                                      style: TextStyle(
                                          fontFamily: 'Segoe UI',
                                          fontSize: 20,
                                          color: Color(0xff131048),
                                          fontWeight: FontWeight.normal),
                                    ),
                                    padding: EdgeInsets.only(bottom: 30),
                                  ),
                                  Text(
                                    value == null ? "0" : value.toString(),
                                    style: TextStyle(
                                        fontFamily: 'Segoe UI',
                                        fontSize: 30,
                                        color: Color(0xff131048),
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Container(
                                    child: Text(
                                      'test',
                                      style: TextStyle(
                                          fontFamily: 'Segoe UI',
                                          fontSize: 14,
                                          color: Color(0xff131048),
                                          fontWeight: FontWeight.normal),
                                    ),
                                    padding: EdgeInsets.only(bottom: 20),
                                  ),
                                  table(
                                    type: widget.type,
                                    card: card,
                                    list: null,
                                    date: date,
                                    callbacks: callback,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 30),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 4,
                              child: SizedBox(),
                            ),
                            Expanded(
                              flex: 2,
                              child: RawMaterialButton(
                                child: Container(
                                  child: Image.asset(
                                      'assets/icons/check-circle.png'),
                                ),
                                onPressed: () async {
                                  print('create log');
                                  await createLog(
                                      widget.type,
                                      value,
                                      selectedDate,
                                      widget.data.getSelectedKid()['kid'],
                                      '',
                                      widget.data.getSelectedKid()['age'],
                                      Timestamp.fromDate(DateTime.now()));
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            Expanded(
                                flex: 4,
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.only(left: 50, right: 20),
                                  child: RawMaterialButton(
                                    child: Container(
                                      child: Image.asset(
                                          'assets/icons/trash-alt.png'),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ))
                          ],
                        ),
                      )
                    ],
                  )
                ]),
          )
        ]));
  }
}
