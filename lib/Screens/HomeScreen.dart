import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:finder/Constants/Colors.dart';
import 'package:finder/Screens/ResultsScreen.dart';
import 'package:finder/ViewModels/ResultsViewModel.dart';
import 'package:finder/ViewModels/SuggestionsViewModel.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class HomeScreen extends StatefulWidget {
  static final routeName = '/home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ResultsViewModel resultsViewModel;
  SuggestionsViewModel suggestionsViewModel;
  bool isSpeechAvailable = false;
  bool isRecognitionOn = false;
  stt.SpeechToText speech = stt.SpeechToText();
  TextEditingController searchController = TextEditingController();
  SpeechRecognitionResult results;
  FocusNode speechFocus = FocusNode();
  Color textFieldColor = Colors.transparent;
  IconButton clearButton;

  @override
  void dispose() {
    resultsViewModel.removeListener(() {});
    super.dispose();
  }

  @override
  void initState() {
    speechFocus.addListener(() {
      if (speechFocus.hasFocus) {
        setState(() {
          textFieldColor = ConstantColors.buttons;
        });
      } else {
        setState(() {
          textFieldColor = Colors.transparent;
        });
      }
    });

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
    Future.microtask(() async {
      if (!isSpeechAvailable) {
        isSpeechAvailable = await speech.initialize(
          onStatus: (status) {},
          onError: (error) {
            print(error);
          },
        );
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: ConstantColors.background,
        body: SingleChildScrollView(
          child: Container(
            height: deviceSize.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Spacer(),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 15, 5, 0),
                      child: TextButton(
                        child: Text(
                          'Home',
                          style: TextStyle(
                            color: ConstantColors.foreground,
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 15, 5, 0),
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
                      margin: EdgeInsets.fromLTRB(0, 15, 5, 0),
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
                        margin: EdgeInsets.fromLTRB(0, 15, 5, 0),
                        child: IconButton(
                            icon: Icon(
                              Icons.apps_rounded,
                              color: ConstantColors.foreground,
                            ),
                            onPressed: () {})),
                  ],
                ),
                Spacer(
                  flex: 1,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    width: deviceSize.width * 0.15 < 200
                        ? 200
                        : deviceSize.width * 0.15,
                    margin: EdgeInsets.fromLTRB(0, 0, 35, 0),
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: RichText(
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        text: TextSpan(
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Uomo',
                              fontStyle: FontStyle.italic),
                          children: [
                            TextSpan(
                              text: 'Finder',
                              style:
                                  TextStyle(color: ConstantColors.foreground),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ]),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: deviceSize.width * 0.3 > 250
                          ? deviceSize.width * 0.3
                          : 250,
                      child: TypeAheadField(
                        loadingBuilder: (BuildContext context) => Container(
                            height: 12,
                            width: 12,
                            margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.transparent,
                              color: ConstantColors.borders,
                              strokeWidth: 1.5,
                            )),
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: searchController,
                          focusNode: speechFocus,
                          style: TextStyle(
                              fontSize: 15, color: ConstantColors.foreground),
                          decoration: new InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 0.0),
                              enabledBorder: new OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        ConstantColors.borders.withOpacity(0.5),
                                    width: 1.0),
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(30.0),
                                ),
                              ),
                              focusedBorder: new OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 0.0),
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(30.0),
                                ),
                              ),
                              filled: true,
                              prefixIcon: Padding(
                                padding: const EdgeInsetsDirectional.only(
                                    start: 12.0),
                                child: Icon(Icons.search,
                                    color: ConstantColors.borders, size: 20),
                              ),
                              suffixIcon: clearButton,
                              hintStyle:
                                  new TextStyle(color: ConstantColors.borders),
                              hintText: "",
                              fillColor: textFieldColor),
                        ),
                        suggestionsCallback: (pattern) async {
                          await suggestionsViewModel.getSuggesitons(pattern);
                          //return ["Liverpool", "Chelsea", "Ahly", "Zamalek"];
                          return suggestionsViewModel.suggestions;
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                              contentPadding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              title: Text(
                                suggestion,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: ConstantColors.foreground),
                              ));
                        },
                        noItemsFoundBuilder: (context) {
                          return Padding(
                              padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                              child: Text("No suggestions found",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: ConstantColors.foreground
                                        .withOpacity(0.5),
                                  )));
                        },
                        onSuggestionSelected: (suggestion) async {
                          searchController.text = suggestion;
                          resultsViewModel.word = searchController.text;
                          Navigator.pushReplacementNamed(
                              context, ResultsScreen.routeName);
                        },
                        suggestionsBoxDecoration: SuggestionsBoxDecoration(
                          color: ConstantColors.buttons,
                          borderRadius: BorderRadius.circular(10),
                          elevation: 5,
                        ),
                      ),
                    ),
                    Container(
                      child: IconButton(
                        icon: Icon(
                          isRecognitionOn
                              ? Icons.settings_voice_rounded
                              : Icons.keyboard_voice_rounded,
                          color: ConstantColors.borders,
                        ),
                        onPressed: () async {
                          if (isRecognitionOn) {
                            setState(() {
                              if (results != null) {
                                searchController.text = results.recognizedWords;
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
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(1, 30, 30, 0),
                    width: 150,
                    height: 40,
                    child: TextButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(ConstantColors.buttons),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(3.0),
                                      side: BorderSide(
                                          color: ConstantColors.buttons)))),
                      onPressed: () async {
                        if (searchController.text.isNotEmpty) {
                          resultsViewModel.word = searchController.text;
                          Navigator.pushReplacementNamed(
                              context, ResultsScreen.routeName);
                        }
                      },
                      child: Text(
                        'Finder Search',
                        style: TextStyle(color: ConstantColors.foreground),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(1, 30, 30, 0),
                    width: 150,
                    height: 40,
                    child: TextButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(ConstantColors.buttons),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(3.0),
                                      side: BorderSide(
                                          color: ConstantColors.buttons)))),
                      onPressed: () async {},
                      child: Text(
                        "I'm Feeling Lucky",
                        style: TextStyle(color: ConstantColors.foreground),
                      ),
                    ),
                  )
                ]),
                SizedBox(
                  height: 25,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 30, 0),
                  child: Text(
                    "Finder offered in: English",
                    style: TextStyle(
                        color: ConstantColors.foreground, fontSize: 12),
                  ),
                ),
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
