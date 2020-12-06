import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:merkar/app/core/constants.dart';
import 'package:merkar/app/pages/favorites/favorites_list/favorite_list_page.dart';
import 'package:merkar/app/pages/favorites/select_my_favorites/select_my_favorites_page.dart';
import 'package:merkar/app/pages/home/home_page.dart';
import 'package:merkar/app/pages/login/auth_view_model.dart';
import 'package:provider/provider.dart';

import 'app/pages/login/register/register_page.dart';
import 'app/pages/login/sign_in/login_page.dart';
import 'app/pages/products/new_product/create_new_product.dart';
import 'app/pages/purchases/purchase_history/purchase_history_page.dart';
import 'app/pages/purchases/purchase_history_show_info/purchase_history_show_info_page.dart';
import 'app/pages/shopping/new_shopping_list/new_shopping_list_page.dart';
import 'app/pages/shopping/select_my_products/select_my_products_page.dart';
import 'app/pages/shopping/shopping_list/shopping_list_page.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/cupertino.dart';

const bool USE_FIRESTORE_EMULATOR = false;
bool _light = true;
ThemeData _darkTheme = ThemeData(
  accentColor: Constant.darkColorAcent,
  brightness: Brightness.dark,
  primaryColor: Constant.darkColor,
  fontFamily: 'Vanitas',
  textTheme: TextTheme(
    headline1: TextStyle(
        fontSize: 72.0,
        fontWeight: FontWeight.bold,
        color: Constant.lightColor),
    headline6: TextStyle(
        fontSize: 36.0,
        fontStyle: FontStyle.italic,
        color: Constant.lightColor),
    bodyText2: TextStyle(
      fontSize: 14.0,
      fontFamily: 'Vanitas',
      color: Constant.lightColor,
    ),
  ),
);

ThemeData _lightTheme = ThemeData(
  accentColor: Constant.lightColorAcent,
  brightness: Brightness.light,
  primaryColor: Constant.lightColor,
  fontFamily: 'Vanitas',
  textTheme: TextTheme(
    bodyText1: TextStyle(),
    bodyText2: TextStyle(),
  ).apply(
    bodyColor: Constant.lightColor,
    displayColor: Constant.lightColorAcent,
  ),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (USE_FIRESTORE_EMULATOR) {
    FirebaseFirestore.instance.settings = Settings(
        host: 'localhost:8080', sslEnabled: false, persistenceEnabled: true);
  }
  await di.init();
  runApp(MyApp());
  /*runApp(
    ChangeNotifierProvider<ProviderTheme>(
      create: (BuildContext context) => ProviderTheme(),
      child: MyApp(),
    ),
  );*/
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var providerTheme = Provider.of<ProviderTheme>(context);

    //Consumer<AppStateNotifier>(builder: (context, appState, child) {
    //return
    return MaterialApp(
      title: 'Merkar',
      //theme: ProviderTheme().light ? _lightTheme : _darkTheme,
      debugShowCheckedModeBanner: false,
      theme: _lightTheme,
      // ThemeData(primarySwatch: Colors.blue),
      darkTheme: _darkTheme,
      // ThemeData(primarySwatch: Colors.blue),
      //home: HomePage(),
      // themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      // home: HomePage(),
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => AuthenticationPage(),
        ShoppingListPage.routeName: (context) => ShoppingListPage(),
        PurchaseHistoryPage.routeName: (context) => PurchaseHistoryPage(),
        PurchaseHistoryShowInfoPage.routeName: (context) =>
            PurchaseHistoryShowInfoPage(),
        NewShoppingListPage.routeName: (context) => NewShoppingListPage(),
        SelectMyProductsPage.routeName: (context) => SelectMyProductsPage(),
        CreateNewProduct.routeName: (context) => CreateNewProduct(),
        RegisterPage.routeName: (context) => RegisterPage(),
        HomePage.routeName: (context) => HomePage(),
        FavoriteListPage.routeName: (context) => FavoriteListPage(),
        SelectMyFavoritesPage.routeName: (context) => SelectMyFavoritesPage(),
      },
    );
  }
  //);
  // }
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
