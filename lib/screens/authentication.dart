import 'dart:io';

import 'package:dynamic_365_integration/helpers/application.dart';
import 'package:dynamic_365_integration/helpers/device_info.dart';
import 'package:dynamic_365_integration/helpers/hive.dart';
import 'package:dynamic_365_integration/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final url =
      "https://login.microsoftonline.com/common/oauth2/authorize?resource=https://orgb4c4dbb4.api.crm4.dynamics.com&response_type=token&client_id=51f81489-12ee-4a9e-aaae-a2591f45987d&redirect_uri=https%3A%2F%2Flocalhost";

  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: DeviceInfo.height(2)),
            Text("Please login with your microsoft account for authentication"),
            SizedBox(height: DeviceInfo.height(2)),
            Expanded(
              child: WebView(
                onPageStarted: (String url) {
                  if (url.contains("https://localhost")) {
                    String? token = Uri.parse(url.replaceAll("localhost/#", "localhost?")).queryParameters["access_token"];
                    if (token != null) {
                      AppHive().setToken(token);
                      Navigator.of(ApplicationHelper().context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (route) => false,
                      );
                    }
                  }
                },
                initialUrl: url,
                javascriptMode: JavascriptMode.unrestricted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
