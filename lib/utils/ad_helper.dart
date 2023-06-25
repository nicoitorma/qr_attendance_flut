import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  static BannerAd? _bannerAd;
  static int _bannerAdLoadAttemps = 0;
  static const int maxFailedLoadAttempts = 3;
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      // if (kDebugMode) {
      // test
      // return 'ca-app-pub-3940256099942544/6300978111';
      // }
      return 'ca-app-pub-9717007945219583/2442397445';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static createBannerAd() {
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: AdHelper.bannerAdUnitId,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            _bannerAdLoadAttemps = 0;
          },
          onAdFailedToLoad: (ad, error) {
            _bannerAdLoadAttemps += 1;
            debugPrint('AD LOADING ERROR: $error');
            _bannerAd = null;
            if (_bannerAdLoadAttemps < maxFailedLoadAttempts) {
              createBannerAd();
            } else {
              ad.dispose();
            }
          },
        ))
      ..load();

    if (_bannerAd != null) {
      return _bannerAd;
    }
  }
}
