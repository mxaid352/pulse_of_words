import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/quote.dart';

class QuoteCard extends StatelessWidget {
  final Quote quote;
  final VoidCallback onFavorite;
  final bool isFavorite;

  const QuoteCard({
    super.key,
    required this.quote,
    required this.onFavorite,
    required this.isFavorite,
  });

  void _copyQuote(BuildContext context) {
    final text = '"${quote.quoteText}" - ${quote.quoteAuthor}';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Quote copied to clipboard"),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.deepPurple.shade700,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Text(
                  '"${quote.quoteText}"',
                  style: const TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '- ${quote.quoteAuthor}',
                      style: const TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.redAccent,
                      ),
                      onPressed: onFavorite,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.copy, color: Colors.white70),
              onPressed: () => _copyQuote(context),
              tooltip: "Copy Quote",
            ),
          ),
        ],
      ),
    );
  }
}
