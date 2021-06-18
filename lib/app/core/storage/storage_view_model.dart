import 'dart:io';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../../data/repositories/login_repository.dart';

class StorageViewModel extends ChangeNotifier {
  final LoginRepository repository;
  String? userName;
  String? userEmail;
  File? image;
  StorageViewModel({required this.repository});

  void loadData() async {
    var userData = await repository.getUserData();
    this.userName = userData.name;
    this.userEmail = userData.email;
    downloadImageProfile();
  }

  Future<String> uploadFile(File file) async {

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
      print('Uploaded success!');
      notifyListeners();
    return 'Uploaded success!';
    }
    print('No file uploaded');
    return 'No file uploaded';
  }

  Future<void> downloadImageProfile() async {
    final _currentUser = repository.getCurrentUser();
   // try{
      firebase_storage.Reference ref =firebase_storage.FirebaseStorage.instance
          .ref('images/profiles/${_currentUser!.uid}.jpg');
      ref.getDownloadURL().then((respose){
      print('Path:  ${ref.getDownloadURL().toString()}  ');
      final Directory systemTempDir = Directory.systemTemp;
      final File tempFile = File('${systemTempDir.path}/${ref.name}.jpg');
      ref.writeToFile(tempFile);
      image=tempFile;
      print('Hay imágen');
      }, onError: onReject);

      /*
      print('Path:  ${ref.getDownloadURL()}  new: ${_currentUser.uid}');
      final Directory systemTempDir = Directory.systemTemp;
      final File tempFile = File('${systemTempDir.path}/${ref.name}.jpg');
      await ref.writeToFile(tempFile);



    }catch(e){
      print('Error al cargar la imágen ${e.toString()}');
    }
     */


  }


  void onReject(error) {
    //console.log(error.code);
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