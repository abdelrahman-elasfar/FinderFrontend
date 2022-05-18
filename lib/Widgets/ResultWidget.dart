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
      // declare array of strings
      List<String> words = widget.query.split(' ');
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
