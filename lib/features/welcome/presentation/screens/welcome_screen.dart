import 'dart:async';
import 'package:flutter/material.dart';
import 'package:subscription_manager/core/theme/app_theme.dart';
import 'package:subscription_manager/features/welcome/presentation/widgets/overlapped_carousel.dart';
import 'package:subscription_manager/core/widgets/primary_button.dart';
import 'package:subscription_manager/core/utils/color_utils.dart';
import 'package:subscription_manager/features/home/presentation/screens/home_screen.dart';
import 'package:subscription_manager/core/animations/scale_slide_transition.dart';

class WelcomeScreenIconData {
  final String assetPath;
  final Color brandColor;
  final String name;

  WelcomeScreenIconData({
    required this.assetPath,
    required this.brandColor,
    required this.name,
  });
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _contentAnimationController;
  late AnimationController _exitAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _exitScaleAnimation;
  late Animation<Offset> _exitSlideAnimation;

  int _currentCarouselIndex = 0;
  bool _isNavigating = false;

  final List<WelcomeScreenIconData> iconDataList = [
    WelcomeScreenIconData(
      assetPath: 'assets/icons/ic_spotify.png',
      brandColor: hexToColor('#1DB954'),
      name: 'Spotify',
    ),
    WelcomeScreenIconData(
      assetPath: 'assets/icons/ic_figma.png',
      brandColor: hexToColor('#A259FF'),
      name: 'Figma',
    ),
    WelcomeScreenIconData(
      assetPath: 'assets/icons/ic_netflix.png',
      brandColor: hexToColor('#E50914'),
      name: 'Netflix',
    ),
    WelcomeScreenIconData(
      assetPath: 'assets/icons/ic_amazon.png',
      brandColor: hexToColor('#00A8E1'),
      name: 'Prime',
    ),
    WelcomeScreenIconData(
      assetPath: 'assets/icons/ic_youtube.png',
      brandColor: hexToColor('#FF0000'),
      name: 'YouTube',
    ),
  ];

  List<Widget> _carouselItems = [];

  Timer? _gradientUpdateDebounce;
  Color _currentGradientCenterColor = kBackgroundColor;

  @override
  void initState() {
    super.initState();

    _currentGradientCenterColor = iconDataList[2].brandColor;

    _contentAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _exitAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentAnimationController,
        curve: Curves.easeOut,
      ),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _contentAnimationController,
            curve: Curves.easeOut,
          ),
        );

    // Exit animations for navigation
    _exitScaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(
        parent: _exitAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _exitSlideAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(-1.0, 0.0)).animate(
          CurvedAnimation(
            parent: _exitAnimationController,
            curve: Curves.easeInOut,
          ),
        );

    _carouselItems = iconDataList
        .map((data) => _buildCarouselItem(data.assetPath))
        .toList();

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _contentAnimationController.forward();
      }
    });
  }

  Widget _buildCarouselItem(String assetPath) {
    return Container(
      width: 60.0,
      height: 60.0,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      child: Image.asset(
        assetPath,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      ),
    );
  }

  void _onCarouselPageChanged(int index) {
    if (_gradientUpdateDebounce?.isActive ?? false) {
      _gradientUpdateDebounce!.cancel();
    }
    _gradientUpdateDebounce = Timer(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _currentCarouselIndex = index % iconDataList.length;
          _currentGradientCenterColor =
              iconDataList[_currentCarouselIndex].brandColor;
        });
      }
    });
  }

  void _navigateToHome() async {
    if (_isNavigating) return;

    setState(() {
      _isNavigating = true;
    });

    // Start exit animation
    await _exitAnimationController.forward();

    if (mounted) {
      // Navigate with custom route transition
      Navigator.of(context).pushReplacement(
        ScaleSlidePageRoute(
          child: const HomeScreen(),
          duration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  void dispose() {
    _contentAnimationController.dispose();
    _exitAnimationController.dispose();
    _gradientUpdateDebounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _exitAnimationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _exitScaleAnimation.value,
              child: Transform.translate(
                offset: Offset(
                  _exitSlideAnimation.value.dx *
                      MediaQuery.of(context).size.width,
                  _exitSlideAnimation.value.dy *
                      MediaQuery.of(context).size.height,
                ),
                child: Column(
                  children: <Widget>[
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: AnimatedContainer(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.45,
                          duration: const Duration(milliseconds: 600),
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              center: Alignment.center,
                              radius: 0.60,
                              colors: [
                                _currentGradientCenterColor.withValues(
                                  alpha: 0.4,
                                ),
                                _currentGradientCenterColor.withValues(
                                  alpha: 0.3,
                                ),
                                _currentGradientCenterColor.withValues(
                                  alpha: 0.2,
                                ),
                                kBackgroundColor.withValues(alpha: 0.0),
                                kBackgroundColor.withValues(alpha: 0.0),
                              ],
                              stops: const [0.1, 0.2, 0.3, 0.9, 1.0],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30.0,
                            ),
                            child: Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxHeight: 450,
                                  maxWidth: 350,
                                ),
                                child: OverlappedCarousel(
                                  widgets: _carouselItems,
                                  currentIndex: _currentCarouselIndex,
                                  freeScroll: false,
                                  skewAngle: 0.0,
                                  onIndexChanged: _onCarouselPageChanged,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0,
                                      vertical: 20.0,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Manage all your\nsubscriptions',
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 32,
                                                height: 1.2,
                                              ),
                                        ),
                                        const SizedBox(height: 24.0),
                                        Text(
                                          'Keep regular expenses on hand and receive timely notifications of upcoming fees',
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontSize: 16.0,
                                                height: 1.5,
                                                color: kTextColor.withValues(
                                                  alpha: 0.7,
                                                ),
                                              ),
                                        ),
                                        const SizedBox(height: 40.0),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: PrimaryButton(
                                  text: 'Get started',
                                  width: double.infinity,
                                  height: 46.0,
                                  onPressed: _isNavigating
                                      ? () {}
                                      : _navigateToHome,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
