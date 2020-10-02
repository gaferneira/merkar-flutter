import 'package:flutter/material.dart';
import 'package:merkar/app/core/strings.dart';

class AboutUsPage extends StatefulWidget {
  static const routeName = "/aboutus";
  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.about_us),
      ),
      body: Text("Acerca de Merkart"),
    );
  }
}
