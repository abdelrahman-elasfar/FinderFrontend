import 'package:flutter/material.dart';
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:finder/Constants/Colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' hide Text;
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ResultWidget extends StatefulWidget {
  final String url;
  final String query;

  const ResultWidget({Key key, this.url, this.query}) : super(key: key);

  @override
  _ResultWidgetState createState() => _ResultWidgetState();
}

class _ResultWidgetState extends State<ResultWidget>
    with AutomaticKeepAliveClientMixin {
  // declare all stop words
  List<String> stopWords = [
    'a',
    'about',
    'above',
    'after',
    'again',
    'against',
    'all',
    'am',
    'an',
    'and',
    'any',
    'are',
    'aren\'t',
    'as',
    'at',
    'be',
    'because',
    'been',
    'before',
    'being',
    'below',
    'between',
    'both',
    'but',
    'by',
    'can\'t',
    'cannot',
    'could',
    'couldn\'t',
    'did',
    'didn\'t',
    'do',
    'does',
    'doesn\'t',
    'doing',
    'don\'t',
    'down',
    'during',
    'each',
    'few',
    'for',
    'from',
    'further',
    'had',
    'hadn\'t',
    'has',
    'hasn\'t',
    'have',
    'haven\'t',
    'having',
    'he',
    'he\'d',
    'he\'ll',
    'he\'s',
    'her',
    'here',
    'here\'s',
    'hers',
    'herself',
    'him',
    'himself',
    'his',
    'how',
    'how\'s',
    'i',
    'i\'d',
    'i\'ll',
    'i\'m',
    'i\'ve',
    'if',
    'in',
    'into',
    'is',
    'isn\'t',
    'it',
    'it\'s',
    'its',
    'itself',
    'let\'s',
    'me',
    'more',
    'most',
    'mustn\'t',
    'my',
    'myself',
    'no',
    'nor',
    'not',
    'of',
    'off',
    'on',
    'once',
    'only',
    'or',
    'other',
    'ought',
    'our',
    'ours',
    'ourselves',
    'out',
    'over',
    'own',
    'same',
    'shan\'t',
    'she',
    'she\'d',
    'she\'ll',
    'she\'s',
    'should',
    'shouldn\'t',
    'so',
    'some',
    'such',
    'than',
    'that',
    'that\'s',
    'the',
    'their',
    'theirs',
    'them',
    'themselves',
    'then',
    'there',
    'there\'s',
    'these',
    'they',
    'they\'d',
    'they\'ll',
    'they\'re',
    'they\'ve',
    'this',
    'those',
    'through',
    'to',
    'too',
    'under',
    'until',
    'up',
    'very',
    'was',
    'wasn\'t',
    'we',
    'we\'d',
    'we\'ll',
    'we\'re',
    'we\'ve',
    'were',
    'weren\'t',
    'what',
    'what\'s',
    'when',
    'when\'s',
    'where',
    'where\'s',
    'which',
    'while',
    'who',
    'who\'s',
    'whom',
    'why',
    'why\'s',
    'with',
    'won\'t',
    'would',
    'wouldn\'t',
    'you',
    'you\'d',
    'you\'ll',
    'you\'re',
    'you\'ve',
    'your',
    'yours',
    'yourself',
    'yourselves'
  ];
  Metadata metadata;
  bool isLoaded = false;
  String body;
  bool found = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    Future.microtask(() async {
      metadata = await MetadataFetch.extract(widget.url);
      http.Response response = await http.get(Uri.parse(widget.url));

      Document document = parse(response.body);
      // Remove stop words from query
      List<String> words = widget.query.split(' ');
      words.removeWhere((word) => stopWords.contains(word.toLowerCase()));

      for (int i = 0; i < words.length; i++) {
        document.querySelectorAll('p').forEach((value) {
          if (!found &&
              value.innerHtml.toLowerCase().contains(words[i].toLowerCase())) {
            body = value.text;
            found = true;
          }
        });

        document.querySelectorAll('h1').forEach((value) {
          if (!found &&
              value.innerHtml.toLowerCase().contains(words[i].toLowerCase())) {
            body = value.text;
            found = true;
          }
        });

        document.querySelectorAll('h2').forEach((value) {
          if (!found &&
              value.innerHtml.toLowerCase().contains(words[i].toLowerCase())) {
            body = value.text;
            found = true;
          }
        });

        document.querySelectorAll('h3').forEach((value) {
          if (!found &&
              value.innerHtml.toLowerCase().contains(words[i].toLowerCase())) {
            body = value.text;
            found = true;
          }
        });

        document.querySelectorAll('h4').forEach((value) {
          if (!found &&
              value.innerHtml.toLowerCase().contains(words[i].toLowerCase())) {
            body = value.text;
            found = true;
          }
        });

        document.querySelectorAll('h5').forEach((value) {
          if (!found &&
              value.innerHtml.toLowerCase().contains(words[i].toLowerCase())) {
            body = value.text;
            found = true;
          }
        });

        document.querySelectorAll('h6').forEach((value) {
          if (!found &&
              value.innerHtml.toLowerCase().contains(words[i].toLowerCase())) {
            body = value.text;
            found = true;
          }
        });

        if (found) break;
      }

      if (!found) {
        body = metadata.description;
      }

      setState(() {
        isLoaded = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return !isLoaded
        ? SizedBox(
            height: deviceSize.height * 0.2,
            child: Shimmer.fromColors(
              baseColor: ConstantColors.borders,
              highlightColor: ConstantColors.buttons.withOpacity(0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: Colors.transparent,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    margin: EdgeInsets.fromLTRB(235, 15, 0, 0),
                    height: 30,
                    width: deviceSize.width * 0.15,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(235, 15, 0, 0),
                    height: 30,
                    width: deviceSize.width * 0.25,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: Colors.transparent,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(235, 15, 0, 0),
                    height: 60,
                    width: deviceSize.width * 0.35,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: Colors.transparent,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                  ),
                ],
              ),
            ),
          )
        : Container(
            child: Row(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Row(
                    children: [
                      Row(children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(235, 15, 0, 0),
                        )
                      ]),
                      Container(
                        width: deviceSize.width * 0.3,
                        child: InkWell(
                          onTap: () => launchUrl(Uri.parse(widget.url)),
                          child: Text(
                            widget.url,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                color:
                                    ConstantColors.foreground.withOpacity(0.5),
                                fontSize: 14),
                          ),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                          child: IconButton(
                              icon: Icon(
                                Icons.more_vert,
                                color:
                                    ConstantColors.foreground.withOpacity(0.5),
                                size: 18,
                              ),
                              onPressed: () {})),
                    ],
                  ),
                ),
                metadata.title != null
                    ? Container(
                        margin: EdgeInsets.fromLTRB(235, 0, 0, 0),
                        width: deviceSize.width * 0.45,
                        child: InkWell(
                            onTap: () => launchUrl(Uri.parse(widget.url)),
                            child: Text(
                              metadata.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                color: ConstantColors.links,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                      )
                    : Container(),
                metadata.description != null
                    ? Container(
                        margin: EdgeInsets.fromLTRB(235, 5, 0, 0),
                        width: deviceSize.width * 0.4,
                        child: Text(
                          body,
                          maxLines: 2,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color:
                                  ConstantColors.foreground.withOpacity(0.85),
                              fontSize: 15),
                        ),
                      )
                    : Container(),
                metadata.image != null
                    ? Container(
                        width: deviceSize.width * 0.4,
                        height: deviceSize.height * 0.2,
                        margin: EdgeInsets.fromLTRB(235, 10, 0, 0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: CachedNetworkImage(
                              imageUrl: metadata.image,
                              fit: BoxFit.fitWidth,
                              errorWidget: (context, url, error) => Container(),
                            )))
                    : Container(),
              ],
            ),
          ]));
  }
}
