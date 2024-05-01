import 'package:flutter/material.dart';
import '/services/onboarding_service.dart';

class OnboardingViewModel extends ChangeNotifier {
  final OnboardingService _onboardingService;

  OnboardingViewModel(this._onboardingService);

  Future<bool> isComplete() async {
    return await _onboardingService.isOnboardingComplete();
  }

  Future<void> completeOnboarding() async {
    await _onboardingService.completeOnboarding();
    notifyListeners();
  }
}
