import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:merkar/app/core/resources/appIcons.dart';
import '../../../core/resources/strings.dart';

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
    return Container(
      decoration: BoxDecoration(border: Border(top: BorderSide(width: 0.5))),
      child: BottomNavigationBar(
        elevation: 5.0,
        //showSelectedLabels: true,
        //showUnselectedLabels: false,
        unselectedLabelStyle: TextStyle(fontSize: 11),
        selectedLabelStyle: TextStyle(fontSize: 14),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            //icon: Icon(Icons.home),
            icon: Icon(AppIcons.home),
            label: Strings.route_home,
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.favorites),
            label: Strings.route_products,
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.history),
            label: Strings.route_purchase_history,
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.add),
            label: Strings.route_more,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          _selectedIndex = index;
          onSelectTab(index);
        },
      ),
    );
  }
}