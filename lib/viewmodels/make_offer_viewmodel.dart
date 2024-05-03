import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parquea2/models/available_time.dart';
import 'package:parquea2/models/client.dart';
import 'package:parquea2/models/garage.dart';
import 'package:parquea2/models/garage_offer.dart';
import 'package:parquea2/models/garage_space.dart';
import 'package:parquea2/models/offer.dart';
import 'package:parquea2/models/user_offer.dart';
import 'package:parquea2/models/vehicle.dart';
import 'package:parquea2/services/client_service.dart';
import 'package:parquea2/services/offer_service.dart';
import 'package:intl/intl.dart';
import 'package:parquea2/services/vehicle_service.dart';

class MakeOfferViewModel extends ChangeNotifier {
  final OfferService _offerService = OfferService();
  final VehicleService _vehicleService = VehicleService();
  final ClientService _clientService = ClientService();

  UserOffer? client;
  Vehicle? vehicle;
  double payOffer = 0.0;
  String? date;
  String? start;
  String? end;
  List<String> warnings = [];
  String state = 'pending';

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  TimeOfDay? startTime;
  TimeOfDay? endTime;
  List<Vehicle> vehicles = [];

  TextEditingController dateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();

  void selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != DateTime.now()) {
      final String formattedDate = DateFormat('dd-MM-yyyy').format(picked);
      date = formattedDate;
      dateController.text = formattedDate;
      notifyListeners();
    }
  }

  void selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      startTime = picked;
      start = _formatTimeOfDay(picked);
      startTimeController.text = start!;
      notifyListeners();
    }
  }

  void selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      endTime = picked;
      end = _formatTimeOfDay(picked);
      endTimeController.text = end!;
      notifyListeners();
    }
  }

  String _formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.Hm();
    return format.format(dt);
  }

  bool validateTime() {
    if (startTime != null && endTime != null) {
      return startTime!.hour < endTime!.hour ||
          (startTime!.hour == endTime!.hour &&
              startTime!.minute < endTime!.minute);
    }
    return false;
  }

  Future<void> fetchVehicles(String userId) async {
    vehicles = await _vehicleService.fetchVehicles(userId);
    notifyListeners();
  }

  void selectVehicle(Vehicle selectedVehicle) {
    vehicle = selectedVehicle;
    notifyListeners();
  }

  Future<String> getUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    String userId;
    if (user != null) {
      userId = user.uid;
    } else {
      userId = '';
    }
    return userId;
  }

  Future<String> getClientDetails(String userId) async {
    String fullName = "Unknown";
    try {
      Client? client = await _clientService.fetchClientById(userId);
      if (client != null && client.fullName != null) {
        fullName = client.fullName;
      } else {
        print("No provider found or missing fullName for user ID: $userId");
      }
    } catch (e) {
      print("Error fetching provider details: $e");
    }
    return fullName;
  }

  Future<void> submitOffer(Garage garage, GarageSpace garageSpace) async {
    _isSubmitting = true;
    notifyListeners();

    String currentUser = await getUserId();
    if (currentUser == '') {
      _isSubmitting = false;
      notifyListeners();
      return;
    }
    String userName = await getClientDetails(currentUser);

    try {
      Offer newOffer = Offer(
        id: 'Offer_${DateTime.now().millisecondsSinceEpoch.toString()}',
        garageSpace: GarageOffer(garageId: garage.id, spaceId: garageSpace.id),
        client: UserOffer(id: currentUser, fullName: userName),
        vehicle: vehicle!,
        provider: UserOffer(id: garage.userId, fullName: garage.userId),
        lastOfferBy: client!.id,
        payOffer: payOffer,
        date: date!,
        time: AvailableTime(startTime: start!, endTime: end!),
        warnings: warnings,
        state: state,
      );

      await _offerService.createOffer(newOffer);
    } catch (e) {
      print('Error creating offer: $e');
      // Handle errors
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}
