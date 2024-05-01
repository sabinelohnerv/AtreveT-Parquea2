import 'package:flutter/material.dart';
import 'package:parquea2/viewmodels/onboarding.viewmodel.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingViewModel viewModel;
  final PageController pageController = PageController();

  OnboardingPage({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double basePadding = MediaQuery.of(context).size.width * 0.05; // Base padding as 5% of screen width
    double cardMarginVertical = MediaQuery.of(context).size.height * 0.06; // Margin as 6% of screen height

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: PageView(
              controller: pageController,
              children: [
                buildPage(
                  context,
                  'assets/images/onBoarding.png',
                  'Encuentra el lugar perfecto para estacionar en zonas urbanas congestionadas.',
                  basePadding,
                  cardMarginVertical
                ),
                buildPage(
                  context,
                  'assets/images/onBoarding2.png',
                  'Reserva y paga estacionamientos seguros con facilidad en cualquier parte de la ciudad.',
                  basePadding,
                  cardMarginVertical
                ),
                buildPage(
                  context,
                  'assets/images/onBoarding3.png',
                  'Gana dinero aprovechando tus garajes vacíos y conviértelos en una fuente de ingresos constante sin esfuerzo.',
                  basePadding,
                  cardMarginVertical
                ),
                buildCallToActionPage(context, basePadding, cardMarginVertical),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 20),
            child: SmoothPageIndicator(
              controller: pageController,
              count: 4,
              effect: WormEffect(
                dotHeight: 10,
                dotWidth: 10,
                activeDotColor: Color.fromARGB(255, 255, 211, 40),
                dotColor: Colors.black.withOpacity(0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPage(BuildContext context, String imagePath, String text, double basePadding, double cardMarginVertical) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: basePadding, vertical: 10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        margin: EdgeInsets.symmetric(horizontal: basePadding, vertical: cardMarginVertical),
        child: Padding(
          padding: EdgeInsets.all(basePadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(imagePath, fit: BoxFit.contain, height: MediaQuery.of(context).size.height * 0.25),
              SizedBox(height: 20),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCallToActionPage(BuildContext context, double basePadding, double cardMarginVertical) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: basePadding, vertical: 10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        margin: EdgeInsets.all(basePadding),
        child: Padding(
          padding: EdgeInsets.all(basePadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Únete a nosotros ahora!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/clientRegister'),
                child: Text('Registrarse como Cliente'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 0, 0, 0), backgroundColor: Color.fromARGB(255, 255, 211, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: Size(double.infinity, 50)
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/providerRegister'),
                child: Text('Registrarse como Ofertante'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 0, 0, 0), backgroundColor: Color.fromARGB(255, 255, 211, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: Size(double.infinity, 50)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
