import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../injection_container.dart';
import 'new_category_page_view_model.dart';

class NewCategoryPage extends StatefulWidget {
  @override
  _NewCategoryPageState createState() => _NewCategoryPageState();
}

class _NewCategoryPageState extends State<NewCategoryPage> {
  NewCategoryPageViewModel viewModel =
      serviceLocator<NewCategoryPageViewModel>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NewCategoryPageViewModel>(
      create: (context) => viewModel,
      child: Consumer<NewCategoryPageViewModel>(
        builder: (context, model, child) => Scaffold(
            appBar: AppBar(
              title: Text('Create new category'),
            ),
            body: Text('')),
      ),
    );
  }
}
