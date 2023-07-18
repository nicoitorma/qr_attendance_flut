import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qr_attendance_flut/utils/ad_helper.dart';
import 'package:qr_attendance_flut/values/strings.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../instantiable_widget.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;
  BannerAd? _bannerAd;
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
    return Scaffold(
      appBar: AppBar(title: Text(labelPrivPol)),
      bottomNavigationBar:
          (_bannerAd != null) ? showAd(_bannerAd) : const SizedBox(),
      body: WebViewWidget(
        controller: WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                // Update loading bar.
              },
              onPageStarted: (String url) {},
              onPageFinished: (String url) {},
              onWebResourceError: (WebResourceError err) {
                _crashlytics.log('PRIVPOL: ${err.toString()}');
              },
              onNavigationRequest: (NavigationRequest request) {
                if (request.url.startsWith('https://www.youtube.com/')) {
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            ),
          )
          ..clearCache()
          ..clearLocalStorage()
          ..loadRequest(Uri.parse(
              'https://nicoitorma.github.io/qr_sidebar/qr-priv-pol.html')),
      ),
    );
  }
}
