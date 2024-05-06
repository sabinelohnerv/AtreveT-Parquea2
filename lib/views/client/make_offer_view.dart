import 'package:flutter/material.dart';
import 'package:parquea2/models/garage.dart';
import 'package:parquea2/models/garage_space.dart';
import 'package:parquea2/models/vehicle.dart';
import 'package:parquea2/viewmodels/make_offer_viewmodel.dart';
import 'package:parquea2/views/widgets/textfields/custom_numberinput.dart';
import 'package:parquea2/views/widgets/textfields/custom_textfield.dart';
import 'package:provider/provider.dart';

class MakeOfferView extends StatefulWidget {
  final Garage garage;
  final GarageSpace garageSpace;

  const MakeOfferView(
      {super.key, required this.garage, required this.garageSpace});

  @override
  State<StatefulWidget> createState() {
    return _MakeOfferViewState();
  }
}

class _MakeOfferViewState extends State<MakeOfferView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<MakeOfferViewModel>(context, listen: false);
    viewModel.fetchVehicles();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MakeOfferViewModel>(context);
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxisScrolled) => [
          SliverAppBar(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40))),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                viewModel.resetData();
                Navigator.of(context).pop();
              },
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: const Text(
              "HACER OFERTA",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            centerTitle: true,
          ),
        ],
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        CustomTextFormField(
                          labelText: 'Fecha de la Reserva',
                          enabled: true,
                          prefixIcon: const Icon(Icons.calendar_month),
                          readOnly: true,
                          onTap: () => viewModel.selectDate(context),
                          controller: viewModel.dateController,
                          validator: (value) => value!.isEmpty
                              ? 'Este campo es obligatorio.'
                              : null,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextFormField(
                                labelText: 'Hora de Inicio',
                                enabled: true,
                                prefixIcon: const Icon(Icons.access_time),
                                readOnly: true,
                                onTap: () => viewModel.selectStartTime(context),
                                controller: viewModel.startTimeController,
                                validator: (value) => value!.isEmpty
                                    ? 'Este campo es obligatorio.'
                                    : null,
                              ),
                            ),
                            Expanded(
                              child: CustomTextFormField(
                                labelText: 'Hora de Finalización',
                                enabled: true,
                                prefixIcon: const Icon(Icons.hourglass_bottom),
                                readOnly: true,
                                onTap: () => viewModel.selectEndTime(context),
                                controller: viewModel.endTimeController,
                                validator: (value) => value!.isEmpty
                                    ? 'Este campo es obligatorio.'
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: DropdownButtonFormField<Vehicle>(
                            isExpanded: true,
                            value: viewModel.vehicle,
                            onChanged: (Vehicle? newValue) {
                              if (newValue != null) {
                                viewModel.selectVehicle(
                                    newValue, widget.garageSpace);
                              }
                            },
                            items: viewModel.vehicles
                                .map<DropdownMenuItem<Vehicle>>(
                                    (Vehicle vehicle) {
                              return DropdownMenuItem<Vehicle>(
                                value: vehicle,
                                child: Text(
                                  '${vehicle.make.toUpperCase()} ${vehicle.model.toUpperCase()} - ${vehicle.plateNumber}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            decoration: const InputDecoration(
                              labelText: 'Vehículo',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              prefixIcon: Icon(Icons.directions_car),
                            ),
                          ),
                        ),
                        CustomNumberInput(
                          labelText: 'Oferta',
                          prefixIcon: const Icon(Icons.attach_money),
                          controller: viewModel.payOfferController,
                          onSaved: (value) {
                            double payOffer = double.tryParse(value) ?? 0;
                            viewModel.updatePayOffer(payOffer);
                          },
                        ),
                        if (viewModel.warnings.isNotEmpty)
                          TextButton.icon(
                            onPressed: () =>
                                showWarningDialog(context, viewModel.warnings),
                            label: const Text('Avertencia'),
                            icon: const Icon(
                              Icons.warning,
                              color: Colors.amber,
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 28, vertical: 6),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                if (!viewModel.validateTime()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'La hora de fin debe ser posterior a la hora de inicio.'),
                                    ),
                                  );
                                  return;
                                }
                                _formKey.currentState!.save();
                                bool success = await viewModel.submitOffer(
                                    widget.garage, widget.garageSpace);
                                if (success) {
                                  viewModel.resetData();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Oferta enviada.'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  Future.delayed(const Duration(seconds: 2),
                                      () {
                                    viewModel.navigateToOfferDetails(
                                        context, viewModel.id!);
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Error al enviar oferta.'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                            ),
                            child: viewModel.isSubmitting
                                ? const CircularProgressIndicator()
                                : const Text('ENVIAR OFERTA'),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showWarningDialog(BuildContext context, List<String> warnings) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Advertencias'),
          content: SingleChildScrollView(
            child: ListBody(
              children: warnings.map((warning) => Text(warning)).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Entendido'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
