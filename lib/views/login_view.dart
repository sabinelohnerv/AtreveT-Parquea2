import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:parquea2/viewmodels/client_login_viewmodel.dart';
import 'package:parquea2/viewmodels/provider_login_viewmodel.dart';
import 'package:parquea2/views/home_view.dart';
import '/views/widgets/decorative_shape_widget.dart';
import '/views/widgets/animations.dart';

enum UserType { client, provider }

class LoginView extends StatelessWidget {
  final UserType userType;

  LoginView({required this.userType});

  @override
  Widget build(BuildContext context) {
    final clientViewModel = Provider.of<ClientLoginViewModel>(context, listen: false);
    final providerViewModel = Provider.of<ProviderLoginViewModel>(context, listen: false);

    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    dynamic viewModel = userType == UserType.client ? clientViewModel : providerViewModel;

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

  LoginViewStateful({
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
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Login",
                      style: Theme.of(context).textTheme.headline5?.copyWith(fontWeight: FontWeight.bold) ?? TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    SizedBox(height: 20),
                    FadeInAnimation(
                      delay: 200,
                      child: TextField(
                        controller: widget.emailController,
                        decoration: InputDecoration(
                          labelText: "Correo Electrónico",
                          prefixIcon: Icon(Icons.email, color: Colors.grey),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    SizedBox(height: 20),
                    FadeInAnimation(
                      delay: 300,
                      child: TextField(
                        controller: widget.passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          labelText: "Contraseña",
                          prefixIcon: Icon(Icons.lock, color: Colors.grey),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    FadeInAnimation(
                      delay: 400,
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.login),
                        label: Text("Iniciar Sesión"),
                        onPressed: () async {
                          bool success = await widget.viewModel.login(widget.emailController.text, widget.passwordController.text);
                          if (success) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const HomeView()),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login fallido")));
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
                    SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
