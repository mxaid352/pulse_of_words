import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quote.dart';

class LocalStorageService {
  static const String _favoritesKey = 'favorite_quotes';

  /// ✅ Get favorite quotes
  static Future<List<Quote>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final storedList = prefs.getStringList(_favoritesKey) ?? [];

    return storedList.map((item) {
      final json = jsonDecode(item);
      return Quote.fromJson(json);
    }).toList();
  }

  /// ✅ Add a quote to favorites
  static Future<void> addFavorite(Quote quote) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey) ?? [];

    final quoteJson = jsonEncode(quote.toJson());

    final alreadyExists = favorites.any((item) {
      final decoded = Quote.fromJson(jsonDecode(item));
      return decoded == quote;
    });

    if (!alreadyExists) {
      favorites.add(quoteJson);
      await prefs.setStringList(_favoritesKey, favorites);
    }
  }

  /// ✅ Remove a quote from favorites
  static Future<void> removeFavorite(Quote quote) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey) ?? [];

    final updatedList = favorites.where((item) {
      final decoded = Quote.fromJson(jsonDecode(item));
      return decoded != quote;
    }).toList();

    await prefs.setStringList(_favoritesKey, updatedList);
  }

  /// ✅ Check if quote is in favorites
  static Future<bool> isFavorite(Quote quote) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey) ?? [];

    return favorites.any((item) {
      final decoded = Quote.fromJson(jsonDecode(item));
      return decoded == quote;
    });
  }

  /// ✅ Clear all favorites (optional utility)
  static Future<void> clearFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_favoritesKey);
  }

  /// ✅ Clean corrupted data (optional utility)
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
    print("✅ Cleaned up corrupted favorites. Remaining: ${valid.length}");
  }
}
