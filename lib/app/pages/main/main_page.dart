import 'package:flutter/material.dart';
import 'package:merkar/app/pages/main/main_page_view_model.dart';
import 'package:merkar/injection_container.dart';
import 'package:provider/provider.dart';
import '../../pages/products/product_list/product_list_page.dart';
import '../../pages/home/home_page.dart';
import '../../pages/main/widgets/more_page.dart';
import '../../pages/purchases/statistics/statistics_page.dart';
import 'widgets/bottom_navigation.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  var _currentTab = 0;
  MainPageViewModel viewModel = serviceLocator<MainPageViewModel>();

  @override
  void initState() {
    super.initState();
    viewModel.loadData();
  }

  void _selectTab(var index) {
    setState(() => _currentTab = index);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainPageViewModel>.value(
    value: viewModel,
    child: Scaffold(
      body: Stack(children: <Widget>[
        _buildOffstageNavigator(0, HomePage()),
        _buildOffstageNavigator(1, ProductsListPage()),
        _buildOffstageNavigator(2, StatisticsPage()),
        _buildOffstageNavigator(3, MorePage(displayEmail: viewModel.userEmail,displayName: viewModel.userName,)),
      ]),
      bottomNavigationBar: BottomNavigation(
        onSelectTab: _selectTab,
      ),
    )
    );
  }

  Widget _buildOffstageNavigator(int tabItem, Widget page) {
    return Offstage(offstage: _currentTab != tabItem, child: page);
  }
}
