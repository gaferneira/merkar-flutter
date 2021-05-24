import 'package:flutter/material.dart';
import 'package:merkar/app/core/resources/strings.dart';

class BottomNavigation extends StatefulWidget {

  BottomNavigation({required this.onSelectTab});

  final ValueChanged<int> onSelectTab;

  @override
  _BottomNavigationState createState() => _BottomNavigationState(onSelectTab);

}

class _BottomNavigationState extends State<BottomNavigation> {

  int _selectedIndex = 0;

  final ValueChanged<int> onSelectTab;

  _BottomNavigationState(this.onSelectTab);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(

      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: Strings.route_home,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: Strings.route_products,
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
      onTap: (index) {
        _selectedIndex = index;
        onSelectTab(index);
      },
    );
  }
}