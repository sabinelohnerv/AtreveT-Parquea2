import 'package:flutter/material.dart';
import 'package:parquea2/viewmodels/provider_offer_list_viewmodel.dart';
import 'package:provider/provider.dart';

class ProviderOfferListView extends StatelessWidget {
  const ProviderOfferListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'OFERTAS',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ChangeNotifierProvider<ProviderOfferListViewModel>(
        create: (context) => ProviderOfferListViewModel(),
        child: Consumer<ProviderOfferListViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (viewModel.offers.isEmpty) {
              return const Center(
                  child: Text('No se encontraron ofertas activas.'));
            }
            return ListView.builder(
              itemCount: viewModel.offers.length,
              itemBuilder: (context, index) {
                final offer = viewModel.offers[index];
                return Text(offer.id);
              },
            );
          },
        ),
      ),
    );
  }
}
