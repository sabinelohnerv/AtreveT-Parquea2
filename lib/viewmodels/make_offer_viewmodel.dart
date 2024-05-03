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

  Vehicle? vehicle;
  double payOffer = 0.0;
  String? date;
  String? start;
  String? end;
  List<String> warnings = [];
  String state = 'active';

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  TimeOfDay? startTime;
  TimeOfDay? endTime;
  List<Vehicle> vehicles = [];

  TextEditingController dateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController payOfferController = TextEditingController();

  void selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 1)),
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

  void updatePayOffer(double value) {
    payOffer = value;
    payOfferController.text = value.toString();
    notifyListeners();
  }

  Future<void> fetchVehicles() async {
    String userId = await getUserId();
    vehicles = await _vehicleService.fetchVehicles(userId);
    notifyListeners();
  }

  void selectVehicle(Vehicle selectedVehicle, GarageSpace garageSpace) {
    vehicle = selectedVehicle;
    warnings.clear();
    validateMeasurements(garageSpace);
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

  void validateMeasurements(GarageSpace garageSpace) {
    if (vehicle != null) {
      if (vehicle!.measurements.height > garageSpace.measurements.height ||
          vehicle!.measurements.width > garageSpace.measurements.width ||
          vehicle!.measurements.length > garageSpace.measurements.length) {
        warnings.add('Las medidas del vehículo son mayores a las del espacio');
        notifyListeners();
      }
    }
  }

  bool isGarageAvailableAtSelectedTime(Garage garage) {
    if (date == null || start == null || end == null) {
      return false;
    }

    DateTime selectedDate = DateFormat('dd-MM-yyyy').parse(date!);
    String selectedDayOfWeek =
        DateFormat('EEEE').format(selectedDate).toLowerCase();

    AvailableTimeInDay? dayAvailability =
        garage.availableTime.firstWhere((day) => day.day == selectedDayOfWeek);

    if (dayAvailability == null) {
      warnings.add("El garaje no tiene disponibilidad el día seleccionado.");
      notifyListeners();
      return false;
    }

    bool isAvailable = false;
    for (var slot in dayAvailability.availableTime!) {
      if (_isTimeInRange(start!, end!, slot.startTime, slot.endTime)) {
        isAvailable = true;
        break;
      }
    }

    if (!isAvailable) {
      warnings.add("No hay tiempos disponibles en el tiempo seleccionado.");
      notifyListeners();
    }

    return isAvailable;
  }

  bool _isTimeInRange(
      String startTime, String endTime, String slotStart, String slotEnd) {
    TimeOfDay startTOD = _timeOfDayFromString(startTime);
    TimeOfDay endTOD = _timeOfDayFromString(endTime);
    TimeOfDay slotStartTOD = _timeOfDayFromString(slotStart);
    TimeOfDay slotEndTOD = _timeOfDayFromString(slotEnd);

    final startMinutes = startTOD.hour * 60 + startTOD.minute;
    final endMinutes = endTOD.hour * 60 + endTOD.minute;
    final slotStartMinutes = slotStartTOD.hour * 60 + slotStartTOD.minute;
    final slotEndMinutes = slotEndTOD.hour * 60 + slotEndTOD.minute;

    return startMinutes < slotEndMinutes && endMinutes > slotStartMinutes;
  }

  TimeOfDay _timeOfDayFromString(String timeString) {
    final timeParts = timeString.split(':');
    return TimeOfDay(
        hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
  }

  bool validateInputs() {
    return date != null && start != null && end != null;
  }

  Future<bool> submitOffer(Garage garage, GarageSpace garageSpace) async {
    _isSubmitting = true;
    notifyListeners();
    warnings.clear();
    notifyListeners();

    validateMeasurements(garageSpace);
    isGarageAvailableAtSelectedTime(garage);

    if (warnings.isNotEmpty) {
      _isSubmitting = false;
      notifyListeners();
      return false;
    }

    String currentUser = await getUserId();
    if (currentUser == '') {
      _isSubmitting = false;
      notifyListeners();
      return false;
    }
    String userName = await getClientDetails(currentUser);
    UserOffer client = UserOffer(id: currentUser, fullName: userName);
    try {
      Offer newOffer = Offer(
        id: 'Offer_${DateTime.now().millisecondsSinceEpoch.toString()}',
        garageSpace: GarageOffer(garageId: garage.id, spaceId: garageSpace.id),
        client: client,
        vehicle: vehicle!,
        provider: UserOffer(id: garage.userId, fullName: garage.userId),
        lastOfferBy: client.id,
        payOffer: payOffer,
        date: date!,
        time: AvailableTime(startTime: start!, endTime: end!),
        state: state,
      );
      await _offerService.createOffer(newOffer);
      return true;
    } catch (e) {
      print(garage.id);
      print(garageSpace.id);
      print(vehicle!.id);
      print(date);
      print('Error creating offer: $e');
      return false;
      // Handle errors
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  void resetData() {
    date = null;
    start = null;
    end = null;
    vehicle = null;
    vehicles.clear();
    startTime = null;
    endTime = null;
    payOffer = 0.0;
    dateController.clear();
    startTimeController.clear();
    endTimeController.clear();
    payOfferController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    dateController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    payOfferController.dispose();
    super.dispose();
  }
}
