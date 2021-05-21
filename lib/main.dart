import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:merkar/app/core/resources/app_theme.dart';
import 'package:merkar/app/pages/login/reset_password/reset_password_page.dart';
import 'package:merkar/app/pages/login/widgets/background_login.dart';
import 'package:provider/provider.dart';

import 'app/pages/favorites/favorites_list/favorite_list_page.dart';
import 'app/pages/favorites/select_my_favorites/select_my_favorites_page.dart';
import 'app/pages/home/home_page.dart';
import 'app/pages/login/auth_view_model.dart';
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
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
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
        ResetPasswordPage.routeName:(context)=>ResetPasswordPage(),
        HomePage.routeName: (context) => HomePage(),
        FavoriteListPage.routeName: (context) => FavoriteListPage(),
        SelectMyFavoritesPage.routeName: (context) => SelectMyFavoritesPage(),
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
    return BackgroundLogin();
  }
}
