import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:merkar/app/pages/aboutus/about_us_page.dart';
import 'package:merkar/app/pages/comments/comment_page.dart';
import 'package:merkar/app/pages/home/home_page.dart';
import 'package:merkar/app/pages/login/auth_view_model.dart';
import 'package:merkar/app/pages/new_product/create_new_product.dart';
import 'package:merkar/app/pages/purchase_history/purchase_history_page.dart';
import 'package:merkar/app/pages/select_my_products/select_my_products_page.dart';
import 'package:merkar/app/pages/shopping_list/shopping_list_page.dart';
import 'package:provider/provider.dart';

import 'app/pages/purchase_history/purchase_history_page.dart';
import 'app/pages/login/login_page.dart';
import 'app/pages/new_shopping_list/new_shopping_list_page.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';

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
        '/': (context) => AuthenticationPage(),
        ShoppingListPage.routeName: (context) => ShoppingListPage(),
        PurchaseHistoryPage.routeName: (context) => PurchaseHistoryPage(),
        NewShoppingListPage.routeName: (context) => NewShoppingListPage(),
        CommentPage.routeName: (context) => CommentPage(),
        AboutUsPage.routeName: (context) => AboutUsPage(),
        SelectMyProductsPage.routeName: (context) => SelectMyProductsPage(),
        CreateNewProduct.routeName: (context) => CreateNewProduct(),
      },
    );
  }
}

class AuthenticationPage extends StatelessWidget {
  final AuthViewModel viewModel = serviceLocator<AuthViewModel>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthViewModel>.value(
      value: viewModel,
      child: Consumer(
        builder: (context, AuthViewModel viewModel, _) {
          switch (viewModel.status) {
            case AuthStatus.Unauthenticated:
              return LoginPage();
            case AuthStatus.Authenticated:
              return HomePage();
            case AuthStatus.Uninitialized:
            default:
              return Splash();
          }
        },
      ),
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Text("Splash Screen"),
      ),
    );
  }
}
