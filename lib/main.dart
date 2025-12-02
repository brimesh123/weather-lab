import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io' show Platform;
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb, kReleaseMode;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'splash_screen.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // Load environment variables (from .env). If file missing, continue.
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {}

  // Initialize Google Mobile Ads SDK. Skip on web (not supported there).
  if (!kIsWeb) {
    MobileAds.instance.initialize();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Weather Spinner',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(), // Start with Splash Screen
    );
  }
}

class HtmlGamePage extends StatefulWidget {
  const HtmlGamePage({super.key});

  @override
  State<HtmlGamePage> createState() => _HtmlGamePageState();
}

class _HtmlGamePageState extends State<HtmlGamePage> {
  late final WebViewController _controller;
  BannerAd? _bannerAd;
  bool _isBannerReady = false;
  bool _isBannerLoading = false;

  InterstitialAd? _interstitialAd;
  bool _isInterstitialReady = false;
  final List<Timer> _adTimers = [];
  Timer? _repeatingAdTimer;
  // Scheduling: delays in seconds. First element is the initial delay after launch.
  final List<int> _schedule = [5, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60];
  int _scheduleIndex = 0;
  Timer? _nextAdTimer;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadFlutterAsset('assets/web/game.html');

    // Start loading interstitials.
    _loadInterstitial();

    // Schedule the first ad show relative to app launch using _schedule[0].
    _nextAdTimer = Timer(Duration(seconds: _schedule[_scheduleIndex]), _tryShowOrWait);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAdaptiveBannerIfNeeded();
  }

  Future<void> _loadAdaptiveBannerIfNeeded() async {
    if (_isBannerLoading || _isBannerReady) return;
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) return;
    _isBannerLoading = true;

    final int width = MediaQuery.of(context).size.width.truncate();
    final AdSize? size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width);
    if (size == null) {
      _isBannerLoading = false;
      return;
    }

    // Prefer production IDs from env when running release builds.
    const testBannerAndroid = 'ca-app-pub-3940256099942544/6300978111';
    const testBannerIOS = 'ca-app-pub-3940256099942544/2934735716';
    final envBanner = dotenv.env['ADMOB_BANNER_ID'];
    final adUnitId = kReleaseMode && envBanner != null && envBanner.isNotEmpty
      ? envBanner
      : (Platform.isAndroid ? testBannerAndroid : testBannerIOS);

    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) {
            setState(() {
              _isBannerReady = true;
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _isBannerLoading = false;
        },
      ),
    )..load();
  }

  void _loadInterstitial() {
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) return;

    const testInterstitialAndroid = 'ca-app-pub-3940256099942544/1033173712';
    const testInterstitialIOS = 'ca-app-pub-3940256099942544/4411468910';
    final envInterstitial = dotenv.env['ADMOB_INTERSTITIAL_ID'];
    final interstitialUnitId = kReleaseMode && envInterstitial != null && envInterstitial.isNotEmpty
        ? envInterstitial
        : (Platform.isAndroid ? testInterstitialAndroid : testInterstitialIOS);

    InterstitialAd.load(
      adUnitId: interstitialUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialReady = true;
          _interstitialAd!.setImmersiveMode(true);
          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              try {
                ad.dispose();
              } catch (_) {}
              _interstitialAd = null;
              _isInterstitialReady = false;
              // load the next one so it's ready for future scheduled shows
              _loadInterstitial();
              // Start counting for the next ad after this ad was closed
              _scheduleNextAfterClose();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              try {
                ad.dispose();
              } catch (_) {}
              _interstitialAd = null;
              _isInterstitialReady = false;
              _loadInterstitial();
              // treat failure like a close: schedule next
              _scheduleNextAfterClose();
            },
          );
        },
        onAdFailedToLoad: (error) {
          _isInterstitialReady = false;
          // retry after a short delay
          Future.delayed(const Duration(seconds: 5), () {
            if (mounted) _loadInterstitial();
          });
        },
      ),
    );
  }

  void _showInterstitialIfReady() {
    if (_isInterstitialReady && _interstitialAd != null) {
      try {
        _interstitialAd!.show();
      } catch (_) {}
      // fullScreenContentCallback will dispose and load the next
      _interstitialAd = null;
      _isInterstitialReady = false;
    } else {
      // Not ready at scheduled time — keep trying in background (we already call _loadInterstitial on failures)
    }
  }

  void _tryShowOrWait() {
    // Attempt to show; if not ready, retry every 5s until it is shown.
    if (_isInterstitialReady && _interstitialAd != null) {
      _showInterstitialIfReady();
    } else {
      // retry after short delay
      _nextAdTimer = Timer(const Duration(seconds: 5), _tryShowOrWait);
    }
  }

  void _scheduleNextAfterClose() {
    // Cancel any pending one-off timer
    _nextAdTimer?.cancel();

    // Advance schedule index if not yet at last
    if (_scheduleIndex < _schedule.length - 1) {
      _scheduleIndex++;
      _nextAdTimer = Timer(Duration(seconds: _schedule[_scheduleIndex]), _tryShowOrWait);
    } else {
      // already at last (60). Start repeating every 60s. Start first tick after 60s.
      _repeatingAdTimer?.cancel();
      _repeatingAdTimer = Timer.periodic(const Duration(seconds: 60), (_) {
        _tryShowOrWait();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebViewWidget(controller: _controller),
      ),
      bottomNavigationBar: _isBannerReady && _bannerAd != null
          ? Container(
              width: MediaQuery.of(context).size.width,
              height: _bannerAd!.size.height.toDouble(),
              alignment: Alignment.center,
              child: AdWidget(ad: _bannerAd!),
            )
          : const SizedBox.shrink(),
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    for (final t in _adTimers) {
      t.cancel();
    }
    _repeatingAdTimer?.cancel();
    super.dispose();
  }
}

