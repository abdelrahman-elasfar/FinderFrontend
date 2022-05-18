import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:finder/Constants/Status.dart';
import 'package:finder/Models/Webpage.dart';
import 'package:finder/Services/WebServices.dart';

class ResultsViewModel with ChangeNotifier {
  Status status = Status.success;
  List<Webpage> webpages = [];
  String query = '';
  int pageKey = 0;
  int pageSize = 6;

  // bool new search to determine if you are searching for a new query or just navigating to a new page
  Future<List<Webpage>> searchQuery(String query, bool newSearch) async {
    try {
      if (newSearch) {
        webpages.clear();
        pageKey = 0;
      }
      this.query = query;
      status = Status.loading;
      notifyListeners();
      final results = await WebServices().searchQuery(query, pageKey, pageSize);

      for (int i = 0; i < results.length; i++) {
        Webpage webpage = Webpage.fromJson(results[i]);
        webpages.add(webpage);
      }

      status = Status.success;
      pageKey++;
      notifyListeners();
      return webpages;
    } catch (error) {
      print(error);
      return null;
    }
  }
}
