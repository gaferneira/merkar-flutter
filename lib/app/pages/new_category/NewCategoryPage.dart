import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merkar/app/widgets/widgets.dart';
import 'package:merkar/injection_container.dart';

import 'bloc/new_category_bloc.dart';
import 'bloc/new_category_state.dart';

class NewCategoryPage extends StatelessWidget {
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

  BlocProvider<NewCategoryBloc> buildBody(BuildContext context) {
    return BlocProvider(
      builder: (_) => sl<NewCategoryBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              // Top half
              BlocBuilder<NewCategoryBloc, NewCategoryState>(
                builder: (context, state) {
                  return MessageDisplay(
                    message: 'Hi!',
                  );
                },
              ),
              SizedBox(height: 20),
              // Bottom half
              NewCategoryControls()
            ],
          ),
        ),
      ),
    );
  }
}

class NewCategoryControls extends StatefulWidget {
  const NewCategoryControls({
    Key key,
  }) : super(key: key);

  @override
  _NewCategoryControlsState createState() => _NewCategoryControlsState();
}

class _NewCategoryControlsState extends State<NewCategoryControls> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[],
    );
  }
}
