import 'package:flutter/material.dart';
import 'package:parquea2/viewmodels/onboarding.viewmodel.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingViewModel viewModel;
  final PageController pageController = PageController();

  OnboardingPage({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: PageView(
              controller: pageController,
              children: [
                OnboardingSlide(
                  imagePath: 'assets/images/onBoarding.png',
                  title: 'Descubre Lugares',
                  description: 'Encuentra el lugar perfecto para estacionar en zonas urbanas congestionadas.',
                ),
                OnboardingSlide(
                  imagePath: 'assets/images/onBoarding2.png',
                  title: 'Reserva Fácilmente',
                  description: 'Reserva y paga estacionamientos seguros con facilidad en cualquier parte de la ciudad.',
                ),
                OnboardingSlide(
                  imagePath: 'assets/images/onBoarding3.png',
                  title: 'Gana con Nosotros',
                  description: 'Gana dinero aprovechando tus garajes vacíos y conviértelos en una fuente de ingresos constante sin esfuerzo.',
                  isLast: true,
                  context: context,
                ),
              ],
            ),
          ),
          SmoothPageIndicator(
            controller: pageController,
            count: 3,
            effect: ExpandingDotsEffect(
              activeDotColor: Theme.of(context).colorScheme.primary,
              dotColor: Colors.grey,
              dotHeight: 10,
              dotWidth: 10,
              spacing: 4,
            ),
            onDotClicked: (index) => pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => pageController.jumpToPage(2),
                  child: Text('Skip', style: TextStyle(color: Colors.grey)),
                ),
                TextButton(
                  onPressed: () => pageController.nextPage(
                    duration: Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  ),
                  child: Text('Next', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class OnboardingSlide extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final bool isLast;
  final BuildContext? context;

  const OnboardingSlide({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.description,
    this.isLast = false,
    this.context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Image.asset(imagePath, fit: BoxFit.cover),
        ),
        Expanded(
          flex: 2,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  description,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                if (isLast) ...[
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/clientRegister'),
                    child: Text('Registrarse como Cliente'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/providerRegister'),
                    child: Text('Registrarse como Ofertante'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
