import 'dart:convert';
import '../Constants/Endpoints.dart';
import 'package:http/http.dart' as http;

class WebServices {
  Future<List<dynamic>> searchQuery(
      String query, int pageNum, int pageSize) async {
    try {
      print(pageNum);
      final response = await http.get(
        Uri.parse(EndPoints.baseUrl +
            query +
            "?pageSize=" +
            pageSize.toString() +
            "&pageNum=" +
            pageNum.toString()),
      );
      print(response.body);
      return jsonDecode(response.body) as List;
    } catch (error) {
      print(error);
    }
  }

  Future<List> getSuggestions(String query) async {
    try {
      final response = await http.get(
        Uri.parse(EndPoints.baseUrl + '/getSuggestions/' + query),
      );
      print(response.body);

      return jsonDecode(response.body) as List;
    } catch (e) {
      print(e);
    }
  }
}
