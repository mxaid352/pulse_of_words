import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulse_of_words/providers/theme_provider.dart';
import 'package:pulse_of_words/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<void> migrateFavoritesFormat() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList('favorite_quotes') ?? [];

    final cleaned = rawList.where((item) {
      try {
        final json = jsonDecode(item);
        final text = json['quoteText'] ?? '';
        return text.toString().trim().isNotEmpty;
      } catch (_) {
        return false;
      }
    }).map((item) {
      final json = jsonDecode(item);
      final text = json['quoteText'] ?? json['quote'] ?? json['content'] ?? '';
      final author = json['quoteAuthor'] ?? json['author'] ?? 'Unknown';
      return jsonEncode({
        'quoteText': text.trim(),
        'quoteAuthor': author.trim(),
      });
    }).toList();

    await prefs.setStringList('favorite_quotes', cleaned);
    debugPrint("✅ Favorites migrated and cleaned");
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    if (!themeProvider.isInitialized) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    migrateFavoritesFormat();

    return MaterialApp(
      title: 'Pulse of Words',
      navigatorObservers: [routeObserver],
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
        cardColor: Colors.white,
        hintColor: Colors.grey,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: Colors.grey[850],
        hintColor: Colors.grey[450],
      ),
      home: const SplashScreen(),
    );
  }
}
