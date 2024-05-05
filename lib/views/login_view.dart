// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:parquea2/views/client_register_view.dart';
import 'package:parquea2/views/provider_register_view.dart';
import 'package:provider/provider.dart';
import 'package:parquea2/viewmodels/client_login_viewmodel.dart';
import 'package:parquea2/viewmodels/provider_login_viewmodel.dart';
import 'package:parquea2/views/home_view.dart';
import '/views/widgets/animations.dart';

enum UserType { client, provider }

class LoginView extends StatelessWidget {
  final UserType userType;

  const LoginView({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    final clientViewModel =
        Provider.of<ClientLoginViewModel>(context, listen: false);
    final providerViewModel =
        Provider.of<ProviderLoginViewModel>(context, listen: false);

    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    dynamic viewModel =
        userType == UserType.client ? clientViewModel : providerViewModel;

    return LoginViewStateful(
      viewModel: viewModel,
      emailController: emailController,
      passwordController: passwordController,
    );
  }
}

class LoginViewStateful extends StatefulWidget {
  final dynamic viewModel;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginViewStateful({
    super.key,
    required this.viewModel,
    required this.emailController,
    required this.passwordController,
  });

  @override
  _LoginViewStatefulState createState() => _LoginViewStatefulState();
}

class _LoginViewStatefulState extends State<LoginViewStateful> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 70.0, 20.0, 10.0),
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 250,
                  width: 250,
                ),
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.width * 1.43,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(50.0, 50.0, 50.0, 50.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Text(
                          "Bienvenido Nuevamente",
                          style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.w800) ??
                              const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                      ),
                      const Center(
                        child: Text("Coloca tus datos abajo",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w300)),
                      ),
                      const SizedBox(height: 40),
                      FadeInAnimation(
                        delay: 200,
                        child: TextField(
                          controller: widget.emailController,
                          decoration: const InputDecoration(
                            labelText: "Correo Electrónico",
                            prefixIcon: Icon(Icons.email, color: Colors.grey),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      const SizedBox(height: 20),
                      FadeInAnimation(
                        delay: 300,
                        child: TextField(
                          controller: widget.passwordController,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            labelText: "Contraseña",
                            prefixIcon:
                                const Icon(Icons.lock, color: Colors.grey),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      FadeInAnimation(
                        delay: 400,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.login),
                          label: const Text("Iniciar Sesión"),
                          onPressed: () async {
                            bool success = await widget.viewModel.login(
                                widget.emailController.text,
                                widget.passwordController.text);
                            if (success) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomeView()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Login fallido")));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                const Color.fromARGB(255, 255, 211, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 5,
                            fixedSize: const Size(400, 30),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      FadeInAnimation(
                        delay: 400,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.person_2),
                          label: const Text("Registrarse como cliente"),
                          style: ElevatedButton.styleFrom(
                            foregroundColor:
                                Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 5,
                            fixedSize: const Size(400, 30),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ClientRegisterView()),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      FadeInAnimation(
                        delay: 400,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.point_of_sale_sharp),
                          label: const Text("Registrarse como ofertante"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            foregroundColor:
                                Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 5,
                            fixedSize: const Size(400, 30),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProviderRegisterView()),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
