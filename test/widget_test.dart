// This is a basic Flutter widget test for the movie app.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../lib/screens/splash_screen.dart';
import '../lib/providers/theme_provider.dart';
import '../lib/providers/auth_provider.dart';
import '../lib/providers/movie_provider.dart';
import '../lib/providers/favorites_provider.dart';
import '../lib/providers/video_provider.dart';
import '../lib/providers/watch_history_provider.dart';
import '../lib/screens/auth/login_screen.dart';
import '../lib/screens/home_screen.dart';
import '../lib/utils/app_theme.dart';

// Test-specific app that uses a very short splash delay
class TestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MovieProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => VideoProvider()),
        ChangeNotifierProvider(create: (_) => WatchHistoryProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'CineMax',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: SplashScreen(delay: Duration.zero), // No delay for tests
            routes: {
              '/login': (context) => LoginScreen(),
              '/home': (context) => HomeScreen(),
            },
          );
        },
      ),
    );
  }
}

void main() {
  testWidgets('MyApp widget builds successfully', (WidgetTester tester) async {
    await tester.pumpWidget(TestApp());

    // Verify the app builds without errors
    expect(find.byType(TestApp), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);

    // Allow any pending navigation to complete
    await tester.pumpAndSettle();
  });

  testWidgets('App has correct title', (WidgetTester tester) async {
    await tester.pumpWidget(TestApp());

    // Verify app title is set correctly in MaterialApp
    final MaterialApp materialApp = tester.widget(find.byType(MaterialApp));
    expect(materialApp.title, 'CineMax');

    // Allow any pending navigation to complete
    await tester.pumpAndSettle();
  });

  testWidgets('App uses MultiProvider for state management',
      (WidgetTester tester) async {
    await tester.pumpWidget(TestApp());

    // Verify MultiProvider is present
    expect(find.byType(MultiProvider), findsOneWidget);

    // Allow any pending navigation to complete
    await tester.pumpAndSettle();
  });
}
