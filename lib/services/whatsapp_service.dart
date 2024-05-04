import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class WhatsAppService {
  Future<void> sendMessage(String phoneNumber, String message) async {
    final String encodedMessage = Uri.encodeFull(message);
    String url;

    if (Platform.isIOS) {
      url = "https://wa.me/$phoneNumber?text=$encodedMessage";
    } else {
      url = "whatsapp://send?phone=$phoneNumber&text=$encodedMessage";
    }

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
