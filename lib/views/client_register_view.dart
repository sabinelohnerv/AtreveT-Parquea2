import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:parquea2/viewmodels/client_register_viewmodel.dart';

class ClientRegisterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ClientRegisterViewModel>(context);

    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController fullNameController = TextEditingController();
    final TextEditingController phoneNumberController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text("Registro de Cliente")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: fullNameController,
              decoration: InputDecoration(labelText: "Nombre Completo"),
            ),
            TextField(
              controller: phoneNumberController,
              decoration: InputDecoration(labelText: "Número de Teléfono"),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Contraseña"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                bool registered = await viewModel.registerClient(
                  emailController.text,
                  passwordController.text,
                  fullNameController.text,
                  phoneNumberController.text,
                );
                if (registered) {
                  // Navegar a la siguiente pantalla o mostrar éxito
                  Navigator.of(context).pushReplacementNamed('/clientLogin'); // Asegúrate de configurar tus rutas
                } else {
                  // Mostrar un mensaje de error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Registro fallido'))
                  );
                }
              },
              child: Text("Registrarse"),
            ),
          ],
        ),
      ),
    );
  }
}
