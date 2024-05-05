import 'package:flutter/material.dart';
import 'package:parquea2/viewmodels/client/client_viewmodel.dart';
import 'package:parquea2/views/login_view.dart';
import 'package:parquea2/views/map_view.dart';
import 'package:parquea2/views/widgets/drawers/client/drawer.dart';
import 'package:provider/provider.dart';

class ClientHomeView extends StatefulWidget {
  const ClientHomeView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ClientHomeViewState();
  }
}

class _ClientHomeViewState extends State<ClientHomeView> {
  @override
  void initState() {
    super.initState();
    final userViewModel = Provider.of<ClientViewModel>(context, listen: false);
    userViewModel.loadCurrentClient();
  }

  void _handleSignOut(BuildContext context, ClientViewModel viewModel) async {
    bool signedOut = await viewModel.signOut();
    if (signedOut) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<ClientViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 188, 7),
        title: const Text('SWIFT PARK',
            style: TextStyle(fontWeight: FontWeight.w800)),
        foregroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: CustomDrawer(
        fullName: userViewModel.currentClient!.fullName,
        email: userViewModel.currentClient!.email,
        onSignOut: () => _handleSignOut(context, userViewModel),
      ),
      body: const Stack(
        children: [
          Expanded(
            child: MapScreen(),
          ),
        ],
      ),
    );
  }
}
