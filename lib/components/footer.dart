import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:navilaw/utils/theme.dart';

class Footer extends StatelessWidget {
  final VoidCallback scrollToTop;

  Footer({super.key, required this.scrollToTop});

 final String logoPath = 'assets/images/sih_logo.png';
 
  Widget _buildLogo() {
    if (logoPath.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(
        logoPath,
        height: 300,
        width: 300,
        placeholderBuilder: (BuildContext context) => const SizedBox(
          height: 300,
          width: 300,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    } else {
      return Image.asset(
        logoPath,
        height: 300,
        width: 300,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Error loading image: $error');
          return const Icon(Icons.error, size: 100, color: Colors.white);
        },
      );
    }
  }


 
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/footer.png',
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: screenWidth * 0.02),
                    // SvgPicture.asset(
                    //   sihLogo,
                    //   height: 100,
                    // ),
                    _buildLogo(),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contact Us',
                          style: AppTheme.lightTheme(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 32,
                              ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Text(
                          '+91XXXXXXXXXX',
                          style: AppTheme.lightTheme(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Text(
                          'Lawnavigator@Gmail.Com',
                          style: AppTheme.lightTheme(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Check Us Out!',
                          style: AppTheme.lightTheme(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 32,
                              ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon:  const Icon(
                                FontAwesomeIcons.instagram,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            IconButton(
                              onPressed: () {},
                              icon:  const Icon(
                                FontAwesomeIcons.whatsapp,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                             SizedBox(width: screenWidth * 0.02),
                            IconButton(
                              onPressed: () {},
                              icon:  const Icon(
                                FontAwesomeIcons.facebook,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(width: screenWidth * 0.05),
                    IconButton(
                      onPressed: scrollToTop,
                      icon:  Icon(
                        FontAwesomeIcons.circleArrowUp,
                        color: Colors.white,
                        size: screenHeight * 0.05,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
