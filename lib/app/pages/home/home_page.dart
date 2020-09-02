import 'package:flutter/material.dart';
import 'package:merkar/app/pages/home/home_page_view_model.dart';
import 'package:merkar/app/pages/home/widgets/categories_display.dart';
import 'package:merkar/app/pages/new_category/new_category_page.dart';
import 'package:merkar/app/widgets/widgets.dart';
import 'package:merkar/data/entities/category.dart';
import 'package:merkar/injection_container.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomePageViewModel viewModel = serviceLocator<HomePageViewModel>();

  @override
  void initState() {
    super.initState();
  }

  void _goToCreateCategory() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => NewCategoryPage()));
  }

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<List<Category>>(context);
    return ChangeNotifierProvider<HomePageViewModel>(
      create: (context) => viewModel,
      child: Consumer<HomePageViewModel>(
        builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            title: Text('Merkar'),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              (categories == null)
                  ? Center(child: LoadingWidget())
                  : categoriesList(categories),
            ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: _goToCreateCategory,
                tooltip: 'New Category',
                child: Icon(Icons.add),
              ),
            ),
      ),
    );
  }
}
