import 'package:flutter/material.dart';
import 'package:mailto/mailto.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatelessWidget {
  final String email = "teamspatikam@gmail.com"; // Replace with your email

  const HelpPage({super.key});

  Future<void> launchMailto() async {
    final mailtoLink = Mailto(
      to: ['teamspatikam@gmail.com'],
      cc: ['ripskillan312004@gmail.com', 'kavankulal2254@gmail.com'],
    );
    await launch('$mailtoLink');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "If you need any assistance, feel free to contact us.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: launchMailto,
              child: const Text("Email Us"),
            ),
          ],
        ),
      ),
    );
  }
}
