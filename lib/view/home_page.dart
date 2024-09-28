import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navilaw/utils/colors.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'search_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.backgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ResponsiveVisibility(
            visible: false,
            visibleConditions: const [Condition.largerThan(name: MOBILE)],
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'LawNavigator',
                  style: GoogleFonts.imFellEnglishSc(
                    fontSize: 48,
                    color: Colors.black,
                  ),
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 20,
                  children: [
                    // const Icon(Icons.language, color: Colors.black),
                    // const Text('Eng', style: TextStyle(color: Colors.black)),
                    // const Text('Home', style: TextStyle(color: Colors.black)),
                    // const Text('Templates',
                    //     style: TextStyle(color: Colors.black)),
                    // const Text('About', style: TextStyle(color: Colors.black)),
                    // const Text('Team', style: TextStyle(color: Colors.black)),
                    TextButton(
                      onPressed: () {},
                      child: Text('Eng'),
                    ),

                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: AppColors.elevatedButtonColor,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.01,
                          vertical: screenHeight * 0.01,
                        ),
                      ),  
                      child: const Text('Get started'),
                    ),
                    SizedBox(width: screenWidth * 0.05),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.05),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.05),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LayoutBuilder(
                              builder: (context, constraints) {
                                double fontSize =
                                    ResponsiveBreakpoints.of(context)
                                            .largerThan(MOBILE)
                                        ? (constraints.maxWidth > 600 ? 96 : 64)
                                        : 48;
                                return Text(
                                  'ASK. \nSEARCH. \nGENERATE.',
                                  style: GoogleFonts.lato(
                                    letterSpacing: 0.5,
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.bold,
                                    height: 1.2,
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: screenHeight * 0.04),
                            Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.searchBarBackground,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  height: 60,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          decoration: InputDecoration(
                                            hintText:
                                                'fetch me documents needed for...',
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.only(
                                                left: screenWidth * 0.02),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: AppColors.elevatedButtonColor,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(30),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const LegalSearchScreen(),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: screenWidth * 0.02),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Try Now',
                                              style: GoogleFonts.lato(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(width: screenWidth * 0.01),
                                            const Icon(
                                              Icons.gavel,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Image.asset(
                    'assets/images/landing_page_statue.png',
                    height: screenHeight * 0.9,
                  ),
                ),
              ],
            ),
            Image.asset(
              'assets/images/landing_2.png',
              width: screenWidth,
            ),
            Image.asset(
              'assets/images/landing_3.png',
              width: screenWidth,
            ),
          ],
        ),
      ),
    );
  }
}
