import 'package:cloud_firestore/cloud_firestore.dart';

class BabyInfoModel {
  final String name;
  final String gender;
  final dynamic height;
  final dynamic weight;
  final String image;
  final Timestamp birthdate;
  final int sel;

  const BabyInfoModel({
    this.name,
    this.gender,
    this.height,
    this.weight,
    this.image,
    this.birthdate,
    this.sel,
  });

  BabyInfoModel.formMap(Map<String, dynamic> data)
      : this(
          name: data['name'],
          gender: data['gender'],
          height: data['height'],
          weight: data['weight'],
          image: data['image'],
          birthdate: data['birthdate'],
          sel: 0,
        );

  getData() {
    Map babymap = Map();
    babymap['name'] = this.name;
    babymap['gender'] = this.gender;
    babymap['height'] = this.height;
    babymap['weight'] = this.weight;
    babymap['image'] = this.image;
    babymap['birthdate'] = this.birthdate;
    babymap['sel'] = this.sel;
    return babymap;
  }
}
