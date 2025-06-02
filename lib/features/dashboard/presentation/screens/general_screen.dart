import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:subscription_manager/core/theme/app_theme.dart';
import 'package:subscription_manager/core/animations/slide_fade_animation.dart';

class GeneralScreen extends StatelessWidget {
  const GeneralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SlideFadeAnimationWidget(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Spent for January',
                    style: textTheme.titleMedium?.copyWith(color: kTextColor),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '\$ 31',
                        style: GoogleFonts.unbounded(
                          textStyle: textTheme.displayMedium?.copyWith(
                            fontSize: 36,
                            color: kTextColor,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Text(
                        '.45',
                        style: GoogleFonts.unbounded(
                          textStyle: textTheme.displayMedium?.copyWith(
                            fontSize: 36,
                            color: kTextColor.withValues(alpha: 0.25),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          color: kSecondaryColor,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Text(
                          '+5%',
                          style: textTheme.labelMedium?.copyWith(
                            color: kTextColor, // Green text
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32.0),
                  _buildUpcomingPaymentCard(context, textTheme),
                  const SizedBox(height: 32),
                  Text(
                    'Payment history',
                    style: textTheme.headlineSmall?.copyWith(
                      // Prominent title
                      color: kTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            SlideFadeAnimationWidget(
              child: Container(
                height: 800.0,
                decoration: BoxDecoration(
                  color: kSurfaceColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                    bottomLeft: Radius.circular(0.0),
                    bottomRight: Radius.circular(0.0),
                  ),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildPaymentHistoryItem(
                      context,
                      iconPath: 'assets/icons/ic_figma.png',
                      serviceName: 'Figma',
                      date: 'Yesterday, at 5:12 PM',
                      amount: '-\$ 8',
                      textTheme: textTheme,
                    ),
                    _buildPaymentHistoryItem(
                      context,
                      iconPath: 'assets/icons/ic_hbo.png',
                      serviceName: 'HBO Max',
                      date: '20.12.2022, at 1:38 PM',
                      amount: '-\$ 9.99',
                      textTheme: textTheme,
                    ),
                    _buildPaymentHistoryItem(
                      context,
                      iconPath:
                          'assets/icons/ic_github.png', // Placeholder, design shows PS Plus
                      serviceName: 'PS Plus', // As per design
                      date: '15.12.2022, at 8:17 AM',
                      amount: '-\$ 67.57',
                      textTheme: textTheme,
                    ),
                    _buildPaymentHistoryItem(
                      context,
                      iconPath: 'assets/icons/ic_youtube.png',
                      serviceName: 'YouTube',
                      date: '15.12.2022, at 8:17 AM',
                      amount: '-\$ 8.97',
                      textTheme: textTheme,
                    ),
                    _buildPaymentHistoryItem(
                      context,
                      iconPath: 'assets/icons/ic_netflix.png',
                      serviceName: 'Netflix',
                      date: '15.12.2022, at 8:17 AM',
                      amount: '-\$ 8.97',
                      textTheme: textTheme,
                    ),
                    _buildPaymentHistoryItem(
                      context,
                      iconPath: 'assets/icons/ic_amazon.png',
                      serviceName: 'Amazon Prime',
                      date: '15.12.2022, at 10:21 AM',
                      amount: '-\$ 12.99',
                      textTheme: textTheme,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingPaymentCard(BuildContext context, TextTheme textTheme) {
    return Container(
      height: 160.0,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: kSecondaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(4.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              CircleAvatar(
                backgroundColor: kTextColor,
                radius: 26.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/icons/ic_spotify.png', // Specific icon
                  ),
                ),
              ),
              Spacer(),
              Text(
                'Spotify',
                style: GoogleFonts.redHatDisplay(
                  textStyle: textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    'Upcoming payment: ',
                    style: GoogleFonts.unbounded(
                      textStyle: textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ),
                  Text(
                    '25.01',
                    style: GoogleFonts.unbounded(
                      textStyle: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          Column(
            children: [
              Text(
                '\$ 8', // Amount
                style: GoogleFonts.unbounded(
                  textStyle: textTheme.titleMedium?.copyWith(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              Spacer(),
              SizedBox(
                width: 26.0,
                height: 26.0,
                child: IconButton(
                  onPressed: () {},
                  padding: const EdgeInsets.all(0.0),
                  style: IconButton.styleFrom(backgroundColor: Colors.white),
                  icon: Icon(
                    Icons.arrow_forward,
                    size: 18.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentHistoryItem(
    BuildContext context, {
    required String iconPath,
    required String serviceName,
    required String date,
    required String amount,
    required TextTheme textTheme,
  }) {
    return SlideFadeAnimationWidget(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        margin: const EdgeInsets.only(bottom: 12.0),
        decoration: BoxDecoration(
          color: Color(0xFF2D2E35),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: kTextColor,
              radius: 20.0,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Image.asset(iconPath),
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    serviceName,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: kTextColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: textTheme.bodySmall?.copyWith(
                      color: kTextColor.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              amount,
              style: GoogleFonts.unbounded(
                textStyle: textTheme.bodyMedium?.copyWith(
                  color: kTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
