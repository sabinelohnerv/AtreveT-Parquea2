import 'package:flutter/material.dart';
import 'package:parquea2/models/garage.dart';
import 'package:parquea2/views/edit_garage_view.dart';

class GarageCard extends StatelessWidget {
  const GarageCard({
    Key? key,
    required this.garage,
    required this.onTap,
  }) : super(key: key);

  final Garage garage;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Stack(
          children: [
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.20,
                  height: MediaQuery.of(context).size.width * 0.20,
                  decoration: BoxDecoration(
                    image: garage.imgUrl != null && garage.imgUrl!.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(garage.imgUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                    color: garage.imgUrl == null || garage.imgUrl!.isEmpty
                        ? Colors.grey.shade300
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: garage.imgUrl == null || garage.imgUrl!.isEmpty
                      ? const Icon(Icons.business,
                          size: 40, color: Colors.white)
                      : null,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          garage.name,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          garage.location.location,
                          style:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: -5,
              right: 5,
              child: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditGarageView(garage: garage),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
