import 'package:url_launcher/url_launcher.dart';

Future<void> launchDialer(String phoneNumber) async {
  final Uri dialerUri = Uri(scheme: 'tel', path: phoneNumber);
  if (await canLaunchUrl(dialerUri)) {
    await launchUrl(dialerUri);
  } else {
    throw 'Could not launch $dialerUri';
  }
}
