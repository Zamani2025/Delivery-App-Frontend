import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:frontend/models/order_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OrdersProvider extends ChangeNotifier {
  List<Order> _order = [];

  List<Order> get order => _order;

  Future<List<Order>> fetchTrend() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final accessToken = preferences.getString("access_token");
    final response = await http.get(
        Uri.parse("http://10.0.2.2:8000/api/all-orders/"),
        headers: {"Authorization": "Bearer $accessToken"});

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      final List<dynamic> data = jsonData['data'];
      _order = data.map((e) => Order.fromJson(e)).toList();

      notifyListeners();
      return _order;
    } else if (response.statusCode == 401) {
      throw Exception(jsonDecode(response.body)['message']);
    } else {
      throw Exception('Failed to fetch Orders!');
    }
  }
}
