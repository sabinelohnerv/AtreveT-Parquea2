import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/car_query_service.dart';
import '../../../viewmodels/add_vehicle_viewmodel.dart';

class VehicleSearchDelegate extends SearchDelegate<Map<String, dynamic>> {
  final VPICApiService vpicApiService = VPICApiService();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, {});
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: vpicApiService.getModelsForMake(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var model = snapshot.data![index];
              return ListTile(
                title: Text("${model['Model_Name']}"),
                subtitle: Text(
                    'Make: ${model['Make_Name']} - Year: ${model['Model_Year']}'),
                onTap: () {
                  Map<String, dynamic> vehicleData = {
                    'make': model['Make_Name'],
                    'model': model['Model_Name'],
                    'year': model['Make_Year'].toString(),
                  };

                  Provider.of<AddVehicleViewModel>(context, listen: false)
                      .updateVehicleFromApi(vehicleData);
                  close(context, vehicleData);
                },
              );
            },
          );
        } else if (snapshot.hasError) {
          return ListTile(
            title: const Text('Error'),
            subtitle: Text('${snapshot.error}'),
          );
        }
        return const ListTile(title: Text('No results found.'));
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}
