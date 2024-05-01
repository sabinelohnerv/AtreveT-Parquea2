import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:parquea2/viewmodels/provider_login_viewmodel.dart';
import 'package:parquea2/views/home_view.dart';
import '/views/widgets/decorative_shape_widget.dart';
import '/views/widgets/animations.dart';

class ProviderLoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProviderLoginViewModel>(context);
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

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
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeInAnimation(
                      delay: 100,
                      child: Text(
                        "Login Ofertante",
                        style: Theme.of(context).textTheme.headline5?.copyWith(fontWeight: FontWeight.bold) ?? TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                    ),
                    SizedBox(height: 40),
                    FadeInAnimation(
                      delay: 200,
                      child: TextField(
                        controller: emailController,
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
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Contraseña",
                          prefixIcon: Icon(Icons.lock, color: Colors.grey),
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
                          bool success = await viewModel.login(emailController.text, passwordController.text);
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
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
