import 'package:bottom_bar/bottom_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_list/Screen/HomePage.dart';
import 'package:todo_app_list/Screen/Reportpage.dart';
import 'package:todo_app_list/firebase_options.dart';
import 'package:todo_app_list/src/config/color_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int selectedPage = 0;
  void _onItemTapped(int index) {
    setState(() {
      selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: Scaffold(
        body: _getPage(selectedPage),
        bottomNavigationBar: BottomBar(
          onTap: _onItemTapped,
          selectedIndex: selectedPage,
          items: [
            BottomBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
              activeColor: ColorConstants.primary,
              activeTitleColor: ColorConstants.primary,
            ),
            BottomBarItem(
              icon: Icon(Icons.payments),
              title: Text('Report'),
              activeColor: ColorConstants.primary,
              activeTitleColor: ColorConstants.primary,
            ),
            BottomBarItem(
              icon: Icon(Icons.person),
              title: Text('Account'),
              activeColor: ColorConstants.primary,
              activeTitleColor: ColorConstants.primary,
            ),
            BottomBarItem(
              icon: Icon(Icons.settings),
              title: Text('Settings'),
              activeColor: ColorConstants.primary,
              activeTitleColor: ColorConstants.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return Homepage();
      case 1:
        return ReportpageWidget();
      default:
        return Homepage();
    }
  }
}
