import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:frontend/models/message_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MessageProvider extends ChangeNotifier {
  List<Message> _message = [];

  List<Message> get message => _message;

  Future<List<Message>> fetchMessage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final accessToken = preferences.getString("access_token");
    final response = await http.get(
        Uri.parse("http://10.0.2.2:8000/api/messages/"),
        headers: {"Authorization": "Bearer $accessToken"});

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      final List<dynamic> data = jsonData['data'];
      _message = data.map((e) => Message.fromJson(e)).toList();

      notifyListeners();
      return _message;
    } else if (response.statusCode == 401) {
      throw Exception(jsonDecode(response.body)['message']);
    } else {
      throw Exception('Failed to fetch Message!');
    }
  }
}
