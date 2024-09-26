import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navilaw/search.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      initialRoute: "/",
      home: const HomePage(),
      theme: ThemeData(
        primarySwatch: Colors.brown,
        canvasColor: Colors.brown,
        useMaterial3: true,
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown,
            foregroundColor: Colors.white, // Set text color to white
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Navigation Bar
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: ResponsiveVisibility(
                  visible: false,
                  visibleConditions: const [
                    Condition.largerThan(name: MOBILE)
                  ],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'LawNavigator',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 20,
                        children: [
                          const Icon(Icons.language),
                          const Text('Eng'),
                          const Text('Home'),
                          const Text('Templates'),
                          const Text('About'),
                          const Text('Team'),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text('Get started'), // Uses the global theme
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              // Mobile version of Top Navigation Bar
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: ResponsiveVisibility(
                  visible: false,
                  visibleConditions: const [
                    Condition.smallerThan(name: TABLET)
                  ],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'LawNavigator',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Wrap(
                        alignment: WrapAlignment.start,
                        spacing: 20,
                        runSpacing: 10,
                        children: [
                          const Icon(Icons.language),
                          const Text('Eng'),
                          const Text('Home'),
                          const Text('Templates'),
                          const Text('About'),
                          const Text('Team'),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text('Get started'), // Uses the global theme
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50),

              // Main Content Area and Search Bar
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ASK.',
                          style: TextStyle(
                            fontSize: ResponsiveBreakpoints.of(context).largerThan(MOBILE) ? 48 : 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'SEARCH.',
                          style: TextStyle(
                            fontSize: ResponsiveBreakpoints.of(context).largerThan(MOBILE) ? 48 : 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'GENERATE.',
                          style: TextStyle(
                            fontSize: ResponsiveBreakpoints.of(context).largerThan(MOBILE) ? 48 : 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'fetch me documents needed for...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to the search engine page when button is clicked
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LegalSearchScreen(),
                              ),
                            );
                          },
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Try Now'),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Image.asset(
                      'assets/images/statue1.png', // Add your image here
                      height: 800, // Adjust as needed
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
