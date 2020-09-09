import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:merkar/app/pages/home/widgets/show_select_list.dart';

import 'app/pages/home/home_page.dart';
import 'app/pages/home/home_page.dart';
import 'app/pages/new_shopping_list/new_shopping_list_page.dart';
import 'app/pages/new_shopping_list/new_shopping_list_page.dart';
import 'injection_container.dart' as di;

const bool USE_FIRESTORE_EMULATOR = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (USE_FIRESTORE_EMULATOR) {
    FirebaseFirestore.instance.settings = Settings(
        host: 'localhost:8080', sslEnabled: false, persistenceEnabled: true);
  }
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Merkar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: HomePage(),
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => HomePage(),
        // When navigating to the "/showselectlist" route, build the SecondScreen widget.
        showSelectList.routeName: (context) => showSelectList(),
        // When navigating to the "/newshoppinglist" route, build the SecondScreen widget.
        NewShoppingListPage.routeName: (context) => NewShoppingListPage(),
      },
    );
  }
}
