import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:parquea2/models/vehicle.dart';

class VehicleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  VehicleService();

  Future<String> uploadVehicleImage(
      File image, String userId, String vehicleId) async {
    firebase_storage.Reference storageReference = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('users/$userId/vehicle_images/$vehicleId');
    firebase_storage.UploadTask uploadTask = storageReference.putFile(image);
    await uploadTask;
    String url = await storageReference.getDownloadURL();
    return url;
  }

  Future<void> addVehicle(String userId, Vehicle vehicle) async {
    DocumentReference userRef = _firestore.collection('clients').doc(userId);
    CollectionReference vehicles = userRef.collection('vehicles');
    await vehicles.doc(vehicle.id).set(vehicle.toJson());
  }

  Future<void> updateVehicle(String userId, Vehicle vehicle) async {
    DocumentReference vehicleRef = _firestore
        .collection('clients')
        .doc(userId)
        .collection('vehicles')
        .doc(vehicle.id);
    await vehicleRef.update(vehicle.toJson());
  }

  Future<void> deleteVehicle(String userId, String vehicleId) async {
    DocumentReference vehicleRef = _firestore
        .collection('clients')
        .doc(userId)
        .collection('vehicles')
        .doc(vehicleId);
    await vehicleRef.delete();
  }

  Stream<List<Vehicle>> streamVehicles(String userId) {
    return _firestore
        .collection('clients')
        .doc(userId)
        .collection('vehicles')
        .snapshots()
        .handleError((error) {
      print("Error fetching vehicles: $error");
    }).map((snapshot) =>
            snapshot.docs.map((doc) => Vehicle.fromSnapshot(doc)).toList());
  }

  Stream<Vehicle?> getVehicleByIdStream(String userId, String vehicleId) {
    return _firestore
        .collection('clients')
        .doc(userId)
        .collection('vehicles')
        .doc(vehicleId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return Vehicle.fromSnapshot(snapshot);
      } else {
        return null;
      }
    });
  }
}
