import 'package:flutter/material.dart';
import 'package:parquea2/models/reservation.dart';

class ProviderReservationCard extends StatelessWidget {
  const ProviderReservationCard({
    super.key,
    required this.reservation,
    required this.reservationNumber,
    required this.spaceNumber,
    required this.onTap,
  });

  final Reservation reservation;
  final int reservationNumber;
  final int spaceNumber;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Widget determineState() {
      String state = reservation.state;
      Color textColor;
      String stateText;

      switch (state) {
        case 'active':
          textColor = Colors.blue;
          stateText = 'EN USO';
          break;
        case 'reserved':
          textColor = Colors.orange;
          stateText = 'RESERVADO';
          break;
        case 'cancelled-by-provider':
        case 'cancelled-by-client':
        case 'cancelled':
          textColor = Colors.red;
          stateText = 'CANCELADA';
          break;
        case 'finalized':
          textColor = Colors.blue;
          stateText = 'FINALIZADA';
          break;
        case 'needs-rating':
          textColor = Colors.green;
          stateText = 'FINALIZADA';
          break;
        default:
          textColor = Colors.grey;
          stateText = 'DESCONOCIDO';
          break;
      }

      return Text(
        stateText,
        style: TextStyle(
            color: textColor, fontWeight: FontWeight.w600, fontSize: 17),
      );
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(6, 10, 24, 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.1,
              height: MediaQuery.of(context).size.width * 0.15,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(5)),
              child: Center(
                  child: Text(
                reservationNumber.toString(),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              )),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Espacio ${spaceNumber.toString()}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${reservation.time.startTime} - ${reservation.time.endTime}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            determineState()
          ],
        ),
      ),
    );
  }
}
