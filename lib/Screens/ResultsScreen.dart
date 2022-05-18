import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:finder/Constants/Colors.dart';
import 'package:finder/Constants/Status.dart';
import 'package:finder/Screens/HomeScreen.dart';
import 'package:finder/ViewModels/ResultsViewModel.dart';
import 'package:finder/ViewModels/SuggestionsViewModel.dart';
import 'package:finder/Widgets/ResultWidget.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ResultsScreen extends StatefulWidget {
  static final routeName = '/search';
  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  ResultsViewModel resultsViewModel;
  SuggestionsViewModel suggestionsViewModel;
  bool isSpeechAvailable = false;
  bool isRecognitionOn = false;
  stt.SpeechToText speech = stt.SpeechToText();
  TextEditingController searchController = TextEditingController();
  IconButton clearButton;
  ScrollController scrollController = ScrollController();

  SpeechRecognitionResult results;
  @override
  void initState() {
    searchController.addListener(() {
      if (searchController.text.isNotEmpty) {
        setState(() {
          clearButton = IconButton(
            padding: const EdgeInsetsDirectional.only(end: 12.0),
            iconSize: 20,
            icon: Icon(
              Icons.close,
              color: ConstantColors.borders,
            ),
            onPressed: () {
              setState(() {
                searchController.clear();
              });
            },
          );
        });
      } else {
        setState(() {
          clearButton = null;
        });
      }
    });
    resultsViewModel = Provider.of<ResultsViewModel>(context, listen: false);
    suggestionsViewModel =
        Provider.of<SuggestionsViewModel>(context, listen: false);
    searchController.text = resultsViewModel.query;
    Future.microtask(() async {
      resultsViewModel.searchQuery(searchController.text, true);
      try {
        if (!isSpeechAvailable) {
          isSpeechAvailable = await speech.initialize(
            onStatus: (status) {},
            onError: (error) {},
          );
        }
      } catch (error) {
        print(error);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    resultsViewModel = Provider.of<ResultsViewModel>(context, listen: true);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: ConstantColors.background,
        body: SingleChildScrollView(
          child: Container(
            height: deviceSize.height,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                ),
                Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          margin: EdgeInsets.fromLTRB(30, 0, 5, 0),
                          child: IconButton(
                              icon: Icon(
                                Icons.menu,
                                color: ConstantColors.foreground,
                              ),
                              onPressed: () {})),
                      InkWell(
                        onTap: () {
                          resultsViewModel.query = '';
                          Navigator.pushReplacementNamed(
                              context, HomeScreen.routeName);
                        },
                        child: Container(
                          width: 100,
                          margin: EdgeInsets.fromLTRB(30, 0, 5, 0),
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: RichText(
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              text: TextSpan(
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Finder',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Uomo',
                                      fontStyle: FontStyle.italic,
                                      color: ConstantColors.foreground,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: deviceSize.width * 0.35 > 200
                                  ? deviceSize.width * 0.35
                                  : 200,
                              child: TypeAheadField(
                                loadingBuilder: (BuildContext context) =>
                                    Container(
                                        height: 12,
                                        width: 12,
                                        margin:
                                            EdgeInsets.fromLTRB(20, 20, 20, 20),
                                        child: CircularProgressIndicator(
                                          backgroundColor: Colors.transparent,
                                          color: ConstantColors.borders,
                                          strokeWidth: 1.5,
                                        )),
                                textFieldConfiguration: TextFieldConfiguration(
                                  controller: searchController,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: ConstantColors.foreground),
                                  decoration: new InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 0.0, horizontal: 20.0),
                                      enabledBorder: new OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 0.0),
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(30.0),
                                        ),
                                      ),
                                      focusedBorder: new OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 0.0),
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(30.0),
                                        ),
                                      ),
                                      filled: true,
                                      suffixIcon: clearButton,
                                      hintStyle: new TextStyle(
                                          color: ConstantColors.borders),
                                      hintText: "",
                                      fillColor: ConstantColors.buttons),
                                ),
                                suggestionsCallback: (pattern) async {
                                  await suggestionsViewModel
                                      .getSuggesitons(pattern);
                                  //return ["Liverpool", "Chelsea", "Ahly", "Zamalek"];
                                  return suggestionsViewModel.suggestions;
                                },
                                itemBuilder: (context, suggestion) {
                                  return ListTile(
                                      contentPadding:
                                          EdgeInsets.fromLTRB(15, 0, 15, 0),
                                      title: Text(
                                        suggestion,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: ConstantColors.foreground),
                                      ));
                                },
                                noItemsFoundBuilder: (context) {
                                  return Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(15, 15, 15, 15),
                                      child: Text("No suggestions found",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: ConstantColors.foreground
                                                .withOpacity(0.5),
                                          )));
                                },
                                onSuggestionSelected: (suggestion) async {
                                  searchController.text = suggestion;
                                  resultsViewModel.query =
                                      searchController.text;
                                  FocusScope.of(context).unfocus();
                                  // _pagingController.refresh();
                                },
                                suggestionsBoxDecoration:
                                    SuggestionsBoxDecoration(
                                  color: ConstantColors.buttons,
                                  borderRadius: BorderRadius.circular(10),
                                  elevation: 5,
                                ),
                              ),
                            ),
                            Container(
                              child: IconButton(
                                icon: Icon(Icons.search,
                                    color: ConstantColors.borders),
                                onPressed: () async {
                                  if (searchController.text.isNotEmpty) {
                                    resultsViewModel.query =
                                        searchController.text;
                                    FocusScope.of(context).unfocus();
                                    Navigator.pushReplacementNamed(
                                        context, ResultsScreen.routeName);
                                    // _pagingController.refresh();
                                  }
                                },
                              ),
                            ),
                            Container(
                              child: IconButton(
                                icon: Icon(
                                    isRecognitionOn
                                        ? Icons.settings_voice_rounded
                                        : Icons.keyboard_voice_rounded,
                                    color: ConstantColors.borders),
                                onPressed: () async {
                                  if (isRecognitionOn) {
                                    setState(() {
                                      if (results != null) {
                                        searchController.text =
                                            results.recognizedWords;
                                        isRecognitionOn = false;
                                      }
                                      isRecognitionOn = false;
                                      speech.stop();
                                    });
                                  } else {
                                    setState(() {
                                      isRecognitionOn = true;
                                    });

                                    speech.listen(onResult: (result) {
                                      setState(() {
                                        results = result;
                                      });
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: TextButton(
                          child: Text(
                            'Home',
                            style: TextStyle(
                              color: ConstantColors.foreground,
                            ),
                          ),
                          onPressed: () {
                            resultsViewModel.query = '';
                            Navigator.pushReplacementNamed(
                                context, HomeScreen.routeName);
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: TextButton(
                          child: Text(
                            'Mail',
                            style: TextStyle(
                              color: ConstantColors.foreground,
                            ),
                          ),
                          onPressed: () {},
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: TextButton(
                          child: Text(
                            'Images',
                            style: TextStyle(
                              color: ConstantColors.foreground,
                            ),
                          ),
                          onPressed: () {},
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                          child: IconButton(
                              icon: Icon(
                                Icons.apps_rounded,
                                color: ConstantColors.foreground,
                              ),
                              onPressed: () {})),
                    ],
                  ),
                ),
                Divider(
                  color: ConstantColors.borders.withOpacity(0.5),
                  height: 50,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 1350, 25),
                  child: resultsViewModel.webpages.isNotEmpty
                      ? Text(
                          "About ${resultsViewModel.webpages.length} results",
                          style: TextStyle(
                              color: ConstantColors.foreground.withOpacity(0.7),
                              fontSize: 14),
                        )
                      : null,
                ),
                resultsViewModel.webpages.isNotEmpty
                    ? Row(children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(235, 0, 0, 25),
                          child: Text(
                            "Showing results for: ",
                            style: TextStyle(
                                color:
                                    ConstantColors.foreground.withOpacity(0.7),
                                fontSize: 16),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 26),
                          child: Text(
                            resultsViewModel.query,
                            style: TextStyle(
                                color: ConstantColors.foreground,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ])
                    : Row(),
                Container(
                    height: 0.65 * deviceSize.height,
                    child: NotificationListener(
                      onNotification: (ScrollNotification notification) {
                        if (notification.metrics.pixels ==
                                notification.metrics.maxScrollExtent &&
                            resultsViewModel.status != Status.loading) {
                          resultsViewModel.searchQuery(
                              searchController.text, false);
                          return true;
                        } else {
                          return false;
                        }
                      },
                      child: resultsViewModel.webpages.isNotEmpty
                          ? Scrollbar(
                              controller: scrollController,
                              child: ListView.builder(
                                  controller: scrollController,
                                  padding: EdgeInsets.zero,
                                  itemCount: resultsViewModel.webpages.length,
                                  itemBuilder: (_, index) {
                                    return ResultWidget(
                                      url: resultsViewModel.webpages[index].url,
                                      word: searchController.text,
                                    );
                                  }))
                          : resultsViewModel.status != Status.loading
                              ? Center(
                                  child: Text(
                                    'No results found',
                                    style: TextStyle(
                                      color: ConstantColors.foreground
                                          .withOpacity(0.5),
                                      fontSize: 15,
                                    ),
                                  ),
                                )
                              : Center(
                                  child: SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.transparent,
                                        color: ConstantColors.borders,
                                        strokeWidth: 3,
                                      ))),
                    )),
                Spacer(
                  flex: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
