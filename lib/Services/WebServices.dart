import 'dart:convert';
import '../Constants/Endpoints.dart';
import 'package:http/http.dart' as http;

int req = 1;

class WebServices {
  Future<List<dynamic>> searchWord(
      String word, int pageNum, int pageSize) async {
    try {
      print(pageNum);
      req++;
      final response = await http.get(
        Uri.parse(EndPoints.baseUrl +
            word +
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

  Future<List> getSuggestions(String word) async {
    try {
      final response = await http.get(
        Uri.parse(EndPoints.baseUrl + '/getSuggestions/' + word),
      );
      print(response.body);

      return jsonDecode(response.body) as List;
    } catch (e) {
      print(e);
    }
  }
}
