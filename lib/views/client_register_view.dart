import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:parquea2/viewmodels/client_register_viewmodel.dart';
import '/views/widgets/decorative_shape_widget.dart';
import '/views/widgets/animations.dart';

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
                      icon: Icon(Icons.arrow_back, color: Color.fromARGB(255, 255, 211, 40)),
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
                              style: Theme.of(context).textTheme.headline5?.copyWith(fontWeight: FontWeight.bold) ?? TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                            ),
                          ),
                          const SizedBox(height: 20),
                          FadeInAnimation(
                            delay: 200,
                            child: TextField(
                              controller: fullNameController,
                              decoration: InputDecoration(
                                labelText: "Nombre Completo",
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
                              decoration: InputDecoration(
                                labelText: "Número de Teléfono",
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
                              decoration: InputDecoration(
                                labelText: "Email",
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
                              decoration: InputDecoration(
                                labelText: "Contraseña",
                                prefixIcon: Icon(Icons.lock, color: Colors.grey),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          FadeInAnimation(
                            delay: 600,
                            child: ElevatedButton.icon(
                              icon: Icon(Icons.app_registration_outlined),
                              label: Text("Registrarse"),
                              onPressed: () async {
                                bool registered = await viewModel.registerClient(
                                  emailController.text,
                                  passwordController.text,
                                  fullNameController.text,
                                  phoneNumberController.text,
                                );
                                if (registered) {
                                  Navigator.of(context).pushReplacementNamed('/clientLogin');
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Registro fallido'))
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white, 
                                backgroundColor: Color.fromARGB(255, 255, 211, 40),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
