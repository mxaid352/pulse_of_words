import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quote.dart';

class LocalStorageService {
  static const String _favoritesKey = 'favorite_quotes';

  // ✅ Get favorites
  static Future<List<Quote>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final storedList = prefs.getStringList(_favoritesKey) ?? [];

    return storedList.map((item) {
      final json = jsonDecode(item);
      return Quote.fromJson(json);
    }).toList();
  }

  // ✅ Add to favorites
  static Future<void> addFavorite(Quote quote) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey) ?? [];

    final newQuoteJson = jsonEncode(quote.toJson());

    if (!favorites.contains(newQuoteJson)) {
      favorites.add(newQuoteJson);
      await prefs.setStringList(_favoritesKey, favorites);
    }
  }

  // ✅ Remove from favorites
  static Future<void> removeFavorite(Quote quote) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey) ?? [];

    // Decode all stored quotes
    final updatedList = favorites.where((item) {
      final decoded = jsonDecode(item);
      return !(decoded['quoteText'] == quote.quoteText &&
          decoded['quoteAuthor'] == quote.quoteAuthor);
    }).toList();

    await prefs.setStringList(_favoritesKey, updatedList);
  }

  // ✅ Optional: Clean corrupted items
  static Future<void> cleanCorruptFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_favoritesKey) ?? [];

    final valid = stored.where((item) {
      try {
        final json = jsonDecode(item);
        return json['quoteText'] != null && json['quoteAuthor'] != null;
      } catch (_) {
        return false;
      }
    }).toList();

    await prefs.setStringList(_favoritesKey, valid);
    print("Cleaned up corrupted favorites. Remaining: ${valid.length}");
  }
}
