import 'package:flutter/material.dart';
import 'package:parquea2/models/garage.dart';
import 'package:parquea2/services/garage_service.dart'; // Ensure you have this import to access service methods

class GarageOfferCard extends StatefulWidget {
  const GarageOfferCard({
    super.key,
    required this.garage,
    required this.garageService,
    required this.onTap,
  });

  final Garage garage;
  final GarageService garageService;
  final VoidCallback onTap;

  @override
  State<GarageOfferCard> createState() => GarageOfferCardState();
}

class GarageOfferCardState extends State<GarageOfferCard> {
  late Future<int> offersCountFuture;

  @override
  void initState() {
    super.initState();
    offersCountFuture = widget.garageService.getOffersCount(widget.garage.id);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(6, 10, 20, 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.20,
              height: MediaQuery.of(context).size.width * 0.20,
              decoration: BoxDecoration(
                image: widget.garage.imgUrl != null &&
                        widget.garage.imgUrl!.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(widget.garage.imgUrl!),
                        fit: BoxFit.cover)
                    : null,
                color: widget.garage.imgUrl == null ||
                        widget.garage.imgUrl!.isEmpty
                    ? Colors.grey.shade300
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
              ),
              child: widget.garage.imgUrl == null ||
                      widget.garage.imgUrl!.isEmpty
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
                    Text(widget.garage.name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 5),
                    Text(widget.garage.location.location,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ),
            FutureBuilder<int>(
              future: offersCountFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  String offerText = snapshot.data == 1 ? 'OFERTA' : 'OFERTAS';
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${snapshot.data} $offerText',
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
