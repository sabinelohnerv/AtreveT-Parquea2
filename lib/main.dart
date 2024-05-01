import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:parquea2/view_models/add_garage_viewmodel.dart';
import 'package:parquea2/views/add_garage_view.dart';
import 'package:parquea2/views/home_view.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

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
        ChangeNotifierProvider(create: (_) => AddGarageViewModel()),
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
        home: const AddGarageView(),
      ),
    );
  }
}
