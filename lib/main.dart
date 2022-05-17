import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finder/Constants/Colors.dart';
import 'package:finder/Screens/HomeScreen.dart';
import 'package:finder/Screens/ResultsScreen.dart';
import 'package:finder/ViewModels/ResultsViewModel.dart';
import 'package:finder/ViewModels/SuggestionsViewModel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: ResultsViewModel(),
        ),
        ChangeNotifierProvider.value(
          value: SuggestionsViewModel(),
        ),
      ],
      child: MaterialApp(
        title: 'Finder',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch().copyWith(
                secondary: ConstantColors.foreground,
                primary: ConstantColors.borders),
            fontFamily: 'NotoSansJP'),
        home: HomeScreen(),
        routes: {
          HomeScreen.routeName: (ctx) => HomeScreen(),
          ResultsScreen.routeName: (ctx) => ResultsScreen(),
        },
      ),
    );
  }
}
