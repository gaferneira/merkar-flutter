import 'package:flutter/material.dart';

import '../home_page_view_model.dart';

Expanded categoriesList(HomePageViewModel viewModel) {
  return Expanded(
    child: ListView.builder(
      itemCount: viewModel.categories != null ? viewModel.categories.length : 0,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('${viewModel.categories[index].name}'),
        );
      },
    ),
  );
}