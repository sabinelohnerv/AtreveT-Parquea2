import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:parquea2/models/garage.dart';
import 'package:parquea2/models/garage_space.dart';

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

  Future<void> addGarageSpaceAndUpdateSpacesCount(
      GarageSpace garageSpace, String garageId) async {
    DocumentReference garageRef =
        _firestore.collection('garages').doc(garageId);
    CollectionReference garageSpaces = garageRef.collection('spaces');

    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot garageSnapshot = await transaction.get(garageRef);

      if (!garageSnapshot.exists) {
        throw Exception("Garage does not exist!");
      }

      Garage garage = Garage.fromSnapshot(garageSnapshot);

      int updatedNumberOfSpaces = garage.numberOfSpaces + 1;

      transaction.update(garageRef, {'numberOfSpaces': updatedNumberOfSpaces});

      DocumentReference newSpaceRef = garageSpaces.doc(garageSpace.id);
      transaction.set(newSpaceRef, garageSpace.toJson());
    });
  }

  Future<void> updateGarage(Garage garage) async {
    DocumentReference garageRef =
        _firestore.collection('garages').doc(garage.id);
    await garageRef.update(garage.toJson());
  }

  Future<void> deleteGarage(String garageId) async {
    DocumentReference garageRef =
        _firestore.collection('garages').doc(garageId);
    await garageRef.delete();
  }

  Stream<List<Garage>> garagesStream() {
    return _firestore.collection('garages').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Garage.fromSnapshot(doc)).toList();
    });
  }

  Stream<List<Garage>> garagesStreamByUserId(String userId) {
    return _firestore
        .collection('garages')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Garage.fromSnapshot(doc)).toList());
  }

  Stream<List<GarageSpace>> garagesSpacesStreamByGarage(String garageId) {
    return _firestore
        .collection('garages')
        .doc(garageId)
        .collection('spaces')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => GarageSpace.fromSnapshot(doc)).toList());
  }

  Stream<Garage?> getGarageByIdStream(String garageId) {
    return _firestore
        .collection('garages')
        .doc(garageId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return Garage.fromSnapshot(snapshot);
      } else {
        return null;
      }
    });
  }

  Future<int> getAvailableSpacesCount(String garageId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('garages')
          .doc(garageId)
          .collection('spaces')
          .where('state', isEqualTo: 'libre')
          .get();

      return snapshot.docs.length;
    } catch (e) {
      print('Error fetching available spaces: $e');
      return 0;
    }
  }

  Future<void> updateGarageImageUrl(String garageId, String newImageUrl) async {
    DocumentReference garageRef =
        _firestore.collection('garages').doc(garageId);
    return garageRef.update({'imgUrl': newImageUrl});
  }

  Future<void> updateGarageSpace(String garageId, GarageSpace garageSpace) async {
  DocumentReference garageSpaceRef = _firestore
      .collection('garages')
      .doc(garageId)
      .collection('spaces')
      .doc(garageSpace.id);

  await garageSpaceRef.update(garageSpace.toJson());
}


}
