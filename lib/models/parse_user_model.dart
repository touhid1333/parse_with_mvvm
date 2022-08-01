import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class ParseUserModel extends ParseUser implements ParseCloneable {
  ParseUserModel() : super('username', 'email', 'password');

  ParseUserModel.clone() : this();

  @override
  dynamic clone(Map<String, dynamic> map) {
    return ParseUserModel.clone()..fromJson(map);
  }

  //user age
  int get age => get('age');

  set age(int age) => set('age', age);

  //user profession
  String get profession => get('profession');

  set profession(String profession) => set('profession', profession);
}
