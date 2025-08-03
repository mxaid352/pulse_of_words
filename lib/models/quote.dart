class Quote {
  final String quoteText;
  final String quoteAuthor;
  String get id => '$quoteText|$quoteAuthor';

  Quote({required this.quoteText, required this.quoteAuthor});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      quoteText: json['quoteText'] ?? '',
      quoteAuthor: json['quoteAuthor'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quoteText': quoteText,
      'quoteAuthor': quoteAuthor,
    };
  }
}
