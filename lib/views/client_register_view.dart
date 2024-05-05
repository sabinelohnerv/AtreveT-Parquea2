// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:parquea2/viewmodels/client_register_viewmodel.dart';
import '/views/widgets/decorative_shape_widget.dart';
import '/views/widgets/animations.dart';
import 'login_view.dart';

class ClientRegisterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ClientRegisterViewModel>(context);

    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController fullNameController = TextEditingController();
    final TextEditingController phoneNumberController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            right: -70,
            top: 10,
            child: DecorativeShapeWidget(
              size: 200,
              color: Theme.of(context).colorScheme.primary,
              shadowColor: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
          Positioned(
            left: -70,
            bottom: -50,
            child: DecorativeShapeWidget(
              size: 200,
              color: Theme.of(context).colorScheme.primary,
              shadowColor: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Color.fromARGB(255, 255, 211, 40)),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FadeInAnimation(
                            delay: 100,
                            child: Text(
                              "Registro de Cliente",
                              style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.bold) ??
                                  const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24),
                            ),
                          ),
                          const SizedBox(height: 20),
                          FadeInAnimation(
                            delay: 200,
                            child: TextField(
                              controller: fullNameController,
                              decoration: const InputDecoration(
                                labelText: "Nombre Completo",
                                prefixIcon:
                                    Icon(Icons.person, color: Colors.grey),
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
                                prefixIcon:
                                    Icon(Icons.phone, color: Colors.grey),
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
                                prefixIcon:
                                    Icon(Icons.email, color: Colors.grey),
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
                                prefixIcon:
                                    Icon(Icons.lock, color: Colors.grey),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          FadeInAnimation(
                            delay: 600,
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton.icon(
                                    icon: const Icon(
                                        Icons.app_registration_outlined),
                                    label: const Text("Registrarse"),
                                    onPressed: () async {
                                      bool registered =
                                          await viewModel.registerClient(
                                        emailController.text,
                                        passwordController.text,
                                        fullNameController.text,
                                        phoneNumberController.text,
                                      );
                                      if (registered) {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginView()),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content:
                                                    Text('Registro fallido')));
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: const Color.fromARGB(
                                          255, 255, 211, 40),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      elevation: 5,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                ]),
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
