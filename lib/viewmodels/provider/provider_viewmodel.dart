import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parquea2/models/provider.dart';
import 'package:parquea2/services/provider_service.dart';

class ProviderViewModel extends ChangeNotifier {
  final _providerService = ProviderService();
  Provider? _currentProvider;
  Map<String, dynamic>? _providerDetails;

  Provider? get currentProvider => _currentProvider;
  Map<String, dynamic>? get providerDetails => _providerDetails;

  ProviderViewModel() {
    loadCurrentProvider();
  }

  Future<void> loadCurrentProvider() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (userId.isNotEmpty) {
      Provider? provider = await _providerService.fetchProviderById(userId);
      _currentProvider = provider ??
          Provider(id: '', fullName: '', phoneNumber: '', email: '');
      notifyListeners();
    }
  }

  Future<bool> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      print("Error signing out: $e");
      return false;
    }
  }
}
