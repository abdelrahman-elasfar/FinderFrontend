import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:finder/Constants/Status.dart';
import 'package:finder/Services/WebServices.dart';

class SuggestionsViewModel with ChangeNotifier {
  Status status = Status.success;
  List<String> suggestions = [];

  Future<bool> getSuggesitons(String word) async {
    try {
      final List results = await WebServices().getSuggestions(word);
      List<String> newSuggestions = [];
      for (int i = 0; i < results.length; i++) {
        String suggestion = results[i]['word'];
        newSuggestions.add(suggestion);
      }
      if (word != '') {
        suggestions = newSuggestions;
      } else {
        suggestions = [];
      }

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}
