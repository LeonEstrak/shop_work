import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseServices{

  final String uid;
  DatabaseServices({this.uid});

  static final CollectionReference databaseInstance = Firestore.instance.collection("data");

  static final FirebaseStorage _firebaseStorage = FirebaseStorage(storageBucket: "gs://shop-work-12bc7.appspot.com/");

  StorageUploadTask _uploadTask;

///Uploads the profile image to `"images/ProfilePhoto/$uid"` in the Firebase Storage.
  void uploadProfilePhoto({File image}) async {
    //TODO: Error Handling while uploading the profile photo[Back End]
    String filePath = "images/ProfilePhoto/$uid";
    _uploadTask = _firebaseStorage.ref().child(filePath).putFile(image);
    print(_uploadTask);
  }


/// ### @output: Future<bool,String>
///Downloads the profile image from `"images/ProfilePhoto/$uid"` in the Firebase Storage.
/// 0th position is a bool which tells if the image was found or not.
/// 1st position is a String which is the downloadURL when 0th pos is true.
  Future downloadProfilePhoto()async{
    String filePath = "images/ProfilePhoto/$uid";
    try{
      String result= await _firebaseStorage.ref().child(filePath).getDownloadURL();
      return [true,result];
    }catch(e){
      return [false,"invalid File Path"];
    }
  }

  void uploadItemPhoto({File image, String itemName}) {
    itemName = itemName.toLowerCase();
    String filePath = "images/$uid/items/$itemName";
    try{
      _uploadTask = _firebaseStorage.ref().child(filePath).putFile(image);
//      return true;
    }catch(e){
      print(e.toString());
//      return false;
    }
  }

  Future downloadItemPhoto(String itemName)async{
    itemName = itemName.toLowerCase();
    String filePath = "images/$uid/items/$itemName";
    try{
      String result= await _firebaseStorage.ref().child(filePath).getDownloadURL();
      return [true,result];
    }catch(e){
      return [false,"invalid File Path"];
    }
  }

  Future registerUserData({String typeOfUser,String firstName, String lastName, String address, String mobile}) async{
    return await databaseInstance.document(uid).setData({
      "Type of User":typeOfUser,
      "First Name": firstName,
      "Last Name": lastName,
      "Address": address,
      "Mobile Number": mobile
    });
  }

  Future getTypeOfUser()async{
    String result;
    await databaseInstance.document(uid).get().then((documentSnapshot) =>
      result = documentSnapshot.data["Type of User"].toString()
    );
    return result;
  }
}