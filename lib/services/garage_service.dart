import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:parquea2/models/garage.dart';

class GarageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  GarageService();

  Future<String> uploadGarageImage(File image, String garageId) async {
    firebase_storage.Reference storageReference = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('garage_images/$garageId');
    firebase_storage.UploadTask uploadTask = storageReference.putFile(image);
    await uploadTask;
    String url = await storageReference.getDownloadURL();
    return url;
  }

  Future<void> addGarage(Garage garage) async {
    CollectionReference garages = _firestore.collection('garages');
    await garages.doc(garage.id).set(garage.toJson());
  }

  Future<void> updateGarage(Garage garage) async {
    DocumentReference garageRef = _firestore.collection('garages').doc(garage.id);
    await garageRef.update(garage.toJson());
  }

  Future<void> deleteGarage(String garageId) async {
    DocumentReference garageRef = _firestore.collection('garages').doc(garageId);
    await garageRef.delete();
  }
}
