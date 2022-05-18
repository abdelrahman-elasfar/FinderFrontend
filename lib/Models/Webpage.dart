class Webpage {
  int termFreq;
  int titleFreq;
  int textFreq;
  int headingsFreq;
  int normalFreq;
  double score;
  String url;

  Webpage(
      {this.headingsFreq,
      this.textFreq,
      this.termFreq,
      this.titleFreq,
      this.normalFreq,
      this.score,
      this.url});

  factory Webpage.fromJson(Map<String, dynamic> json) {
    return Webpage(
      headingsFreq: json["headingsFreq"],
      textFreq: json["textFreq"],
      termFreq: json["termFreq"],
      titleFreq: json["titleFreq"],
      normalFreq: json["normalFreq"],
      score: json["score"].toDouble(),
      url: json["url"],
    );
  }
}
