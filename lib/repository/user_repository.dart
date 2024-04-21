import 'dart:convert';
import 'package:http/http.dart';

class Users{
  final String? firstName;
  final String? lastName;
  final String? image;

  Users({this.firstName, this.lastName, this.image});
}

class UserRepository {
  static Future<List<Users>> getUsers() async {
    const  uri = "https://dummyjson.com/users";
    final response = await get(Uri.parse(uri));
    final users = jsonDecode(utf8.decode(response.bodyBytes))['users'];
    final res = users.map<Users>((it) {
      return Users(
        firstName: it['firstName'],
        lastName: it['lastName'],
        image: it['image']);
    }).toList();
      return res;
  }
}