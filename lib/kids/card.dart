import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:momandkid/kids/healthCard.dart';
import 'DataTest.dart';

class card extends StatefulWidget {
  card({this.data, this.type, this.list});
  dataTest data;
  List<Map<dynamic, dynamic>> list;
  String type;
  @override
  _cardState createState() => _cardState();
}

class _cardState extends State<card> {
  @override
  Widget build(BuildContext context) {
    // print(widget.list.runtimeType);
    return Container(
        margin: EdgeInsets.only(top: 0),
        padding: EdgeInsets.only(bottom: 20),
        // width: MediaQuery.of(context).size.width / 1.13,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: getAllCard(context, widget.data, widget.list, widget.type));
  }
}

getAllCard(BuildContext context, dataTest data,
    List<Map<dynamic, dynamic>> list, String type) {
  return Column(
    children: <Widget>[allcard(context, data, list, type)],
  );
}

Widget allcard(BuildContext context, dataTest data,
        List<Map<dynamic, dynamic>> list, String type) =>
    new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Text('Today,'),
                Text('${toDate(list[0]['date'].toDate())}')
              ],
            )),
        Container(
          // color: Colors.red,
          padding: EdgeInsets.all(40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'จำนวน${data.getTitle(type)}',
                style: TextStyle(fontSize: 17),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text('${list.length} ', style: TextStyle(fontSize: 20)),
                  Text('${data.getTitle(type)}',
                      style: TextStyle(fontSize: 17)),
                  // Text(data.getTitle(type))
                ],
              )
            ],
          ),
        ),
        getCard(context, data, list, type)
      ],
    );

getCard(BuildContext context, dataTest data, List<Map<dynamic, dynamic>> list,
    String type) {
  return Column(
      // children: ,
      children: list.map((e) => cards(context, data, type, e)).toList()
      // children: <Widget>[
      //   cards(context,data, type)
      // ],
      );
}

getDateLog(dynamic data) {
  String year = '';
  String month = '';
  String day = '';
  if (data['year'] != 0) {
    year = ' ${data['year']} ปี';
  }
  if (data['month'] != 0) {
    month = ' ${data['month']} เดือน';
  }
  if (data['day'] != 0 || (data['year'] == 0 && data['month'] == 0)) {
    day = ' ${data['day']} วัน';
  }

  return year + month + day;
}

Widget cards(BuildContext context, dataTest data, String type,
        Map<dynamic, dynamic> list) =>
    new GestureDetector(
        onTap: () {
          // data.setRecent(list['id']);
          // print('This is recent ${data.getRecent()}');
          Route route = MaterialPageRoute(
              builder: (context) => healthCard(
                    data: data,
                    type: type,
                    list: list,
                  ));
          Navigator.push(context, route);
        },
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),

          // color: Colors.red,
          // height: ,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // color: Colors.red,
                        border: Border.all(width: 0.3),
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('${data.getImg(type)}'),
                        )),
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width - 250,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: data.getSubval(type) == ''
                            ? <Widget>[
                                Text(
                                  '${list['val']}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ]
                            : <Widget>[
                                Text('${list['val']}'),
                                Text('${list['subval']}')
                              ],
                      ))
                ],
              ),
              Column(
                  children: type == 'vac' || type == 'evo'
                      ? [
                          type == 'evo'
                              ? Icon(
                                  list['stat'] == 2
                                      ? Icons.highlight_off
                                      : Icons.check_circle_outline,
                                  color: list['stat'] == 1
                                      ? Colors.grey
                                      : list['stat'] == 0
                                          ? Colors.green
                                          : Colors.red,
                                )
                              : Icon(Icons.check_circle_outline,
                                  color: list['stat'] == 1
                                      ? Colors.green
                                      : Colors.grey),
                          Container(
                              width: 80, child: Text('อายุ${getDateLog(list)}'))
                        ]
                      : [
                          Container(
                              width: 80, child: Text('อายุ${getDateLog(list)}'))
                        ])
              // Text('อายุ ${list['']} เดือน')
            ],
          ),
        ));

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
