import 'package:flutter/material.dart';

import '../../../models/vehicle.dart';

class VehicleDetailsCard extends StatelessWidget {
  final Vehicle vehicle;
  final BuildContext context;

  const VehicleDetailsCard({super.key, required this.vehicle, required this.context});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(

      child: SizedBox(
        height: MediaQuery.of(context).size.height*0.42,
        width: MediaQuery.of(context).size.width*0.8,
        child: Card(
        
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          surfaceTintColor: Colors.white,
          color: Colors.white,
          elevation: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  vehicle.make.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Container(
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    child: Image.network(
                      vehicle.imgUrl.toString(), 
                    
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  decoration: BoxDecoration(border: Border.all(color: Colors.black,style: BorderStyle.solid,width: 3)),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                        vehicle.plateNumber.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
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
