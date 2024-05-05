import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:parquea2/services/garage_service.dart';
import 'package:parquea2/services/vehicle_service.dart';
import 'package:parquea2/viewmodels/client/add_vehicle_viewmodel.dart';
import 'package:parquea2/viewmodels/client/client_viewmodel.dart';
import 'package:parquea2/viewmodels/provider/add_garage_space_viewmodel.dart';
import 'package:parquea2/viewmodels/client/client_garage_list_viewmodel.dart';
import 'package:parquea2/viewmodels/client/client_garage_spaces_list_viewmodel.dart';
import 'package:parquea2/viewmodels/client/client_offer_list_viewmodel.dart';
import 'package:parquea2/viewmodels/provider/garage_spaces_list_viewmodel.dart';
import 'package:parquea2/viewmodels/make_offer_viewmodel.dart';
import 'package:parquea2/viewmodels/provider/provider_add_garage_viewmodel.dart';
import 'package:parquea2/viewmodels/provider/provider_garage_list_viewmodel.dart';
import 'package:parquea2/viewmodels/provider/provider_login_viewmodel.dart';
import 'package:parquea2/viewmodels/provider/provider_offer_list_viewmodel.dart';
import 'package:parquea2/viewmodels/client/client_vehicles_list_viewmodel.dart';
import 'package:parquea2/views/client/client_offer_list_view.dart';
import 'package:parquea2/views/map_view.dart';
import 'package:parquea2/views/provider/provider_home_view.dart';
import 'package:provider/provider.dart';
import 'package:parquea2/viewmodels/onboarding.viewmodel.dart';
import 'package:parquea2/viewmodels/client/client_register_viewmodel.dart';
import 'package:parquea2/viewmodels/provider/provider_register_viewmodel.dart';
import 'package:parquea2/views/client/client_home_view.dart.dart';
import 'package:parquea2/views/onboarding_view.dart';
import 'package:parquea2/views/client/client_register_view.dart';
import 'package:parquea2/views/provider/provider_register_view.dart';
import 'package:parquea2/views/login_view.dart';
import 'firebase_options.dart';
import 'services/onboarding_service.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_ES', null);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await _setupFirebaseMessaging();
  _setupNotificationListeners();
  runApp(const MyApp());
}

Future<void> _setupFirebaseMessaging() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    provisional: false,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

void _setupNotificationListeners() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'default_channel',
            'General Notifications',
            channelDescription: 'All important notifications',
            importance: Importance.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('A new onMessageOpenedApp event was published!');
  });
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
        ChangeNotifierProvider<LoginViewModel>(
            create: (context) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => AddGarageViewModel()),
        ChangeNotifierProvider(create: (_) => AddVehicleViewModel()),
        ChangeNotifierProvider(create: (context) => GarageListViewModel()),
        ChangeNotifierProvider(
            create: (context) => ClientGarageListViewModel()),
        ChangeNotifierProvider(
            create: (context) => ClientViewModel()),
        ChangeNotifierProvider(
            create: (context) => VehicleListViewModel(VehicleService())),
        ChangeNotifierProvider(
            create: (context) =>
                GarageSpacesListViewModel('garageId', GarageService())),
        ChangeNotifierProvider(
            create: (context) =>
                ClientGarageSpacesListViewModel('garageId', GarageService())),
        ChangeNotifierProvider(create: (context) => AddGarageSpaceViewModel()),
        ChangeNotifierProvider(create: (context) => MakeOfferViewModel()),
        ChangeNotifierProvider(
            create: (context) => ProviderOfferListViewModel('garageId')),
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
                        ? const LoginView()
                        : OnboardingPage(
                            viewModel:
                                Provider.of<OnboardingViewModel>(context));
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
          '/mapScreen': (context) => const MapScreen(),
          '/clientRegister': (context) => const ClientRegisterView(),
          '/providerRegister': (context) => ProviderRegisterView(),
          '/clientHome': (context) => const ClientHomeView(),
          '/providerHome': (context) => const ProviderHomeView(),
          '/clientOfferList': (context) => const ClientOfferListView(),
          '/login': (context) => const LoginView(),
        },
      ),
    );
  }
}
