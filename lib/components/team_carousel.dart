import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:navilaw/utils/colors.dart';
import 'package:navilaw/utils/theme.dart';

class TeamCarousel extends StatefulWidget {
  @override
  _TeamCarouselState createState() => _TeamCarouselState();
}

class _TeamCarouselState extends State<TeamCarousel> {
  int _currentIndex = 0;
  List<Map<String, String>> teamMembers = [
    {
      "name": "Prajjwal Tripathi",
      "role": "Frontend Developer",
      "image": "assets/images/prajjwal.png"
    },
    {
      "name": "Devroop Saha",
      "role": "Machine Learning",
      "image": "assets/images/devroop.png"
    },
    {
      "name": "Gaurav Singh",
      "role": "Frontend Developer",
      "image": "assets/images/gaurav.png"
    },
    {
      "name": "Vanshika Vats",
      "role": "Designer",
      "image": "assets/images/vanshika.png"
    },
    {
      "name": "Abhishek Singh Rajput",
      "role": "Manegerial",
      "image": "assets/images/abhishek.png"
    },
    {
      "name": "Siddhant Baghel",
      "role": "UI/UX Designer",
      "image": "assets/images/siddhant.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(height: screenHeight * 0.02),
        CarouselSlider(
          options: CarouselOptions(
            viewportFraction: 0.3,
            aspectRatio: 3.5,
            enlargeCenterPage: true,
            initialPage: 0,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: teamMembers.map((member) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  height: screenHeight * 0.1,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color:  AppColors.grey,
                        spreadRadius: 3,
                        blurRadius: 3,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          member['image']!,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const  BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            color: Colors.black.withOpacity(0.5),
                          ),
                          padding: EdgeInsets.symmetric( vertical: 10, horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(member['name']!,
                                  style: AppTheme.lightTheme(context)
                                      .textTheme
                                      .headlineLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 20,
                                      )),
                              Text(member['role']!,
                                  style: AppTheme.lightTheme(context)
                                      .textTheme
                                      .bodyMedium?.copyWith(
                                        color: AppColors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }).toList(),
        ),
        SizedBox(height: screenHeight * 0.02),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: teamMembers.asMap().entries.map((entry) {
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == entry.key
                    ? AppColors.brown_1
                    : Colors.white,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
