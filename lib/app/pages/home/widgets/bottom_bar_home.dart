import 'package:flutter/material.dart';
import 'package:merkar/app/core/resources/strings.dart';
import 'package:merkar/app/pages/favorites/favorites_list/favorite_list_page.dart';
import 'package:merkar/app/pages/home/widgets/more_page.dart';
import 'package:merkar/app/pages/purchases/purchase_history/purchase_history_page.dart';


class BottomBarHome extends StatefulWidget {

  @override
  _BottomBarHomeState createState() => _BottomBarHomeState();
}

class _BottomBarHomeState extends State<BottomBarHome> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  void _onItemTapped(int index) {
    setState(() {
      //_selectedIndex = index;
      _goToRoute(index, context);

    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: Strings.route_home,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: Strings.route_favorites,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: Strings.route_purchase_history,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: Strings.route_more,
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amber[800],
      onTap: _onItemTapped,
      unselectedItemColor: Theme.of(context).primaryColor,
    );
  }

  void _goToRoute(int option, BuildContext context) async {
    switch (option) {
      case 0:
        {
          //se queda en home
          break;
        }
      case 1:
        {
          Navigator.of(context).pushNamed(FavoriteListPage.routeName);
          break;
        }
      case 2:
        {
          Navigator.of(context).pushNamed(PurchaseHistoryPage.routeName);
          break;
        }
      case 3:
        {
          MorePage(context);
          break;
        }
    }
  }
}
