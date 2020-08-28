import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merkar/app/pages/new_category/NewCategoryPage.dart';
import 'package:merkar/app/widgets/widgets.dart';
import 'package:merkar/injection_container.dart';

import 'bloc/home_bloc.dart';
import 'bloc/home_event.dart';
import 'bloc/home_state.dart';
import 'widgets/categories_display.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Merkar'),
      ),
      body: SingleChildScrollView(
        child: buildBody(context),
      ),
    );
  }

  BlocProvider<HomeBloc> buildBody(BuildContext context) {
    return BlocProvider(
      builder: (_) => sl<HomeBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              // Top half
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is Empty) {
                    return MessageDisplay(
                      message: 'Start searching!',
                    );
                  } else if (state is Loading) {
                    return LoadingWidget();
                  } else if (state is Loaded) {
                    return CategoriesDisplay(categories: state.categories);
                  } else if (state is Error) {
                    return MessageDisplay(
                      message: state.message,
                    );
                  } else {
                    return MessageDisplay(
                      message: "Error",
                    );
                  }
                },
              ),
              SizedBox(height: 20),
              // Bottom half
              HomeControls()
            ],
          ),
        ),
      ),
    );
  }
}

class HomeControls extends StatefulWidget {
  const HomeControls({
    Key key,
  }) : super(key: key);

  @override
  _HomeControlsState createState() => _HomeControlsState();
}

class _HomeControlsState extends State<HomeControls> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomeBloc>(context).dispatch(GetCategories());
  }

  void _goToCreateCategory() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => NewCategoryPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FloatingActionButton(
          onPressed: _goToCreateCategory,
          tooltip: 'New Category',
          child: Icon(Icons.add),
        ),
      ],
    );
  }
}
