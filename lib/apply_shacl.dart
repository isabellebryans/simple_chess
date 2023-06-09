import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:xml2json/xml2json.dart';

Future<String> fetchAlbum() async {
  /* final response2 = await http.post(
    Uri.parse('http://localhost:3000/updateBoard'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'from': "d1", 'to': "d3", 'piece': "P2"}),
  );*/

  /* final response2 = await http.post(
    Uri.parse('http://localhost:3000/resetBoard'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );*/
  final response2 = await http.post(
    Uri.parse('http://localhost:3000/testMove'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'from': "d1", 'to': "d3", 'piece': "P2"}),
  );

  final response = await http.get(Uri.parse('http://localhost:3000/move'));

  print(response.statusCode);
  print(response2.statusCode);

  if (response.statusCode == 200 && response2.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    String responsedata = response.body;
    print("here");
    print(responsedata);
    print(response2.body);
    print(response.statusCode);
    print("after repone 1 body");
    //print(response2.statusCode);
    return responsedata;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Album {
  final int userId;
  final int id;
  final String title;

  const Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}
