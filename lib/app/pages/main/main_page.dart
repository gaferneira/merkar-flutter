import 'package:flutter/material.dart';
import 'package:merkar/app/pages/products/product_list/product_list_page.dart';
import 'package:merkar/app/pages/home/home_page.dart';
import 'package:merkar/app/pages/main/widgets/more_page.dart';
import 'package:merkar/app/pages/purchases/statistics/statistics_page.dart';

import 'widgets/bottom_navigation.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  var _currentTab = 0;

  void _selectTab(var index) {
    setState(() => _currentTab = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        _buildOffstageNavigator(0, HomePage()),
        _buildOffstageNavigator(1, ProductsListPage()),
        _buildOffstageNavigator(2, StatisticsPage()),
        _buildOffstageNavigator(3, MorePage()),
      ]),
      bottomNavigationBar: BottomNavigation(
        onSelectTab: _selectTab,
      ),
    );
  }

  Widget _buildOffstageNavigator(int tabItem, Widget page) {
    return Offstage(offstage: _currentTab != tabItem, child: page);
  }
}
