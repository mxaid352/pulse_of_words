class Quote {
  final String quoteText;
  final String quoteAuthor;

  // Unique ID to help identify quotes when adding/removing
  String get id => '${quoteText.trim()}|${quoteAuthor.trim()}';

  Quote({
    required this.quoteText,
    required this.quoteAuthor,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      quoteText: (json['quoteText'] ?? '').toString().trim(),
      quoteAuthor: (json['quoteAuthor'] ?? 'Unknown').toString().trim(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quoteText': quoteText.trim(),
      'quoteAuthor': quoteAuthor.trim(),
    };
  }

  // 🔁 Equality based on quoteText and quoteAuthor
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Quote &&
              runtimeType == other.runtimeType &&
              quoteText.trim() == other.quoteText.trim() &&
              quoteAuthor.trim() == other.quoteAuthor.trim();

  @override
  int get hashCode => quoteText.trim().hashCode ^ quoteAuthor.trim().hashCode;
}
