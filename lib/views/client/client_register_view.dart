// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:parquea2/viewmodels/client/client_register_viewmodel.dart';
import '/views/widgets/animations.dart';
import '../login_view.dart';

class ClientRegisterView extends StatelessWidget {
  const ClientRegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ClientRegisterViewModel>(context);

    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController fullNameController = TextEditingController();
    final TextEditingController phoneNumberController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color.fromARGB(255, 255, 211, 40)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/2dcar.png',
                  height: 250,
                  width: 300,
                ),
                FadeInAnimation(
                  delay: 100,
                  child: const Text(
                    "¡Regístrate!",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
                  ),
                ),
                const Text(
                  "Cliente",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w300),
                ),
                const SizedBox(height: 20),
                FadeInAnimation(
                  delay: 200,
                  child: TextField(
                    controller: fullNameController,
                    decoration: const InputDecoration(
                      labelText: "Nombre Completo",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FadeInAnimation(
                  delay: 300,
                  child: TextField(
                    controller: phoneNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: "Número de Teléfono",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FadeInAnimation(
                  delay: 400,
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FadeInAnimation(
                  delay: 500,
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Contraseña",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FadeInAnimation(
                  delay: 600,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.app_registration_outlined),
                    label: const Text("REGISTRARSE"),
                    onPressed: () async {
                      bool registered = await viewModel.registerClient(
                        emailController.text,
                        passwordController.text,
                        fullNameController.text,
                        phoneNumberController.text,
                      );
                      if (registered) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginView()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
