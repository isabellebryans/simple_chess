import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:xml2json/xml2json.dart';
import 'package:simple_chess/SHACL/SHACLResults.dart';
import 'package:simple_chess_board/models/short_move.dart';
import 'package:chess/chess.dart' as chesslib;

String SHACL_results = "";

Future<String> update_board(ShortMove move) async {
  final response = await http.post(
    Uri.parse('http://localhost:3000/updateBoard'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'from': move.from, 'to': move.to}),
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    String responsedata = response.body;

    print(responsedata);
    print(response.statusCode);

    return responsedata;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to update board');
  }
}

Future<String> reset_board() async {
  final response = await http.post(
    Uri.parse('http://localhost:3000/resetBoard'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    String responsedata = response.body;

    print(responsedata);
    print(response.statusCode);

    return responsedata;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to reset board');
  }
}

// ignore: non_constant_identifier_names
Future<String> SHACL_move_validation(
    ShortMove move, chesslib.Piece? capturedPiece) async {
  final response = await http.post(
    Uri.parse('http://localhost:3000/testMove'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'from': move.from, 'to': move.to}),
  );

  print(response.statusCode);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    //dynamic jsonObject = jsonDecode(response.body);
    //String conforms = jsonObject['@graph'][0]['sh:conforms']['@value'];
    SHACLResults results = SHACLResults.fromJson(jsonDecode(response.body));
    print(results.conforms);
    String responsedata = response.body;
    print("here");
    SHACL_results = responsedata;
    print(responsedata);
    print(response.statusCode);
    print("after response 1 body");
    //print(response2.statusCode);
    return responsedata;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}
