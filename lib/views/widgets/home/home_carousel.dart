import 'package:flutter/material.dart';
import 'package:parquea2/models/garage.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../provider/provider_garage_details_view.dart';
import 'home_card.dart';

class HomeGaragesCarousel extends StatelessWidget {
  final List<Garage> garages;
  final String defaultImageUrl =
      'https://firebasestorage.googleapis.com/v0/b/atrevet-parquea2.appspot.com/o/defaults%2Fdefault.png?alt=media&token=0f75d437-93b9-4fc9-a740-af32d55dd23a';

  const HomeGaragesCarousel({
    super.key,
    required this.garages,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> carouselItems = [];

    if (garages.isEmpty) {
      carouselItems.add(GarageCarouselCard(
        imageUrl: defaultImageUrl,
        title: "No hay garajes registrados",
      ));
    } else {
      carouselItems.add(GarageCarouselCard(
        imageUrl: defaultImageUrl,
        title: "¡Bienvenido!",
      ));
      carouselItems.addAll(garages.map((garage) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GarageDetails(
                  garageId: garage.id,
                ),
              ),
            );
          },
          child: GarageCarouselCard(
            imageUrl: garage.imgUrl ?? defaultImageUrl,
            title: garage.name,
          ),
        );
      }).toList());
    }

    return CarouselSlider(
      items: carouselItems,
      options: CarouselOptions(
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.95,
        aspectRatio: 1.2,
        initialPage: 0,
        autoPlayInterval: const Duration(seconds: 12),
        autoPlayAnimationDuration: const Duration(milliseconds: 1000),
      ),
    );
  }
}
