import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qr_attendance_flut/utils/ad_helper.dart';
import 'package:qr_attendance_flut/values/strings.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../instantiable_widget.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  BannerAd? _bannerAd;
  late final PlatformWebViewControllerCreationParams params;
  WebViewController? controller;

  @override
  void initState() {
    super.initState();
    _bannerAd = AdHelper.createBannerAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WebViewController controller = WebViewController()
      ..clearCache()
      ..clearLocalStorage()
      ..loadRequest(
          Uri.parse('https://nicoitorma.github.io/qr_sidebar/qr-help.html'));
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: Text(labelHelp)),
        bottomNavigationBar:
            (_bannerAd != null) ? showAd(_bannerAd) : const SizedBox(),
        body: WebViewWidget(
          controller: controller,
        ));
  }
}
