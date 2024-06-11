import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/task.dart';

class APIService {
  static final APIService singleton = APIService();

  Future<List<String>> sendRequest(String command) async {
    final url = Uri.parse('http://localhost:8000/$command');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final value = jsonDecode(response.body);
      return List<String>.from(value);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Task> askCurrentTask(String command) async {
    final url = Uri.parse('http://localhost:8000/$command');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final value = jsonDecode(response.body);
      return Task(value['task_name'], value['completion_percent']);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
