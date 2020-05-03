import 'package:age/age.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BabyInfoModel {
  final String kid;
  final String name;
  final String gender;
  final dynamic height;
  final dynamic weight;
  final String image;
  final Timestamp birthdate;
  final Timestamp date;
  final int sel;

  const BabyInfoModel({
    this.kid,
    this.name,
    this.gender,
    this.height,
    this.weight,
    this.image,
    this.birthdate,
    this.date,
    this.sel,
  });

  BabyInfoModel.formMap(Map<String, dynamic> data)
      : this(
          kid: data['kid'],
          name: data['name'],
          gender: data['gender'],
          height: data['height'],
          weight: data['weight'],
          image: data['image'],
          birthdate: data['birthdate'],
          date: data['date'],
          sel: 0,
        );

  getData() {
    Map babymap = Map();
    babymap['kid'] = this.kid;
    babymap['name'] = this.name;
    babymap['gender'] = this.gender;
    babymap['height'] = this.height;
    babymap['weight'] = this.weight;
    babymap['image'] = this.image;
    babymap['birthdate'] = this.birthdate.toDate();
    babymap['sel'] = this.sel;
    babymap['age'] = getAge(this.birthdate.toDate());
    babymap['date'] = this.date;
    return babymap;
  }

  getAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    AgeDuration age;

    age = Age.dateDifference(fromDate: birthDate, toDate: today);
    return age; // test version use string wait fix next version
  }
}
