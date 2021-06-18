import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'more_view_model.dart';
import 'package:provider/provider.dart';
import '../../../../core/resources/strings.dart';
import '../../../login/sign_in/login_view_model.dart';
import '../about_us_page.dart';
import '../comment_page.dart';
import '../../../../../injection_container.dart';

class MorePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() =>
      MorePageState();
}

class MorePageState extends State<MorePage> {

  MorePageState();
  MoreViewModel viewModel= serviceLocator<MoreViewModel>();
  File? _image;

  @override
  initState(){
    super.initState();
    viewModel.loadData();
  }

  _imgFromCamera() async {
    PickedFile? image = (await ImagePicker.platform.pickImage(
        source: ImageSource.camera, imageQuality: 50
    )) ;
    if(image!=null)
    setState(() {
      _image = File(image.path);
    });
    viewModel.uploadFile(_image!);
  }

  _imgFromGallery() async {
    PickedFile? image = await  ImagePicker.platform.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );
    if(image!=null)
    setState(() {
      _image = File(image.path);
    });
    viewModel.uploadFile(_image!);
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text(Strings.gallery),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text(Strings.camera),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    _image = viewModel.image;
    return ChangeNotifierProvider<MoreViewModel>.value(value: viewModel,
    child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          // Then, the content of your dialog.
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryVariant),
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: [
                            SizedBox(height: 30.0),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                onTap: () {
                                  _showPicker(context);
                                },
                                child: CircleAvatar(
                                  radius: 55,
                                  backgroundColor: Theme.of(context).primaryColor,
                                  backgroundImage: (_image != null) ? FileImage(_image!) :
                                  null,
                                  child: (_image == null)
                                      ? Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(50)),
                                    width: 100,
                                    height: 100,
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.grey[800],
                                    ),
                                  ): null,
                                ),
                              ),
                            ),
                            SizedBox(height: 15.0),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                viewModel.userName ?? '',
                                style: TextStyle(color: Colors.white, fontSize: 20.0),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight + Alignment(0, 0.4),
                              child: Text(
                                viewModel.userEmail ?? '',
                                style: TextStyle(color: Colors.white70, fontSize: 15.0),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              ListTile(
                title: Text(Strings.route_comments),
                leading: Icon(
                  Icons.comment,
                  color: Theme.of(context).primaryColor,
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Theme.of(context).primaryColor,
                ),
                onTap: () => _goToRoute(0, context),
              ),
              SizedBox(height: 30.0),
              ListTile(
                title: Text(Strings.route_about_us),
                leading: Icon(
                  Icons.info,
                  color: Theme.of(context).primaryColor,
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Theme.of(context).primaryColor,
                ),
                onTap: () => _goToRoute(1, context),
              ),
              SizedBox(height: 30.0),
              ListTile(
                leading: Icon(
                  Icons.close,
                  textDirection: TextDirection.rtl,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(Strings.route_close_session),
                onTap: () => _goToRoute(2, context),
              ),
            ]),
      ),
    ),);

  }

  void _goToRoute(int option, BuildContext context) async {
    switch (option) {
      case 0:
        {
          CommentePage(context);
          break;
        }
      case 1:
        {
          AboutUsPage(context);
          break;
        }
      case 2:
        {
          final viewModel = serviceLocator<LoginViewModel>();
          viewModel.signOut();
          break;
        }
    }
  }
}
