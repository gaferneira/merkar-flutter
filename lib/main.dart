import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:merkar/data/repositories/categories_repository.dart';
import 'package:merkar/injection_container.dart';
import 'package:provider/provider.dart';

import 'app/pages/home/home_page.dart';
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
    CategoriesRepository _categoriesRepository =
        serviceLocator<CategoriesRepository>();
    return MultiProvider(
      providers: [
        StreamProvider(
            create: (_) => _categoriesRepository.fetchAllCategories()),
      ],
      child: MaterialApp(
        title: 'Merkar',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
      ),
    );
  }
}
