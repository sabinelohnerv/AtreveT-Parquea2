import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:parquea2/services/garage_service.dart';
import 'package:parquea2/services/vehicle_service.dart';
import 'package:parquea2/viewmodels/add_vehicle_viewmodel.dart';
import 'package:parquea2/viewmodels/add_garage_space_viewmodel.dart';
import 'package:parquea2/viewmodels/client_garage_list_viewmodel.dart';
import 'package:parquea2/viewmodels/client_garage_spaces_list_viewmodel.dart';
import 'package:parquea2/viewmodels/client_offer_list_viewmodel.dart';
import 'package:parquea2/viewmodels/garage_spaces_list_viewmodel.dart';
import 'package:parquea2/viewmodels/make_offer_viewmodel.dart';
import 'package:parquea2/viewmodels/provider_add_garage_viewmodel.dart';
import 'package:parquea2/viewmodels/provider_garage_list_viewmodel.dart';
import 'package:parquea2/viewmodels/provider_offer_list_viewmodel.dart';
import 'package:parquea2/viewmodels/user_vehicles_list_viewmodel.dart';
import 'package:parquea2/views/map_view.dart';
import 'package:provider/provider.dart';
import 'package:parquea2/viewmodels/onboarding.viewmodel.dart';
import 'package:parquea2/viewmodels/client_register_viewmodel.dart';
import 'package:parquea2/viewmodels/provider_register_viewmodel.dart';
import 'package:parquea2/viewmodels/client_login_viewmodel.dart';
import 'package:parquea2/viewmodels/provider_login_viewmodel.dart';
import 'package:parquea2/views/home_view.dart';
import 'package:parquea2/views/onboarding_view.dart';
import 'package:parquea2/views/client_register_view.dart';
import 'package:parquea2/views/provider_register_view.dart';
import 'package:parquea2/views/client_login_view.dart';
import 'package:parquea2/views/provider_login_view.dart';
import 'package:parquea2/views/login_view.dart';
import 'firebase_options.dart';
import 'services/onboarding_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<OnboardingViewModel>(
            create: (context) => OnboardingViewModel(OnboardingService())),
        ChangeNotifierProvider<ClientRegisterViewModel>(
            create: (context) => ClientRegisterViewModel()),
        ChangeNotifierProvider<ProviderRegisterViewModel>(
            create: (context) => ProviderRegisterViewModel()),
        ChangeNotifierProvider<ClientLoginViewModel>(
            create: (context) => ClientLoginViewModel()),
        ChangeNotifierProvider<ProviderLoginViewModel>(
            create: (context) => ProviderLoginViewModel()),
        ChangeNotifierProvider(create: (_) => AddGarageViewModel()),
        ChangeNotifierProvider(create: (_) => AddVehicleViewModel()),
        ChangeNotifierProvider(create: (context) => GarageListViewModel()),
        ChangeNotifierProvider(create: (context) => ClientGarageListViewModel()),
        ChangeNotifierProvider(create: (context) => VehicleListViewModel(VehicleService())),
        ChangeNotifierProvider(create: (context) => GarageSpacesListViewModel('garageId', GarageService())),
        ChangeNotifierProvider(create: (context) => ClientGarageSpacesListViewModel('garageId', GarageService())),
        ChangeNotifierProvider(create: (context) => AddGarageSpaceViewModel()),
        ChangeNotifierProvider(create: (context) => MakeOfferViewModel()),
        ChangeNotifierProvider(create: (context) => ProviderOfferListViewModel()),
        ChangeNotifierProvider(create: (context) => ClientOfferListViewModel()),
      ],
      child: MaterialApp(
        title: 'Parquea2',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'PlusJakartaSans',
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 255, 188, 7),
            primary: const Color.fromARGB(255, 255, 188, 7),
          ),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => FutureBuilder<bool>(
                future: Provider.of<OnboardingViewModel>(context, listen: false)
                    .isComplete(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return snapshot.data == true
                        ? const HomeView()
                        : OnboardingPage(
                            viewModel:
                                Provider.of<OnboardingViewModel>(context));
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
          '/mapScreen': (context) => MapScreen(),
          '/clientRegister': (context) => ClientRegisterView(),
          '/providerRegister': (context) => ProviderRegisterView(),
          '/clientLogin': (context) => ClientLoginView(),
          '/providerLogin': (context) => ProviderLoginView(),
          '/login': (context) => LoginView(userType: UserType.client),
          '/home': (context) => const HomeView(),
        },
      ),
    );
  }
}
