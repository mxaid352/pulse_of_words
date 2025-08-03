import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/quote.dart';
import '../services/local_storage_service.dart';
import '../widgets/drawer.dart';
import '../widgets/quote_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Quote> _quotes = [];
  List<Quote> _filteredQuotes = [];
  int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadQuotes();
  }

  Future<void> _loadQuotes() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/quotes.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      setState(() {
        _quotes = jsonData.map((item) => Quote.fromJson(item)).toList();
        _filteredQuotes = List.from(_quotes);
      });
    } catch (e) {
      print('❌ Error loading quotes: $e');
    }
  }

  void _showNextQuote() {
    if (_filteredQuotes.isEmpty) return;
    setState(() {
      _currentIndex = (_currentIndex + 1) % _filteredQuotes.length;
    });
  }

  void _showPreviousQuote() {
    if (_filteredQuotes.isEmpty) return;
    setState(() {
      _currentIndex = (_currentIndex - 1 + _filteredQuotes.length) % _filteredQuotes.length;
    });
  }

  void _addToFavorites() async {
    final currentQuote = _filteredQuotes[_currentIndex];
    await LocalStorageService.addFavorite(currentQuote);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Saved: "${currentQuote.quoteText}"')),
    );
  }

  void _searchQuotes(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredQuotes = List.from(_quotes);
      } else {
        _filteredQuotes = _quotes.where((quote) =>
        quote.quoteText.toLowerCase().contains(query.toLowerCase()) ||
            quote.quoteAuthor.toLowerCase().contains(query.toLowerCase())).toList();
      }
      _currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final quote = _filteredQuotes.isNotEmpty ? _filteredQuotes[_currentIndex] : null;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: isDark ? Colors.black : const Color(0xFF3f51b5),
      drawer: POFDrawer(),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? const [
                  Color(0xFF0F2027),
                  Color(0xFF203A43),
                  Color(0xFF2C5364),
                  Color(0xFF1F4068),
                  Color(0xFF5C258D),
                  Color(0xFF4389A2),
                ]
                    : const [
                  Color(0xFFE0F7FA),
                  Color(0xFFB2EBF2),
                  Color(0xFF80DEEA),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(color: Colors.black.withOpacity(0.2)),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                children: [
                  Text(
                    "Pulse of Words",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: isDark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text('Words that sparks soul', style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _searchController,
                    onChanged: _searchQuotes,
                    decoration: InputDecoration(
                      hintText: 'Search quotes or authors...',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (quote != null) ...[
                    QuoteCard(
                      quote: quote,
                      isFavorite: true,
                      onFavorite: _addToFavorites,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _showPreviousQuote,
                          icon: const Icon(Icons.navigate_before),
                          label: const Text("Previous"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.2),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _showNextQuote,
                          icon: const Icon(Icons.navigate_next),
                          label: const Text("Next"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.2),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else
                    const Center(child: CircularProgressIndicator()),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
