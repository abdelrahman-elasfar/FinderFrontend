import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:finder/Constants/Status.dart';
import 'package:finder/Models/WebsiteModel.dart';
import 'package:finder/Services/WebServices.dart';

class ResultsViewModel with ChangeNotifier {
  Status status = Status.success;
  List<Website> websites = [
    Website(
        url:
            'https://www.theguardian.com/football/2022/may/14/chelsea-liverpool-fa-cup-final-match-report',
        tf: 121,
        titleFrequency: 23131,
        plainTextFrequency: 232321),
    Website(
        url:
            'https://www.skysports.com/football/chelsea-vs-liverpool/report/463481',
        tf: 121,
        titleFrequency: 23131,
        plainTextFrequency: 232321),
    Website(
        url:
            'https://www.thisisanfield.com/2022/05/wembley-deja-vu-double-in-the-bag-5-talking-points-from-liverpools-fa-cup-triumph/',
        tf: 121,
        titleFrequency: 23131,
        plainTextFrequency: 232321),
    Website(
        url:
            'https://www.thisisanfield.com/2022/05/liverpool-0-0-chelsea-6-5-pens-player-ratings/',
        tf: 121,
        titleFrequency: 23131,
        plainTextFrequency: 232321),
    Website(
        url:
            'https://twitter.com/LFC?ref_src=twsrc%5Egoogle%7Ctwcamp%5Eserp%7Ctwgr%5Eauthor',
        tf: 121,
        titleFrequency: 23131,
        plainTextFrequency: 232321),
    Website(
        url:
            'https://www.liverpoolecho.co.uk/sport/football/football-news/liverpool-chelsea-facup-live-score-23949941',
        tf: 121,
        titleFrequency: 23131,
        plainTextFrequency: 232321),
    Website(
        url: 'https://www.instagram.com/liverpoolfc/?hl=en',
        tf: 121,
        titleFrequency: 23131,
        plainTextFrequency: 232321),
  ];
  String word = '';
  int pageKey = 0;
  int pageSize = 6;

  Future<List<Website>> searchWord(String word, bool newSearch) async {
    try {
      if (newSearch) {
        websites.clear();
        pageKey = 0;
      }
      this.word = word;
      status = Status.loading;
      notifyListeners();
      final results = await WebServices().searchWord(word, pageKey, pageSize);

      for (int i = 0; i < results.length; i++) {
        Website website = Website.fromJson(results[i]);
        websites.add(website);
      }

      status = Status.success;
      pageKey++;
      notifyListeners();
      return websites;
    } catch (error) {
      print(error);
      return null;
    }
  }
}
