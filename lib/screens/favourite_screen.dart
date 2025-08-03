import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pulse_of_words/widgets/drawer.dart';
import '../main.dart'; // Contains routeObserver
import '../models/quote.dart';
import '../widgets/quote_card.dart';
import '../services/local_storage_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> with RouteAware {
  List<Quote> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favorites = await LocalStorageService.getFavorites();
    setState(() {
      _favorites = favorites.where((q) => q.quoteText.isNotEmpty).toList();
    });
  }

  Future<void> _removeFromFavorites(Quote quote) async {
    await LocalStorageService.removeFavorite(quote);
    _loadFavorites(); // reload list from storage

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Removed: ${quote.quoteText}'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Favorites',
          style: GoogleFonts.montserrat(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
      ),
      drawer: const POFDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [
              Color(0xFF0F2027),
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ]
                : [
              Color(0xFFE0F7FA),
              Color(0xFFB2EBF2),
              Color(0xFF80DEEA),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: _favorites.isEmpty
            ? Center(
          child: Text(
            "No favorite quotes yet.",
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white70 : Colors.black,
            ),
          ),
        )
            : Padding(
          padding: const EdgeInsets.only(top: 100, left: 16, right: 16),
          child: ListView.separated(
            padding: const EdgeInsets.only(bottom: 20),
            itemCount: _favorites.length,
            separatorBuilder: (_, __) => SizedBox(height: 16),
            itemBuilder: (context, index) {
              final quote = _favorites[index];
              return QuoteCard(
                key: ValueKey(quote.id),
                quote: quote,
                isFavorite: true,
                onFavorite: () => _removeFromFavorites(quote),
              );
            },
          ),
        ),
      ),
    );
  }
}
