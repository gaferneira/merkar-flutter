import 'dart:io';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../../../../data/repositories/login_repository.dart';

class MoreViewModel extends ChangeNotifier {
  final LoginRepository repository;
  String? userName;
  String? userEmail;
  File? image;
  MoreViewModel({required this.repository});

  void loadData() async {
    var userData = await repository.getUserData();
    this.userName = userData.name;
    this.userEmail = userData.email;
    downloadImageProfile();
  }

  Future<void> uploadFile(File file) async {

    firebase_storage.UploadTask uploadTask;
    final _currentUser = repository.getCurrentUser();
    // Create a Reference to the file
    if(_currentUser!=null){
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images/')
        .child('profiles')
        .child('/${_currentUser.uid}.jpg');

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': file.path});

      uploadTask = ref.putFile(File(file.path), metadata);
      image=file;
      notifyListeners();
    }
  }

  Future<void> downloadImageProfile() async {
    //search image in a local or then in fire base storage
    final _currentUser = repository.getCurrentUser();
   // try{
      firebase_storage.Reference ref =firebase_storage.FirebaseStorage.instance
          .ref('images/profiles/${_currentUser!.uid}.jpg');
      ref.getDownloadURL().then((respose){
      final Directory systemTempDir = Directory.systemTemp;
      final File tempFile = File('${systemTempDir.path}/${ref.name}.jpg');
      ref.writeToFile(tempFile);
      image=tempFile;
      }, onError: onReject);

  }

  void onReject(error) {
    print('Error al cargar el archivo: ${error.toString()}');
  }

  Future<void> downloadFile(firebase_storage.Reference ref, BuildContext context) async {
    final Directory systemTempDir = Directory.systemTemp;
    final File tempFile = File('${systemTempDir.path}/temp-${ref.name}');
    if (tempFile.existsSync()) await tempFile.delete();

    await ref.writeToFile(tempFile);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Success!\n Downloaded ${ref.name} \n from bucket: ${ref.bucket}\n '
              'at path: ${ref.fullPath} \n'
              'Wrote "${ref.fullPath}" to tmp-${ref.name}.txt',
        ),
      ),
    );
  }
}