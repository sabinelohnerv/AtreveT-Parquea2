import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
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
        ChangeNotifierProvider<OnboardingViewModel>(create: (context) => OnboardingViewModel(OnboardingService())),
        ChangeNotifierProvider<ClientRegisterViewModel>(create: (context) => ClientRegisterViewModel()),
        ChangeNotifierProvider<ProviderRegisterViewModel>(create: (context) => ProviderRegisterViewModel()),
        ChangeNotifierProvider<ClientLoginViewModel>(create: (context) => ClientLoginViewModel()),
        ChangeNotifierProvider<ProviderLoginViewModel>(create: (context) => ProviderLoginViewModel()),
      ],
      child: MaterialApp(
        title: 'Parquea2',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Montserrat',
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 255, 211, 40),
            primary: const Color.fromARGB(255, 255, 211, 40),
          ),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => FutureBuilder<bool>(
            future: Provider.of<OnboardingViewModel>(context, listen: false).isComplete(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return snapshot.data == true ? const HomeView() : OnboardingPage(viewModel: Provider.of<OnboardingViewModel>(context));
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
          '/clientRegister': (context) => ClientRegisterView(),
          '/providerRegister': (context) => ProviderRegisterView(),
          '/clientLogin': (context) => ClientLoginView(),
          '/providerLogin': (context) => ProviderLoginView(),
          '/home': (context) => const HomeView(),
        },
      ),
    );
  }
}
