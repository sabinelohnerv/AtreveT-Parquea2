import 'package:flutter/material.dart';
import 'package:parquea2/models/garage.dart';
import 'package:parquea2/services/garage_service.dart'; // Ensure you have this import to access service methods

class GarageCard extends StatefulWidget {
  const GarageCard({
    Key? key,
    required this.garage,
    required this.garageService,
    required this.onTap,
  }) : super(key: key);

  final Garage garage;
  final GarageService garageService;
  final VoidCallback onTap;

  @override
  State<GarageCard> createState() => _GarageCardState();
}

class _GarageCardState extends State<GarageCard> {
  late Future<int> availableSpacesFuture;

  @override
  void initState() {
    super.initState();
    availableSpacesFuture =
        widget.garageService.getAvailableSpacesCount(widget.garage.id);
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
                        fit: BoxFit.cover,
                      )
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
                    Text(
                      widget.garage.name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.garage.location.location,
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
            FutureBuilder<int>(
              future: availableSpacesFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                    width: MediaQuery.of(context).size.width * 0.07,
                    height: MediaQuery.of(context).size.width * 0.07,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        snapshot.data.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                } else {
                  return CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.tertiary,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
