import 'package:flutter/material.dart';
import 'package:parquea2/models/garage.dart';

class ReservationGarageCard extends StatelessWidget {
  const ReservationGarageCard({
    Key? key,
    required this.garage,
    required this.reservationCount,
    required this.onTap,
  }) : super(key: key);

  final Garage garage;
  final int reservationCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    String reservationText = reservationCount == 1 ? 'RESERVA' : 'RESERVAS';

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(6, 10, 20, 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.17,
              height: MediaQuery.of(context).size.width * 0.17,
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
                  ? const Icon(Icons.business, size: 40, color: Colors.white)
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
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 6,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 1),
              width: MediaQuery.of(context).size.width * 0.27,
              height: MediaQuery.of(context).size.width * 0.07,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  '${reservationCount.toString()} $reservationText',
                  style: const TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
